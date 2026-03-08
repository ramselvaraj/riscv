module tb_data_memory;

reg clk;
reg reset;
reg memread;
reg memwrite;
reg [31:0] address;
reg [31:0] write_data;
wire [31:0] rdata;

data_memory uut(
    .clk(clk),
    .reset(reset),
    .memread(memread),
    .memwrite(memwrite),
    .address(address),
    .write_data(write_data),
    .rdata(rdata)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_data_memory.vcd");
    $dumpvars(0, tb_data_memory);
    
    $monitor("At time %d, memread = %b, memwrite = %b, address = %d, write_data = %h, rdata = %h", 
             $time, memread, memwrite, address, write_data, rdata);
    
    clk = 0;
    reset = 1;
    memread = 0;
    memwrite = 0;
    address = 0;
    write_data = 0;
    
    #10;
    reset = 0;
    
    // Test writing to memory at address 4
    address = 4;
    write_data = 32'hDEADBEEF;
    memwrite = 1;
    #10; // wait for one clock cycle
    
    // Test reading from memory at address 4
    memwrite = 0;
    memread = 1;
    #10; // wait for one clock cycle
    
    if (rdata !== 32'hDEADBEEF) $display("Error: expected DEADBEEF at address 4, got %h", rdata);
    $finish;

end

endmodule;