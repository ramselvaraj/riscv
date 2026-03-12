module branch_and_zero(
    input branch,
    input zero,
    output branch_taken
);

// AND gate to determine if a branch should be taken

assign branch_taken = branch & zero;

endmodule // branch_and_zero