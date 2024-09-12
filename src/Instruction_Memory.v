`timescale 1ns / 1ps

module Instruction_Memory #(
    parameter NBITS = 8,
    parameter INST_BITS = 32,
    parameter CELLS = 256
)(
    input   wire    i_clk,
    input   wire    [INST_BITS-1:0]     i_addr, // Preguntar a GASPAR si debe ser de 32 en lugar de 8
    input   wire    [INST_BITS-1:0]     i_data, // Preguntar a GASPAR si debe ser de 32 en lugar de 8
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
    //Load 0x00000001 into R0; lUI $t1, 1
    {memory[0], memory[1], memory[2], memory[3]} = 32'h012A5821;     //ADDU R11, R10, R11; addu $t3, $t1, $t2
    //{memory[0], memory[1], memory[2], memory[3]} = 32'h3c090001; //Load 0x00000001 into R0; lUI $t1, 1 
    //{memory[4], memory[5], memory[6], memory[7]} = 32'h3c0a0002; //Load 0x00000001 into R1; lUI $t2, 2
    //{memory[8], memory[9], memory[10], memory[11]} = 32'h12A5821;   //ADDU R11, R10, R11; addu $t3, $t1, $t2

end

//////////////////////////////// SE UTILIZA BIG ENDIAN //////////////////////////////
always @(posedge i_clk) begin
    if ( !i_wr_en ) begin
        o_data  <= {memory[i_addr], memory[i_addr + 1], memory[i_addr + 2], memory[i_addr + 3]};  // BIG ENDIAN
        //          0000 0000       0000 0001       0000 0010       0000 0011
    end
end

endmodule 
