`timescale 1ns / 1ps

module Instruction_Mem_tb;

  reg clk;
  reg rst;
  reg [4:0] address;
  reg write_enable;
  reg [31:0] data_in;

  wire [31:0] data_out;

  // Instantiate the RAM module
  Instruction_Memory #() my_ram (
    .clk(clk),
    .rst(rst),
    .i_addr(address),
    .i_wr_en(write_enable),
    .i_data(data_in),
    .o_data(data_out)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Testbench stimulus
  initial begin
    clk = 0;
    rst = 1;
    write_enable = 0;
    data_in = 32'h00000000;
    address = 5'b00000;

    // Reset the RAM
    rst = 0;
    #10 rst = 1;
    #10 rst = 0;
    // Write data to address 1
    address = 1;
    write_enable = 1;
    data_in = 32'h12345678;
    #10 write_enable = 0;
    // Read data from address 1
    #10
    $display("Data read from address 1: %h", data_out);
    // Write data to address 2
    address = 2;
    write_enable = 1;
    data_in = 32'h87654321;
    #10 write_enable = 0;
    // Read data from address 2
    #10
    $display("Data read from address 2: %h", data_out);

    // Finish the simulation
    $finish;
  end

endmodule
