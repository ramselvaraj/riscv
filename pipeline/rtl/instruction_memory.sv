module pipeline_instruction_memory(
    input  logic [31:0] address,
    output logic [31:0] instruction
);
    logic [31:0] memdata [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memdata[i] = 32'b0;
    end

    assign instruction = memdata[address[9:2]];
endmodule
