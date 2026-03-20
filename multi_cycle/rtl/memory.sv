module memory(
    input clk,
    input reset,
    input w_enable,
    input r_enable,
    input [31:0] adr,
    input [31:0] wd,
    output [31:0] rd
);


logic [31:0] memdata [64:0];
integer k;

    always_ff @(posedge clk or posedge reset) begin
        
        if (reset) begin
            for (k = 0; k < 64; k = k + 1) begin
                memdata[k] <= 0;
            end
        end

        else if (w_enable) begin
            memdata[adr] <= wd;
        end

        else if (r_enable) begin
            rd <= memdata[adr];
        end

    end
endmodule //memory