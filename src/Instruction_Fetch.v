`timescale 1ns / 1ps

module Instruction_Fetch (
    parameter NBITS = 32,
)(
    input   wire i_clk,
    input   wire i_rst,

    // PC Mux input
    input   wire i_sel_jump,                   // Select signal for PC Mux
    input   wire [NBITS-1:0] i_jump_pc,        // Jump PC
    
    output  wire [NBITS-1:0] o_pc,    
    output  wire [NBITS:0] o_instr,           // Fetched instruction
    
    // Instruction Memory
    input   wire i_inst_mem_wr_en,
    input   wire [NBITS-1:0] i_inst_mem_data,
);

wire [NBITS-1:0] next_pc;
wire [NBITS-1:0] mux_2_pc;

pc_mux PC_MUX (
    .i_clk(i_clk),                      // Clock signal
    .i_rst(i_rst),                      // Reset signal
    .i_sel_jump(i_sel_jump),            // Select signal for PC Mux
    .i_next_pc(next_pc),                // PC input 
    .o_pc(mux_2_pc)                     // Mux output
);

wire [NBITS-1:0] pc;
program_counter PC (
    .i_clk(i_clk),                      // Clock signal
    .i_rst(i_rst),                      // Reset signal
    .i_next_pc(mux_2_pc),               // Next PC
    .o_pc(o_pc)                         // PC output
);

// Instantiate adder module
adder Adder_4 (
    .i_operand_1(4'd0),               // Input A
    .i_operand_2(o_pc),               // Input B
    .o_result(next_pc)              // Output sum
);

// Instantiate Instruction Memory module
Instruction_memory IM (
    .i_clk(i_clk),                      // Clock signal
    .i_rst(i_rst),                      // Reset signal
    .i_wr_en(i_inst_mem_wr_en),
    .i_addr(o_pc),                   
    .i_data(i_inst_mem_data),                   
    .o_data(o_instr)
);


endmodule
