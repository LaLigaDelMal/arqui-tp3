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
    // Set FFFFFFFFF as first value of data memory
    dut.MA.u_Data_Memory.memory[0] = 8'h00;
    dut.MA.u_Data_Memory.memory[1] = 8'hFF;
    dut.MA.u_Data_Memory.memory[2] = 8'hFF;
    dut.MA.u_Data_Memory.memory[3] = 8'hFF;

    // LH instruction to load in t1
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h84090000;    // LH $t1 0x0000 $zero
    #100;
    inst_mem_wr_en = 0;
    #100;
    // NOP instruction (will be replaced by stall)
    inst_mem_wr_en = 1;
    inst_mem_addr = 4;
    inst_mem_data = 32'h00000000;    // NOP
    #100;
    inst_mem_wr_en = 0;
    #100;
    // ADDI instruction to add 0xC to t1 and store in t2
    inst_mem_wr_en = 1;
    inst_mem_addr = 8;
    inst_mem_data = 32'h212A000C;    // addi $t2 $t1 0x000c
    #100;
    inst_mem_wr_en = 0;
    #100;
    // ADD instruction to add t1 and t2 and store in t3
    inst_mem_wr_en = 1;
    inst_mem_addr = 12;
    inst_mem_data = 32'h1495820;    // add $t3 $t2 $t1
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
