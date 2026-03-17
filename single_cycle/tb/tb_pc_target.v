`timescale 1ns / 1ps
module tb_pc_target;

reg [31:0] pc;
reg [31:0] imm_ext;
wire [31:0] pc_target;

pc_target uut (
    .pc(pc),    
    .imm_ext(imm_ext),
    .pc_target(pc_target)
);

initial begin

$dumpfile("tb_pc_target.vcd");
$dumpvars(0, tb_pc_target);
$monitor("At time %d, pc = %d, imm_ext = %d, pc_target = %d", $time, pc, imm_ext, pc_target);

// Test case 1: PC = 0, imm_ext = 4
pc = 32'd0;
imm_ext = 32'd4;
#10;

// Test case 2: PC = 100, imm_ext = 20
pc = 32'd100;
imm_ext = 32'd20;
#10;

// Test case 3: PC = 0xFFFFFFFF, imm_ext = 1 (overflow case)
pc = 32'hFFFFFFFF;
imm_ext = 32'd1;
#10;



end

endmodule //tb_pc_target