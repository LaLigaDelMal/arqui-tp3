`timescale 1ns / 1ps

module Top_Execute#(
    parameter   NBITS = 32
)(
    input wire   [25:0]       i_addr_offset,
    input wire                i_flg_equal,
    input wire   [3:0]        i_ALU_opcode,
    input wire   [2:0]        i_AGU_opcode,
    input wire                i_flg_branch,
    input wire                i_flg_jump,
    input wire   [NBITS-1:0]  i_ALU_src_A,
    input wire   [NBITS-1:0]  i_ALU_src_B,
    input wire   [NBITS-1:0]  i_AGU_src_addr,
    input wire   [NBITS-1:0]  i_ALU_rslt_MEM,
    input wire   [NBITS-1:0]  i_WB_wr_data,
    input wire   [1:0]        i_ALU_src_A_ctrl,
    input wire   [1:0]        i_ALU_src_B_ctrl,

    output wire               o_pc_mux_ctrl,
    output wire  [NBITS-1:0]  o_ALU_rslt,
    output wire  [NBITS-1:0]  o_eff_addr
);
    
    wire rslt_lsb = o_ALU_rslt[0];

    wire [NBITS-1:0] ALU_mux_A_result;
    Mux_4 u_ALU_mux_A (
        .i_sel(i_ALU_src_A_ctrl),
        .i_a(i_ALU_src_A),
        .i_b(i_ALU_rslt_MEM),
        .i_c(i_WB_wr_data),
        .i_d(0),
        .o_result(ALU_mux_A_result)
    );

    wire [NBITS-1:0] ALU_mux_B_result;
    Mux_4 u_ALU_mux_B (
        .i_sel(i_ALU_src_B_ctrl),
        .i_a(i_ALU_src_B),
        .i_b(i_ALU_rslt_MEM),
        .i_c(i_WB_wr_data),
        .i_d(0),
        .o_result(ALU_mux_B_result)
    );

    wire [NBITS-1:0] ALU_result;
    ALU u_ALU (
        .i_opcode(i_ALU_opcode),
        .i_op_A(ALU_mux_A_result),
        .i_op_B(ALU_mux_B_result),
        .o_rslt(ALU_result),
        .o_zero(),
        .o_carry(),
        .o_ovfl_exception()
    );

    wire [NBITS-1:0] AGU_eff_addr;
    AGU u_AGU (
        .i_opcode(i_AGU_opcode),
        .i_addr(i_AGU_src_addr),
        .i_offset(i_addr_offset),
        .o_eff_addr(AGU_eff_addr),
        .o_addr_exception()         // TODO: Debug unit
    );

    wire PC_CU_pc_mux_ctrl;
    PC_Control_Unit u_PC_Control_Unit (
        .i_flg_jump(i_flg_jump),
        .i_flg_branch(i_flg_branch),
        .i_flg_equal(i_flg_equal),
        .i_rslt_lsb(rslt_lsb),
        .o_pc_mux_ctrl(PC_CU_pc_mux_ctrl)
    );

    assign o_pc_mux_ctrl = PC_CU_pc_mux_ctrl;
    assign o_eff_addr = AGU_eff_addr;
    assign o_ALU_rslt = ALU_result;
endmodule
