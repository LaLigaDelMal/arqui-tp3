`define CHECK_TEST_RESULT(result, description) \
    if (result) begin \
        $display("Test Passed: %s - %s", `__FILE__, description); \
    end else begin \
        $display("Test Failed: %s - %s", `__FILE__, description); \
        $finish; \
    end

module Registers_tb;

  // Inputs
  reg i_reset;
  reg [4:0] i_rs_select;
  reg [4:0] i_rt_select;
  reg [4:0] i_rd_select;
  reg i_wr_enable;
  reg [31:0] i_write_data;

  // Outputs
  wire [31:0] o_rsource_data;
  wire [31:0] o_rtarget_data;

  // Instantiate the unit under test (UUT)
  Registers uut (
    .i_rst(i_reset),
    .i_rs_sel(i_rs_select),
    .i_rt_sel(i_rt_select),
    .i_rd_sel(i_rd_select),
    .i_wr_en(i_wr_enable),
    .i_wr_data(i_write_data),
    .o_rs_data(o_rsource_data),
    .o_rt_data(o_rtarget_data)
  );

  initial begin
    // Initialize inputs
    i_reset = 1;
    i_rs_select = 0;
    i_rt_select = 0;
    i_rd_select = 2;
    i_wr_enable = 0;
    i_write_data = 0;

    // Wait for 100 ns for global reset to finish
    #100;

    // Test case 1: Read register 0 (zero register)
    i_reset = 0;
    #10;
    `CHECK_TEST_RESULT(o_rsource_data === 8'h00, "Test Case 1. Read register 0 (zero register)");

    // Test case 2: Write to register 1 and read back
    i_rd_select = 1;
    i_write_data = 32'hFFFFFFFF;
    i_wr_enable = 1;
    #10;
    i_wr_enable = 0;
    #10;
    i_rs_select = 1;
    #10;
    `CHECK_TEST_RESULT(o_rsource_data === 32'hFFFFFFFF, "Test Case 2. Write to register 1 and read back");

    // Test case 3: Write to register 1 and 2 and read back both
    i_rd_select = 1;
    i_write_data = 32'h0123ABCD;
    i_wr_enable = 1;
    #10;
    i_wr_enable = 0;
    #10;
    i_rd_select = 2;
    i_write_data = 32'h4567EF01;
    i_wr_enable = 1;
    #10;
    i_wr_enable = 0;
    #10;
    i_rs_select = 1;
    i_rt_select = 2;
    #10;
    `CHECK_TEST_RESULT(o_rsource_data === 32'h0123ABCD && o_rtarget_data === 32'h4567EF01, "Test Case 3. Write to register 1 and 2 and read back both");

  end

endmodule