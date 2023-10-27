`define CHECK_TEST_RESULT(result, description) \
    if (result) begin \
        $display("Test Passed: %s - %s", `__FILE__, description); \
    end else begin \
        $display("Test Failed: %s - %s", `__FILE__, description); \
        $finish; \
    end

module ALU_tb;

  // Inputs
  reg [3:0] i_op_code;
  reg [31:0] i_op_A;
  reg [31:0] i_op_B;

  // Outpus
  wire [31:0] o_rslt;
  wire o_zero;
  wire o_carry;
  wire o_ovfl_exception;

  // Instantiate the unit under test (UUT)
  ALU uut (
    .i_op_code(i_op_code),
    .i_op_A(i_op_A),
    .i_op_B(i_op_B),
    .o_rslt(o_rslt),
    .o_zero(o_zero),
    .o_carry(o_carry),
    .o_ovfl_exception(o_ovfl_exception)
  );

  initial begin
    // Initialize inputs
    i_op_code = 0;
    i_op_A = 0;
    i_op_B = 0;

    #10;

    // Test case 1: Logical shift right
    i_op_code = 4'b0000;
    i_op_A = 32'hABCD0123;
    i_op_B = 32'h0000002;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'h2af34048, "Test Case 1. Logical shift right");

    // Test case 2: Logical shift left
    i_op_code = 4'b0001;
    i_op_A = 32'hABCD0123;
    i_op_B = 32'h00000003;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'h5E680918, "Test Case 2. Logical shift left");

    // Test case 3: Arithmetic shift right
    i_op_code = 4'b0010;
    i_op_A = 32'h0123ABCD;
    i_op_B = 32'h00000001;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'h0091D5E6, "Test Case 3. Arithmetic shift right");

    // Test case 4: Unsigned add
    i_op_code = 4'b0100;
    i_op_A = 32'h0123ABCD;
    i_op_B = 32'hABCD0123;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'hACF0ACF0, "Test Case 4. Unsigned add");

    // Test case 5: Unsigned sub
    i_op_code = 4'b0101;
    i_op_A = 32'h49263105;
    i_op_B = 32'hFFFFFFFF;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'h49263106, "Test Case 5. Unsigned sub");

    // Test case 6: AND
    i_op_code = 4'b0110;
    i_op_A = 32'h19FAF551;
    i_op_B = 32'hF0F00F0F;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'h10F00501, "Test Case 6. AND");

    // Test case 7: OR
    i_op_code = 4'b0111;
    i_op_A = 32'hCFE257A5;
    i_op_B = 32'hABCD0123;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'hEFEF57A7, "Test Case 7. OR");

    // Test case 8: XOR
    i_op_code = 4'b1000;
    i_op_A = 32'hADC2CCD0;
    i_op_B = 32'hABCD0123;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'h60FCDF3, "Test Case 8. XOR");

    // Test case 9: NOR
    i_op_code = 4'b1001;
    i_op_A = 32'h0123ABCD;
    i_op_B = 32'h89DF634B;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 32'h76001430, "Test Case 9. NOR");

    // Test case 10: GT (one value positive, one value negative)
    i_op_code = 4'b1010;
    i_op_A = 32'hffffe800;
    i_op_B = 32'h01234567;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 0, "Test Case 10. GT (one value positive, one value negative)");

    // Test case 11: GT (both values positive)
    i_op_code = 4'b1010;
    i_op_A = 32'h01234567;
    i_op_B = 32'h0FEDCBA9;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 0, "Test Case 11. GT (both values positive)");

    // Test case 12: GT (both values negative)
    i_op_code = 4'b1010;
    i_op_A = 32'hff6f9000;
    i_op_B = 32'hff5f0800;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 1, "Test Case 12. GT (both values negative)");

    // Test case 13: GT (both values zero)
    i_op_code = 4'b1010;
    i_op_A = 32'h00000000;
    i_op_B = 32'h00000000;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 0, "Test Case 13. GT (both values zero)");

    // Test case 14: CMP (equal)
    i_op_code = 4'b1011;
    i_op_A = 32'h0123ABCD;
    i_op_B = 32'h0123ABCD;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 1, "Test Case 14. CMP (equal)");

    // Test case 15: CMP (not equal)
    i_op_code = 4'b1011;
    i_op_A = 32'h0123ABCD;
    i_op_B = 32'hABCD0123;
    #10;
    `CHECK_TEST_RESULT(o_rslt === 0, "Test Case 15. CMP (not equal)");

    // Test case 16: ADD (without overflow)
    i_op_code = 4'b1100;
    i_op_A = 32'h0123ABCD;
    i_op_B = 32'h0BCD1234;
    #10;
    `CHECK_TEST_RESULT((o_rslt === 32'h0CF0BE01) && o_ovfl_exception != 1, "Test Case 16. ADD");

    // Test case 17: ADD (with overflow)
    i_op_code = 4'b1100;
    i_op_A = 32'h7FFFFFFF;
    i_op_B = 32'h00000001;
    #10;
    `CHECK_TEST_RESULT((o_rslt === 32'h80000000) && o_ovfl_exception == 1, "Test Case 17. ADD");

    // Test case 18: Check zero flag
    i_op_code = 4'b1100;
    i_op_A = 32'h00000000;
    i_op_B = 32'h00000000;
    #10;
    `CHECK_TEST_RESULT((o_rslt === 32'h00000000) && o_zero == 1, "Test Case 18. Check zero flag");

  end

endmodule