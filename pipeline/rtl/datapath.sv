module pipeline_datapath(
    input logic clk,
    input logic reset
);
    logic [31:0] pc, pc_plus4, fetched_instruction;

    logic if_id_valid;
    logic [31:0] if_id_pc, if_id_pc4, if_id_instruction;
    logic [4:0] decode_rs1, decode_rs2, decode_rd;
    logic [31:0] reg_read1, reg_read2, decode_data1, decode_data2, decode_immediate;
    logic decode_instruction_valid, decode_reg_write, decode_mem_read, decode_mem_write;
    logic decode_mem_to_reg, decode_alu_src_imm, decode_branch, decode_jump;
    logic decode_jump_reg, decode_wb_pc4, decode_use_rs1, decode_use_rs2;
    logic [2:0] decode_immediate_type;
    logic [3:0] decode_alu_operation;

    logic id_ex_valid;
    logic [31:0] id_ex_pc, id_ex_pc4, id_ex_data1, id_ex_data2, id_ex_immediate;
    logic [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;
    logic id_ex_reg_write, id_ex_mem_read, id_ex_mem_write, id_ex_mem_to_reg;
    logic id_ex_alu_src_imm, id_ex_branch, id_ex_jump, id_ex_jump_reg, id_ex_wb_pc4;
    logic [3:0] id_ex_alu_operation;

    logic [1:0] forward_a_select, forward_b_select;
    logic [31:0] forwarded_a, forwarded_b, alu_b, alu_result, execute_result;
    logic branch_equal, redirect;
    logic [31:0] redirect_target;

    logic ex_mem_valid;
    logic [31:0] ex_mem_result, ex_mem_store_data;
    logic [4:0] ex_mem_rd;
    logic ex_mem_reg_write, ex_mem_mem_read, ex_mem_mem_write, ex_mem_mem_to_reg;
    logic [31:0] memory_read_data;

    logic mem_wb_valid;
    logic [31:0] mem_wb_result, mem_wb_memory_data, writeback_data;
    logic [4:0] mem_wb_rd;
    logic mem_wb_reg_write, mem_wb_mem_to_reg;
    logic writeback_enable;

    logic stall;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else if (redirect)
            pc <= redirect_target;
        else if (!stall)
            pc <= pc_plus4;
    end

    assign pc_plus4 = pc + 32'd4;

    pipeline_instruction_memory imem_inst(
        .address(pc),
        .instruction(fetched_instruction)
    );

    if_id_reg if_id_reg_inst(
        .clk,
        .reset,
        .enable(!stall),
        .flush(redirect),
        .valid_in(1'b1),
        .pc_in(pc),
        .pc4_in(pc_plus4),
        .instruction_in(fetched_instruction),
        .valid_out(if_id_valid),
        .pc_out(if_id_pc),
        .pc4_out(if_id_pc4),
        .instruction_out(if_id_instruction)
    );

    assign decode_rs1 = if_id_instruction[19:15];
    assign decode_rs2 = if_id_instruction[24:20];
    assign decode_rd = if_id_instruction[11:7];

    pipeline_controller controller_inst(
        .opcode(if_id_instruction[6:0]),
        .funct3(if_id_instruction[14:12]),
        .funct7_bit(if_id_instruction[30]),
        .instruction_valid(decode_instruction_valid),
        .reg_write(decode_reg_write),
        .mem_read(decode_mem_read),
        .mem_write(decode_mem_write),
        .mem_to_reg(decode_mem_to_reg),
        .alu_src_imm(decode_alu_src_imm),
        .branch(decode_branch),
        .jump(decode_jump),
        .jump_reg(decode_jump_reg),
        .wb_pc4(decode_wb_pc4),
        .use_rs1(decode_use_rs1),
        .use_rs2(decode_use_rs2),
        .immediate_type(decode_immediate_type),
        .alu_operation(decode_alu_operation)
    );

    pipeline_immediate_generator immediate_generator_inst(
        .instruction(if_id_instruction),
        .immediate_type(decode_immediate_type),
        .immediate(decode_immediate)
    );

    assign writeback_data = mem_wb_mem_to_reg ? mem_wb_memory_data : mem_wb_result;
    assign writeback_enable = mem_wb_valid && mem_wb_reg_write;

    pipeline_reg_file regfile_inst(
        .clk,
        .reset,
        .write_enable(writeback_enable),
        .read_addr1(decode_rs1),
        .read_addr2(decode_rs2),
        .write_addr(mem_wb_rd),
        .write_data(writeback_data),
        .read_data1(reg_read1),
        .read_data2(reg_read2)
    );

    // Explicit WB-to-ID bypass avoids dependence on register-file edge timing.
    assign decode_data1 = (writeback_enable && mem_wb_rd != 5'b0 && mem_wb_rd == decode_rs1)
                        ? writeback_data : reg_read1;
    assign decode_data2 = (writeback_enable && mem_wb_rd != 5'b0 && mem_wb_rd == decode_rs2)
                        ? writeback_data : reg_read2;

    pipeline_hazard_unit hazard_unit_inst(
        .id_ex_valid,
        .id_ex_mem_read,
        .id_ex_rd,
        .if_id_rs1(decode_rs1),
        .if_id_rs2(decode_rs2),
        .if_id_use_rs1(decode_use_rs1),
        .if_id_use_rs2(decode_use_rs2),
        .stall
    );

    id_ex_reg id_ex_reg_inst(
        .clk,
        .reset,
        .flush(redirect || stall),
        .valid_in(if_id_valid && decode_instruction_valid),
        .pc_in(if_id_pc),
        .pc4_in(if_id_pc4),
        .rs1_data_in(decode_data1),
        .rs2_data_in(decode_data2),
        .immediate_in(decode_immediate),
        .rs1_in(decode_rs1),
        .rs2_in(decode_rs2),
        .rd_in(decode_rd),
        .reg_write_in(decode_reg_write),
        .mem_read_in(decode_mem_read),
        .mem_write_in(decode_mem_write),
        .mem_to_reg_in(decode_mem_to_reg),
        .alu_src_imm_in(decode_alu_src_imm),
        .branch_in(decode_branch),
        .jump_in(decode_jump),
        .jump_reg_in(decode_jump_reg),
        .wb_pc4_in(decode_wb_pc4),
        .alu_operation_in(decode_alu_operation),
        .valid_out(id_ex_valid),
        .pc_out(id_ex_pc),
        .pc4_out(id_ex_pc4),
        .rs1_data_out(id_ex_data1),
        .rs2_data_out(id_ex_data2),
        .immediate_out(id_ex_immediate),
        .rs1_out(id_ex_rs1),
        .rs2_out(id_ex_rs2),
        .rd_out(id_ex_rd),
        .reg_write_out(id_ex_reg_write),
        .mem_read_out(id_ex_mem_read),
        .mem_write_out(id_ex_mem_write),
        .mem_to_reg_out(id_ex_mem_to_reg),
        .alu_src_imm_out(id_ex_alu_src_imm),
        .branch_out(id_ex_branch),
        .jump_out(id_ex_jump),
        .jump_reg_out(id_ex_jump_reg),
        .wb_pc4_out(id_ex_wb_pc4),
        .alu_operation_out(id_ex_alu_operation)
    );

    pipeline_forwarding_unit forwarding_unit_inst(
        .id_ex_rs1,
        .id_ex_rs2,
        .ex_mem_reg_write(ex_mem_valid && ex_mem_reg_write),
        .ex_mem_mem_to_reg,
        .ex_mem_rd,
        .mem_wb_reg_write(writeback_enable),
        .mem_wb_rd,
        .forward_a(forward_a_select),
        .forward_b(forward_b_select)
    );

    always_comb begin
        case (forward_a_select)
            2'b10: forwarded_a = ex_mem_result;
            2'b01: forwarded_a = writeback_data;
            default: forwarded_a = id_ex_data1;
        endcase
        case (forward_b_select)
            2'b10: forwarded_b = ex_mem_result;
            2'b01: forwarded_b = writeback_data;
            default: forwarded_b = id_ex_data2;
        endcase
    end

    assign alu_b = id_ex_alu_src_imm ? id_ex_immediate : forwarded_b;

    pipeline_alu alu_inst(
        .a(forwarded_a),
        .b(alu_b),
        .operation(id_ex_alu_operation),
        .result(alu_result)
    );

    assign execute_result = id_ex_wb_pc4 ? id_ex_pc4 : alu_result;
    assign branch_equal = (forwarded_a == forwarded_b);
    assign redirect = id_ex_valid && (id_ex_jump || (id_ex_branch && branch_equal));
    assign redirect_target = id_ex_jump_reg
                           ? ((forwarded_a + id_ex_immediate) & 32'hffff_fffe)
                           : (id_ex_pc + id_ex_immediate);

    ex_mem_reg ex_mem_reg_inst(
        .clk,
        .reset,
        .valid_in(id_ex_valid),
        .result_in(execute_result),
        .store_data_in(forwarded_b),
        .rd_in(id_ex_rd),
        .reg_write_in(id_ex_reg_write),
        .mem_read_in(id_ex_mem_read),
        .mem_write_in(id_ex_mem_write),
        .mem_to_reg_in(id_ex_mem_to_reg),
        .valid_out(ex_mem_valid),
        .result_out(ex_mem_result),
        .store_data_out(ex_mem_store_data),
        .rd_out(ex_mem_rd),
        .reg_write_out(ex_mem_reg_write),
        .mem_read_out(ex_mem_mem_read),
        .mem_write_out(ex_mem_mem_write),
        .mem_to_reg_out(ex_mem_mem_to_reg)
    );

    pipeline_data_memory dmem_inst(
        .clk,
        .reset,
        .write_enable(ex_mem_valid && ex_mem_mem_write),
        .read_enable(ex_mem_valid && ex_mem_mem_read),
        .address(ex_mem_result),
        .write_data(ex_mem_store_data),
        .read_data(memory_read_data)
    );

    mem_wb_reg mem_wb_reg_inst(
        .clk,
        .reset,
        .valid_in(ex_mem_valid),
        .result_in(ex_mem_result),
        .memory_data_in(memory_read_data),
        .rd_in(ex_mem_rd),
        .reg_write_in(ex_mem_reg_write),
        .mem_to_reg_in(ex_mem_mem_to_reg),
        .valid_out(mem_wb_valid),
        .result_out(mem_wb_result),
        .memory_data_out(mem_wb_memory_data),
        .rd_out(mem_wb_rd),
        .reg_write_out(mem_wb_reg_write),
        .mem_to_reg_out(mem_wb_mem_to_reg)
    );
endmodule
