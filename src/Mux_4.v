`timescale 1ns / 1ps

module Mux_4 #(
    parameter   NBITS = 32
)(
    input wire  [1:0]        i_sel,
    input wire  [NBITS-1:0]  i_a,
    input wire  [NBITS-1:0]  i_b,
    input wire  [NBITS-1:0]  i_c,
    input wire  [NBITS-1:0]  i_d,
    output reg  [NBITS-1:0]  o_result
);

always @(*) begin
    case (i_sel)
        2'b00: o_result <= i_a;
        2'b01: o_result <= i_b;
        2'b10: o_result <= i_c;
        2'b11: o_result <= i_d;
    endcase
end

endmodule