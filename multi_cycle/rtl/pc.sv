module pc_sv(
    input clk;
    input reset;
    input pc_ctrl;
    input [31:0] pc_next;
    output [31:0] pc;
);

always_ff @(posedge clk or posedge reset) begin
   if (reset) begin
        pc <= 0;
   end
   else if (pc_ctrl) begin //wait till previous instruction is finished to start the next one
        pc <= pc_next;
   end

end
    

endmodule //pc_sv