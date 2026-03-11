`timescale 1ns/1ps

module inst_mem(
  input clk,
  input reset,
  input [31:0] read_addr,
  output reg [31:0] inst_out
);

integer  k;
reg [31:0] I_Mem[63:0];

// always @(posedge clk or posedge reset) begin
//   if (reset) begin
//     for (k = 0; k < 64; k = k+1) begin
//       I_Mem[k] <= 32'b0;
//     end
//     // I_Mem[0] <= 32'h003100B3; //add x1, x2, x3
//     I_Mem[0] <= 32'h00002003; //lw x0, 0(x0)
//     I_Mem[4] <= 32'h00000033; //add x0, x0, x0
  
//     //I_Mem[4] <= 32'h0000B103; //lw x2, 0(x1)
//     //I_Mem[8] <= 32'h0000B103; //lw x2, 0(x0)
//     // I_Mem[8] <= 32'h003100B3; //and x1,x2,x3
//     // I_Mem[12] <= 32'h003160B3; //or x1,x2,x3
    

//   end
//   else
//     inst_out <= I_Mem[read_addr];
// end

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

  //load instructions
  //I_Mem[20] = 32'b

  //SW Instruction
  //I_Mem[20] = 32'h00948663; //beq x9, x9, 12
  I_Mem[20] = 32'hfe108ae3; //beq x9, x9, -12

  end
  else begin
    inst_out = I_Mem[read_addr];
  end 
  
end

endmodule //inst_mem
