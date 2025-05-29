`timescale 1ns / 1ps


module UART_TOP_TEST_RX #(
    parameter PAYLOAD_SIZE = 8
)(
    input wire i_clk,
    input wire i_rx,
    output wire o_tx,
    output wire o_test_tick,
    output wire o_test_clk

);

wire tick;
UART_tick_gen u_UART_tick_gen (
    .i_clk(i_clk),
    .i_rst(i_rst_rx),
    .o_tick(tick)
);

wire tx;
wire data_sent;
wire data_received;
wire [PAYLOAD_SIZE-1:0] data;

UART_tx u_UART_tx (
    .i_clk(i_clk),
    .i_rst(i_rst_tx),
    .i_ready(data_received),
    .i_data(data),
    .o_tx(tx),
    .o_done(data_sent)
);

UART_rx u_UART_rx (
    .i_clk(i_clk),
    .i_rst(0),
    .i_rx(i_rx),
    .i_tick(tick),
    .o_ready(data_received),
    .o_data(data)
);


assign o_tx = tx;
assign o_test_tick = tick;
assign o_test_clk = i_clk;

endmodule
