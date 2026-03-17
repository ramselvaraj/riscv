`timescale 1ns/1ps

module alu_mux(
    input [31:0] rd2,k
    input [31:0] imm,
    input alu_src,
    output [31:0] alu_rs2
);
// select between rd2 and imm based on the alu_src signal, and output the result as alu_rs2
// used to alternate between second reg value or calculations for load and store instructions, and for R-type instructions


    assign alu_rs2 = (alu_src) ? imm : rd2;

endmodule // alu_mux