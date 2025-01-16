`timescale 1ns / 1ps

module Top_Instruction_Fetch #(
    parameter NBITS = 32
)(
    input   wire i_clk,
    input   wire i_rst,

    // PC Mux input
    input   wire i_pc_mux_ctrl,                // Select signal for PC Mux
    input   wire [NBITS-1:0] i_eff_addr,       // Jump PC
    
    // Instruction Memory
    input   wire i_inst_mem_wr_en,
    input   wire [NBITS-1:0] i_inst_mem_addr,
    input   wire [NBITS-1:0] i_inst_mem_data,

    // From TOP
    input   wire             i_hazard_detected,
    input   wire             i_step,

    // Outputs
    output  wire [NBITS-1:0] o_pc,    
    output  wire [NBITS-1:0] o_instr,            // Fetched instruction
    output  wire [NBITS-1:0] o_cycle_count
);


PC_Mux u_PC_Mux (
    .i_sel_jump(i_pc_mux_ctrl),                 // Select signal for PC Mux
    .i_next_pc(u_Adder.o_result),               // PC input 
    .i_jump_pc(i_eff_addr),                     // Jump PC input
    .o_pc()                                     // Mux output
);  

Program_Counter u_PC (
    .i_clk(i_clk),                              // Clock signal
    .i_rst(i_rst),                              // Reset signal
    .i_next_pc(u_PC_Mux.o_pc),                  // Next PC
    .i_hazard_detected(i_hazard_detected),      // Hazard detected signal
    .i_step(i_step),                        // Used for the step by step execution
    .o_pc()                                     // PC output
);

// Instantiate adder module
Adder u_Adder (
    .i_rst(i_rst),                              // Reset signal
    .i_operand_1(32'd4),                        // Input A
    .i_operand_2(u_PC.o_pc),                    // Input B
    .o_result()                                 // Output sum
);

// Instantiate Instruction Memory module
Instruction_Memory u_Instruction_Memory (
    .i_clk(i_clk),                              // Clock signal
    .i_rst(i_rst),                              // Reset signal
    .i_wr_en(i_inst_mem_wr_en),
    .i_addr(u_PC.o_pc),
    .i_addr_wr(i_inst_mem_addr),                   
    .i_data(i_inst_mem_data),                   
    .o_data()
);

// Cycle counter stadistics
Cycle_Counter u_Cycle_Counter (
    .i_clk(i_clk),                              // Clock signal
    .i_rst(i_rst),                              // Reset signal
    .i_step(i_step),                            // Step signal
    .o_count()                                  // Cycle counter output
);

assign o_pc = u_PC.o_pc;
assign o_instr = u_Instruction_Memory.o_data;
assign o_cycle_count = u_Cycle_Counter.o_count;

endmodule
