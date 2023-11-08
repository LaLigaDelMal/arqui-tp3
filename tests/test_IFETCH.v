`timescale 1ns / 1ps

module InstructionFetch_tb;

    reg clk;
    reg rst;
    reg i_en;
    reg i_mem_valid;
    reg [31:0] i_pc;
    reg [31:0] i_mem_data;
    wire [31:0] o_pc;
    wire [31:0] o_mem_addr;
    wire o_mem_wr;
    wire [31:0] o_instr;
    

    // Instantiate the Unit Under Test (UUT)
    Instruction_Fetch uut (
        .clk(clk), 
        .rst(rst), 
        .i_en(i_en), 
        .i_pc(i_pc), 
        .i_mem_data(i_mem_data), 
        .i_mem_data_valid(i_mem_valid),
        .o_pc(o_pc), 
        .o_mem_addr(o_mem_addr), 
        .o_mem_wr(o_mem_wr), 
        .o_instr(o_instr)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        i_en = 0;
        i_pc = 0;
        i_mem_data = 0;
        i_mem_valid = 0;

        // Wait for 10 ns for global reset to finish
        #10;
        
        // Assert Enable
        i_en = 1;
        #10;

        // De-assert the reset
        rst = 1;
        #10; rst = 0; #10;
        
        // Change PC and memory data
        i_pc = 32'h00000000;
        #40
        if ( o_mem_addr == 32'h00000000 ) begin
            $display("Test O_MEM_ADDR passed");
            i_mem_valid = 1;
            i_mem_data = 32'h00000066;
        end else begin
            $display("Test O_MEM_ADDR failed");
            $finish;
        end
        #20
        if ( o_instr == 32'h00000066 ) begin
            $display("Test O_INSTR passed");
        end else begin
            $display("Test O_INSTR failed");
            $finish;
        end

        if ( o_pc == (i_pc+4) ) begin
            $display("Test O_PC passed");
        end else begin
            $display("Test O_PC failed");
            $finish;
        end 
        #10;
    end

    // Clock generator
    always begin
        #10 clk = ~clk;
    end

endmodule