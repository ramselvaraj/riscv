module id_ex_reg(
    input  logic        clk,
    input  logic        reset,
    input  logic        flush,
    input  logic        valid_in,
    input  logic [31:0] pc_in,
    input  logic [31:0] pc4_in,
    input  logic [31:0] rs1_data_in,
    input  logic [31:0] rs2_data_in,
    input  logic [31:0] immediate_in,
    input  logic [4:0]  rs1_in,
    input  logic [4:0]  rs2_in,
    input  logic [4:0]  rd_in,
    input  logic        reg_write_in,
    input  logic        mem_read_in,
    input  logic        mem_write_in,
    input  logic        mem_to_reg_in,
    input  logic        alu_src_imm_in,
    input  logic        branch_in,
    input  logic        jump_in,
    input  logic        jump_reg_in,
    input  logic        wb_pc4_in,
    input  logic [3:0]  alu_operation_in,
    output logic        valid_out,
    output logic [31:0] pc_out,
    output logic [31:0] pc4_out,
    output logic [31:0] rs1_data_out,
    output logic [31:0] rs2_data_out,
    output logic [31:0] immediate_out,
    output logic [4:0]  rs1_out,
    output logic [4:0]  rs2_out,
    output logic [4:0]  rd_out,
    output logic        reg_write_out,
    output logic        mem_read_out,
    output logic        mem_write_out,
    output logic        mem_to_reg_out,
    output logic        alu_src_imm_out,
    output logic        branch_out,
    output logic        jump_out,
    output logic        jump_reg_out,
    output logic        wb_pc4_out,
    output logic [3:0]  alu_operation_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            valid_out <= 1'b0;
            pc_out <= 32'b0;
            pc4_out <= 32'b0;
            rs1_data_out <= 32'b0;
            rs2_data_out <= 32'b0;
            immediate_out <= 32'b0;
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out <= 5'b0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            alu_src_imm_out <= 1'b0;
            branch_out <= 1'b0;
            jump_out <= 1'b0;
            jump_reg_out <= 1'b0;
            wb_pc4_out <= 1'b0;
            alu_operation_out <= 4'b0;
        end else begin
            valid_out <= valid_in;
            pc_out <= pc_in;
            pc4_out <= pc4_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            immediate_out <= immediate_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            alu_src_imm_out <= alu_src_imm_in;
            branch_out <= branch_in;
            jump_out <= jump_in;
            jump_reg_out <= jump_reg_in;
            wb_pc4_out <= wb_pc4_in;
            alu_operation_out <= alu_operation_in;
        end
    end
endmodule
