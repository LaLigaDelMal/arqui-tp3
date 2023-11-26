module Instruction_Decode (
    input [31:0] i_instr,
    output reg [5:0] o_opcode,
    output reg [5:0] o_funct,
    output reg [4:0] o_rs,
    output reg [4:0] o_rt,
    output reg [4:0] o_rd,
    output reg [15:0] o_immediate,
    output reg [25:0] o_addr
);

always @(instruction) begin
    o_opcode    = i_instr[31:26];
    o_rs        = i_instr[25:21];
    o_rt        = i_instr[20:16];
    o_rd        = i_instr[15:11];
    o_funct     = i_instr[5:0];
    o_immediate = i_instr[15:0];
    o_addr      = i_instr[25:0];
end

endmodule