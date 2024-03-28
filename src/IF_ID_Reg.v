`timescale 1ns / 1ps

module IF_ID_Reg #(
    parameter   NBITS = 32
)(
    input wire                i_clk,
    input wire                i_rst,
    input wire   [NBITS-1:0]  i_pc,
    input wire   [NBITS-1:0]  i_instruction,
    output wire  [NBITS-1:0]  o_pc,
    output wire  [NBITS-1:0]  o_instruction
);

reg [NBITS-1:0] PC;
reg [NBITS-1:0] instruction;

always @(posedge i_clk) begin
    if ( i_rst ) begin
        PC <= {NBITS{1'b0}};
        instruction <= {NBITS{1'b0}};
    end

    else begin
        PC <= i_pc;
        instruction <= i_instruction;
    end
end

assign o_pc = PC;
assign o_instruction = instruction;

endmodule
