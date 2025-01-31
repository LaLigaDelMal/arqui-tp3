`timescale 1ns / 1ps

module Data_Memory #(
    parameter WORD_LEN = 32,
    parameter MEM_CELL_SIZE = 8,
    parameter DATA_MEM_SIZE = 16
    )(
    input   wire                i_clk,
    input   wire                i_rst,
    input   wire                i_step,
    input   wire                i_write_en,
    input   wire [1:0]          i_size,    // 00: Byte, 01: Half Word, 10: Word
    input   wire                i_unsigned,
    input   wire [WORD_LEN-1:0] i_addr,
    input   wire [WORD_LEN-1:0] i_data,
    input   wire [WORD_LEN-1:0] i_dbg_addr,
    output  wire [WORD_LEN-1:0] o_data,
    output  wire [WORD_LEN-1:0] o_dbg_data
);

    integer i;
    reg [MEM_CELL_SIZE-1:0] memory[DATA_MEM_SIZE-1:0];

    reg [WORD_LEN-1:0] data;
    reg [WORD_LEN-1:0] dbg_data;
    reg sign;

    //initial begin
    //    for (i = 0; i < DATA_MEM_SIZE; i = i + 1) begin
    //        memory[i] = 0;
    //    end
    //end

    always @ (negedge i_clk) begin
        if (i_rst) begin
            data <= 0;
        end else if (i_write_en & i_step) begin  // Escritura
            case (i_size)
                2'b00: memory[i_addr] <= i_data[7:0];
                2'b01: {memory[i_addr], memory[i_addr + 1] } <= i_data[15:0];
                2'b11: {memory[i_addr], memory[i_addr + 1], memory[i_addr + 2], memory[i_addr + 3]} <= i_data[31:0];
            endcase
        end else begin                  // Lectura
            sign = memory[i_addr][7] & ~i_unsigned;
            case (i_size)
                2'b00: data = {{24{sign}}, memory[i_addr]}; // Byte
                2'b01: data = {{16{sign}}, memory[i_addr], memory[i_addr + 1]}; // Half Word
                2'b11: data = {memory[i_addr], memory[i_addr + 1], memory[i_addr + 2], memory[i_addr + 3]}; // Word
            endcase
        end
    end

    always @ (*) begin
        dbg_data = {memory[i_dbg_addr], memory[i_dbg_addr + 1], memory[i_dbg_addr + 2], memory[i_dbg_addr + 3]};
    end

assign o_data = data;
assign o_dbg_data = dbg_data;

endmodule
