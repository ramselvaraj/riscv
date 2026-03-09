`timescale 1ns/1ps

module tb_alu_mux;

reg rd2;
reg imm;
reg alu_src;
wire alu_rs2;

alu_mux uut (
    .rd2(rd2),
    .imm(imm),
    .alu_src(alu_src),
    .alu_rs2(alu_rs2)
);

initial begin

    $monitor("rd2: %b, imm: %b, alu_src: %b, alu_rs2: %b", rd2, imm, alu_src, alu_rs2);

    // Test case 1: alu_src = 0, should select rd2
    rd2 = 1'b0;
    imm = 1'b1; // imm value should be ignored
    alu_src = 1'b0; // Select rd2
    #10; // Wait for 10 time units

    // Test case 2: alu_src = 1, should select imm
    rd2 = 1'b0; // rd2 value should be ignored
    imm = 1'b1;
    alu_src = 1'b1; // Select imm
    #10; // Wait for 10 time units

     // Test case 3: alu_src = 0, should select rd2 again
    rd2 = 1'b1;
    imm = 1'b0; // imm value should be ignored
    alu_src = 1'b0; // Select rd2
    #10; // Wait for 10 time units

        // Test case 4: alu_src = 1, should select imm again
    rd2 = 1'b0; // rd2 value should be ignored
    imm = 1'b0;
    alu_src = 1'b1; // Select imm
    #10; // Wait for 10 time units

    $finish;

end

endmodule // tb_alu_mux
