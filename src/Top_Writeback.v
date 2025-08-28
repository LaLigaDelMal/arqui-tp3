`timescale 1ns / 1ps

module Top_Writeback#(
    parameter   NBITS = 32
)(
    input wire   [NBITS-1:0]  i_ALU_rslt,
    input wire   [NBITS-1:0]  i_data,
    input wire   [1:0]        i_flg_ALU_dst,
    input wire   [4:0]        i_rd, i_rt,
    input wire                i_flg_wb_src,

    output wire  [NBITS-1:0]  o_wr_data,
    output wire  [4:0]        o_reg_sel
);

wire [NBITS-1:0] wr_data;
Mux_2 #(
    .NBITS(NBITS)
) u_Mux_2 (
    .i_sel(i_flg_wb_src),
    .i_a(i_data),
    .i_b(i_ALU_rslt),
    .o_result(wr_data)
);

wire [4:0] reg_sel;
Mux_4 #(
    .NBITS(5)
) u_Mux_4 (
    .i_sel(i_flg_ALU_dst),
    .i_a(i_rt),
    .i_b(i_rd),
    .i_c(5'b0),
    .i_d(5'd31),
    .o_result(reg_sel)
);

assign o_wr_data = wr_data;
assign o_reg_sel = reg_sel;

endmodule