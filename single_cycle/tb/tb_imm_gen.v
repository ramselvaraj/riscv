`timescale 1ns/1ps
module tb_imm_gen;

reg [31:0] instr;
wire [31:0] imm_ext;

imm_gen uut (
    .instr(instr),
    .imm_ext(imm_ext)
);

initial begin

    $dumpfile("tb_imm_gen.vcd");
    $dumpvars(0, tb_imm_gen);
    
    // Test case 1: I-type instruction (LW)
    instr = 32'b000000000001_00000_010_00001_0000011; // LW x1, 1(x0)
    #10;
    $display("Test case 1: I-type (LW) - imm_ext: %b", imm_ext);

    // Test case 2: S-type instruction (SW)
    instr = 32'b0000000_00010_00001_010_00000_0100011; // SW x2, 0(x1)
    #10;
    $display("Test case 2: S-type (SW) - imm_ext: %b", imm_ext);

    // Test case 3: SB-type instruction (BEQ)
    instr = 32'b0000000_00010_00001_000_00000_1100011; // BEQ x2, x1, offset 0
    #10;
    $display("Test case 3: SB-type (BEQ) - imm_ext: %b", imm_ext);

    // Test case 4: I-type instruction (LW)
    instr = 32'b100000000001_00000_010_00001_0000011; // LW x1, 1(x0)
    #10;
    $display("Test case 4: I-type (LW) - imm_ext: %b", imm_ext);

    // Test case 5: S-type instruction (SW)
    instr = 32'b1000000_00010_00001_010_00000_0100011; // SW x2, 0(x1)
    #10;
    $display("Test case 5: S-type (SW) - imm_ext: %b", imm_ext);

    // Test case 6: SB-type instruction (BEQ)
    instr = 32'b1000000_00010_00001_000_00000_1100011; // BEQ x2, x1, offset 0
    #10;
    $display("Test case 6: SB-type (BEQ) - imm_ext: %b", imm_ext);

end

endmodule //tb_imm_gen