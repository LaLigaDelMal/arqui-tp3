`timescale 1ns / 1ps

module Cycle_Counter #(
    parameter   NBITS = 32
)(
    input   wire    i_clk,
    input   wire    i_rst,
    input   wire    i_step,
    output  wire  [NBITS-1:0]  o_count
);

    reg [NBITS-1:0] count;

    always @(posedge i_clk) begin
        if ( i_rst ) begin
            count <= 0;
        end else if ( i_step ) begin
            count <= count + 1;
        end
    end

    assign o_count = count;

endmodule