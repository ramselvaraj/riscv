`timescale 1ns/1ps

module control_unit(
    //based on the opcode, generate control signals for the datapath
    input [6:0] opcode,
    output reg branch,
    output reg memread,
    output reg memtoreg,
    output reg [1:0] ALUop,
    output reg memwrite,
    output reg ALUsrc,
    output reg regwrite
);

    always @(*) begin
        branch   = 1'b0;
        memread  = 1'b0;
        memtoreg = 1'b0;
        ALUop    = 2'b00;
        memwrite = 1'b0;
        ALUsrc   = 1'b0;
        regwrite = 1'b0;
        
        case (opcode)
            7'b0110011: begin
                ALUsrc <= 0;
                memtoreg <= 0;
                regwrite <= 1;
                memread <= 0;
                memwrite <= 0;
                branch <= 0;
                ALUop <= 2'b10; 
            end
            7'b0000011: begin
                ALUsrc <= 1;
                memtoreg <= 1;
                regwrite <= 1;
                memread <= 1;
                memwrite <= 0;
                branch <= 0;
                ALUop <= 2'b00; 
            end
            7'b0100011: begin
                ALUsrc <= 1;
                memtoreg <= 0;
                regwrite <= 0;
                memread <= 0;
                memwrite <= 1;
                branch <= 0;
                ALUop <= 2'b00; 
            end
            7'b1100011: begin
                ALUsrc <= 0;
                memtoreg <= 0;
                regwrite <= 0;
                memread <= 0;
                memwrite <= 0;
                branch <= 1;
                ALUop <= 2'b01; 
            end
        endcase
    end

endmodule //control_unit