`timescale 1ns / 1ps


module UART_TOP_TEST_RX #(
    parameter PAYLOAD_SIZE = 8
)(
    input wire clk_in1,
    input wire i_rst,
    input wire i_rx,
    output wire o_tx

);

wire i_clk;
clk_wiz_0 clk_50
(
    // Clock out ports
    .clk_out1(i_clk),     // output clk_out1
    // Status and control signals
    .reset(0), // input reset
    .locked(),       // output locked
    // Clock in ports
    .clk_in1(clk_in1)
);

wire tick;
UART_tick_gen u_UART_tick_gen (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .o_tick(tick)
);

wire tx;
wire data_sent;
wire data_received;
wire [PAYLOAD_SIZE-1:0] data;

UART_tx u_UART_tx (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_ready(data_received),
    .i_data(data),
    .o_tx(tx),
    .o_done(data_sent)
);

UART_rx u_UART_rx (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_rx(i_rx),
    .i_tick(tick),
    .o_ready(data_received),
    .o_data(data)
);


assign o_tx = tx;

endmodule
