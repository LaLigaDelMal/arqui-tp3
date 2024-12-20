`timescale 1ns / 1ps


module Debug_Unit #(
    parameter   NBITS = 32,
    parameter   REGS_ADDR = 5
)(
    input  wire                  i_clk,             // Clock signal
    input  wire  [NBITS-1:0]     i_pc,              // Program counter
    input  wire  [REGS_ADDR-1:0] i_reg_sel,         // Special addresing bus for registers (only for debug unit).
    input  wire  [NBITS-1:0]     i_data_mem_addr,   // Address of the data memory.
    output wire  [NBITS-1:0]     o_reg_data,        // Data output from the register file.
    output wire  [NBITS-1:0]     o_data_mem,        // Data output from the data memory.
    output wire                  o_inst_mem_wr,     // Write enable for the instruction memory.
    output wire  [NBITS-1:0]     o_inst_mem_addr,   // Address for the instruction memory.
    output wire  [NBITS-1:0]     o_inst_mem_data,   // Data for the instruction memory.
    output wire                  o_reset,           // Restore every state of the processor before runing a new program. (This goes to every reset in the design).
    output wire                  o_enable           // At high by default (should be initialized to 1). It is used to allow the clock to run.
    );
endmodule
