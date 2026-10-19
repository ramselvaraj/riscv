module pipeline_data_memory(
    input  logic        clk,
    input  logic        reset,
    input  logic        write_enable,
    input  logic        read_enable,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);
    logic [31:0] memdata [0:255];
    integer i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 256; i = i + 1)
                memdata[i] <= 32'b0;
        end else if (write_enable) begin
            memdata[address[9:2]] <= write_data;
        end
    end

    assign read_data = read_enable ? memdata[address[9:2]] : 32'b0;
endmodule
