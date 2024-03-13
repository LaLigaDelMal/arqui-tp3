`timescale 1ns / 1ps

module Instruction_Memory #(
        parameter NBITS = 32,
        parameter CELLS = 256
    )(
    input   wire    i_clk,
    input   wire    i_wr_en,
    input   wire    [NBITS-1:0] i_addr,
    input   wire    [NBITS-1:0] i_data,
    
    output  reg     [NBITS-1:0] o_data,
);

reg [NBITS-1:0] memory[CELLS-1:0];
integer i;

initial begin
    for (i = 0; i < CELLS; i = i + 1) begin
        memory[i] = 0;
    end  
end

always @( i_addr ) begin
    if ( !i_wr_en ) begin
        o_data  <= memory[i_addr];
    end
end

endmodule

