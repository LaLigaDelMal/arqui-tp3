`timescale 1ns / 1ps

module PC_Mux #(
    parameter   NBITS = 32
)(
    input wire               i_sel_jump,
    input wire  [NBITS-1:0]  i_next_pc,
    input wire  [NBITS-1:0]  i_jump_pc,
    output reg  [NBITS-1:0]  o_pc
);

always @(*) begin
    if ( i_sel_jump ) begin
        o_pc <= i_jump_pc;
    end
    else begin
        o_pc <= i_next_pc;
    end
end

endmodule