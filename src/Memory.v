`timescale 1ns / 1ps

// Para usar una memoria de 32bits y 64 lugares entonces se utilizara RAM #(32, 6) my_ram (...)
// De esta forma tendría 2^6 lugares de memoria

//module memory #(parameter DATA_WIDTH=8, ADDR_WIDTH=4) (
module Memory #(parameter DATA_WIDTH=8, ADDR_WIDTH=4) (
    input wire clk,
    input wire rst,
    input wire [ADDR_WIDTH-1:0] address,
    input wire write_enable,
    input wire read_enable,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out
);

reg [DATA_WIDTH-1:0] memory [0:2**ADDR_WIDTH-1]; // Parameterized memory size

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        // Reset process
        for ( integer i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
            memory[i] <= 0;
        end
    end else begin
        if (write_enable)
            memory[address] <= data_in;
    end

    data_out <= memory[address];
end

always @(posedge clk)
begin
    if (read_enable)
        data_out <= memory[address];
end

endmodule
