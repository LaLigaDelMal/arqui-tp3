`timescale 1ns / 1ps

module IF_top_tb;
    // Declaración de señales
    reg clk, rst;
    wire [31:0] mem_addr;
    wire mem_wr_en;
    wire [31:0] mem_data_in;
    wire mem_data_valid;
    wire [31:0] mem_data_out;
    reg [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] inst_out;
    
    // Throaway module for testbench
    reg writer_en;
    reg writer_wr_en;
    reg [31:0] writer_addr;
    reg [31:0] writer_data;
    
    MemoryWriter #(32,32) UUT_MemoryWriter(
        .clk(clk),
        .rst(rst),
        .i_en(writer_en),
        .i_wr_en(writer_wr_en),
        .i_addr(writer_addr),
        .i_data(writer_data),
        .o_addr(mem_addr),
        .o_en(mem_wr_en),
        .o_data(mem_data_in)
    );

    Instruction_Memory #(32,32) UUT_Memory(
        .clk(clk),
        .rst(rst),
        .i_addr(mem_addr),
        .i_wr_en(mem_wr_en),
        .i_data(mem_data_in),
        .o_data(mem_data_out),
        .o_mem_data_valid(mem_data_valid)
    );

    reg IF_en;
    Instruction_Fetch UUT_Fetch(
        .clk(clk),
        .rst(rst),
        .i_en(IF_en),
        .i_pc(pc),
        .i_mem_data(mem_data_out),
        .i_mem_data_valid(mem_data_valid),
        .o_pc(next_pc),
        .o_mem_addr(mem_addr),
        .o_mem_wr(mem_wr_en),
        .o_instr(inst_out)
    );

    /*Program_Counter UUT_PC(
        .clk(clk),
        .rst(rst),
        .i_en(IF_en),
        .i_pc(next_pc),
        .o_pc(pc)
    );*/

    // Clock generator
    always begin
        #10 clk = ~clk;
    end

    // Inicialización de las señales de entrada
    initial begin
        clk = 0;
        rst = 1;
        IF_en = 0;

        //RAM WRITING
        writer_en = 0;
        writer_data = 32'h00000000;
        writer_addr = 5'b00000;

        // Reset the RAM
        rst = 0;
        #10 rst = 1;
        #10 rst = 0;

        writer_en = 1;
        // Write data to address 0
        #20 writer_wr_en = 1; writer_addr = 0; writer_data = 32'h11111111;
        #10 writer_wr_en = 0;

        #20 writer_wr_en = 1; writer_addr = 4; writer_data = 32'h87654321;
        #10 writer_wr_en = 0;

        #20 writer_wr_en = 1; writer_addr = 8; writer_data = 32'h10101010;
        #10 writer_wr_en = 0;

        #20 writer_wr_en = 1; writer_addr = 12; writer_data = 32'h11111111;
        #10 writer_wr_en = 0;
        #10 writer_en = 0;
        // END RAM WRITING
        
        // INSTRUCTION FETCH PART
        #20 IF_en = 1;
        pc=0;
        #40
        pc=4;

        // END INSTRUCTION FETCH PART
        $finish;
    end

endmodule

module MemoryWriter(
    input wire clk,
    input wire rst,
    input wire i_en,
    input wire i_wr_en,
    input wire [31:0] i_addr,
    input wire [31:0] i_data,
    output reg [31:0] o_data,
    output reg [31:0] o_addr,
    output reg o_en
);
    always @(*) begin
        // Put on the output the input
        if (i_en) begin
            o_data = i_data;
            o_addr = i_addr;
            o_en = i_wr_en;
        end else begin
            o_data = 32'bZ; // High impedance
            o_addr = 32'bZ;
            o_en = 1'bZ;
        end
    end
endmodule