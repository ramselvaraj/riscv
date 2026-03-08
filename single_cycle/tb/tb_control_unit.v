module tb_control_unit;

reg [6:0] opcode;
wire branch;
wire memread;
wire memtoreg;
wire [1:0] ALUop;
wire memwrite;
wire ALUsrc;
wire regwrite;

control_unit uut(
    .opcode(opcode),
    .branch(branch),
    .memread(memread),
    .memtoreg(memtoreg),
    .ALUop(ALUop),
    .memwrite(memwrite),
    .ALUsrc(ALUsrc),
    .regwrite(regwrite)
);

initial begin
    $dumpfile("tb_control_unit.vcd");
    $dumpvars(0, tb_control_unit);
    
    $monitor("At time %d, opcode = %b, branch = %b, memread = %b, memtoreg = %b, ALUop = %b, memwrite = %b, ALUsrc = %b, regwrite = %b", 
             $time, opcode, branch, memread, memtoreg, ALUop, memwrite, ALUsrc, regwrite);
    
    // Test R-type instruction (opcode 0110011)
    opcode = 7'b0110011;
    #10;
    
    // Test I-type instruction (opcode 0000011)
    opcode = 7'b0000011;
    #10;
    
    // Test S-type instruction (opcode 0100011)
    opcode = 7'b0100011;
    #10;
    
    // Test B-type instruction (opcode 1100011)
    opcode = 7'b1100011;
    #10;
    
    $finish;

end

endmodule //tb_control_unit