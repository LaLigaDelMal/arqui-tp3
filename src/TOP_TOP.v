`timescale 1ns / 1ps

module TOP_TOP#(
    parameter   NBITS = 32
)(
    input wire i_clk,
    input wire i_rst,
    
)

wire [31:0] pc_IF_ID;
wire [31:0] instr_IF_ID;
Top_Instruction_Fetch IF (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_pc_mux_ctrl(),   //Viene de WB
    .i_eff_addr(),      //Viene de MA
    .i_inst_mem_wr_en(),// Viene de afuera
    .i_inst_mem_data(),// Viene de afuera
    .o_pc(pc_IF_ID),
    .o_instr(instr_IF_ID),          // Fetched instruction
);

Reg_IF_ID IF_ID (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_pc(pc_IF_ID),
    .i_instruction(instr_IF_ID),
    .o_pc(),    
    .o_instr()          // Fetched instruction
);

Top_Instruction_Decode ID (
    .i_rst(i_rst),
    .i_rd_sel(),    //Viene de WB
    .i_wr_en(),     //Viene de WB
    .i_wr_data(),   //Viene de WB
    .i_pc(pc_IF_ID),
    .i_instruction(instr_IF_ID),
    .o_flg_ALU_dst(),
    .o_flg_ALU_opcode(),
    .o_flg_AGU_dst(),
    .o_flg_AGU_opcode(),
    .o_flg_jump(),
    .o_flg_branch(),
    .o_ALU_src_a(),
    .o_ALU_src_b(),
    .o_AGU_src_addr(),
    .flg_equal(),
    .flg_mem_op(),
    .flg_mem_type(),
    .flg_mem_size(),
    .flg_unsign(),
    .o_pc(),
    .o_rt(),
    .o_rd()
);

Reg_ID_EX ID_EX (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_pc(),
    .i_rd(),
    .i_rt(),
    .i_addr_offset(),
    .i_flg_equal(),
    .i_flg_mem_op(),
    .i_flg_mem_type(),
    .i_flg_mem_size(),
    .i_flg_unsign(),
    .i_ALU_enable(),
    .i_ALU_dst(),
    .i_ALU_opcode(),
    .i_AGU_enable(),
    .i_AGU_dst(),
    .i_AGU_opcode(),
    .i_flg_branch(),
    .i_flg_jump(),
    .i_ALU_src_A(),
    .i_ALU_src_B(),
    .i_AGU_src_addr(),
    .o_clk(),
    .o_rst(),
    .o_pc(),
    .o_rd(),
    .o_rt(),
    .o_addr_offset(),
    .o_flg_equal(),
    .o_flg_mem_op(),
    .o_flg_mem_type(),
    .o_flg_mem_size(),
    .o_flg_unsign(),
    .o_ALU_enable(),
    .o_ALU_dst(),
    .o_ALU_opcode(),
    .o_AGU_enable(),
    .o_AGU_dst(),
    .o_AGU_opcode(),
    .o_flg_branch(),
    .o_flg_jump(),
    .o_ALU_src_A(),
    .o_ALU_src_B(),
    .o_AGU_src_addr()
);

Top_Execution EX (
    .i_pc(ID_EX.o_pc),
    .i_addr_offset(ID_EX.o_addr_offset),
    .i_flg_equal(ID_EX.o_flg_equal),
    .i_ALU_opcode(ID_EX.o_ALU_opcode),
    .i_AGU_opcode(ID_EX.o_AGU_opcode),
    .i_flg_branch(ID_EX.o_flg_branch),
    .i_flg_jump(ID_EX.o_flg_jump),
    .i_ALU_src_A(ID_EX.o_ALU_src_A),
    .i_ALU_src_B(ID_EX.o_ALU_src_B),
    .i_AGU_src_addr(ID_EX.o_AGU_src_addr),
    .o_pc_mux_ctrl(),
    .o_ALU_rslt(),
    .o_eff_addr()
)

Reg_EX_MA EX_MA (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_flg_ALU_dst(EX.o_pc_mux_ctrl),
    .i_flg_mem_op(EX.o_flg_mem_op),
    .i_ALU_rslt(EX.o_ALU_rslt),
    .i_data(EX.o_eff_addr),
    .i_rd(ID_EX.o_rd),
    .i_rt(ID_EX.o_rt),
    .o_flg_ALU_dst(),
    .o_neg_flg_mem_op(),
    .o_ALU_rslt(),
    .o_data(),
    .o_rd(),
    .o_rt()
);

Top_Memory_Access MA (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_ALU_rslt(EX_MA.o_ALU_rslt),
    .i_flg_unsign(EX_MA.o_flg_unsign),
    .i_flg_mem_size(EX_MA.o_flg_mem_size),
    .i_flg_mem_type(EX_MA.o_flg_mem_type),
    .i_eff_addr(EX_MA.o_data),
    .o_data()
);

Reg_MA_WB MA_WB (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_flg_ALU_dst(MA.o_flg_ALU_dst),
    .i_flg_mem_op(MA.o_neg_flg_mem_op),
    .i_ALU_rslt(MA.o_data),
    .i_data(MA.o_data),
    .i_rd(MA.o_rd),
    .i_rt(MA.o_rt),
    .o_flg_ALU_dst(),
    .o_neg_flg_mem_op(),
    .o_ALU_rslt(),
    .o_data(),
    .o_rd(),
    .o_rt()
);

Top_Writeback WB (
    .i_neg_flg_mem_op(MA_WB.o_neg_flg_mem_op),
    .i_ALU_rslt(MA_WB.o_ALU_rslt),
    .i_data(MA_WB.o_data),
    .i_flg_ALU_dst(MA_WB.o_flg_ALU_dst),
    .i_rd(MA_WB.o_rd),
    .i_rt(MA_WB.o_rt),
    .o_wr_data(),
    .o_reg_sel()
);
