`timescale 1ns / 1ps
//Test bench top

module test_branch;

// Inputs
reg clk;
reg reset;
reg inst_mem_wr_en;
reg [31:0] inst_mem_addr;
reg [31:0] inst_mem_data;

// Instantiate the module under test
TOP_TOP dut(
    clk,
    reset,
    inst_mem_wr_en,
    inst_mem_addr,
    inst_mem_data
);

initial begin
    clk=0;
end


// Clock generation
always begin
    #50 clk = ~clk;
end


// Test forwarding unit
initial begin

    // LUI $t0 0xFFFF
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h3C08FFFF;
    #100;
    inst_mem_wr_en = 0;
    #100 reset = 0;

    // ADDI $t1 $t1 0x0004
    inst_mem_wr_en = 1;
    inst_mem_addr = 4;
    inst_mem_data = 32'h21290004;
    #100;
    inst_mem_wr_en = 0;
    #100 reset = 0;

    // BNE $t0 $t1 0x0001    (salta 4 lugares de memoria)
    inst_mem_wr_en = 1;
    inst_mem_addr = 8;
    inst_mem_data = 32'h15090002;
    #100;
    inst_mem_wr_en = 0;
    #100;

    // NOP
    inst_mem_wr_en = 1;
    inst_mem_addr = 12;
    inst_mem_data = 32'h00000000;
    #100;
    inst_mem_wr_en = 0;
    #100;

    // ADDU instruction to add t1 and t2 and store in t3
    inst_mem_wr_en = 1;
    inst_mem_addr = 16;
    inst_mem_data = 32'h01495821;    // addu $t3 $t2 $t1
    #100;
    inst_mem_wr_en = 0;
    #100;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    #2000;

    // End simulation
    $finish;
end

endmodule
