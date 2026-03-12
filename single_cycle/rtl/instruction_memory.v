`timescale 1ns/1ps

module inst_mem(
  input clk,
  input reset,
  input [31:0] read_addr,
  output reg [31:0] inst_out
);

integer  k;
reg [31:0] I_Mem[63:0];

always @(*) begin
  if (reset) begin
    for (k = 0; k < 64; k = k+1) begin
      I_Mem[k] = 32'b0;
    end
    
  //R-type instructions  
  I_Mem[0] = 32'b0; // NOP
  I_Mem[4] = 32'b0000000_11001_10000_000_01101_0110011; // add x13, x16, x25
  I_Mem[8] = 32'b0100000_00011_01000_000_00101_0110011; // sub x5, x8, x3
  I_Mem[12] = 32'b0000000_00011_00010_111_00001_0110011; // and x1, x2, x3
  I_Mem[16] = 32'b0000000_00101_00011_110_00100_0110011; //or x4, x3, x5

  //I-type instructions
  I_Mem[20] = 32'b000000001111_00101_010_01000_0000011; //lw x8, 15(x5)
  I_Mem[24] = 32'b000000000011_00011_010_01001_0000011; //lw x9, 3(x3)

  //S Type Instructions
  I_Mem[28] = 32'b0000000_01111_00101_010_01100_0100011; // sw x15, 12(x5)
  I_Mem[32] = 32'b0000000_01110_00110_010_01010_0100011; // sw x14, 10(x6)
  
  
  //SB Instruction
  I_Mem[36] = 32'h00948663; //beq x9, x9, 12
  //I_Mem[36] = 32'hfe108ae3; //beq x9, x9, -12
  I_Mem[48] = 32'b0000000_11001_10000_000_01101_0110011; // add x13, x16, x25

  end
  else begin
    inst_out = I_Mem[read_addr];
  end 
  
end

endmodule //inst_mem
