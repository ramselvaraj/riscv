module riscv_pipeline(
    input logic clk,
    input logic reset
);
    pipeline_datapath datapath_inst(.clk, .reset);
endmodule
