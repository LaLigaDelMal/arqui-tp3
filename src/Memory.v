`timescale 1ns / 1ps

module Memory #(
        parameter SIZE = 16, parameter ADDR_BITS = $clog2(SIZE)
     )(
    input wire clk,
    input wire rst,
    input wire [ADDR_BITS-1:0] i_addr,
    input wire i_wr_en,
    input wire [31:0] i_data,
    output reg [31:0] o_data
    
);

// Celdas de 8 bits, bus de direcciones de 32, bus de datos de 32 (UNICO si es posible) y cantidad de celdas parametrizable
localparam T_SIZE = 4*SIZE;
reg [8:0] mem [0:4*T_SIZE];

always @(posedge clk) begin
    if (rst) begin
        // Reset process
        for (integer i = 0; i < T_SIZE; i = i +1 )
            mem[i] <= 0;
        o_data <= 0;
    end 
end

always @(*) begin    
    // This is BIG ENDIAN
    // 31 | 30 | 29 | 28 | 27 | 26 | 25 | 24 | 23 | 22 | 21 | 20 | 19 | 18 | 17 | 16 | 15 | 14 | 13 | 12 | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
    // B1: 31-24 
    // B2: 23-16 
    // B3: 15-8 
    // B4: 7-0
    
    // Write Operation 
    if (i_wr_en && (i_addr < T_SIZE - 3)) begin
        mem[i_addr]     = i_data[31:24];
        mem[i_addr +1]  = i_data[23:16];
        mem[i_addr +2]  = i_data[15:8];
        mem[i_addr +3]  = i_data[7:0];
    //end else if (!i_wr_en || (i_addr >= T_SIZE - 3)) begin
        // Invalid write operation or write to non-existent addresses
        // You can choose to generate an error signal or take appropriate action here
        // For now, we just don't perform any write operations to undefined addresses.
    end
        
    // Read operation
    if (!i_wr_en) begin
        o_data[31:24]    = mem[i_addr];
        o_data[23:16]    = mem[i_addr+1];
        o_data[15:8]     = mem[i_addr+2];
        o_data[7:0]      = mem[i_addr+3];
    end
end

endmodule

