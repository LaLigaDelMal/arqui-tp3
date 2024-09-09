`timescale 1ns / 1ps

module Instruction_Memory #(
    parameter NBITS = 8,
    parameter INST_BITS = 32,
    parameter CELLS = 256
)(
    input   wire    [NBITS-1:0] i_addr,
    input   wire    [NBITS-1:0] i_data,
    input   wire                i_wr_en,
    output  reg     [INST_BITS-1:0] o_data
);

reg [NBITS-1:0] memory[CELLS-1:0];
integer i;

initial begin
    for (i = 0; i < CELLS; i = i + 1) begin
        memory[i] = i;
    end
end

always @( i_addr ) begin
    if ( !i_wr_en ) begin
        o_data  <= {memory[i_addr], memory[i_addr + 1], memory[i_addr + 2], memory[i_addr + 3]};
        //          0000 0000       0000 0001       0000 0010       0000 0011
    end
end

endmodule

