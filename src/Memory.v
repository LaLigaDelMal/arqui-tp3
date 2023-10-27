`timescale 1ns / 1ps

// Para usar una memoria de 32bits y 8 lugares entonces se utilizara RAM #(32, 8) my_ram (...)

module Memory #(parameter DATA_BUS=32, LENGTH=8) (
    input wire clk,
    input wire rst,
    input wire [$clog2(LENGTH)-1:0] i_addr,
    input wire i_wr_en,
    input wire [DATA_BUS-1:0] i_data,
    output reg [DATA_BUS-1:0] o_data
);


// Celdas de 32 bits, y IF detecta ultimos 2 bits no son 00

reg [DATA_BUS-1:0] mem [0:2**$clog2(LENGTH)-1];

always @(posedge clk) begin
    if (rst) begin
        // Reset process
        for (integer i = 0; i < 2**$clog2(LENGTH); i = i + 1)
            mem[i] <= 0;
        o_data <= 0;
    end else begin
        if (i_wr_en)
            mem[i_addr] <= 0;
        else
            o_data <= mem[i_addr];
    end
end

endmodule
