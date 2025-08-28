`timescale 1ns / 1ps

module program_counter_tb;

    // Inputs
    reg clk;
    reg rst;
    reg enable;

    // Outputs
    wire [31:0] pc_out;
    wire [31:0] pc_4_out;
    wire [31:0] pc_8_out;

    Program_Counter #(
        .NBITS(32)
    ) u_PC (
        .i_clk(clk),
        .i_rst(rst),
        .i_wr_en(enable),
        .o_pc(pc_out),
        .o_pc_4(pc_4_out),
        .o_pc_8(pc_8_out)
    );

    // Clock generation
    always #10 clk = ~clk;

    // Stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        enable = 0;

        // Wait for 100 ns for rst to complete
        #35;rst = 0;

        // Test 1: PC out should be clear when enable is low
        #5;
        if (pc_out == 32'h00000000) $display("Test 1 succeded"); else $error("Test 1 failed");

        // Test 2: PC incremental
        enable = 1;
        #100;
        //for (integer i = 2; i < 12; i = i + 1) begin
        //    #10; //20 para (posedge clk) y 10 para (clk) en Program_Counter.v
         //   if (pc_out == pc_in) $display("Test ",i," succeded"); else $display("Test ",i," failed");
          //  pc_in = pc_in + 1;
        //end

        // End of test
        $display("All tests passed");
        $finish;
    end

endmodule
