`timescale 1ns / 1ps

module Instruction_Fetch (
    input wire clk,
    input wire rst,
    input wire i_en,             // Instruction memory read enable
    
    //PC
    input wire [31:0] i_pc,             // Program Counter
    output wire [31:0] o_pc,
    
    //Memory
    input wire [31:0] i_mem_data,
    input wire i_mem_data_valid,
    output wire [31:0] o_mem_addr,
    output wire o_mem_wr, //wr en
    
    //IF output    
    output wire [31:0] o_instr           // Fetched instruction
);

reg mem_wr_en;
reg [31:0] addr_mem;
reg [31:0] instr;
reg [31:0] post_pc;

always @(posedge clk) begin
    if (rst) begin
        mem_wr_en   = 0;
        addr_mem    = 0;
        instr       = 0;
        post_pc     = 0;
    end
    if(!i_en) begin
        mem_wr_en   = 1'bZ;
        addr_mem    = 32'bZ;
        instr       = 32'bZ;
        post_pc     = 32'bZ;
    end
end

always @(*) begin //Combinational, with signals involved in sensitivity list and with = in operation
    if (i_en) begin
        // Solo sumara PC+4 cuando i_mem_data_valid flag sea alto
        mem_wr_en   = 0;
        addr_mem = i_pc;
        instr = i_mem_data;
        post_pc = {i_pc[31:2], 2'b00} + 4; // increment the address by 4 (assuming i_pc is byte-addressable)
    end
end

assign o_mem_wr     = mem_wr_en; 
assign o_mem_addr   = addr_mem;
assign o_instr      = instr;
assign o_pc         = post_pc;

endmodule
