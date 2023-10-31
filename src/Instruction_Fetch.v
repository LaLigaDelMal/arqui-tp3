`timescale 1ns / 1ps

module InstructionFetch (
    input wire clk,
    input wire rst,
    input wire i_en,             // Instruction memory read enable
    
    //PC
    input wire [31:0] i_pc,             // Program Counter
    output wire [31:0] o_pc,
    
    //Memory
    input wire [31:0] i_mem_data,
    output wire [31:0] o_mem_addr,
    output wire o_mem_wr, //wr en
    
    //IF output    
    output wire [31:0] o_instr           // Fetched instruction
);

reg mem_wr_en;
reg addr_mem;
reg instr;
reg post_pc;

always @(posedge clk) begin
    if (rst) begin
        mem_wr_en = 0;
        addr_mem = 0;
    end
end

always @(*) begin //Combinacional, con señales involucradas en lista de sensibilidad y con = en funcionamiento
    if (i_en) begin
        mem_wr_en = 0;
        addr_mem = {i_pc[31:2], 1'b00};     //Use bits 31-2 of PC as memory address
    end
end

always @(i_mem_data) begin
    instr = i_mem_data;
    post_pc = {i_pc[31:2]+1'b100};
end

assign o_mem_wr     = mem_wr_en; 
assign o_mem_addr   = addr_mem;
assign o_instr      = instr;
assign o_pc         = post_pc;

endmodule
