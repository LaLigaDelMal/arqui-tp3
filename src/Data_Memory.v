`timescale 1ns / 1ps

module Data_Memory #(
    parameter WORD_LEN = 32,
    parameter MEM_CELL_SIZE = 8,
    parameter DATA_MEM_SIZE = 1024
    )(
    input   wire                i_clk,
    input   wire                i_rst,
    input   wire                i_write_en,
    input   wire [1:0]          i_size,    // 00: Byte, 01: Half Word, 10: Word
    input   wire                i_unsigned,
    input   wire [WORD_LEN-1:0] i_addr,
    input   wire [WORD_LEN-1:0] i_data_in,
    output  wire [WORD_LEN-1:0] o_data_out
);

    integer i;
    reg [MEM_CELL_SIZE-1:0] memory[DATA_MEM_SIZE-1:0];
    wire [WORD_LEN-1:0] base_address;

    reg [WORD_LEN-1:0] data;
    reg msb, sign;
    reg [2:0] offset; 

    initial begin
        for (i = 0; i < DATA_MEM_SIZE; i = i + 1) begin
            memory[i] = 0;
        end
    end

    always @ (negedge i_clk) begin
        if (i_rst) begin
            data <= 0;
        end else if (i_write_en) begin
            case (i_size)
                2'b00: memory[i_addr] <= i_data_in[7:0];
                2'b01: {memory[i_addr + 1], memory[i_addr] } <= i_data_in[15:0];
                2'b10: {memory[i_addr + 3], memory[i_addr + 2], memory[i_addr + 1], memory[i_addr]} <= i_data_in[31:0];
            endcase
        end else begin
            offset = i_size << 1;
            sign = memory[i_addr + offset][7] & ~i_unsigned; // memory[i_addr + offset][7] -> MSB of the data in memory at the specified data size
            case (i_size)
                2'b00: data = {{24{sign}}, memory[i_addr]}; // Byte
                2'b01: data = {{16{sign}}, memory[i_addr + 1], memory[i_addr]}; // Half Word
                2'b10: data = {memory[i_addr + 3], memory[i_addr + 2], memory[i_addr + 1], memory[i_addr]}; // Word
            endcase
        end
    end

    assign o_data_out = data;

endmodule
