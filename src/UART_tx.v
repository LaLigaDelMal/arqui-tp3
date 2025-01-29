`timescale 1ns / 1ps


module UART_tx
#(
    parameter       CLK_FREQ     = 50000000,  
    parameter       BAUD_RATE    = 9600, 
    parameter       PAYLOAD_SIZE   = 8
)(
    input wire                                  i_clk,
    input wire                                  i_rst, 
    input wire                                  i_ready,
    input wire          [(PAYLOAD_SIZE-1)  :0]  i_data,
    output wire                                 o_tx,
    output wire                                 o_done
);


    localparam IDLE     = 1'b0;
    localparam TRANSMIT = 1'b1;

    localparam   DIV_COUNTER_VALUE   = CLK_FREQ / BAUD_RATE;
    localparam   DIV_COUNTER_SIZE    = $clog2(DIV_COUNTER_VALUE + 1);
    localparam   BIT_COUNTER_SIZE    = $clog2(PAYLOAD_SIZE + 2);

    reg         [DIV_COUNTER_SIZE-1:0]       div_counter;
    reg         [BIT_COUNTER_SIZE-1:0]       bit_counter, next_bit_counter;
    reg                                      state, next_state;
    reg         [PAYLOAD_SIZE+1:0]           shift_reg, next_shift_reg; 

    reg                                      tx, next_tx;
    reg                                      tx_done, next_tx_done;

    always @ (posedge i_clk) begin 
        if (i_rst) begin
            state           <= IDLE;
            div_counter     <= 0; 
            bit_counter     <= 0; 
            tx              <= 1;
            tx_done         <= 1;
        end else begin
            div_counter <= div_counter + 1;
            //if (div_counter >= DIV_COUNTER_VALUE) begin
            
                div_counter         <=  0;
                state               <=  next_state;
                shift_reg           <=  next_shift_reg;
                bit_counter         <=  next_bit_counter;
                tx                  <=  next_tx;
                tx_done             <=  next_tx_done;
            //end
        end
    end 

    always @ (*) begin
        next_state          <= state;
        next_shift_reg      <= shift_reg;
        next_tx             <= tx;
        next_bit_counter    <= bit_counter;
        next_tx_done        <= tx_done;

        case (state)
            IDLE: begin 
                if (i_ready) begin
                    $display("Sending data: %b", i_data);
                    next_state           <= TRANSMIT;
                    next_shift_reg       <= {1'b1,i_data,1'b0};
                end else begin
                    next_state           <= IDLE;
                    next_tx              <= 1; 
                    next_tx_done         <= 1;
                end
            end
            TRANSMIT: begin
                if (bit_counter >= 10) begin
                    next_state          <= IDLE;
                    next_bit_counter    <= 0;
                end else begin
                    next_state          <=  TRANSMIT;
                    next_tx_done        <=  0;
                    next_tx             <=  shift_reg[0]; 
                    next_shift_reg      <=  shift_reg >> 1;
                    next_bit_counter    <=  bit_counter + 1;
                end
            end
            default: 
                next_state <= IDLE;                      
        endcase
    end

    assign o_tx   = tx;
    assign o_done = tx_done;

endmodule
