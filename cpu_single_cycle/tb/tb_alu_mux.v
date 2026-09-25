`timescale 1ns/1ps

module tb_alu_mux;

reg [31:0] rd2;
reg [31:0] imm;
reg alu_src;
wire [31:0] alu_rs2;

alu_mux uut (
    .rd2(rd2),
    .imm(imm),
    .alu_src(alu_src),
    .alu_rs2(alu_rs2)
);

initial begin

    $monitor("rd2: %b, imm: %b, alu_src: %b, alu_rs2: %b", rd2, imm, alu_src, alu_rs2);
    
    // Test case 1: alu_src = 0, should select rd2
    rd2 = 32'h12345678;
    imm = 32'h87654321;
    alu_src = 1'b0;
    #10;

    // Test case 2: alu_src = 1, should select imm
    rd2 = 32'hDEADBEEF;
    imm = 32'hCAFEBABE;
    alu_src = 1'b1;
    #10;

    // Test case 3: alu_src = 0, should select rd2
    rd2 = 32'hFFFFFFFF;
    imm = 32'h00000000;
    alu_src = 1'b0;
    #10;

    // Test case 4: alu_src = 1, should select imm
    rd2 = 32'h11111111;
    imm = 32'h22222222;
    alu_src = 1'b1;
    #10;
    $finish;

end

endmodule // tb_alu_mux
