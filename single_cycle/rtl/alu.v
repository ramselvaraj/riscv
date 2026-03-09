`timescale 1ns/1ps

module alu(
    input [31:0] rs1,
    input [31:0] rs2,
    input [3:0] alu_ctrl,
    output reg [31:0] alu_result,
    output reg zero
);

always @(alu_ctrl or rs1 or rs2) begin

    alu_result = 32'b0;
    zero = 1'b0;

    case (alu_ctrl)
        4'b0000: begin zero <= 0; alu_result <= rs1 & rs2; end // AND
        4'b0001: begin zero <= 0; alu_result <= rs1 | rs2; end // OR
        4'b0010: begin zero <= 0; alu_result <= rs1 + rs2; end  // ADD
        4'b0110: begin alu_result <= rs1 - rs2; zero <=  (rs1 == rs2);
                end // SUB
    endcase
end

endmodule //alu