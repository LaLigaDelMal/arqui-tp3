`timescale 1ns / 1ps
//Test bench top

module test_top_serial;

// Inputs
reg clk;
reg reset;
reg rx;
reg tx;


// Instantiate the module under test
TOP_TOP dut(
    clk,
    reset,
    rx
);

// Clock generation
always begin
    #5 clk = ~clk;
end

// Reset generation
initial begin
    clk=0;
    reset = 1;
    #100 reset = 0;

end

// UART Timing
localparam BIT_PERIOD = 104167; // in ns for 9600 bps

// Send a UART byte
task send_uart_byte(input [7:0] byte);
    integer i;
    begin
        // Start bit
        rx <= 0;
        #(BIT_PERIOD);

        // Data bits (LSB first)
        for (i = 0; i < 8; i = i + 1) begin
            rx <= byte[i];
            #(BIT_PERIOD);
        end

        // Stop bit
        rx <= 1;
        #(BIT_PERIOD);
    end
endtask

// Test case
initial begin
    // Initialize
    rx = 1; // idle high
    #200;
    reset = 0;

    // Wait a bit
    #10;

    // 3c010001
    // 3c020001
    // 00221821
    // ffffffff
    // Send the L load
    send_uart_byte(8'h6C);
    #BIT_PERIOD;

    send_uart_byte(8'h3C);
    #BIT_PERIOD;
    send_uart_byte(8'h01);
    #BIT_PERIOD;
    send_uart_byte(8'h00);
    #BIT_PERIOD;
    send_uart_byte(8'h01);
    #BIT_PERIOD;

    send_uart_byte(8'h3C);
    #BIT_PERIOD;
    send_uart_byte(8'h02);
    #BIT_PERIOD;
    send_uart_byte(8'h00);
    #BIT_PERIOD;
    send_uart_byte(8'h01);
    #BIT_PERIOD;

    send_uart_byte(8'h00);
    #BIT_PERIOD;
    send_uart_byte(8'h22);
    #BIT_PERIOD;
    send_uart_byte(8'h18);
    #BIT_PERIOD;
    send_uart_byte(8'h21);
    #BIT_PERIOD;

    send_uart_byte(8'hFF);
    #BIT_PERIOD;
    send_uart_byte(8'hFF);
    #BIT_PERIOD;
    send_uart_byte(8'hFF);
    #BIT_PERIOD;
    send_uart_byte(8'hFF);
    #BIT_PERIOD;

    // RUN THE THING
    send_uart_byte(8'h72); // Send the run command
    #BIT_PERIOD;



    // Wait and finish
    #30000000;
    $finish;
end

integer f;
initial begin
    f = $fopen("uart_tx_output_2.txt", "w");
end

always @(posedge clk) begin
    $fwrite(f, "%0t %b\n", $time, dut.o_tx);
end

endmodule