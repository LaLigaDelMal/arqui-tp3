`timescale 1ns / 1ps

module Reg_sel_Mux #(
    parameter   NBITS = 5
)(
    input wire  [1:0]        i_sel,
    input wire  [NBITS-1:0]  i_rt,
    input wire  [NBITS-1:0]  i_rd,
    output reg  [NBITS-1:0]  o_result
);

always @(*) begin
    case (i_sel)
        2'b00: o_result <= i_rt;
        2'b01: o_result <= i_rd;
        2'b11: o_result <= 5'd31;
    endcase
end

endmodule
