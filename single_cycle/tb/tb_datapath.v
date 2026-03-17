`timescale 1ns/1ps

module tb_datapath;

reg clk;
reg reset;

datapath dut(
    .clk(clk),
    .reset(reset)
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


    $dumpfile("tb_datapath.vcd");
    $dumpvars(0, tb_datapath);

    $monitor("Time: %0t | PC: %h | Instruction: %h | RegWrite: %b | ALU Result: %h", 
             $time, dut.pc_top, dut.instruction_top, dut.regwrite_top, dut.alu_result_top);

#20 reset = 0;
    
    #1000 $finish;

end

endmodule // tb_datapath
