`timescale 1ns/1ps

module alu_mux(
    input [31:0] rd2,
    input [31:0] imm,
    input alu_src,
    output [31:0] alu_rs2
);

    assign alu_rs2 = (alu_src) ? imm : rd2;

endmodule // alu_mux