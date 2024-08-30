`timescale 1ns / 1ps


module Reg_EX_MA #(
    parameter   NBITS = 32
)(

    input wire                i_clk,
    input wire                i_rst,
    input wire               i_pc_mux_ctrl,
    input wire  [NBITS-1:0]  i_ALU_rslt,
    input wire  [NBITS-1:0]  i_eff_addr,
    input wire               i_flg_mem_op,
    input wire               i_flg_mem_type,
    input wire  [1:0]        i_flg_mem_size,
    input wire               i_flg_unsign,
    input wire  [4:0]        i_rd, i_rt,
    input wire               i_flg_ALU_dst,

    output reg               o_pc_mux_ctrl,
    output reg  [NBITS-1:0]  o_ALU_rslt,
    output reg  [NBITS-1:0]  o_eff_addr,
    output reg               o_flg_mem_op,
    output reg               o_flg_mem_type,
    output reg  [1:0]        o_flg_mem_size,
    output reg               o_flg_unsign,
    output reg  [4:0]        o_rd, o_rt,
    output reg               o_flg_ALU_dst,

    );

    always @(posedge i_clk) begin
    if ( i_rst ) begin
        o_pc_mux_ctrl <= 0;
        o_ALU_rslt <= 0;
        o_eff_addr <= 0;
        o_flg_mem_op <= 0;
        o_flg_mem_type <= 0;
        o_flg_mem_size <= 0;
        o_flg_unsign <= 0;
        o_rd <= 0;
        o_rt <= 0;
        o_flg_ALU_dst <= 0;
    end
    else begin
        o_pc_mux_ctrl <= i_pc_mux_ctrl;
        o_ALU_rslt <= i_ALU_rslt;
        o_eff_addr <= i_eff_addr;
        o_flg_mem_op <= i_flg_mem_op;
        o_flg_mem_type <= i_flg_mem_type;
        o_flg_mem_size <= i_flg_mem_size;
        o_flg_unsign <= i_flg_unsign;
        o_rd <= i_rd;
        o_rt <= i_rt;
        o_flg_ALU_dst <= i_flg_ALU_dst;
    end
end
endmodule
