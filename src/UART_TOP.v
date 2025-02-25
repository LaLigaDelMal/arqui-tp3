`timescale 1ns / 1ps


module UART_TOP #(
    parameter PAYLOAD_SIZE = 8
)(
    input wire i_clk,
    input wire i_rst_rx,
    input wire i_rst_tx,
    input wire i_rx,
    input wire [PAYLOAD_SIZE-1:0] i_data,
    input wire i_send_data,
    output wire [PAYLOAD_SIZE-1:0] o_data,
    output wire o_tx,
    output wire o_flg_data_recieved,
    output wire o_flg_data_sent

);

wire tick;
UART_tick_gen u_UART_tick_gen (
    .i_clk(i_clk),
    .i_rst(i_rst_rx),
    .o_tick(tick)
);

wire tx;
wire data_sent;
UART_tx u_UART_tx (
    .i_clk(i_clk),
    .i_rst(i_rst_tx),
    .i_ready(i_send_data),
    .i_data(i_data),
    .o_tx(tx),
    .o_done(data_sent)
);

wire data_received;
wire [PAYLOAD_SIZE-1:0] data;
UART_rx u_UART_rx (
    .i_clk(i_clk),
    .i_rst(i_rst_rx),
    .i_rx(i_rx),
    .i_tick(tick),
    .o_ready(data_received),
    .o_data(data)
);

assign o_tx = tx;
assign o_flg_data_sent = data_sent;
assign o_data = data;
assign o_flg_data_recieved = data_received;

endmodule
