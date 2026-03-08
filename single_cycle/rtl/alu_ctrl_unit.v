module alu_ctrl_unit(
    input [1:0] alu_op,
    input funct7,
    input [2:0] funct3,
    output [3:0] alu_ctrl
);
    always @(*) begin
    case ({alu_op,funct7, funct3})
        6'b00_0_000: alu_ctrl <= 4'b0010; // LW, SW (ADD)
        6'b01_0_000: alu_ctrl <= 4'b0110; // BEQ (SUB)
        6'b10_0_000: alu_ctrl <= 4'b0010; // R-type ADD
        6'b10_0_111: alu_ctrl <= 4'b0000; // R-type AND
        6'b10_0_110: alu_ctrl <= 4'b0001; // R-type OR
        6'b10_1_000: alu_ctrl <= 4'b0110; // R-type SUB
    
    endcase
    end

endmodule //alu_ctrl_unit