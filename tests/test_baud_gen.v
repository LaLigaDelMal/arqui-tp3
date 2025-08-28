`timescale 1ns / 1ps

module baud_gen_tb;

    reg rst, clk;
    wire tick;
    
    UART_tick_gen dut(
        clk,
        rst,
        tick
    );

    initial begin
        clk = 0;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    initial begin
        #10 rst = 1;     // Probar sacando el delay en esta linea
        #10 rst = 0;

      #100000;
        $finish;
    end


endmodule
