`include "defines.v"

module DataMemory(
    parameter WORD_LEN = 32,
    parameter MEM_CELL_SIZE = 8,
    parameter DATA_MEM_SIZE = 1024
    )(
    input   wire                i_clk,
    input   wire                i_rst,
    input   wire                i_write_en,
    input   wire [1:0]          i_byte_mask,    // 00: Byte, 01: Half Word, 10: Word
    input   wire [WORD_LEN-1:0] i_addr,
    input   wire [WORD_LEN-1:0] i_data_in,
    output  reg  [WORD_LEN-1:0] o_data_out
);

    integer i;
    reg [MEM_CELL_SIZE-1:0] memory[DATA_MEM_SIZE-1:0];
    wire [WORD_LEN-1:0] base_address;

    always @ (posedge i_clk) begin
        if (i_rst) begin
            for (i = 0; i < DATA_MEM_SIZE; i = i + 1) begin
                memory[i] <= 0;
            end
        end else if (i_write_en) begin
            case (i_byte_mask)
                2'b00: memory[i_addr] <= i_data_in[7:0];
                2'b01: {memory[i_addr + 1], memory[i_addr] } <= i_data_in[15:0];
                2'b10: {memory[i_addr + 3], memory[i_addr + 2], memory[i_addr + 1], memory[i_addr]} <= i_data_in[31:0];
            endcase
        end else begin
            case (i_byte_mask)
                2'b00: o_data_out <= {24'b0, memory[i_addr]};
                2'b01: o_data_out <= {16'b0, memory[i_addr + 1], memory[i_addr]};
                2'b10: o_data_out <= {memory[i_addr + 3], memory[i_addr + 2], memory[i_addr + 1], memory[i_addr]};
            endcase
        end
    end

endmodule
