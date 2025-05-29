`timescale 1ns / 1ps

module Probe_Clock #(
    parameter CLOCK_CYCLES = 1000000
)(
    input wire i_clk,
    output wire o_pulse
);

    reg [31:0] counter;
    reg status_reg;


    always @ (posedge i_clk) begin

        if(counter < CLOCK_CYCLES) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            status_reg <= ~status_reg;
        end
    end

    assign o_pulse = status_reg;

endmodule
