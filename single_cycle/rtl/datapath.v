`timescale 1ns/1ps

module datapath(
    input clk,
    input reset,
);

//core datapath module, instantiates all submodules and wires them together


//pc and instruction wires
wire [31:0] pc_top, pc_next_top, instruction_top, immediate_top;
wire [31:0] pc_target_top, pc_plus4_top;
wire branch_taken_top;


//register wires
wire [31:0] rdata1_top, rdata2_top;


//alu & control wires
wire [3:0] alu_ctrl_top;
wire [31:0] alu_rs2_top, alu_result_top;
wire alu_zero_top;


//control wires
wire regwrite_top, branch_top, memread_top, memtoreg_top, memwrite_top, alusrc_top;
wire [1:0] alu_op_top;


//data memory wires
wire [31:0] data_rdata_top;
wire [31:0] reg_write_data_top;


pc pc_inst(
    .clk(clk),
    .reset(reset),
    .pc_next(pc_next_top),
    .pc(pc_top)
);

pc_plus4 pc_plus4_inst(
    .pc(pc_top),
    .pcplus4(pc_plus4_top)
);

pc_target pc_target_inst(
    .pc(pc_top),
    .imm_ext(immediate_top),
    .pc_target(pc_target_top)
);

pc_mux pc_mux_inst(
    .pc_plus4(pc_plus4_top),
    .branch_target(pc_target_top),
    .branch_taken(branch_taken_top),
    .next_pc(pc_next_top)
);

inst_mem imem_inst(
    .clk(clk),
    .reset(reset),
    .read_addr(pc_top),
    .inst_out(instruction_top)
);

reg_file reg_file_inst(
    .clk(clk),
    .reset(reset),
    .regwrite(regwrite_top),
    .rreg1(instruction_top[19:15]),
    .rreg2(instruction_top[24:20]),
    .wreg(instruction_top[11:7]),
    .wdata(reg_write_data_top),
    .rdata1(rdata1_top),
    .rdata2(rdata2_top)
);

control_unit control_unit_inst(
    .opcode(instruction_top[6:0]),
    .branch(branch_top),
    .memread(memread_top),
    .memtoreg(memtoreg_top),
    .ALUop(alu_op_top),
    .memwrite(memwrite_top),
    .ALUsrc(alusrc_top),
    .regwrite(regwrite_top)
);

imm_gen imm_gen_inst(
    .instr(instruction_top),
    .imm_ext(immediate_top)
);

alu_ctrl_unit alu_control_inst(
    .alu_op(alu_op_top),
    .funct7(instruction_top[30]),
    .funct3(instruction_top[14:12]),
    .alu_ctrl(alu_ctrl_top)
);

alu alu_inst(
    .rs1(rdata1_top),
    .rs2(alu_rs2_top),
    .alu_ctrl(alu_ctrl_top),
    .alu_result(alu_result_top),
    .zero(alu_zero_top)
);

alu_mux alu_mux_inst(
    .rd2(rdata2_top),
    .imm(immediate_top),
    .alu_src(alusrc_top),
    .alu_rs2(alu_rs2_top)
);

branch_and_zero branch_and_zero_inst(
    .branch(branch_top),
    .zero(alu_zero_top),
    .branch_taken(branch_taken_top)
);

//data memory

data_memory data_memory_inst(
    .clk(clk),
    .reset(reset),
    .memread(memread_top),
    .memwrite(memwrite_top),
    .address(alu_result_top),
    .write_data(rdata2_top),
    .rdata(data_rdata_top)
);

data_mux data_mux_inst(
    .alu_result(alu_result_top),
    .mem_data(data_rdata_top),
    .mem_to_reg(memtoreg_top),
    .reg_write_data(reg_write_data_top)
);


endmodule //datapath