`timescale 1ns / 1ps

module test_jump;

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


initial begin

    // LUI $t3 0x00F0
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h3C0B00F0;
    #100;
    inst_mem_wr_en = 0;
    #100;

    // J 0x30FFF0F
    //inst_mem_wr_en = 1;
    //inst_mem_addr = 4;
    //inst_mem_data = 32'h0B0FFF0F;
    //#100;
    //inst_mem_wr_en = 0;
    //#100;

    // JR $t3                     //// Debuguear el JUMPPPPPP en fetch/decode
    inst_mem_wr_en = 1;
    inst_mem_addr = 4;
    inst_mem_data = 32'h01600008;
    #100;
    inst_mem_wr_en = 0;
    #100;

    // LUI $t0 0xFFFF
    inst_mem_wr_en = 1;
    inst_mem_addr = 8;
    inst_mem_data = 32'h3C08FFFF;
    #100;
    inst_mem_wr_en = 0;
    #100;

    // ADDI $t1 $t1 0x0004
    inst_mem_wr_en = 1;
    inst_mem_addr = 12;
    inst_mem_data = 32'h21290004;
    #100;
    inst_mem_wr_en = 0;
    #100;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    #2000;
    reset = 0;

    // End simulation
    $finish;
end

endmodule
