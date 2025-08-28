`timescale 1ns / 1ps

module TOP_TOP #(
    parameter   NBITS = 32
)(
    input wire clk_in1,
    input wire i_rst,
    input wire  i_rx,
    output wire o_tx,
    output wire [3:0] o_state
);

wire i_clk;
clk_wiz_0 clk_50
(
    // Clock out ports
    .clk_out1(i_clk),     // output clk_out1
    // Status and control signals
    .reset(0), // input reset
    .locked(),       // output locked
    // Clock in ports
    .clk_in1(clk_in1)
);

wire [NBITS-1:0]  IF_pc;
wire [NBITS-1:0]  IF_instr;
wire [NBITS-1:0]  IF_cycle_count;
wire HU_hazard_detected;
wire  [NBITS-1:0]  EX_eff_addr;
wire               EX_pc_mux_ctrl;
wire [NBITS-1:0]  IF_dbg_data;

wire DU_mips_step;
wire DU_mips_rst;
wire [4:0] DU_mips_reg_sel;
wire [NBITS-1:0] DU_mips_mem_addr;
wire [NBITS-1:0] DU_mips_instr_addr;
wire [NBITS-1:0] DU_mips_instr_data;
wire DU_mips_instr_write;

Top_Instruction_Fetch IF (
    .i_clk(i_clk),
    .i_rst(DU_mips_rst),
    .i_pc_mux_ctrl(EX_pc_mux_ctrl),           // Viene de WB
    .i_eff_addr(EX_eff_addr),                 // Viene de MA
    .i_inst_mem_wr_en(DU_mips_instr_write),   // Viene de DEBUG
    .i_inst_mem_addr(DU_mips_instr_addr),     // Viene de DEBUG
    .i_inst_mem_data(DU_mips_instr_data),     // Viene de DEBUG
    .i_hazard_detected(HU_hazard_detected),
    .i_step(DU_mips_step),                    // Viene de DEBUG
    .o_pc(IF_pc),
    .o_instr(IF_instr),                                 // Fetched instruction
    .o_cycle_count(IF_cycle_count),
    .o_dbg_data(IF_dbg_data)
);

wire [NBITS-1:0]  IF_ID_pc;
wire [NBITS-1:0]  IF_ID_instruction;
Reg_IF_ID IF_ID (
    .i_clk(i_clk),
    .i_rst(DU_mips_rst),
    .i_pc(IF_pc),
    .i_instruction(IF_instr),
    .i_hazard_detected(HU_hazard_detected),
    .i_step(DU_mips_step),
    .o_pc(IF_ID_pc),    
    .o_instruction(IF_ID_instruction)          // Fetched instruction
);

wire [1:0] ID_flg_ALU_dst;
wire [3:0] ID_flg_ALU_opcode;
wire [2:0] ID_flg_AGU_opcode;
wire [25:0] ID_addr_offset;
wire ID_flg_jump;
wire ID_flg_branch;
wire [NBITS-1:0] ID_ALU_src_A;
wire [NBITS-1:0] ID_ALU_src_B;
wire [NBITS-1:0] ID_AGU_src_addr;
wire ID_flg_equal;
wire [1:0] ID_flg_mem_size;
wire ID_flg_unsign;
wire [4:0] ID_rt;
wire [4:0] ID_rd;
wire [4:0] ID_rs;
wire [NBITS-1:0] ID_dbg_reg_data;
wire ID_flg_reg_wr_en;
wire ID_flg_mem_wr_en;
wire ID_flg_wb_src;
wire [1:0] ID_flg_ALU_src_A;
wire ID_flg_ALU_src_B;
wire ID_flg_mem_op;
wire ID_flg_jmp_trg_reg;
wire ID_flg_halt;

wire [NBITS-1:0] WB_wr_data;
wire [4:0] WB_reg_sel;
wire MA_WB_flg_reg_wr_en;
Top_Instruction_Decode ID (
    .i_clk(i_clk),
    .i_rst(DU_mips_rst),
    .i_hazard_detected(HU_hazard_detected),
    .i_dbg_reg_sel(DU_mips_reg_sel),        //Viene de DEBUG
    .i_step(DU_mips_step),                  //Viene de DEBUG
    .i_rd_sel(WB_reg_sel),                    //Viene de WB
    .i_wr_en(MA_WB_flg_reg_wr_en),            //Viene de MA_WB
    .i_wr_data(WB_wr_data),                   //Viene de WB
    .i_pc(IF_ID_pc),
    .i_instruction(IF_ID_instruction),
    .o_flg_ALU_dst(ID_flg_ALU_dst),
    .o_flg_ALU_opcode(ID_flg_ALU_opcode),
    .o_flg_AGU_opcode(ID_flg_AGU_opcode),
    .o_addr_offset(ID_addr_offset),
    .o_flg_jump(ID_flg_jump),
    .o_flg_branch(ID_flg_branch),
    .o_ALU_src_A(ID_ALU_src_A),
    .o_ALU_src_B(ID_ALU_src_B),
    .o_AGU_src_addr(ID_AGU_src_addr),
    .o_flg_equal(ID_flg_equal),
    .o_flg_mem_size(ID_flg_mem_size),
    .o_flg_unsign(ID_flg_unsign),
    .o_rt(ID_rt),
    .o_rd(ID_rd),
    .o_rs(ID_rs),
    .o_dbg_reg_data(ID_dbg_reg_data),
    .o_flg_reg_wr_en(ID_flg_reg_wr_en),
    .o_flg_mem_wr_en(ID_flg_mem_wr_en),
    .o_flg_wb_src(ID_flg_wb_src),
    .o_flg_ALU_src_A(ID_flg_ALU_src_A),
    .o_flg_ALU_src_B(ID_flg_ALU_src_B),
    .o_flg_mem_op(ID_flg_mem_op),
    .o_flg_jmp_trg_reg(ID_flg_jmp_trg_reg),
    .o_flg_halt(ID_flg_halt)
);

wire [NBITS-1:0] ID_EX_pc;
wire [4:0] ID_EX_rd;
wire [4:0] ID_EX_rt;
wire [4:0] ID_EX_rs;
wire [25:0] ID_EX_addr_offset;
wire ID_EX_flg_equal;
wire [1:0] ID_EX_flg_mem_size;
wire ID_EX_flg_unsign;
wire [1:0] ID_EX_ALU_dst;
wire [3:0] ID_EX_ALU_opcode;
wire [2:0] ID_EX_AGU_opcode;
wire ID_EX_flg_branch;
wire ID_EX_flg_jump;
wire [NBITS-1:0] ID_EX_ALU_src_A;
wire [NBITS-1:0] ID_EX_ALU_src_B;
wire [NBITS-1:0] ID_EX_AGU_src_addr;
wire ID_EX_flg_reg_wr_en;
wire ID_EX_flg_mem_wr_en;
wire ID_EX_flg_wb_src;
wire [1:0] ID_EX_flg_ALU_src_A;
wire ID_EX_flg_ALU_src_B;
wire ID_EX_flg_mem_op;
wire ID_EX_flg_halt;

Reg_ID_EX ID_EX (
    .i_clk(i_clk),
    .i_rst(DU_mips_rst),
    .i_step(DU_mips_step),
    .i_pc(IF_ID_pc),
    .i_rd(ID_rd),
    .i_rt(ID_rt),
    .i_rs(ID_rs),
    .i_addr_offset(ID_addr_offset),
    .i_flg_equal(ID_flg_equal),
    .i_flg_mem_size(ID_flg_mem_size),
    .i_flg_unsign(ID_flg_unsign),
    .i_ALU_dst(ID_flg_ALU_dst),
    .i_ALU_opcode(ID_flg_ALU_opcode),
    .i_AGU_opcode(ID_flg_AGU_opcode),
    .i_flg_branch(ID_flg_branch),
    .i_flg_jump(ID_flg_jump),
    .i_ALU_src_A(ID_ALU_src_A),
    .i_ALU_src_B(ID_ALU_src_B),
    .i_AGU_src_addr(ID_AGU_src_addr),
    .i_flg_reg_wr_en(ID_flg_reg_wr_en),
    .i_flg_mem_wr_en(ID_flg_mem_wr_en),
    .i_flg_wb_src(ID_flg_wb_src),
    .i_flg_ALU_src_A(ID_flg_ALU_src_A),
    .i_flg_ALU_src_B(ID_flg_ALU_src_B),
    .i_flg_mem_op(ID_flg_mem_op),
    .i_flg_halt(ID_flg_halt),
    .o_pc(ID_EX_pc),
    .o_rd(ID_EX_rd),
    .o_rt(ID_EX_rt),
    .o_rs(ID_EX_rs),
    .o_addr_offset(ID_EX_addr_offset),
    .o_flg_equal(ID_EX_flg_equal),
    .o_flg_mem_size(ID_EX_flg_mem_size),
    .o_flg_unsign(ID_EX_flg_unsign),
    .o_ALU_dst(ID_EX_ALU_dst),
    .o_ALU_opcode(ID_EX_ALU_opcode),
    .o_AGU_opcode(ID_EX_AGU_opcode),
    .o_flg_branch(ID_EX_flg_branch),
    .o_flg_jump(ID_EX_flg_jump),
    .o_ALU_src_A(ID_EX_ALU_src_A),
    .o_ALU_src_B(ID_EX_ALU_src_B),
    .o_AGU_src_addr(ID_EX_AGU_src_addr),
    .o_flg_reg_wr_en(ID_EX_flg_reg_wr_en),
    .o_flg_mem_wr_en(ID_EX_flg_mem_wr_en),
    .o_flg_wb_src(ID_EX_flg_wb_src),
    .o_flg_ALU_src_A(ID_EX_flg_ALU_src_A),
    .o_flg_ALU_src_B(ID_EX_flg_ALU_src_B),
    .o_flg_mem_op(ID_EX_flg_mem_op),
    .o_flg_halt(ID_EX_flg_halt)
);

wire [1:0] FU_ALU_src_a_ctrl;
wire [1:0] FU_ALU_src_b_ctrl;

wire [4:0] EX_MA_rd;
wire [4:0] EX_MA_rt;
wire EX_MA_flg_reg_wr_en;

wire [4:0] MA_WB_rd;
wire [4:0] MA_WB_rt;
wire [1:0] MA_WB_flg_ALU_dst;
wire [1:0] EX_MA_flg_ALU_dst;

Forwarding_Unit FU (
    .i_rt_EX(ID_EX_rt),
    .i_rs_EX(ID_EX_rs),
    .i_flg_ALU_src_A(ID_EX_flg_ALU_src_A),
    .i_flg_ALU_src_B(ID_EX_flg_ALU_src_B),
    .i_rt_MEM(EX_MA_rt),
    .i_rd_MEM(EX_MA_rd),
    .i_flg_reg_wr_en_MEM(EX_MA_flg_reg_wr_en),
    .i_flg_ALU_dst_MEM(EX_MA_flg_ALU_dst),
    .i_flg_reg_wr_en_WB(MA_WB_flg_reg_wr_en),
    .i_rt_WB(MA_WB_rt),
    .i_rd_WB(MA_WB_rd),
    .i_flg_ALU_dst_WB(MA_WB_flg_ALU_dst),
    .o_ALU_src_a_ctrl(FU_ALU_src_a_ctrl),
    .o_ALU_src_b_ctrl(FU_ALU_src_b_ctrl)
);


Hazard_Unit HU (
    .i_rd_EX(ID_EX_rd),
    .i_rt_EX(ID_EX_rt),
    .i_rd_MA(EX_MA_rd),
    .i_rt_MA(EX_MA_rt),
    .i_rd_WB(MA_WB_rd),
    .i_rt_WB(MA_WB_rt),
    .i_reg_wr_EX(ID_EX_flg_reg_wr_en),
    .i_reg_wr_MA(EX_MA_flg_reg_wr_en),
    .i_reg_wr_WB(MA_WB_flg_reg_wr_en),
    .i_flg_WB_src_EX(ID_EX_flg_wb_src),
    .i_flg_mem_op_EX(ID_EX_flg_mem_op),
    .i_rs_ID(ID_rs),
    .i_rt_ID(ID_rt),
    .i_flg_jmp_trg_reg(ID_flg_jmp_trg_reg),
    .i_flg_halt(ID_flg_halt),
    .o_hazard_detected(HU_hazard_detected)
);

wire  [NBITS-1:0]  EX_ALU_rslt;
wire EX_MA_pc_mux_ctrl;
wire [NBITS-1:0] EX_MA_ALU_rslt;
wire [NBITS-1:0] EX_MA_eff_addr;
wire [1:0] EX_MA_flg_mem_size;
wire EX_MA_flg_unsign;
wire EX_MA_flg_mem_wr_en;
wire EX_MA_flg_wb_src;
wire EX_MA_flg_halt;

Top_Execute EX (
    .i_addr_offset(ID_EX_addr_offset),
    .i_flg_equal(ID_EX_flg_equal),
    .i_ALU_opcode(ID_EX_ALU_opcode),
    .i_AGU_opcode(ID_EX_AGU_opcode),
    .i_flg_branch(ID_EX_flg_branch),
    .i_flg_jump(ID_EX_flg_jump),
    .i_ALU_src_A(ID_EX_ALU_src_A),
    .i_ALU_src_B(ID_EX_ALU_src_B),
    .i_AGU_src_addr(ID_EX_AGU_src_addr),
    .i_ALU_rslt_MEM(EX_MA_ALU_rslt),
    .i_WB_wr_data(WB_wr_data),
    .i_ALU_src_A_ctrl(FU_ALU_src_a_ctrl),
    .i_ALU_src_B_ctrl(FU_ALU_src_b_ctrl),
    .o_pc_mux_ctrl(EX_pc_mux_ctrl),
    .o_ALU_rslt(EX_ALU_rslt),
    .o_eff_addr(EX_eff_addr)
);

Reg_EX_MA EX_MA (
    .i_clk(i_clk),
    .i_rst(DU_mips_rst),
    .i_step(DU_mips_step),
    .i_pc_mux_ctrl(EX_pc_mux_ctrl),
    .i_ALU_rslt(EX_ALU_rslt),
    .i_eff_addr(EX_eff_addr),
    .i_flg_mem_size(ID_EX_flg_mem_size),
    .i_flg_unsign(ID_EX_flg_unsign),
    .i_rd(ID_EX_rd),
    .i_rt(ID_EX_rt),
    .i_flg_ALU_dst(ID_EX_ALU_dst),
    .i_flg_reg_wr_en(ID_EX_flg_reg_wr_en),
    .i_flg_mem_wr_en(ID_EX_flg_mem_wr_en),
    .i_flg_wb_src(ID_EX_flg_wb_src),
    .i_flg_halt(ID_EX_flg_halt),
    
    .o_pc_mux_ctrl(EX_MA_pc_mux_ctrl),
    .o_ALU_rslt(EX_MA_ALU_rslt),
    .o_eff_addr(EX_MA_eff_addr),
    .o_flg_mem_size(EX_MA_flg_mem_size),
    .o_flg_unsign(EX_MA_flg_unsign),
    .o_rd(EX_MA_rd),
    .o_rt(EX_MA_rt),
    .o_flg_ALU_dst(EX_MA_flg_ALU_dst),
    .o_flg_reg_wr_en(EX_MA_flg_reg_wr_en),
    .o_flg_mem_wr_en(EX_MA_flg_mem_wr_en),
    .o_flg_wb_src(EX_MA_flg_wb_src),
    .o_flg_halt(EX_MA_flg_halt)
);

wire [NBITS-1:0] MA_data;
wire [NBITS-1:0] MA_dbg_data;
Top_Memory_Access MA (
    .i_clk(i_clk),
    .i_rst(DU_mips_rst),
    .i_step(DU_mips_step),
    .i_ALU_rslt(EX_MA_ALU_rslt),
    .i_flg_unsign(EX_MA_flg_unsign),
    .i_flg_mem_size(EX_MA_flg_mem_size),
    .i_flg_mem_wr_en(EX_MA_flg_mem_wr_en),
    .i_eff_addr(EX_MA_eff_addr),
    .i_dbg_addr(DU_mips_mem_addr),
    .o_data(MA_data),
    .o_dbg_data(MA_dbg_data)
);


wire [NBITS-1:0] MA_WB_ALU_rslt;
wire [NBITS-1:0] MA_WB_data;
wire MA_WB_flg_wb_src;
wire MA_WB_flg_halt;
Reg_MA_WB MA_WB (
    .i_clk(i_clk),
    .i_rst(DU_mips_rst),
    .i_step(DU_mips_step),
    .i_flg_ALU_dst(EX_MA_flg_ALU_dst),
    .i_ALU_rslt(EX_MA_ALU_rslt),
    .i_data(MA_data),
    .i_rd(EX_MA_rd),
    .i_rt(EX_MA_rt),
    .i_flg_reg_wr_en(EX_MA_flg_reg_wr_en),
    .i_flg_wb_src(EX_MA_flg_wb_src),
    .i_flg_halt(EX_MA_flg_halt),
    .o_flg_ALU_dst(MA_WB_flg_ALU_dst),
    .o_ALU_rslt(MA_WB_ALU_rslt),
    .o_data(MA_WB_data),
    .o_rd(MA_WB_rd),
    .o_rt(MA_WB_rt),
    .o_flg_reg_wr_en(MA_WB_flg_reg_wr_en),
    .o_flg_wb_src(MA_WB_flg_wb_src),
    .o_flg_halt(MA_WB_flg_halt)
);

Top_Writeback WB (
    .i_ALU_rslt(MA_WB_ALU_rslt),
    .i_data(MA_WB_data),
    .i_flg_ALU_dst(MA_WB_flg_ALU_dst),
    .i_rd(MA_WB_rd),
    .i_rt(MA_WB_rt),
    .i_flg_wb_src(MA_WB_flg_wb_src),
    .o_wr_data(WB_wr_data),
    .o_reg_sel(WB_reg_sel)
);


wire [7:0] UART_data;
wire UART_flg_data_recieved;
wire UART_flg_data_sent;

wire DU_uart_rx_rst;
wire DU_uart_tx_rst;
wire [7:0] DU_uart_data;
wire DU_uart_send_data;
UART_TOP UART (
    .i_clk(i_clk),
    .i_rst_rx(DU_uart_rx_rst),
    .i_rst_tx(DU_uart_tx_rst),
    .i_rx(i_rx),
    .i_data(DU_uart_data),
    .i_send_data(DU_uart_send_data),
    .o_data(UART_data),
    .o_tx(o_tx),
    .o_flg_data_recieved(UART_flg_data_recieved),
    .o_flg_data_sent(UART_flg_data_sent)
);

Debug_Unit DU (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_uart_data_received(UART_flg_data_recieved),
    .i_uart_data(UART_data),
    .i_uart_data_sent(UART_flg_data_sent),

    .i_mips_halt(MA_WB_flg_halt),
    .i_mips_pc(IF_pc),
    .i_mips_clk_count(IF_cycle_count),
    .i_mips_reg_data(ID_dbg_reg_data),
    .i_mips_mem_data(MA_dbg_data),
    .i_mips_mem_instr(IF_dbg_data),

    .o_uart_rx_rst(DU_uart_rx_rst),
    .o_uart_tx_rst(DU_uart_tx_rst),
    .o_uart_data(DU_uart_data),
    .o_uart_send_data(DU_uart_send_data),
    .o_mips_step(DU_mips_step),
    .o_mips_rst(DU_mips_rst),
    .o_mips_reg_sel(DU_mips_reg_sel),
    .o_mips_mem_addr(DU_mips_mem_addr),
    .o_mips_instr_addr(DU_mips_instr_addr),
    .o_mips_instr_data(DU_mips_instr_data),
    .o_mips_instr_write(DU_mips_instr_write),
    .o_state(o_state)
);


endmodule