`timescale 1ns / 1ps

module Top_Execute#(
    parameter   NBITS = 32
)(
    input wire   [NBITS-1:0]  i_pc,
    input wire   [25:0]       i_addr_offset,
    input wire                i_flg_equal,
    input wire   [3:0]        i_ALU_opcode,
    input wire   [2:0]        i_AGU_opcode,
    input wire                i_flg_branch,
    input wire                i_flg_jump,
    input wire   [NBITS-1:0]  i_ALU_src_A,
    input wire   [NBITS-1:0]  i_ALU_src_B,
    input wire   [NBITS-1:0]  i_AGU_src_addr,


    output wire               o_pc_mux_ctrl,
    output wire  [NBITS-1:0]  o_ALU_rslt,
    output wire  [NBITS-1:0]  o_eff_addr
);
    
    wire o_rslt_lsb = o_ALU_rslt[0];

    ALU u_ALU (
        .i_opcode(i_ALU_opcode),
        .i_src_A(i_ALU_src_A),
        .i_src_B(i_ALU_src_B),
        .o_rslt(o_ALU_rslt)
    );

    AGU u_AGU (
        .i_op_code(i_AGU_opcode),
        .i_addr(i_AGU_src_addr),
        .i_offset(i_addr_offset),
        .o_eff_addr(o_eff_addr),
        .o_addr_exception()         // TODO: Debug unit
    );

    PC_Control_Unit u_PC_Control_Unit (
        .i_flg_jump(i_flg_jump),
        .i_flg_branch(i_flg_branch),
        .i_flg_equal(i_flg_equal),
        .i_rslt_lsb(o_rslt_lsb),
        .o_pc_mux_ctrl(o_pc_mux_ctrl)
    );

endmodule
