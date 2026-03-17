`timescale 1ns/1ps

module pc_mux(
    input [31:0] pc_plus4,
    input [31:0] branch_target,
    input branch_taken,
    output [31:0] next_pc
);

assign next_pc = branch_taken ? branch_target : pc_plus4;

endmodule //pc_mux