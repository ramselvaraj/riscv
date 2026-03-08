module imm_gen(
    input [31:0] instr,
    output reg [31:0] imm_ext
);

always @(*) begin
    case (instr[6:0])
    7'b0000011: imm_ext = {{20{instr[31]}}, instr[31:20]}; // I-type
    7'b0100011: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
    7'b1100011: imm_ext = {{19{instr[31]}}, instr[31], instr[30:25], instr[11:8], 1'b0}; // SB-type
    endcase
end

endmodule //imm_gen