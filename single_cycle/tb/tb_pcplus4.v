`timescale 1ns / 1ps

module tb_pcplus4;

// Inputs
reg clk;
reg reset;
reg [31:0] pc;
wire [31:0] pcplus4; 

//DUT
pc_plus4 uut (
    .pc(pc),
    .pcplus4(pcplus4)
);

always #5 clk = ~clk; // 10ns period clock

initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;
    pc = 32'h00000000;

    $dumpfile("tb_pcplus4.vcd");
    $dumpvars(0, tb_pcplus4);

    // Wait for global reset
    #10;
    reset = 0;

    // Test case 1: Normal operation
    $display("Test 1: Normal operation");
    pc = 32'h00000000;
    #10;
    if (pcplus4 !== 32'h00000004) $display("ERROR: Expected pcplus4=0x00000004, got 0x%h", pcplus4);

    pc = 32'h00000004;
    #10;
    if (pcplus4 !== 32'h00000008) $display("ERROR: Expected pcplus4=0x00000008, got 0x%h", pcplus4);

    pc = 32'h00000008;
    #10;
    if (pcplus4 !== 32'h0000000C) $display("ERROR: Expected pcplus4=0x0000000C, got 0x%h", pcplus4);
    
    $display("Test 2: Edge case with large value");
    pc = 32'hFFFFFFFC;
    #10;
    if (pcplus4 !== 32'h00000000) $display("ERROR: Expected pcplus4=0x00000000, got 0x%h", pcplus4);

    $display("All tests completed");
    $finish;
end

endmodule //tb_pcplus4