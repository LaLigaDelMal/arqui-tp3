`timescale 1ns / 1ps

module Top_Instruction_Decode #(
    parameter NBITS = 32
)(
    input   wire i_rst,

    // Non buffer inputs (WB signals)
    input wire [4:0]    i_rd_sel,
    input wire          i_wr_en,
    input wire [31:0]   i_wr_data,

    // Input from IF_ID_Reg
    input wire  [NBITS-1:0]  i_pc,
    input wire  [NBITS-1:0]  i_instruction,

    // Outputs
    

    // Control signals
    output wire        o_flg_ALU_enable;
    output wire        o_flg_ALU_dst;
    output wire [2:0]  o_flg_ALU_opcode;

    output wire        o_flg_AGU_enable;
    output wire        o_flg_AGU_dst;
    output wire [2:0]  o_flg_AGU_opcode;

    output wire        o_flg_jump;
    output wire        o_flg_branch;

    output wire [31:0]  o_ALU_src_a;
    output wire [31:0]  o_ALU_src_b;
    output wire [31:0]  o_AGU_src_addr;
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
wire [1:0]  flg_ALU_src_a;
wire        flg_ALU_src_b;
wire        flg_AGU_src_addr;
Control_Unit Ctrl_Unit(
    .i_funct(funct),

    .i_flg_pc_modify(flg_pc_modify),
    .i_flg_link_ret(flg_link_ret),
    .i_flg_addr_type(flg_addr_type),
    .i_link_reg(link_reg),
    .i_addr_reg(addr_reg),
    .i_flg_inmediate(flg_inmediate),
    .i_flg_mem_op(flg_mem_op),

    .o_flg_ALU_enable(o_flg_ALU_enable),
    .o_flg_ALU_src_a(flg_ALU_src_a),
    .o_flg_ALU_src_b(flg_ALU_src_b),
    .o_flg_ALU_dst(o_flg_ALU_dst),
    .o_ALU_opcode(o_flg_ALU_opcode),

    .o_flg_AGU_enable(o_flg_AGU_enable),
    .o_flg_AGU_src_addr(flg_AGU_src_addr),
    .o_flg_AGU_dst(o_flg_AGU_dst),
    .o_flg_AGU_opcode(o_flg_AGU_opcode),

    .o_flg_jump(o_flg_jump),
    .o_flg_branch(o_flg_branch),

    .o_extend_sign(extend_sign),
);

wire [31:0]  rs_data,
wire [31:0]  rt_data,

Registers Regs(
    .i_rst(i_rst),

    .i_rs_sel(rs),
    .i_rt_sel(rt),
    .i_rd_sel(i_rd_sel),
    .i_wr_en(i_wr_en),  //TODO Viene de otra etapa (WB signals)
    .i_wr_data(i_wr_data),

    .o_rs_data(rs_data),
    .o_rt_data(rt_data)
);

wire [15:0] imm_ext;
Sign_Extender Sign_Ext(
    .i_inmediate(imm),
    .i_mode(extend_sign),
    .o_result(imm_ext)
);


Mux_4 ALU_SRC_A(
    .i_sel(flg_ALU_src_a),
    .i_a(i_pc),             // (00) PC+4
    .i_b(o_rt_data),        // (01) rt data
    .i_c(),                 // (10) NC
    .i_d(imm_ext),          // (11) Sign Extender result
    .o_result(o_ALU_src_a)
);

Mux_2 ALU_SRC_B(
    .i_sel(flg_ALU_src_b),
    .i_a(rs_data),          // (0) rs data
    .i_b(sa),               // (1) Sign Extender result
    .o_result(o_ALU_src_b)
);

Mux_2 AGU_SRC_ADDR(
    .i_sel(flg_AGU_src_addr),
    .i_a(rs_data),          // (0) rs data
    .i_b(i_pc),             // (1) PC
    .o_result(o_AGU_src_addr)
);

endmodule