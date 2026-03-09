`timescale 1ns/1ps

module data_mux(
    input [31:0] alu_result,
    input [31:0] mem_data,
    input mem_to_reg,
    output [31:0] reg_write_data
);

    assign reg_write_data = (mem_to_reg) ? mem_data : alu_result;

endmodule // data_mux