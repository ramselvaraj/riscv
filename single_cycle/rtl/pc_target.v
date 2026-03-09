module pc_target(
    input [31:0] pc,
    input [31:0] imm_ext,
    output [31:0] pc_target
);

assign pc_target = pc + imm_ext;

endmodule //pc_target