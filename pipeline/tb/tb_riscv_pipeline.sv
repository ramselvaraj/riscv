`timescale 1ns/1ps

module tb_riscv_pipeline;
    localparam logic [6:0] OP_RTYPE = 7'b0110011;
    localparam logic [6:0] OP_ITYPE = 7'b0010011;
    localparam logic [6:0] OP_LW    = 7'b0000011;
    localparam logic [6:0] OP_SW    = 7'b0100011;
    localparam logic [6:0] OP_BRANCH= 7'b1100011;
    localparam logic [6:0] OP_JAL   = 7'b1101111;
    localparam logic [6:0] OP_JALR  = 7'b1100111;

    logic clk = 1'b0;
    logic reset = 1'b1;
    integer errors = 0;
    integer stall_count = 0;
    integer redirect_count = 0;

    riscv_pipeline dut(.clk, .reset);

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (!reset && dut.datapath_inst.stall)
            stall_count = stall_count + 1;
        if (!reset && dut.datapath_inst.redirect)
            redirect_count = redirect_count + 1;
    end

    function automatic [31:0] encode_r(
        input logic [6:0] funct7,
        input logic [4:0] rs2,
        input logic [4:0] rs1,
        input logic [2:0] funct3,
        input logic [4:0] rd
    );
        encode_r = {funct7, rs2, rs1, funct3, rd, OP_RTYPE};
    endfunction

    function automatic [31:0] encode_i(
        input integer immediate,
        input logic [4:0] rs1,
        input logic [2:0] funct3,
        input logic [4:0] rd,
        input logic [6:0] opcode
    );
        encode_i = {immediate[11:0], rs1, funct3, rd, opcode};
    endfunction

    function automatic [31:0] encode_s(
        input integer immediate,
        input logic [4:0] rs2,
        input logic [4:0] rs1,
        input logic [2:0] funct3
    );
        encode_s = {immediate[11:5], rs2, rs1, funct3, immediate[4:0], OP_SW};
    endfunction

    function automatic [31:0] encode_b(
        input integer immediate,
        input logic [4:0] rs2,
        input logic [4:0] rs1,
        input logic [2:0] funct3
    );
        encode_b = {immediate[12], immediate[10:5], rs2, rs1, funct3,
                    immediate[4:1], immediate[11], OP_BRANCH};
    endfunction

    function automatic [31:0] encode_j(
        input integer immediate,
        input logic [4:0] rd
    );
        encode_j = {immediate[20], immediate[10:1], immediate[11],
                    immediate[19:12], rd, OP_JAL};
    endfunction

    task automatic expect_equal(
        input logic [31:0] actual,
        input logic [31:0] expected,
        input string name
    );
        if (actual !== expected) begin
            $display("FAIL: %s: expected %08h, got %08h", name, expected, actual);
            errors = errors + 1;
        end else begin
            $display("PASS: %s", name);
        end
    endtask

    initial begin
        #1;
        // Arithmetic and immediate operations.
        dut.datapath_inst.imem_inst.memdata[0]  = encode_i(10, 0, 3'b000, 1, OP_ITYPE); // addi x1,x0,10
        dut.datapath_inst.imem_inst.memdata[1]  = encode_i(3, 0, 3'b000, 2, OP_ITYPE);  // addi x2,x0,3
        dut.datapath_inst.imem_inst.memdata[2]  = encode_r(7'b0, 2, 1, 3'b000, 3);       // add x3,x1,x2
        dut.datapath_inst.imem_inst.memdata[3]  = encode_r(7'b0100000, 2, 1, 3'b000, 4);// sub x4,x1,x2
        dut.datapath_inst.imem_inst.memdata[4]  = encode_r(7'b0, 2, 1, 3'b111, 5);       // and x5,x1,x2
        dut.datapath_inst.imem_inst.memdata[5]  = encode_r(7'b0, 2, 1, 3'b110, 6);       // or x6,x1,x2
        dut.datapath_inst.imem_inst.memdata[6]  = encode_i(15, 1, 3'b100, 7, OP_ITYPE); // xori x7,x1,15
        dut.datapath_inst.imem_inst.memdata[7]  = encode_i(6, 1, 3'b111, 8, OP_ITYPE);  // andi x8,x1,6
        dut.datapath_inst.imem_inst.memdata[8]  = encode_i(8, 2, 3'b110, 9, OP_ITYPE);  // ori x9,x2,8
        dut.datapath_inst.imem_inst.memdata[9]  = encode_i(2, 2, 3'b001, 10, OP_ITYPE); // slli x10,x2,2
        dut.datapath_inst.imem_inst.memdata[10] = encode_i(1, 10, 3'b101, 11, OP_ITYPE);// srli x11,x10,1
        dut.datapath_inst.imem_inst.memdata[11] = encode_i(-16, 0, 3'b000, 12, OP_ITYPE);// addi x12,x0,-16
        dut.datapath_inst.imem_inst.memdata[12] = encode_i(32'h402, 12, 3'b101, 13, OP_ITYPE);// srai x13,x12,2
        dut.datapath_inst.imem_inst.memdata[13] = encode_i(-1, 12, 3'b010, 14, OP_ITYPE);// slti x14,x12,-1
        dut.datapath_inst.imem_inst.memdata[14] = encode_i(4, 2, 3'b011, 15, OP_ITYPE); // sltiu x15,x2,4

        // Memory, load-use stalls, store forwarding, and branches.
        dut.datapath_inst.imem_inst.memdata[15] = encode_s(0, 3, 0, 3'b010);            // sw x3,0(x0)
        dut.datapath_inst.imem_inst.memdata[16] = encode_i(0, 0, 3'b010, 16, OP_LW);   // lw x16,0(x0)
        dut.datapath_inst.imem_inst.memdata[17] = encode_r(7'b0, 2, 16, 3'b000, 17);   // add x17,x16,x2
        dut.datapath_inst.imem_inst.memdata[18] = encode_s(4, 17, 0, 3'b010);           // sw x17,4(x0)
        dut.datapath_inst.imem_inst.memdata[19] = encode_i(4, 0, 3'b010, 18, OP_LW);   // lw x18,4(x0)
        dut.datapath_inst.imem_inst.memdata[20] = encode_b(12, 17, 18, 3'b000);        // beq x18,x17,+12
        dut.datapath_inst.imem_inst.memdata[21] = encode_i(99, 0, 3'b000, 19, OP_ITYPE);// flushed
        dut.datapath_inst.imem_inst.memdata[22] = encode_i(98, 0, 3'b000, 19, OP_ITYPE);// flushed
        dut.datapath_inst.imem_inst.memdata[23] = encode_i(1, 0, 3'b000, 19, OP_ITYPE);// branch target
        dut.datapath_inst.imem_inst.memdata[24] = encode_b(12, 2, 1, 3'b000);          // beq x1,x2,+12 (not taken)
        dut.datapath_inst.imem_inst.memdata[25] = encode_i(2, 0, 3'b000, 20, OP_ITYPE);// executes

        // JAL and JALR each flush two younger instructions.
        dut.datapath_inst.imem_inst.memdata[26] = encode_j(12, 21);                    // jal x21,+12
        dut.datapath_inst.imem_inst.memdata[27] = encode_i(99, 0, 3'b000, 22, OP_ITYPE);// flushed
        dut.datapath_inst.imem_inst.memdata[28] = encode_i(98, 0, 3'b000, 22, OP_ITYPE);// flushed
        dut.datapath_inst.imem_inst.memdata[29] = encode_i(1, 21, 3'b000, 22, OP_ITYPE);// x22=link+1
        dut.datapath_inst.imem_inst.memdata[30] = encode_i(136, 0, 3'b000, 23, OP_ITYPE);// JALR target
        dut.datapath_inst.imem_inst.memdata[31] = encode_i(0, 23, 3'b000, 24, OP_JALR);// jalr x24,0(x23)
        dut.datapath_inst.imem_inst.memdata[32] = encode_i(99, 0, 3'b000, 25, OP_ITYPE);// flushed
        dut.datapath_inst.imem_inst.memdata[33] = encode_i(98, 0, 3'b000, 25, OP_ITYPE);// flushed
        dut.datapath_inst.imem_inst.memdata[34] = encode_i(7, 0, 3'b000, 25, OP_ITYPE);// target
        dut.datapath_inst.imem_inst.memdata[35] = encode_s(8, 25, 0, 3'b010);           // forwarded store

        repeat (2) @(posedge clk);
        reset = 1'b0;
        repeat (80) @(posedge clk);
        #1;

        expect_equal(dut.datapath_inst.regfile_inst.registers[1], 10, "ADDI");
        expect_equal(dut.datapath_inst.regfile_inst.registers[3], 13, "ADD with forwarding");
        expect_equal(dut.datapath_inst.regfile_inst.registers[4], 7, "SUB");
        expect_equal(dut.datapath_inst.regfile_inst.registers[5], 2, "AND");
        expect_equal(dut.datapath_inst.regfile_inst.registers[6], 11, "OR");
        expect_equal(dut.datapath_inst.regfile_inst.registers[7], 5, "XORI");
        expect_equal(dut.datapath_inst.regfile_inst.registers[8], 2, "ANDI");
        expect_equal(dut.datapath_inst.regfile_inst.registers[9], 11, "ORI");
        expect_equal(dut.datapath_inst.regfile_inst.registers[10], 12, "SLLI");
        expect_equal(dut.datapath_inst.regfile_inst.registers[11], 6, "SRLI dependency forwarding");
        expect_equal(dut.datapath_inst.regfile_inst.registers[12], 32'hfffffff0, "negative ADDI");
        expect_equal(dut.datapath_inst.regfile_inst.registers[13], 32'hfffffffc, "SRAI");
        expect_equal(dut.datapath_inst.regfile_inst.registers[14], 1, "SLTI");
        expect_equal(dut.datapath_inst.regfile_inst.registers[15], 1, "SLTIU");
        expect_equal(dut.datapath_inst.regfile_inst.registers[16], 13, "LW");
        expect_equal(dut.datapath_inst.regfile_inst.registers[17], 16, "load-use result");
        expect_equal(dut.datapath_inst.dmem_inst.memdata[1], 16, "store-data forwarding");
        expect_equal(dut.datapath_inst.regfile_inst.registers[19], 1, "taken BEQ flush");
        expect_equal(dut.datapath_inst.regfile_inst.registers[20], 2, "untaken BEQ");
        expect_equal(dut.datapath_inst.regfile_inst.registers[21], 108, "JAL link");
        expect_equal(dut.datapath_inst.regfile_inst.registers[22], 109, "JAL target and link forwarding");
        expect_equal(dut.datapath_inst.regfile_inst.registers[24], 128, "JALR link");
        expect_equal(dut.datapath_inst.regfile_inst.registers[25], 7, "JALR target and flush");
        expect_equal(dut.datapath_inst.dmem_inst.memdata[2], 7, "post-JALR forwarded store");
        expect_equal(dut.datapath_inst.regfile_inst.registers[0], 0, "x0 remains zero");
        expect_equal(stall_count, 2, "two load-use stalls");
        expect_equal(redirect_count, 3, "branch and jump redirects");

        if (errors == 0)
            $display("All five-stage pipeline tests passed.");
        else
            $fatal(1, "%0d pipeline test(s) failed.", errors);
        $finish;
    end
endmodule
