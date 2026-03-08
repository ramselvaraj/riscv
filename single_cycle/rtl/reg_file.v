module reg_file(
  //pass values stored at rreg1 and rreg2 inside the register to rdata1,
  //rdata2 respectively
  //
  //if regwrite control signal is enabled, then write the wdata into register
  //at position wreg
  input clk,
  input reset,
  input regwrite, 
  input [4:0] rreg1,  rreg2, wreg,
  input [31:0] wdata,
  output reg [31:0] rdata1, rdata2
);

integer k;
reg [31:0] registers [31:0];
assign rdata1 = registers[rreg1];
assign rdata2 = registers[rreg2];

always @(posedge clk or posedge reset) begin
  if(reset) begin
    for (k = 0; k < 32; k = k + 1) begin
      registers[k] <= 32'b0;
    end
  end

  elseif (regwrite) begin
    registers[wreg] <= wdata;
  end

end


endmodule //reg_file
