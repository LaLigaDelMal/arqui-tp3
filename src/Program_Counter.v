`timescale 1ns / 1ps

module Program_Counter #(
    parameter   NBITS = 32
)(
    input wire               i_clk,
    input wire               i_rst,
    input wire  [NBITS-1:0]  i_next_pc,
    output reg  [NBITS-1:0]  o_pc
);

always @(posedge i_clk) begin
    if ( i_rst ) begin
        o_pc <= {NBITS{1'b0}};
    end

    else begin
        o_pc <= i_next_pc;
    end
end

endmodule
