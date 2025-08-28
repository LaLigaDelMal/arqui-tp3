`timescale 1ns / 1ps

module Top_Instruction_Decode #(
    parameter NBITS = 32
)(
    input   wire i_clk,
    input   wire i_rst,
    input   wire i_hazard_detected,
    input   wire [4:0] i_dbg_reg_sel,
    input   wire        i_step,
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
    output wire [NBITS-1:0] o_dbg_reg_data,

    output wire         o_flg_reg_wr_en,
    output wire         o_flg_mem_wr_en,
    output wire         o_flg_wb_src,
    output wire [1:0]   o_flg_ALU_src_A,
    output wire         o_flg_ALU_src_B,
    output wire         o_flg_mem_op,

    output wire         o_flg_jmp_trg_reg,
    output wire         o_flg_halt
);

wire [5:0] funct;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [NBITS-1:0] sa;
wire [15:0] imm;
wire [25:0] addr_offset;
wire flg_pc_modify;
wire flg_link_ret;
wire [1:0] flg_addr_type;
wire flg_equal;   
wire flg_inmediate;
wire flg_mem_op;
wire flg_mem_type;
wire [1:0] flg_mem_size;
wire flg_unsign;
wire flg_halt;
Instruction_Decoder Inst_Deco(
    .i_instr(i_instruction),

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
    .o_flg_equal(flg_equal),

    .o_flg_inmediate(flg_inmediate),
    .o_flg_mem_op(flg_mem_op),
    .o_flg_mem_type(flg_mem_type),
    .o_flg_mem_size(flg_mem_size),
    .o_flg_unsign(flg_unsign),
    .o_flg_halt(flg_halt)
);

wire [1:0] flg_ALU_src_A;
wire flg_ALU_src_B;
wire [1:0] flg_ALU_dst;
wire [3:0] ALU_opcode;

wire flg_AGU_src_addr;
wire [2:0] flg_AGU_opcode;
wire flg_jump;
wire flg_branch;
wire flg_reg_wr_en;
wire flg_mem_wr_en;
wire flg_wb_src;
wire flg_jmp_trg_reg;
wire [1:0] extend_sign;
Control_Unit Ctrl_Unit(
    .i_funct(funct),

    .i_flg_pc_modify(flg_pc_modify),
    .i_flg_link_ret(flg_link_ret),
    .i_flg_addr_type(flg_addr_type),
    .i_flg_inmediate(flg_inmediate),
    .i_flg_mem_op(flg_mem_op),
    .i_flg_mem_type(flg_mem_type),
    .i_hazard_detected(i_hazard_detected),
    .i_flg_halt(flg_halt),

    .o_flg_ALU_src_a(flg_ALU_src_A),
    .o_flg_ALU_src_b(flg_ALU_src_B),
    .o_flg_ALU_dst(flg_ALU_dst),
    .o_ALU_opcode(ALU_opcode),

    .o_flg_AGU_src_addr(flg_AGU_src_addr),
    .o_flg_AGU_opcode(flg_AGU_opcode),

    .o_flg_jump(flg_jump),
    .o_flg_branch(flg_branch),

    .o_flg_reg_wr_en(flg_reg_wr_en),
    .o_flg_mem_wr_en(flg_mem_wr_en),
    .o_flg_wb_src(flg_wb_src),
    .o_flg_jmp_trg_reg(flg_jmp_trg_reg),

    .o_extend_sign(extend_sign)
);


wire [NBITS-1:0] rs_data;
wire [NBITS-1:0] rt_data;
wire [NBITS-1:0] dbg_reg_data;
Registers Regs(
    .i_clk(i_clk),
    .i_rst(i_rst),

    .i_rs_sel(rs),
    .i_rt_sel(rt),
    .i_rd_sel(i_rd_sel),    // Viene de otra etapa (WB signals)
    .i_wr_en(i_wr_en),      // Viene de otra etapa (WB signals)
    .i_wr_data(i_wr_data),  // Viene de otra etapa (WB signals)

    .i_dbg_reg_sel(i_dbg_reg_sel),
    .i_step(i_step),

    .o_rs_data(rs_data),
    .o_rt_data(rt_data),
    .o_dbg_reg_data(dbg_reg_data)
);

wire [NBITS-1:0] sign_ext_result;
Sign_Extender Sign_Ext(
    .i_inmediate(imm),
    .i_mode(extend_sign),

    .o_result(sign_ext_result)
);

wire [NBITS-1:0] adder_pc_8;
Adder PC_8(
    .i_rst(i_rst),
    .i_operand_1(i_pc),
    .i_operand_2(32'b1000),
    .o_result(adder_pc_8)
);

wire [NBITS-1:0] result_Mux_ALU_A;
Mux_4 ALU_SRC_A(
    .i_sel(flg_ALU_src_A),
    .i_a(adder_pc_8),            // (00) PC+8
    .i_b(rt_data),               // (01) rt data
    .i_c(32'b0),                 // (10) NC
    .i_d(sign_ext_result),       // (11) Sign Extender result
    
    .o_result(result_Mux_ALU_A)
);

wire [NBITS-1:0] result_Mux_ALU_B;
Mux_2 ALU_SRC_B(
    .i_sel(flg_ALU_src_B),
    .i_a(rs_data),               // (0) rs data
    .i_b(sa),               // (1) Sign Extender result
    .o_result(result_Mux_ALU_B)
);

wire [NBITS-1:0] result_AGU_ADDR;
Mux_2 AGU_SRC_ADDR(
    .i_sel(flg_AGU_src_addr),
    .i_a(rs_data),               // (0) rs data
    .i_b(adder_pc_8),                // (1) PC+8
    .o_result(result_AGU_ADDR)
);

assign o_rt = rt;
assign o_rd = rd;
assign o_rs = rs;
assign o_dbg_reg_data = dbg_reg_data;

assign o_addr_offset = addr_offset;

assign o_flg_equal = flg_equal;
assign o_flg_mem_size = flg_mem_size;
assign o_flg_unsign = flg_unsign;

assign o_flg_ALU_dst    = flg_ALU_dst;
assign o_flg_ALU_opcode = ALU_opcode;

assign o_flg_AGU_opcode = flg_AGU_opcode;

assign o_flg_jump       = flg_jump;
assign o_flg_branch     = flg_branch;

assign o_ALU_src_A = result_Mux_ALU_A;
assign o_ALU_src_B = result_Mux_ALU_B;

assign o_AGU_src_addr = result_AGU_ADDR;

assign o_flg_reg_wr_en = flg_reg_wr_en;
assign o_flg_mem_wr_en = flg_mem_wr_en;
assign o_flg_wb_src = flg_wb_src;

assign o_flg_ALU_src_A = flg_ALU_src_A;
assign o_flg_ALU_src_B = flg_ALU_src_B;

assign o_flg_mem_op = flg_mem_op;

assign o_flg_jmp_trg_reg = flg_jmp_trg_reg;
assign o_flg_halt = flg_halt;

endmodule
