`timescale 1ns / 1ps

module Top_Memory_Access#(
    parameter   NBITS = 32
)(
    input wire                i_clk,
    input wire                i_rst,
    input wire                i_step,
    input wire   [NBITS-1:0]  i_ALU_rslt,
    input wire                i_flg_unsign,
    input wire   [1:0]        i_flg_mem_size,
    input wire                i_flg_mem_wr_en,
    input wire   [NBITS-1:0]  i_eff_addr,
    input wire   [NBITS-1:0]  i_dbg_addr,

    output wire  [NBITS-1:0]  o_data
    output wire  [NBITS-1:0]  o_dbg_data
);

    Data_Memory u_Data_Memory (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_step(i_step),
        .i_write_en(i_flg_mem_wr_en),
        .i_size(i_flg_mem_size),
        .i_unsigned(i_flg_unsign),
        .i_addr(i_eff_addr),
        .i_data(i_ALU_rslt),
        .i_dbg_addr(i_dbg_addr),
        .o_data(o_data),
        .o_dbg_data(o_dbg_data)
    );

endmodule