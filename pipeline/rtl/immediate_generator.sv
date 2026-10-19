module pipeline_immediate_generator(
    input  logic [31:0] instruction,
    input  logic [2:0]  immediate_type,
    output logic [31:0] immediate
);
    localparam logic [2:0] IMM_I = 3'd0, IMM_S = 3'd1,
                           IMM_B = 3'd2, IMM_J = 3'd3;

    always_comb begin
        case (immediate_type)
            IMM_S: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            IMM_B: immediate = {{19{instruction[31]}}, instruction[31], instruction[7],
                               instruction[30:25], instruction[11:8], 1'b0};
            IMM_J: immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12],
                               instruction[20], instruction[30:21], 1'b0};
            default: immediate = {{20{instruction[31]}}, instruction[31:20]};
        endcase
    end
endmodule
