`timescale 1ns / 1ps

module Top_Instruction_Fetch #(
    parameter NBITS = 32
)(
    input   wire i_clk,
    input   wire i_rst,

    // PC Mux input
    input   wire                i_pc_mux_ctrl,                // Select signal for PC Mux
    input   wire [NBITS-1:0]    i_eff_addr,       // Jump PC
    
    // Instruction Memory
    input   wire                i_inst_mem_wr_en,
    input   wire [NBITS-1:0]    i_inst_mem_addr,
    input   wire [NBITS-1:0]    i_inst_mem_data,

    // From TOP
    input   wire                i_hazard_detected,
    input   wire                i_step,

    // Outputs
    output  wire [NBITS-1:0] o_pc,    
    output  wire [NBITS-1:0] o_instr,            // Fetched instruction
    output  wire [NBITS-1:0] o_cycle_count,
    output  wire [NBITS-1:0] o_dbg_data
);

wire [NBITS-1:0] pc_mux;
wire [NBITS-1:0] pc_mux_next;
PC_Mux u_PC_Mux (
    .i_sel_jump(i_pc_mux_ctrl),                 // Select signal for PC Mux
    .i_next_pc(pc_mux_next),               // PC input 
    .i_jump_pc(i_eff_addr),                     // Jump PC input
    .o_pc(pc_mux)                                     // Mux output
);  

wire [NBITS-1:0] pc;
Program_Counter u_PC (
    .i_clk(i_clk),                              // Clock signal
    .i_rst(i_rst),                              // Reset signal
    .i_next_pc(pc_mux),                  // Next PC
    .i_hazard_detected(i_hazard_detected),      // Hazard detected signal
    .i_step(i_step),                        // Used for the step by step execution
    .o_pc(pc)                                     // PC output
);

// Instantiate adder module
Adder u_Adder (
    .i_rst(i_rst),                              // Reset signal
    .i_operand_1(32'd4),                        // Input A
    .i_operand_2(pc),                    // Input B
    .o_result(pc_mux_next)                                 // Output sum
);

wire [NBITS-1:0] data;
// Instantiate Instruction Memory module
Instruction_Memory u_Instruction_Memory (
    .i_clk(i_clk),                              // Clock signal
    .i_rst(i_rst),                              // Reset signal
    .i_step(i_step),                            // Step signal
    .i_dbg_wr_en(i_inst_mem_wr_en),
    .i_addr(pc),
    .i_dbg_addr(i_inst_mem_addr),
    .i_dbg_inst(i_inst_mem_data),
    .o_data(data),
    .o_dbg_data(dbg_data)
);

wire [NBITS-1:0] count;
// Cycle counter stadistics
Cycle_Counter u_Cycle_Counter (
    .i_clk(i_clk),                              // Clock signal
    .i_rst(i_rst),                              // Reset signal
    .i_step(i_step),                            // Step signal
    .o_count(count)                                  // Cycle counter output
);

assign o_pc = pc;
assign o_instr = data;
assign o_cycle_count = count;
assign o_dbg_data = dbg_data;

endmodule
