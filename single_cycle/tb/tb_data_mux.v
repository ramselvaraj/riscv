module tb_data_mux;

reg [31:0] rdata;
reg [31:0] alu_result;
reg mem_to_reg;
wire [31:0] reg_write_data;

data_mux data_mux_inst(
    .alu_result(alu_result),
    .mem_data(rdata),
    .mem_to_reg(mem_to_reg),
    .reg_write_data(reg_write_data)
);

initial begin
    // Test case 1: mem_to_reg = 0, should select alu_result
    alu_result = 32'hDEADBEEF;
    rdata = 32'hCAFEBABE;
    mem_to_reg = 0;
    #10; // Wait for the output to stabilize
    $display("Test case 1: mem_to_reg=0, reg_write_data=0x%h (expected 0xDEADBEEF)", reg_write_data);

    // Test case 2: mem_to_reg = 1, should select rdata
    mem_to_reg = 1;
    #10; // Wait for the output to stabilize
    $display("Test case 2: mem_to_reg=1, reg_write_data=0x%h (expected 0xCAFEBABE)", reg_write_data);

    $finish; // End the simulation

end


endmodule // tb_data_mux