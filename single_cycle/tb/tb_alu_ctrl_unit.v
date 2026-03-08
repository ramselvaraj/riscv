module tb_alu_ctrl_unit;

reg [1:0] alu_op;
reg funct7;
reg [2:0] funct3;
wire [3:0] alu_ctrl;

alu_ctrl_unit uut (
    .alu_op(alu_op),
    .funct7(funct7),
    .funct3(funct3),
    .alu_ctrl(alu_ctrl)
);

initial begin

    $dumpfile("tb_alu_ctrl_unit.vcd");
    $dumpvars(0, tb_alu_ctrl_unit);
    
    // Test case 1: LW (ADD)
    alu_op = 2'b00; funct7 = 0; funct3 = 3'b000;
    #10;
    $display("Test case 1: LW (ADD) - alu_ctrl: %b", alu_ctrl);

    // Test case 2: BEQ (SUB)
    alu_op = 2'b01; funct7 = 0; funct3 = 3'b000;
    #10;
    $display("Test case 2: BEQ (SUB) - alu_ctrl: %b", alu_ctrl);

    // Test case 3: R-type ADD
    alu_op = 2'b10; funct7 = 0; funct3 = 3'b000;
    #10;
    $display("Test case 3: R-type ADD - alu_ctrl: %b", alu_ctrl);

    // Test case 4: R-type AND
    alu_op = 2'b10; funct7 = 0; funct3 = 3'b111;
    #10;
    $display("Test case 4: R-type AND - alu_ctrl: %b", alu_ctrl);

    // Test case 5: R-type OR
    alu_op = 2'b10; funct7 = 0; funct3 = 3'b110;
    #10;
    $display("Test case 5: R-type OR - alu_ctrl: %b", alu_ctrl);

    // Test case 6: R-type SUB
    alu_op = 2'b10; funct7 = 1; funct3 = 3'b000;
    #10;
    $display("Test case 6: R-type SUB - alu_ctrl: %b", alu_ctrl);
end

endmodule //tb_alu_ctrl_unit