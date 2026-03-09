module tb_branch_and_zero;

reg branch;
reg zero;
wire branch_taken;

branch_and_zero uut (
    .branch(branch),
    .zero(zero),
    .branch_taken(branch_taken)
);

initial begin
    // Test case 1: branch = 0, zero = 0
    branch = 0;
    zero = 0;
    #10; // Wait for 10 time units
    $display("Test case 1: branch = %b, zero = %b, branch_taken = %b", branch, zero, branch_taken);

    // Test case 2: branch = 0, zero = 1
    branch = 0;
    zero = 1;
    #10; // Wait for 10 time units
    $display("Test case 2: branch = %b, zero = %b, branch_taken = %b", branch, zero, branch_taken);

    // Test case 3: branch = 1, zero = 0
    branch = 1;
    zero = 0;
    #10; // Wait for 10 time units
    $display("Test case 3: branch = %b, zero = %b, branch_taken = %b", branch, zero, branch_taken);

    // Test case 4: branch = 1, zero = 1
    branch = 1;
    zero = 1;
    #10; // Wait for 10 time units
    $display("Test case 4: branch = %b, zero = %b, branch_taken = %b", branch, zero, branch_taken);

end

endmodule // branch_and_zero