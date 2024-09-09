`timescale 1ns / 1ps
//Test bench top

module test_TOP;

// Inputs
reg clk;
reg reset;

// Instantiate the module under test
TOP_TOP dut(
    clk,
    reset
);

// Clock generation
always begin
    #5 clk = ~clk;
end

// Reset generation
initial begin
    clk=0;
    reset = 1;
    #10 reset = 0;
end

// Test case
initial begin
    // Wait for a few clock cycles
    #100;

    // Perform test operations here
    
    // End simulation
    $finish;
end

endmodule

