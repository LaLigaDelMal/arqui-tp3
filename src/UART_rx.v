`timescale 1ns / 1ps

module UART_rx
#(
    parameter FRAME_SIZE = 8,
    parameter OVERSAMPLING = 16
)
(
    input wire  i_clk,
    input wire  i_rst,
    input wire  i_rx,
    input wire  i_tick,
    output wire o_ready,
    output wire [(FRAME_SIZE-1):0] o_data
);


    localparam NDATA_COUNTER_BITS = $clog2(OVERSAMPLING);
    localparam MID_SAMPLE = 7;

    localparam [3:0]
        IDLE  = 0,
        START = 1,
        DATA  = 2,
        STOP  = 3;
 
    reg[3:0] tick_counter, next_tick_counter;
    reg[3:0] state, next_state;
    reg[(NDATA_COUNTER_BITS-1):0] bits_counter, next_bits_counter;
    reg[(FRAME_SIZE-1):0] buffer, next_buffer;
    reg rx_done, next_rx_done;


    always @ (posedge i_clk) begin

        if (i_rst) begin
            state <= IDLE;
            tick_counter <= 0;
            bits_counter <= 0;
            buffer <= 0;
            rx_done <= 0;
        end else begin
            state <= next_state;
            tick_counter <= next_tick_counter;
            bits_counter <= next_bits_counter;
            buffer <= next_buffer;
            rx_done <= next_rx_done;
        end
    end


    always @ (*) begin

        next_state = state;
        next_tick_counter = tick_counter;
        next_bits_counter = bits_counter;
        next_buffer = buffer;
        next_rx_done = rx_done;

        case (state)
            IDLE: begin
                next_rx_done = 0;
                if (~i_rx) begin
                    next_state = START;
                    next_tick_counter = 0;
                end
            end

            START: begin
                if (i_tick) begin
                    if (tick_counter == MID_SAMPLE) begin
                        next_state = DATA;
                        next_tick_counter = 0;
                        next_bits_counter = 0;
                        next_rx_done = 0;
                    end else begin
                        next_tick_counter = tick_counter + 1;
                    end
                end
            end

            DATA: begin
                if (i_tick) begin
                    if (tick_counter == MID_SAMPLE) begin     // Probar 15
                        next_tick_counter = 0;
                        next_buffer = {i_rx, buffer[(FRAME_SIZE-1):1]};
                        if (bits_counter == (FRAME_SIZE-1)) begin
                            next_state = STOP;
                        end else begin
                            next_bits_counter = bits_counter + 1;
                        end
                    end else begin
                        next_tick_counter = tick_counter + 1;
                    end
                end
            end

            STOP: begin
                if (i_tick) begin
                    if (tick_counter == (OVERSAMPLING - 1)) begin
                        next_state = IDLE;
                        next_rx_done = 1;
                    end else begin
                        next_tick_counter = tick_counter + 1;
                    end
                end
            end
        endcase   
    end

    assign o_data = buffer;
    assign o_ready = rx_done;

endmodule
