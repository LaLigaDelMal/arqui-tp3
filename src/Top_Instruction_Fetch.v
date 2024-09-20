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
    input   wire [NBITS-1:0] i_inst_mem_data,

    // Outputs
    output  wire [NBITS-1:0] o_pc,    
    output  wire [NBITS-1:0] o_instr            // Fetched instruction
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
    .i_wr_en(i_inst_mem_wr_en),
    .i_addr(u_PC.o_pc),                   
    .i_data(i_inst_mem_data),                   
    .o_data()
);

assign o_pc = u_PC.o_pc;
assign o_instr = u_Instruction_Memory.o_data;

endmodule
