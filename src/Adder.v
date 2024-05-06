`timescale 1ns / 1ps

module Adder #(
    parameter   NBITS = 32
)(
    input  wire [NBITS-1:0] i_operand_1,
    input  wire [NBITS-1:0] i_operand_2,
    output wire [NBITS-1:0] o_result
);

assign o_result = i_operand_1 + i_operand_2;

endmodule