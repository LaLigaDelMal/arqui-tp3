`timescale 1ns / 1ps
//Test bench top

module test_forwarding;

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

    // LUI to set the value 0xFFFF0000 to $t0
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h3C08FFFF;
    #100;
    inst_mem_wr_en = 0;
    #100 reset = 0;

    // SW to set the memory address 0x0 with the value in $t0 (r8)
    inst_mem_wr_en = 1;
    inst_mem_addr = 4;
    inst_mem_data = 32'hAC080000;
    #100;
    inst_mem_wr_en = 0;
    #100 reset = 0;

    // En memoria de datos tendriamos el valor 0xFFFF0000 en la direccion 0

    // LH instruction to load in t1
    inst_mem_wr_en = 1;
    inst_mem_addr = 8;
    inst_mem_data = 32'h84090001;    // LH $t1 0x0001 $zero
    #100;
    inst_mem_wr_en = 0;
    #100;

    // NOP instruction (will be replaced by stall)
    inst_mem_wr_en = 1;
    inst_mem_addr = 12;
    inst_mem_data = 32'h00000000;    // NOP
    #100;
    inst_mem_wr_en = 0;
    #100;

    // ADDI instruction to add 0xC to t1 and store in t2
    inst_mem_wr_en = 1;
    inst_mem_addr = 16;
    inst_mem_data = 32'h212A000C;    // addi $t2 $t1 0x000c
    #100;
    inst_mem_wr_en = 0;
    #100;

    // ADDU instruction to add t1 and t2 and store in t3
    inst_mem_wr_en = 1;
    inst_mem_addr = 20;
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
