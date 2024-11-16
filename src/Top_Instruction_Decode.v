`timescale 1ns / 1ps

module Top_Instruction_Decode #(
    parameter NBITS = 32
)(
    input   wire i_clk,
    input   wire i_rst,
    input   wire i_hazard_detected,

    // Non buffer inputs (WB signals)
    input wire [4:0]    i_rd_sel,
    input wire          i_wr_en,
    input wire [31:0]   i_wr_data,

    // Input from IF_ID_Reg
    input wire  [NBITS-1:0]  i_pc,
    input wire  [NBITS-1:0]  i_instruction,

    // Outputs
    // Control signals
    output wire [1:0]  o_flg_ALU_dst,
    output wire [3:0]  o_flg_ALU_opcode,

    output wire [2:0]  o_flg_AGU_opcode,

    output wire [25:0]  o_addr_offset,
    
    output wire        o_flg_jump,
    output wire        o_flg_branch,

    output wire [31:0]  o_ALU_src_A,
    output wire [31:0]  o_ALU_src_B,
    output wire [31:0]  o_AGU_src_addr,
        
    output wire         o_flg_equal,
    output wire [1:0]   o_flg_mem_size,
    output wire         o_flg_unsign,
    output wire [4:0]   o_rt,
    output wire [4:0]   o_rd,
    output wire [4:0]   o_rs,

    output wire         o_flg_reg_wr_en,
    output wire         o_flg_mem_wr_en,
    output wire         o_flg_wb_src,
    output wire [1:0]   o_flg_ALU_src_A,
    output wire         o_flg_ALU_src_B,
    output wire         o_flg_mem_op
);

Instruction_Decoder Inst_Deco(
    .i_instr(i_instruction),

    .o_funct(),
    .o_rs(),
    .o_rt(),
    .o_rd(),
    .o_sa(),
    .o_imm(),
    .o_addr_offset(),
    
    .o_flg_pc_modify(),
    .o_flg_link_ret(),
    .o_flg_addr_type(),
    .o_link_reg(),
    .o_addr_reg(),
    .o_flg_inmediate(),

    .o_flg_equal(),
    .o_flg_mem_op(),
    .o_flg_mem_type(),
    .o_flg_mem_size(),
    .o_flg_unsign()
);


Control_Unit Ctrl_Unit(
    .i_funct(Inst_Deco.o_funct),

    .i_flg_pc_modify(Inst_Deco.o_flg_pc_modify),
    .i_flg_link_ret(Inst_Deco.o_flg_link_ret),
    .i_flg_addr_type(Inst_Deco.o_flg_addr_type),
    .i_link_reg(Inst_Deco.o_link_reg),
    .i_addr_reg(Inst_Deco.o_addr_reg),
    .i_flg_inmediate(Inst_Deco.o_flg_inmediate),
    .i_flg_mem_op(Inst_Deco.o_flg_mem_op),
    .i_flg_mem_type(Inst_Deco.o_flg_mem_type),
    .i_hazard_detected(i_hazard_detected),

    .o_flg_ALU_src_a(),
    .o_flg_ALU_src_b(),
    .o_flg_ALU_dst(),
    .o_ALU_opcode(),

    .o_flg_AGU_src_addr(),
    .o_flg_AGU_opcode(),

    .o_flg_jump(),
    .o_flg_branch(),

    .o_flg_reg_wr_en(),
    .o_flg_mem_wr_en(),
    .o_flg_wb_src(),

    .o_extend_sign()
);



Registers Regs(
    .i_clk(i_clk),
    .i_rst(i_rst),

    .i_rs_sel(Inst_Deco.o_rs),
    .i_rt_sel(Inst_Deco.o_rt),
    .i_rd_sel(i_rd_sel),    //TODO Viene de otra etapa (WB signals)
    .i_wr_en(i_wr_en),      //TODO Viene de otra etapa (WB signals)
    .i_wr_data(i_wr_data),  //TODO Viene de otra etapa (WB signals)

    .o_rs_data(),
    .o_rt_data()
);

Sign_Extender Sign_Ext(
    .i_inmediate(Inst_Deco.o_imm),
    .i_mode(Ctrl_Unit.o_extend_sign),

    .o_result()
);


Mux_4 ALU_SRC_A(
    .i_sel(Ctrl_Unit.o_flg_ALU_src_a),
    .i_a(i_pc),                     // (00) PC+4 TODO: Verificar si es correcto
    .i_b(Regs.o_rt_data),           // (01) rt data
    .i_c(),                         // (10) NC
    .i_d(Sign_Ext.o_result),        // (11) Sign Extender result
    
    .o_result(o_ALU_src_A)
);

Mux_2 ALU_SRC_B(
    .i_sel(Ctrl_Unit.o_flg_ALU_src_b),
    .i_a(Regs.o_rs_data),          // (0) rs data
    .i_b(Inst_Deco.o_sa),               // (1) Sign Extender result

    .o_result()
);



Mux_2 AGU_SRC_ADDR(
    .i_sel(Ctrl_Unit.o_flg_AGU_src_addr),
    .i_a(Regs.o_rs_data),          // (0) rs data
    .i_b(i_pc),             // (1) PC

    .o_result()
);

assign o_rt = Inst_Deco.o_rt;
assign o_rd = Inst_Deco.o_rd;
assign o_rs = Inst_Deco.o_rs;

assign o_addr_offset = Inst_Deco.o_addr_offset;

assign o_flg_equal = Inst_Deco.o_flg_equal;
assign o_flg_mem_size = Inst_Deco.o_flg_mem_size;
assign o_flg_unsign = Inst_Deco.o_flg_unsign;

assign o_flg_ALU_dst    = Ctrl_Unit.o_flg_ALU_dst;
assign o_flg_ALU_opcode = Ctrl_Unit.o_ALU_opcode;

assign o_flg_AGU_opcode = Ctrl_Unit.o_flg_AGU_opcode;

assign o_flg_jump       = Ctrl_Unit.o_flg_jump;
assign o_flg_branch     = Ctrl_Unit.o_flg_branch;

assign o_ALU_src_A = ALU_SRC_A.o_result;
assign o_ALU_src_B = ALU_SRC_B.o_result;

assign o_AGU_src_addr = AGU_SRC_ADDR.o_result;

assign o_flg_reg_wr_en = Ctrl_Unit.o_flg_reg_wr_en;
assign o_flg_mem_wr_en = Ctrl_Unit.o_flg_mem_wr_en;
assign o_flg_wb_src = Ctrl_Unit.o_flg_wb_src;

assign o_flg_ALU_src_A = Ctrl_Unit.o_flg_ALU_src_a;
assign o_flg_ALU_src_B = Ctrl_Unit.o_flg_ALU_src_b;

assign o_flg_mem_op = Inst_Deco.o_flg_mem_op;

endmodule