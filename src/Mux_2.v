`timescale 1ns / 1ps

module Mux_2 #(
    parameter   NBITS = 32
)(
    input wire               i_sel,
    input wire  [NBITS-1:0]  i_a,
    input wire  [NBITS-1:0]  i_b,
    output reg  [NBITS-1:0]  o_result
);

always @(*) begin
    case (i_sel)
        1'b0: o_result <= i_a;
        1'b1: o_result <= i_b;
    endcase
end

endmodule