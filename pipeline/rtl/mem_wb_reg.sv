module mem_wb_reg(
    input  logic        clk,
    input  logic        reset,
    input  logic        valid_in,
    input  logic [31:0] result_in,
    input  logic [31:0] memory_data_in,
    input  logic [4:0]  rd_in,
    input  logic        reg_write_in,
    input  logic        mem_to_reg_in,
    output logic        valid_out,
    output logic [31:0] result_out,
    output logic [31:0] memory_data_out,
    output logic [4:0]  rd_out,
    output logic        reg_write_out,
    output logic        mem_to_reg_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_out <= 1'b0;
            result_out <= 32'b0;
            memory_data_out <= 32'b0;
            rd_out <= 5'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            valid_out <= valid_in;
            result_out <= result_in;
            memory_data_out <= memory_data_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule
