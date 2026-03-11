`timescale 1ns/1ps

module data_memory(
    input clk,
    input reset,
    input memread,
    input memwrite,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] rdata
);

integer k;
integer seed;
reg [31:0] data_mem [63:0]; // 64 words of 32-bit memory

assign rdata = (memread) ? data_mem[address] : 32'b0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        
        seed = $urandom;
        for (k = 0; k < 64; k = k+1) begin
            data_mem[k] <= $random % 256;
        end
        // data_mem[0] <= 32'h0000000A; // 10
        // data_mem[4] <= 32'h00000014; // 20
        // data_mem[8] <= 32'h0000001E; // 30
        
    end else if (memwrite) begin
        data_mem[address] <= write_data;
    end

end


endmodule //data_memory