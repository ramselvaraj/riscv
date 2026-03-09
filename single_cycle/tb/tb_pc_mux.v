`timescale 1ns / 1ps

module tb_pc_mux;

reg [31:0] pc_plus4;
reg [31:0] branch_target;
reg branch_taken;
wire [31:0] next_pc;

pc_mux uut(
    .pc_plus4(pc_plus4),
    .branch_target(branch_target),
    .branch_taken(branch_taken),
    .next_pc(next_pc)
);

initial begin
    $dumpfile("tb_pc_mux.vcd");
    $dumpvars(0, tb_pc_mux);

    $monitor("At time %d, pc_plus4 = %h, branch_target = %h, branch_taken = %b, next_pc = %h", $time, pc_plus4, branch_target, branch_taken, next_pc);
    
    // Test case 1: branch not taken
    pc_plus4 = 32'h00000004;
    branch_target = 32'h00000010;
    branch_taken = 0;
    #10; // wait for the output to stabilize
    if (next_pc !== 32'h00000004) $display("Error: expected next_pc = %h, got %h", 32'h00000004, next_pc);
    
    // Test case 2: branch taken
    pc_plus4 = 32'h00000008;
    branch_target = 32'h00000020;
    branch_taken = 1;
    #10; // wait for the output to stabilize
    if (next_pc !== 32'h00000020) $display("Error: expected next_pc = %h, got %h", 32'h00000020, next_pc);
    
    $finish;
end

endmodule //tb_pc_mux