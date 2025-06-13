`timescale 1ns / 1ps


module Forwarding_Unit(
    // Inputs from EX stage
    input wire  [4:0]  i_rt_EX, i_rs_EX,
    input wire  [1:0]  i_flg_ALU_src_A,
    input wire         i_flg_ALU_src_B,
    
    // Inputs from MEM stage
    input wire  [4:0]  i_rt_MEM, i_rd_MEM,
    input wire         i_flg_reg_wr_en_MEM,
    input wire  [1:0]  i_flg_ALU_dst_MEM,
    // Inputs from WB stage
    input wire         i_flg_reg_wr_en_WB,
    input wire  [4:0]  i_rt_WB, i_rd_WB,
    input wire  [1:0]  i_flg_ALU_dst_WB,

    output reg  [1:0]  o_ALU_src_a_ctrl, o_ALU_src_b_ctrl
    );
    // ALU destination control signals: rt 00, rd 01, 31 11

    // Source A control signal
    always @ (*) begin
        if (i_flg_reg_wr_en_MEM & ( ((i_rt_EX == i_rt_MEM) & i_flg_ALU_dst_MEM == 2'b00 )  | ((i_rt_EX == i_rd_MEM) & i_flg_ALU_dst_MEM == 2'b01) ) & i_flg_ALU_src_A == 2'b01) begin
            o_ALU_src_a_ctrl <= 2'b01;
        end else if (i_flg_reg_wr_en_WB & ( ((i_rt_EX == i_rt_WB) & i_flg_ALU_dst_WB == 2'b00 ) | ((i_rt_EX == i_rd_WB) & i_flg_ALU_dst_WB == 2'b01 ) )  & i_flg_ALU_src_A == 2'b01) begin
            o_ALU_src_a_ctrl <= 2'b10;
        end else begin
            o_ALU_src_a_ctrl <= 2'b00;
        end
    end

    // Source B control signal
    always @ (*) begin
        if (i_flg_reg_wr_en_MEM & ( ((i_rs_EX == i_rt_MEM) & i_flg_ALU_dst_MEM == 2'b00) | ((i_rs_EX == i_rd_MEM) & i_flg_ALU_dst_MEM == 2'b01)) & i_flg_ALU_src_B == 1'b0) begin
            o_ALU_src_b_ctrl <= 2'b01;
        end else if (i_flg_reg_wr_en_WB & ( ((i_rs_EX == i_rt_WB) & i_flg_ALU_dst_WB == 2'b00) | ((i_rs_EX == i_rd_WB) & i_flg_ALU_dst_WB == 2'b01)) & i_flg_ALU_src_B == 1'b0) begin
            o_ALU_src_b_ctrl <= 2'b10;
        end else begin
            o_ALU_src_b_ctrl <= 2'b00;
        end
    end

endmodule
