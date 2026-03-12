`timescale 1ns/1ps

module riscv_sc(
    input clk,
    input rst
); // RISC V Single Cycle Processor 
//datapath wrapper module

datapath datapath_inst(
    .clk(clk),
    .reset(rst)
);


endmodule //riscv_sc
