module pipeline_controller(
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic       funct7_bit,
    output logic       instruction_valid,
    output logic       reg_write,
    output logic       mem_read,
    output logic       mem_write,
    output logic       mem_to_reg,
    output logic       alu_src_imm,
    output logic       branch,
    output logic       jump,
    output logic       jump_reg,
    output logic       wb_pc4,
    output logic       use_rs1,
    output logic       use_rs2,
    output logic [2:0] immediate_type,
    output logic [3:0] alu_operation
);
    localparam logic [6:0] OP_RTYPE = 7'b0110011;
    localparam logic [6:0] OP_ITYPE = 7'b0010011;
    localparam logic [6:0] OP_LW    = 7'b0000011;
    localparam logic [6:0] OP_SW    = 7'b0100011;
    localparam logic [6:0] OP_BRANCH= 7'b1100011;
    localparam logic [6:0] OP_JAL   = 7'b1101111;
    localparam logic [6:0] OP_JALR  = 7'b1100111;

    localparam logic [2:0] IMM_I = 3'd0, IMM_S = 3'd1,
                           IMM_B = 3'd2, IMM_J = 3'd3;
    localparam logic [3:0] ALU_ADD = 4'd0, ALU_SUB = 4'd1,
                           ALU_AND = 4'd2, ALU_OR = 4'd3,
                           ALU_XOR = 4'd4, ALU_SLT = 4'd5,
                           ALU_SLTU = 4'd6, ALU_SLL = 4'd7,
                           ALU_SRL = 4'd8, ALU_SRA = 4'd9;

    always_comb begin
        instruction_valid = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;
        alu_src_imm = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
        jump_reg = 1'b0;
        wb_pc4 = 1'b0;
        use_rs1 = 1'b0;
        use_rs2 = 1'b0;
        immediate_type = IMM_I;
        alu_operation = ALU_ADD;

        case (opcode)
            OP_RTYPE: begin
                use_rs1 = 1'b1;
                use_rs2 = 1'b1;
                case (funct3)
                    3'b000: begin
                        instruction_valid = 1'b1;
                        reg_write = 1'b1;
                        alu_operation = funct7_bit ? ALU_SUB : ALU_ADD;
                    end
                    3'b110: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_OR; end
                    3'b111: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_AND; end
                    default: ;
                endcase
            end
            OP_ITYPE: begin
                use_rs1 = 1'b1;
                alu_src_imm = 1'b1;
                immediate_type = IMM_I;
                case (funct3)
                    3'b000: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_ADD; end
                    3'b010: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_SLT; end
                    3'b011: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_SLTU; end
                    3'b100: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_XOR; end
                    3'b110: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_OR; end
                    3'b111: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_AND; end
                    3'b001: begin instruction_valid = 1'b1; reg_write = 1'b1; alu_operation = ALU_SLL; end
                    3'b101: begin
                        instruction_valid = 1'b1;
                        reg_write = 1'b1;
                        alu_operation = funct7_bit ? ALU_SRA : ALU_SRL;
                    end
                    default: ;
                endcase
            end
            OP_LW: if (funct3 == 3'b010) begin
                instruction_valid = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_to_reg = 1'b1;
                alu_src_imm = 1'b1;
                use_rs1 = 1'b1;
            end
            OP_SW: if (funct3 == 3'b010) begin
                instruction_valid = 1'b1;
                mem_write = 1'b1;
                alu_src_imm = 1'b1;
                use_rs1 = 1'b1;
                use_rs2 = 1'b1;
                immediate_type = IMM_S;
            end
            OP_BRANCH: if (funct3 == 3'b000) begin
                instruction_valid = 1'b1;
                branch = 1'b1;
                use_rs1 = 1'b1;
                use_rs2 = 1'b1;
                immediate_type = IMM_B;
                alu_operation = ALU_SUB;
            end
            OP_JAL: begin
                instruction_valid = 1'b1;
                reg_write = 1'b1;
                jump = 1'b1;
                wb_pc4 = 1'b1;
                immediate_type = IMM_J;
            end
            OP_JALR: if (funct3 == 3'b000) begin
                instruction_valid = 1'b1;
                reg_write = 1'b1;
                jump = 1'b1;
                jump_reg = 1'b1;
                wb_pc4 = 1'b1;
                use_rs1 = 1'b1;
                immediate_type = IMM_I;
            end
            default: ;
        endcase
    end
endmodule
