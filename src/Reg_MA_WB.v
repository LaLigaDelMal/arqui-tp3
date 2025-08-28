`timescale 1ns / 1ps


module Reg_MA_WB #(
    parameter   NBITS = 32
)(
    input wire                i_clk,
    input wire                i_rst,
    input wire                i_step,
    input wire  [1:0]         i_flg_ALU_dst,
    input wire  [NBITS-1:0]   i_ALU_rslt,
    input wire  [NBITS-1:0]   i_data,
    input wire  [4:0]         i_rd, i_rt,
    input wire                i_flg_reg_wr_en,
    input wire                i_flg_wb_src,
    input wire                i_flg_halt,

    output reg  [1:0]         o_flg_ALU_dst,
    output reg  [NBITS-1:0]   o_ALU_rslt,
    output reg  [NBITS-1:0]   o_data,
    output reg  [4:0]         o_rd, o_rt,
    output reg                o_flg_reg_wr_en,
    output reg                o_flg_wb_src,
    output reg                o_flg_halt
    );

    always @(posedge i_clk) begin
        if ( i_rst ) begin
            o_flg_ALU_dst <= 0;
            o_ALU_rslt <= 0;
            o_data <= 0;
            o_rd <= 0;
            o_rt <= 0;
            o_flg_reg_wr_en <= 0;
            o_flg_wb_src <= 0;
            o_flg_halt <= 0;
        end
        else if (i_step) begin
            o_flg_ALU_dst <= i_flg_ALU_dst;
            o_ALU_rslt <= i_ALU_rslt;
            o_data <= i_data;
            o_rd <= i_rd;
            o_rt <= i_rt;
            o_flg_reg_wr_en <= i_flg_reg_wr_en;
            o_flg_wb_src <= i_flg_wb_src;
            o_flg_halt <= i_flg_halt;
        end
    end

endmodule
