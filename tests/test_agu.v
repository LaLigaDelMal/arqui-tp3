`define CHECK_TEST_RESULT(result, description) \
    if (result) begin \
        $display("Test Passed: %s - %s", `__FILE__, description); \
    end else begin \
        $display("Test Failed: %s - %s", `__FILE__, description); \
        $finish; \
    end

module AGU_tb;

  // Inputs
  reg [3:0] i_op_code;
  reg [31:0] i_addr;
  reg [25:0] i_offset;

  // Outpus
  wire [31:0] o_eff_addr;
  wire [1:0] o_addr_exception;

  // Instantiate the unit under test (UUT)
  AGU uut (
    .i_op_code(i_op_code),
    .i_addr(i_addr),
    .i_offset(i_offset),
    .o_eff_addr(o_eff_addr),
    .o_addr_exception(o_addr_exception)
  );

  initial begin
    // Initialize inputs
    i_op_code = 0;
    i_addr = 0;
    i_offset = 0;

    #10;

    // Test case 1: Effective address given base and a 16-bit (negative) offset
    i_op_code = 4'b001;
    i_addr = 32'h0000ABC0;
    i_offset = 16'hFFFF;
    #10;
    `CHECK_TEST_RESULT((o_eff_addr === 32'h0000ABBF) && (o_addr_exception === 2'b11), "Test Case 1. 16 bit offset");

    // Test case 2: 16 bits signed offset shifted 2 bits is added to the address
    i_op_code = 4'b010;
    i_addr = 32'h0000ABC0;
    i_offset = 16'hFFFF;
    #10;
    `CHECK_TEST_RESULT(o_eff_addr === 32'h0000ABBC, "Test Case 2. 18 bit offset");

    // Test case 3: 26 bits offset shifted 2 bits and completing the lower part of the address
    i_op_code = 4'b011;
    i_addr = 32'hEFEFABCD;
    i_offset = 26'hFFFFFFF;
    #10;
    `CHECK_TEST_RESULT(o_eff_addr === 32'hEFFFFFFC, "Test Case 3. 28 bit offset");

  end

endmodule