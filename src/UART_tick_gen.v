`timescale 1ns / 1ps

module UART_tick_gen #(
    parameter CLOCK = 100000000,
    parameter BAUD_RATE = 9600
)(
    input wire i_clk,
    input wire i_rst,
    output wire o_tick
);

    localparam TICK_RATE = CLOCK/(BAUD_RATE*16);    // (2BAUD_RATE) para Tx, (2BAUD_RATE16) para Rx
    localparam COUNTER_BITS = $clog2(TICK_RATE);

    reg [COUNTER_BITS-1:0] counter;

    initial begin
        counter   = {COUNTER_BITS{1'b0}};
    end

    always @ (posedge i_clk) begin
        if (i_rst) begin
            counter <= 0;
        end else if(counter < TICK_RATE) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end

    assign o_tick = (counter==TICK_RATE-1)? 1'b1 : 1'b0;

endmodule
