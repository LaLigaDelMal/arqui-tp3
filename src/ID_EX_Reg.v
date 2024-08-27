`timescale 1ns / 1ps

module ID_EX_Reg #(
    parameter   NBITS = 32
)(
    input wire                i_clk,
    input wire                i_rst,
    input wire   [NBITS-1:0]  i_pc,
    input wire   [4:0]        i_rd,
    input wire   [4:0]        i_rt,
    input wire   [25:0]       i_addr_offset,
    input wire                i_flg_equal,
    input wire                i_flg_mem_op,
    input wire                i_flg_mem_type,
    input wire   [1:0]        i_flg_mem_size,
    input wire                i_flg_unsign,
    input wire                i_ALU_enable,
    input wire   [1:0]        i_ALU_dst,
    input wire   [3:0]        i_ALU_opcode,
    input wire                i_AGU_enable,
    input wire                i_AGU_dst,
    input wire   [2:0]        i_AGU_opcode,
    input wire                i_flg_branch,
    input wire                i_flg_jump,
    input wire   [NBITS-1:0]  i_ALU_src_A,
    input wire   [NBITS-1:0]  i_ALU_src_B,
    input wire   [NBITS-1:0]  i_AGU_src_addr,

    output reg                o_clk,
    output reg                o_rst,
    output reg   [NBITS-1:0]  o_pc,
    output reg   [4:0]        o_rd,
    output reg   [4:0]        o_rt,
    output reg   [25:0]       o_addr_offset,
    output reg                o_flg_equal,
    output reg                o_flg_mem_op,
    output reg                o_flg_mem_type,
    output reg   [1:0]        o_flg_mem_size,
    output reg                o_flg_unsign,
    output reg                o_ALU_enable,
    output reg   [1:0]        o_ALU_dst,
    output reg   [3:0]        o_ALU_opcode,
    output reg                o_AGU_enable,
    output reg                o_AGU_dst,
    output reg   [2:0]        o_AGU_opcode,
    output reg                o_flg_branch,
    output reg                o_flg_jump,
    output reg   [NBITS-1:0]  o_ALU_src_A,
    output reg   [NBITS-1:0]  o_ALU_src_B,
    output reg   [NBITS-1:0]  o_AGU_src_addr,

);

always @(posedge i_clk) begin
    if ( i_rst ) begin
        i_pc <= 0;
        i_rd <= 0;
        i_rt <= 0;
        i_addr_offset <= 0;
        i_flg_equal <= 0;
        i_flg_mem_op <= 0;
        i_flg_mem_type <= 0;
        i_flg_mem_size <= 0;
        i_flg_unsign <= 0;
        i_ALU_enable <= 0;
        i_ALU_dst <= 0;
        i_ALU_opcode <= 0;
        i_AGU_enable <= 0;
        i_AGU_dst <= 0;
        i_AGU_opcode <= 0;
        i_flg_branch <= 0;
        i_flg_jump <= 0;
        i_ALU_src_A <= 0;
        i_ALU_src_B <= 0;
        i_AGU_src_addr <= 0;
    end
    else begin
        o_pc <= i_pc;
        o_rd <= i_rd;
        o_rt <= i_rt;
        o_addr_offset <= i_addr_offset;
        o_flg_equal <= i_flg_equal;
        o_flg_mem_op <= i_flg_mem_op;
        o_flg_mem_type <= i_flg_mem_type;
        o_flg_mem_size <= i_flg_mem_size;
        o_flg_unsign <= i_flg_unsign;
        o_ALU_enable <= i_ALU_enable;
        o_ALU_dst <= i_ALU_dst;
        o_ALU_opcode <= i_ALU_opcode;
        o_AGU_enable <= i_AGU_enable;
        o_AGU_dst <= i_AGU_dst;
        o_AGU_opcode <= i_AGU_opcode;
        o_flg_branch <= i_flg_branch;
        o_flg_jump <= i_flg_jump;
        o_ALU_src_A <= i_ALU_src_A;
        o_ALU_src_B <= i_ALU_src_B;
        o_AGU_src_addr <= i_AGU_src_addr;
    end
end

endmodule
