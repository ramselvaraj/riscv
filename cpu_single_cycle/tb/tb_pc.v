`timescale 1ns / 1ps

module tb_pc;

// Inputs
reg clk;
reg reset;
reg [31:0] pc_next;

// Outputs
wire [31:0] pc;

// Instantiate the Unit Under Test (UUT)
pc uut (
    .clk(clk),
    .reset(reset),
    .pc_next(pc_next),
    .pc(pc)
);

// Clock generation
always #5 clk = ~clk; // 10ns period clock

// Test sequence
initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;
    pc_next = 32'h00000000;

    $dumpfile("tb_pc.vcd");
    $dumpvars(0, tb_pc);

    // Wait for global reset
    #10;
    reset = 0;

    // Test case 1: Normal operation
    $display("Test 1: Normal operation");
    pc_next = 32'h00000004;
    #10;
    if (pc !== 32'h00000004) $display("ERROR: Expected pc=0x00000004, got 0x%h", pc);

    pc_next = 32'h00000008;
    #10;
    if (pc !== 32'h00000008) $display("ERROR: Expected pc=0x00000008, got 0x%h", pc);

    pc_next = 32'h0000000C;
    #10;
    if (pc !== 32'h0000000C) $display("ERROR: Expected pc=0x0000000C, got 0x%h", pc);

    // Test case 2: Reset functionality
    $display("Test 2: Reset functionality");
    reset = 1;
    #10;
    if (pc !== 32'h00000000) $display("ERROR: Expected pc=0x00000000 after reset, got 0x%h", pc);

    reset = 0;
    pc_next = 32'h00000010;
    #10;
    if (pc !== 32'h00000010) $display("ERROR: Expected pc=0x00000010, got 0x%h", pc);

    // Test case 3: Asynchronous reset during operation
    $display("Test 3: Asynchronous reset during operation");
    pc_next = 32'h00000014;
    #5; // Half clock cycle
    reset = 1;
    #5; // Complete clock cycle
    if (pc !== 32'h00000000) $display("ERROR: Expected pc=0x00000000 after async reset, got 0x%h", pc);

    $display("All tests completed.");
    $finish;
end

endmodule