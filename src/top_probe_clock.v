`timescale 1ns / 1ps

module Probe_Clock #(
    parameter CLOCK_CYCLES = 1000000
)(
    input wire clk_in1,
    output wire o_pulse
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

    reg [31:0] counter;
    reg status_reg;


    always @ (posedge clk_out1) begin

        if(counter < CLOCK_CYCLES) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            status_reg <= ~status_reg;
        end
    end

    assign o_pulse = status_reg;

endmodule
