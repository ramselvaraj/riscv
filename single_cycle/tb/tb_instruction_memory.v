`timescale 1ns/1ps
module tb_instruction_memory;

reg clk;
reg reset;
reg [31:0] read_addr;
wire [31:0] inst_out;

inst_mem uut(
    .clk(clk),
    .reset(reset),
    .read_addr(read_addr),
    .inst_out(inst_out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("tb_instruction_memory.vcd");
    $dumpvars(0, tb_instruction_memory);
    
    $monitor("At time %d, read_addr = %d, inst_out = %h", $time, read_addr, inst_out);
    
    reset = 1;
    #10;
    reset = 0;
    #10; // wait for one clock cycle after reset
    
    read_addr = 32'd0;
    #10;
    if (inst_out !== 32'h0) $display("Error at address 0: expected 0, got %h", inst_out);
    
    read_addr = 32'd4;
    #10;
    if (inst_out !== 32'h0) $display("Error at address 4: expected 0, got %h", inst_out);
    
    read_addr = 32'd8;
    #10;
    if (inst_out !== 32'h0) $display("Error at address 8: expected 0, got %h", inst_out);
    
    read_addr = 32'd12;
    #10;
    if (inst_out !== 32'h0) $display("Error at address 12: expected 0, got %h", inst_out);
    
    $finish;
end

endmodule //tb_instruction_memory