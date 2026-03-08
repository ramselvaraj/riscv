`timescale 1ns/1ps

module tb_alu;

    reg [31:0] rs1;
    reg [31:0] rs2;
    reg  [3:0] alu_ctrl;
    wire [31:0] alu_result;
    wire        zero;

    alu uut (
        .rs1(rs1),
        .rs2(rs2),
        .alu_ctrl(alu_ctrl),
        .alu_result(alu_result),
        .zero(zero)
    );

`define TEST_AND  4'b0000
`define TEST_OR   4'b0001
`define TEST_ADD  4'b0010
`define TEST_SUB  4'b0110
`define TEST_CASES 4

    integer i;
    reg [31:0] test_rs1    [0:`TEST_CASES-1];
    reg [31:0] test_rs2    [0:`TEST_CASES-1];
    reg  [3:0] test_alu_ctrl[0:`TEST_CASES-1];
    reg [31:0] golden      [0:`TEST_CASES-1];

    initial begin
        // Test vectors
        test_rs1[0] = 32'h0000000F; test_rs2[0] = 32'h000000F0; test_alu_ctrl[0] = `TEST_AND;
        test_rs1[1] = 32'h0000000F; test_rs2[1] = 32'h000000F0; test_alu_ctrl[1] = `TEST_OR;
        test_rs1[2] = 32'h0000000F; test_rs2[2] = 32'h000000F0; test_alu_ctrl[2] = `TEST_ADD;
        test_rs1[3] = 32'h0000000F; test_rs2[3] = 32'h000000F0; test_alu_ctrl[3] = `TEST_SUB;

        golden[0] = 32'h00000000;     // AND
        golden[1] = 32'h000000FF;     // OR
        golden[2] = 32'h000000FF;     // ADD
        golden[3] = 32'hFFFFFF1F;     // SUB → 15 - 240 = -225 → 0xFFFFFF1F

        $dumpfile("tb_alu.vcd");
        $dumpvars(0, tb_alu);

        for (i = 0; i < `TEST_CASES; i = i + 1) begin
            rs1       <= test_rs1[i];
            rs2       <= test_rs2[i];
            alu_ctrl  <= test_alu_ctrl[i];
            #10;

            $display("Test %0d: ctrl=%b  0x%h  ?  0x%h  →  0x%h   zero=%b",
                     i, alu_ctrl, rs1, rs2, alu_result, zero);

            if (alu_result !== golden[i])
                $display("  → FAIL  (expected 0x%h)", golden[i]);
            else
                $display("  → PASS");
        end

        #20 $finish;
    end

endmodule