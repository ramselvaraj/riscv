module inst_mem(
  input clk,
  input reset,
  input [31:0] read_addr,
  output reg [31:0] inst_out
);

integer  k;
reg [31:0] I_Mem[63:0];

always @(posedge clk or posedge reset) begin
  if (reset) begin
    for (k = 0; k < 64; k = k+1) begin
      I_Mem[k] <= 32'b0;
    end
  end
  else
    inst_out <= I_Mem[read_addr];
end

endmodule //inst_mem
