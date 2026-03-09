module branch_and_zero(
    input branch,
    input zero,
    output branch_taken
);

assign branch_taken = branch & zero;

endmodule // branch_and_zero