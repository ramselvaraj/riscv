module data_memory(
    input clk,
    input reset,
    input memread,
    input memwrite,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] rdata
);

integer k;
reg [31:0] data_mem [63:0]; // 64 words of 32-bit memory

//assign rdata <= (memread) ? data_mem[address] : 32'b0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (k = 0; k < 64; k = k+1) begin
            data_mem[k] <= 32'b0;
        end
        rdata <= 32'b0;

    end else if (memread) begin
        rdata <= data_mem[address];

    end else if (memwrite) begin
        data_mem[address] <= write_data;
    end

end


endmodule //data_memory