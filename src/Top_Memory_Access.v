`timescale 1ns / 1ps

module Top_Memory_Access#(
    parameter   NBITS = 32
)(
    input wire                i_clk,
    input wire                i_rst,
    input wire   [NBITS-1:0]  i_ALU_rslt,
    input wire                i_flg_unsign,
    input wire   [1:0]        i_flg_mem_size,
    input wire                i_flg_mem_type,
    input wire   [NBITS-1:0]  i_eff_addr,

    output wire  [NBITS-1:0]  o_data
);

    Data_Memory u_Data_Memory (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_write_en(i_flg_mem_type),
        .i_size(i_flg_mem_size),
        .i_unsigned(i_flg_unsign),
        .i_addr(i_eff_addr),
        .i_data_in(i_ALU_rslt),
        .o_data_out(o_data)
    );

endmodule