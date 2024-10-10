`timescale 1ns / 1ps


module Reg_MA_WB #(
    parameter   NBITS = 32
)(
    input wire                i_clk,
    input wire                i_rst,
    input wire  [1:0]         i_flg_ALU_dst,
    input wire                i_flg_mem_op,
    input wire  [NBITS-1:0]   i_ALU_rslt,
    input wire  [NBITS-1:0]   i_data,
    input wire  [4:0]         i_rd, i_rt,

    output reg  [1:0]         o_flg_ALU_dst,
    output reg                o_neg_flg_mem_op,
    output reg  [NBITS-1:0]   o_ALU_rslt,
    output reg  [NBITS-1:0]   o_data,
    output reg  [4:0]         o_rd, o_rt
    );

    always @(posedge i_clk) begin
        if ( i_rst ) begin
            o_flg_ALU_dst <= 0;
            o_neg_flg_mem_op <= 0;
            o_ALU_rslt <= 0;
            o_data <= 0;
            o_rd <= 0;
            o_rt <= 0;
        end
        else begin
            o_flg_ALU_dst <= i_flg_ALU_dst;
            o_neg_flg_mem_op <= ~i_flg_mem_op;
            o_ALU_rslt <= i_ALU_rslt;
            o_data <= i_data;
            o_rd <= i_rd;
            o_rt <= i_rt;
        end
    end

endmodule
