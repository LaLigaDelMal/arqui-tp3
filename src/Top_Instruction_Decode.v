`timescale 1ns / 1ps

module Top_Instruction_Decode #(
    parameter NBITS = 32
)(
    input   wire i_clk,
    input   wire i_rst,

    // Non buffer inputs (WB signals)
    input wire [4:0]    i_rd_sel,
    input wire          i_wr_en,
    input wire [31:0]   i_wr_data,

    // Input from IF_ID_Reg
    input wire  [NBITS-1:0]  i_pc,
    input wire  [NBITS-1:0]  i_instruction,

    // Outputs
    output wire [31:0]  o_rs_data,
    output wire [31:0]  o_rt_data,

    output wire        o_flg_ALU_enable;
    output wire        o_flg_ALU_src_a;
    output wire        o_flg_ALU_src_b;
    output wire        o_flg_ALU_dst;
    output wire [2:0]  o_flg_ALU_opcode;

    output wire        o_flg_AGU_enable;
    output wire        o_flg_AGU_src_addr;
    output wire        o_flg_AGU_dst;
    output wire [2:0]  o_flg_AGU_opcode;

    output wire        o_flg_jump;
    output wire        o_flg_branch;

    output wire [15:0] imm_ext;
);

wire [5:0]  funct;
wire [4:0]  rs;
wire [4:0]  rt;
wire [4:0]  rd;
wire [4:0]  sa;
wire [15:0] imm;
wire [25:0] addr_offset;

wire        flg_pc_modify;
wire        flg_link_ret;
wire [1:0]  flg_addr_type;
wire [4:0]  link_reg;
wire [4:0]  addr_reg;
wire        flg_equal;
wire        flg_inmediate;
wire        flg_mem_op;
wire        flg_mem_type;
wire [1:0]  flg_mem_size;
wire        flg_unsign;

Instruction_Decoder Inst_Deco(
    .i_instruction(i_instruction),

    .o_funct(funct),
    .o_rs(rs),
    .o_rt(rt),
    .o_rd(rd),
    .o_sa(sa),
    .o_imm(imm),
    .o_addr_offset(addr_offset),
    
    .o_flg_pc_modify(flg_pc_modify),
    .o_flg_link_ret(flg_link_ret),
    .o_flg_addr_type(flg_addr_type),
    .o_link_reg(link_reg),
    .o_addr_reg(addr_reg),
    .o_flg_equal(flg_equal),
    .o_flg_inmediate(flg_inmediate),
    .o_flg_mem_op(flg_mem_op),
    .o_flg_mem_type(flg_mem_type),
    .o_flg_mem_size(flg_mem_size),
    .o_flg_unsign(flg_unsign)
);

wire [1:0]  extend_sign;

Control_Unit Ctrl_Unit(
    .i_funct(funct),
    .i_rs(rs),
    .i_rt(rt),
    .i_rd(rd),
    .i_sa(sa),
    .i_imm(imm),
    .i_addr_offset(offset),

    .i_flg_pc_modify(flg_pc_modify),
    .i_flg_link_ret(flg_link_ret),
    .i_flg_addr_type(flg_addr_type),
    .i_link_reg(link_reg),
    .i_addr_reg(addr_reg),
    .i_flg_equal(flg_equal),
    .i_flg_inmediate(flg_inmediate),
    .i_flg_mem_op(flg_mem_op),
    .i_flg_mem_type(flg_mem_type),
    .i_flg_mem_size(flg_mem_size),
    .i_flg_unsign(flg_unsign)

    .o_flg_ALU_enable(o_flg_ALU_enable),
    .o_flg_ALU_src_a(o_flg_ALU_src_a),
    .o_flg_ALU_src_b(o_flg_ALU_src_b),
    .o_flg_ALU_dst(o_flg_ALU_dst),
    .o_ALU_opcode(o_flg_ALU_opcode),

    .o_flg_AGU_enable(o_flg_AGU_enable),
    .o_flg_AGU_src_addr(o_flg_AGU_src_addr),
    .o_flg_AGU_dst(o_flg_AGU_dst),
    .o_flg_AGU_opcode(o_flg_AGU_opcode),

    .o_flg_jump(o_flg_jump),
    .o_flg_branch(o_flg_branch),

    .o_extend_sign(extend_sign),
);

Registers Regs(
    .i_rst(i_rst),

    .i_rs_sel(rs),
    .i_rt_sel(rt),
    .i_rd_sel(i_rd_sel),
    .i_wr_en(i_wr_en),  //TODO Viene de otra etapa (WB signals)
    .i_wr_data(i_wr_data),

    .o_rs_data(o_rs_data),
    .o_rt_data(o_rt_data)
);

Sign_Extender Sign_Ext(
    .i_inmediate(imm),
    .i_mode(extend_sign),
    .o_result(imm_ext)
);

endmodule