`timescale 1ns / 1ps

module Top_Writeback#(
    parameter   NBITS = 32
)(
    input wire                i_neg_flg_mem_op,
    input wire   [NBITS-1:0]  i_ALU_rslt,
    input wire   [NBITS-1:0]  i_data,
    input wire   [1:0]        i_flg_ALU_dst,
    input wire   [4:0]        i_rd, i_rt,

    output wire  [NBITS-1:0]  o_wr_data,
    output wire  [4:0]        o_reg_sel
);

    Mux_2 #(
        .NBITS(NBITS)
    ) u_Mux_2 (
        .i_sel(i_neg_flg_mem_op),
        .i_a(i_data),
        .i_b(i_ALU_rslt),
        .o_result(o_wr_data)
    );

    Mux_4 #(
        .NBITS(NBITS)
    ) u_Mux_4 (
        .i_sel(i_flg_ALU_dst),
        .i_a(i_rt),
        .i_b(i_rd),
        .i_c(5'b0),
        .i_d(5'd31),
        .o_result(o_reg_sel)
    );

endmodule