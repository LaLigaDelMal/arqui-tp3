`timescale 1ns / 1ps

module Instruction_Memory #(
    parameter NBITS = 8,
    parameter INST_BITS = 32,
    parameter CELLS = 256
)(
    input   wire    i_clk,
    input   wire    i_rst,
    input   wire    [INST_BITS-1:0]     i_addr,
    input   wire    [INST_BITS-1:0]     i_addr_wr,
    input   wire    [INST_BITS-1:0]     i_data,
    input   wire                        i_wr_en,
    output  reg     [INST_BITS-1:0]     o_data
);

reg [NBITS-1:0] memory[CELLS-1:0];
integer i;

initial begin
    for (i = 0; i < CELLS; i = i + 1) begin
        memory[i] = 0;
    end

    //Make two loads and an ADD operation between them
    {memory[0], memory[1], memory[2], memory[3]}     = 32'h3C080000; // Carga un 0 en T0
    {memory[4], memory[5], memory[6], memory[7]}     = 32'h81090001; // Carga el valor de la memoria de datos (direccion 0) en T1

end

//////////////////////////////// SE UTILIZA BIG ENDIAN //////////////////////////////
always @(negedge i_clk) begin
    if (i_rst) begin
        o_data <= 0;
    end else if (i_wr_en) begin
        {memory[i_addr_wr], memory[i_addr_wr + 1], memory[i_addr_wr + 2], memory[i_addr_wr + 3]} <= i_data[31:0];
    end else begin
        o_data <= {memory[i_addr], memory[i_addr + 1], memory[i_addr + 2], memory[i_addr + 3]};
    end
end

endmodule 
