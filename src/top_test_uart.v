`timescale 1ns / 1ps


module UART_TOP_TEST #(
    parameter PAYLOAD_SIZE = 8
)(
    input wire clk_in1,
    input wire i_rx,
    output wire o_tx

);

wire clk_out1;
clk_wiz_0 clk_50
(
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
    // Status and control signals
    .reset(0), // input reset
    .locked(),       // output locked
    // Clock in ports
    .clk_in1(clk_in1)
);

wire tx;

UART_tx u_UART_tx (
    .i_clk(clk_out1),
    .i_rst(0),
    .i_ready(1),
    .i_data(8'b01010101),
    .o_tx(tx),
    .o_done()
);

assign o_tx = tx;

endmodule
