`timescale 1ns / 1ps


module UART_TOP #(
    parameter PAYLOAD_SIZE = 8
)(
    input wire i_clk,
    input wire i_rx,
    output wire o_tx

);

wire tx;

UART_tx u_UART_tx (
    .i_clk(i_clk),
    .i_rst(0),
    .i_ready(1),
    .i_data(8'b01010101),
    .o_tx(tx),
    .o_done()
);

assign o_tx = tx;

endmodule
