`timescale 1ns/1ps

module alu(
    input [31:0] rs1,
    input [31:0] rs2,
    input [3:0] alu_ctrl,
    output reg [31:0] alu_result,
    output reg zero
);

// will perform the ALU operation specified by the alu_ctrl signal on the inputs rs1 and rs2, and output the result as alu_result
// zero bit is toggled when sub operation results in zero, used for branch instructions

always @(*) begin
    alu_result = 32'b0;

    case (alu_ctrl)
        4'b0000: begin zero = 0; alu_result = rs1 & rs2; end // AND
        4'b0001: begin zero = 0; alu_result = rs1 | rs2; end // OR
        4'b0010: begin zero = 0; alu_result = rs1 + rs2; end  // ADD
        4'b0110: begin alu_result = rs1 - rs2; zero =  1;
                end // SUB
    endcase
end

endmodule //alu