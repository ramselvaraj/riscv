`timescale 1ns/1ps

module tb_datapath;

reg clk;
reg reset;

datapath dut(
    .clk(clk),
    .reset(reset)
);

always #5 clk = ~clk; // 10ns clock period

initial begin
    clk = 0;
    reset = 1;

    #20 reset = 0;

    #1000 $finish;

end

endmodule // tb_datapath
