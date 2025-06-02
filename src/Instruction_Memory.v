`timescale 1ns / 1ps

module Instruction_Memory #(
    parameter NBITS = 8,
    parameter INST_BITS = 32,
    parameter CELLS = 256
)(
    input   wire    i_clk,
    input   wire    i_rst,
    input   wire    i_step,
    input   wire    [INST_BITS-1:0]     i_addr,
    input   wire    [INST_BITS-1:0]     i_dbg_addr,
    input   wire    [INST_BITS-1:0]     i_dbg_inst,
    input   wire                        i_dbg_wr_en,
    output  reg     [INST_BITS-1:0]     o_data,
    output  reg     [INST_BITS-1:0]     o_dbg_data
);

reg [NBITS-1:0] memory[CELLS-1:0];
integer i;

always @ (negedge i_clk) begin
    if (i_rst) begin
        o_data <= 0;
    end else if (i_step) begin
        o_data <= {memory[i_addr], memory[i_addr + 1], memory[i_addr + 2], memory[i_addr + 3]};
    end
end

always @ (posedge i_dbg_wr_en) begin
    {memory[i_dbg_addr], memory[i_dbg_addr + 1], memory[i_dbg_addr + 2], memory[i_dbg_addr + 3]} <= i_dbg_inst[31:0];
end

always @ (*) begin
    o_dbg_data = {memory[i_dbg_addr], memory[i_dbg_addr + 1], memory[i_dbg_addr + 2], memory[i_dbg_addr + 3]};
end

endmodule
