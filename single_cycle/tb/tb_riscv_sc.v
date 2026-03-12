`timescale 1ns/1ps

module tb_riscv_sc;

reg clk;
reg reset;

riscv_sc dut(
    .clk(clk),
    .rst(reset)
);

initial begin
    #10;
    clk = 0;
    forever #5 clk = ~clk;   // 10 ns clock period
end

initial begin
    reset = 1;   // assert reset
    #5;          // hold for 5 time units (5 ns)
    reset = 0;   // release reset
end
    

initial begin


    $dumpfile("tb_riscv_sc.vcd");
    $dumpvars(0, tb_riscv_sc);

#20 reset = 0;
    
    #1000 $finish;

end

endmodule // tb_datapath
