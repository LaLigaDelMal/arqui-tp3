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
    #50 clk = ~clk;
end

// Reset generation
initial begin
    clk=0;
    reset = 1;
    #100 reset = 0;
end

// Test case
initial begin
    // Wait for a few clock cycles
    #10000;

    // Perform test operations here
    
    // End simulation
    $finish;
end

endmodule

