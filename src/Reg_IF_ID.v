`timescale 1ns / 1ps

module Reg_IF_ID #(
    parameter   NBITS = 32
)(
    input wire                      i_clk,
    input wire                      i_rst,
    input wire                      i_step,
    input wire      [NBITS-1:0]     i_pc,
    input wire      [NBITS-1:0]     i_instruction,
    input wire                      i_hazard_detected,
    
    output reg      [NBITS-1:0]     o_pc,
    output reg      [NBITS-1:0]     o_instruction
);

always @(posedge i_clk) begin
    if ( i_rst ) begin
        {o_pc, o_instruction} <= 0;
    end
    else if (~i_hazard_detected & i_step) begin
        o_pc <= i_pc;
        o_instruction <= i_instruction;
    end
end

endmodule
