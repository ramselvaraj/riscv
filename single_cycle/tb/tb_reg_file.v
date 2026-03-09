`timescale 1ns/1ps
module tb_reg_file;

reg clk;
reg reset;
reg regwrite;
reg [4:0] rreg1, rreg2, wreg;
reg [31:0] wdata;
wire [31:0] rdata1, rdata2;

reg_file uut(
    .clk(clk),
    .reset(reset),
    .regwrite(regwrite),
    .rreg1(rreg1),
    .rreg2(rreg2),
    .wreg(wreg),
    .wdata(wdata),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_reg_file.vcd");
    $dumpvars(0, tb_reg_file);
    
    $monitor("At time %d, rreg1 = %d, rreg2 = %d, wreg = %d, wdata = %h, rdata1 = %h, rdata2 = %h", 
             $time, rreg1, rreg2, wreg, wdata, rdata1, rdata2);
    
    clk = 0;
    reset = 1;
    regwrite = 0;
    rreg1 = 0;
    rreg2 = 0;
    wreg = 0;
    wdata = 0;
    
    #10;
    reset = 0;
    
    // Test writing to register 5
    wreg = 5;
    wdata = 32'hDEADBEEF;
    regwrite = 1;
    #10; // wait for one clock cycle
    
    // Test reading from register 5
    rreg1 = 5;
    #10; // wait for one clock cycle
    
    if (rdata1 !== 32'hDEADBEEF) $display("Error: expected DEADBEEF in register 5, got %h", rdata1);
    
    // Test writing to register 10
    wreg = 10;
    wdata = 32'hCAFEBABE;
    #10; // wait for one clock cycle
    
    // Test reading from register 10
    rreg2 = 10;
    #10; // wait for one clock cycle
    
    if (rdata2 !== 32'hCAFEBABE) $display("Error: expected CAFEBABE in register 10, got %h", rdata2);
    
    $finish;
end

endmodule //tb_reg_file