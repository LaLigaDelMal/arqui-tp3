`timescale 1ns / 1ps
//Test bench top

module test_debug;

// Inputs
reg clk;
reg reset;
reg rx;


// Instantiate the module under test
TOP_TOP dut(
    clk,
    reset,
    rx
);

initial begin
    clk=0;
end

// Clock generation
always begin
    #5 clk = ~clk;
end

reg [9:0] load = 10'b1011100110;
integer i;

initial begin
    $display("Test debug");
    // RUN:  01110010
    // STEP: 01110011
    // LOAD: 01110011
    
    i = 0;
    rx = 1;
    $display("Reset in progress");
    // Reset
    reset = 1;
    #10;
    reset = 0;
    
    $display("Reset Done");

    $display("Load");
    // lOAD
    
    // 104166
        
    for (i = 0; i < 10; i = i + 1) begin
        rx = load[i];
        $display("RX: %b", load[i]);
        #160;
    end

    rx = 1;
    
    $display("Finish load");
    
    #300;
    $finish;
    
end



endmodule