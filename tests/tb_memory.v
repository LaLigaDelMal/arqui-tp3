`timescale 1ns / 1ps

module tb_memory;

  reg clk;
  reg rst;
  reg [4:0] address;
  reg write_enable;
  reg read_enable;
  reg [31:0] data_in;

  wire [31:0] data_out;

  // Instantiate the RAM module
  Memory #(32, 5) my_ram (
    .clk(clk),
    .rst(rst),
    .address(address),
    .write_enable(write_enable),
    .read_enable(read_enable),
    .data_in(data_in),
    .data_out(data_out)
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
    read_enable = 0;
    data_in = 32'h00000000;
    address = 5'b00000;

    // Reset the RAM
    rst = 0;
    #10 rst = 1;
    #10 rst = 0;
    // Write data to address 1
    address = 5'b00001;
    write_enable = 1;
    data_in = 32'h12345678;
    #10 write_enable = 0;

    // Read data from address 1
    read_enable = 1;
    #10 read_enable = 0;

    // Write data to address 2
    address = 5'b00010;
    write_enable = 1;
    data_in = 32'hABCDEF01;
    #10 write_enable = 0;

    // Read data from address 2
    read_enable = 1;
    #10 read_enable = 0;

    $display("Data read from address 1: %h", data_out);

    $display("Data read from address 2: %h", data_out);

    // Finish the simulation
    $finish;
  end

endmodule
