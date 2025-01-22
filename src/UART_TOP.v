`timescale 1ns / 1ps


module UART_TOP #(
    parameter PAYLOAD_SIZE = 8
)(
    input wire i_clk,
    input wire i_rst,
    input wire i_rx,
    input wire [PAYLOAD_SIZE-1:0] i_data,
    input wire i_send_data,
    output wire [PAYLOAD_SIZE-1:0] o_data,
    output wire o_tx,
    output wire o_flg_data_recieved,
    output wire o_flg_data_sent

);

    UART_tick_gen u_UART_tick_gen (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_tick()
    );

    UART_tx u_UART_tx (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_ready(i_send_data),
        .i_data(i_data),
        .o_tx(o_tx),
        .o_done(o_flg_data_sent)
    );

    UART_rx u_UART_rx (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rx(i_rx),
        //.i_tick(u_UART_tick_gen.o_tick),
        .i_tick(i_clk),
        .o_ready(o_flg_data_recieved),
        .o_data(o_data)
    );


endmodule
