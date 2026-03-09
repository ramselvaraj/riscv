`timescale 1ns/1ps

module alu_mux(
    input rd2,
    input imm,
    input alu_src,
    output alu_rs2
);

    assign alu_rs2 = (alu_src) ? imm : rd2;

endmodule // alu_mux