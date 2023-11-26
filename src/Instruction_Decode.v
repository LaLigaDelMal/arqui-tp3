module Instruction_Decode (
    input [31:0] i_instr,
    output reg [5:0] o_opcode,
    output reg [5:0] o_funct,
    output reg [4:0] o_rs,
    output reg [4:0] o_rt,
    output reg [4:0] o_rd,
    output reg [4:0] o_sa,      //Shamt
    output reg [15:0] o_imm,    //Immediate
    output reg [25:0] o_addr
);

always @(instruction) begin
    o_opcode    = i_instr[31:26];
    if(o_opcode == 6'b000000) begin                                         // Can be R type or R with Jump -> Check funct

        o_funct = i_instr[5:0];
        if(o_function == 6'b001000 || o_function == 6'b001001) begin        // Is R type but with Jump ( JR or JALR )
            o_rs        = i_instr[25:21];
            o_rt        = 5'b0;
            o_rd        = 5'b0;
            o_shamt     = 5'b0;
            o_imm       = 16'b0;
            o_addr      = 26'b0;
        end else begin                                                      // Is R type
            o_rs        = i_instr[25:21];
            o_rt        = i_instr[20:16];
            o_rd        = i_instr[15:11];
            o_shamt     = i_instr[10:6];
            o_immediate = 16'b0;
            o_addr      = 26'b0;
        end

    end else if(o_opcode == 6'b000010 || o_opcode == 6'b000011) begin       // Is J type( J or JAL )
        o_rs        = 5'b0;
        o_rt        = 5'b0;
        o_rd        = 5'b0;
        o_shamt     = 5'b0;
        o_immediate = 16'b0;
        o_addr      = i_instr[25:0];

    end else begin                                                          // Is I type
        o_rs        = i_instr[25:21];
        o_rt        = i_instr[20:16];
        o_rd        = 5'b0;
        o_shamt     = 5'b0;
        o_immediate = i_instr[15:0];
        o_addr      = 26'b0;
    end
end

endmodule