module Instruction_Decode (
    input [31:0] instruction,
    output reg [5:0] opcode,
    output reg [5:0] funct,
    output reg [4:0] rs,
    output reg [4:0] rt,
    output reg [4:0] rd,
    output reg [15:0] immediate,
    output reg [25:0] address
);

always @(instruction) begin
    opcode = instruction[31:26];
    rs = instruction[25:21];
    rt = instruction[20:16];
    rd = instruction[15:11];
    funct = instruction[5:0];
    immediate = instruction[15:0];
    address = instruction[25:0];
end

endmodule