`include "defines.v"

module DataMemory(
    parameter WORD_LEN = 32,
    parameter MEM_CELL_SIZE = 8,
    parameter DATA_MEM_SIZE = 1024
    )(
    input   wire                i_clk,
    input   wire                i_rst,
    input   wire                i_write_en,
    input   wire                i_read_en,
    input   wire [WORD_LEN-1:0] i_addr,
    input   wire [WORD_LEN-1:0] i_data_in,
    output  wire [WORD_LEN-1:0] o_data_out
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
            {memory[base_address], memory[base_address + 1], memory[base_address + 2], memory[base_address + 3]} <= i_data_in;
        end
    end

    assign base_address = {22'b0, i_addr[9:2], 2'b0}; // To align the address to directions of 4 bytes and below 1024 addresses
    assign o_data_out = {memory[base_address], memory[base_address + 1], memory[base_address + 2], memory[base_address + 3]};

endmodule
