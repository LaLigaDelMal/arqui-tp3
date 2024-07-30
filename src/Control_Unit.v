`timescale 1ns / 1ps

// ALU operations
`define OP_SHIFT_LEFT 4'b0001
`define OP_SHIFT_RIGHT 4'b0000
`define OP_SHIFT_RIGHT_ARIT 4'b0010
`define OP_ADD 4'b0100
`define OP_SUB 4'b0101
`define OP_AND 4'b0110
`define OP_OR 4'b0111
`define OP_XOR 4'b1000
`define OP_NOR 4'b1001
`define OP_SLT 4'b1010
`define OP_SIGNED_ADD 4'b1100
`define OP_PASS 4'b0011
`define OP_CMP 4'b1011

// R type functions
`define FUNC_SLL 6'b000000
`define FUNC_SRL 6'b000010
`define FUNC_SRA 6'b000011
`define FUNC_SLLV 6'b000100
`define FUNC_SRLV 6'b000110
`define FUNC_SRAV 6'b000111
`define FUNC_ADDU 6'b100001
`define FUNC_SUBU 6'b100011
`define FUNC_AND 6'b100100
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_NOR 6'b100111
`define FUNC_SLT 6'b101010
`define FUNC_JR 6'b001000
`define FUNC_JALR 6'b001001

// I type functions
`define FUNC_ADDI 6'b000000
`define FUNC_ANDI 6'b000100
`define FUNC_ORI  6'b000101
`define FUNC_XORI 6'b000110
`define FUNC_LUI  6'b000111
`define FUNC_SLTI 6'b000010

// Modes of sign extension
`define MODE_SIGN_EXT 2'b00
`define MODE_ZERO_EXT_UPPER 2'b01
`define MODE_ZERO_EXT_LOWER 2'b10

module Control_Unit(
    input reg [5:0]     i_funct,                // Function code for R type instructions or in the case of aritmetic operations with inmediate values (I type instructions) the lower 3 bits represent the lower 3 bits of the opcode
    input reg [4:0]     i_rs,
    input reg [4:0]     i_rt,
    input reg [4:0]     i_rd,
    input reg [4:0]     i_sa,
    input reg [15:0]    i_imm,
    input reg [25:0]    i_addr_offset,

    input reg       i_flg_pc_modify,            // 1 if jump/branch, 0 if not
    input reg       i_flg_link_ret,             // 1 if saves the return address, 0 if not
    input reg [1:0] i_flg_addr_type,            // 00 if address comes from register, 01 if the address is obtained by replacing the low 28 bits of the PC with the 26-bit offset, 10 if the address is obtained by adding the 16-bit offset to the base address shifted 2 bits
    input reg [4:0] i_link_reg,                 // Link register for JAL and JALR
    input reg [4:0] i_addr_reg,                 // Address register for JR and JALR
    input reg       i_flg_equal,                // 1 if the compare checks if it's equal, 0 if not
    input reg       i_flg_inmediate,            // 1 if the instruction is an I type instruction, 0 if not
    input reg       i_flg_mem_op,               // 1 if the instruction is a memory operation, 0 if not
    input reg       i_flg_mem_type,             // 0 if load, 1 if store
    input reg [1:0] i_flg_mem_size,             // 00 if byte, 01 if halfword, 11 if word
    input reg       i_flg_unsign,               // 1 if the operation is unsigned, 0 if not

    output reg          o_flg_ALU_enable,       // 1 if the ALU is enabled, 0 if not
    output reg [1:0]    o_flg_ALU_src_a,        // 01 if the ALU source A is the value of the register RT, 00 if is the PC+4, 11 if the source is the output from the sign extender
    output reg          o_flg_ALU_src_b,        // 1 if the ALU source B is the SA value in the instruction, 0 if the soure is the register RS
    output reg [1:0]    o_flg_ALU_dst,          // 01 if the ALU destination is the register RD, 00 if the destination is RT, 11 if the destination is the 31 ($ra)
    output reg [3:0]    o_ALU_opcode,


    output reg          o_flg_AGU_enable,       // 1 if the AGU is enabled, 0 if not
    output reg          o_flg_AGU_src_addr,     // 1 if the PC, 0 if the address is the content of the RS register
    output reg          o_flg_AGU_dst,          // 1 if the PC is the destination, 0 if for memory addressing (load and store)
    output reg [2:0]    o_flg_AGU_opcode

    output reg o_flg_jump,                      // 1 if the instruction is a jump, 0 if not (this should change the mux that controls the AGU output to either PC or RD)
    output reg o_flg_branch,                    // 1 if the the result of the ALU will be used to make a conditional jump, 0 if is not a branch
    
    output reg [1:0] o_extend_sign,             // 00 if the inmediate value is sign extended, 01 if the upper part of the word is completed with zeros, 10 if the lower part of the word is completed with zeros
    );

    always @ (*) begin
        wire [11:0] flags = { // NO TOCAR ORDEN
            i_flg_pc_modify,
            i_flg_link_ret,
            i_flg_addr_type,
            i_flg_equal,
            i_flg_inmediate,
            i_flg_mem_op,
            i_flg_mem_type,
            i_flg_mem_size,
            i_flg_unsign
        };
        case (flags):
            12'b0XXXX0XXXXX: begin        // R type instructions
                o_flg_ALU_enable <= 1;
                o_flg_ALU_src_a  <= 2'b01;
                o_flg_ALU_dst    <= 2'b01;

                o_flg_AGU_enable <= 0;
                
                o_flg_jump      <= 0;
                o_flg_branch    <= 0;

                case (i_funct):
                    `FUNC_SLL:  begin o_flg_alu_src_b <= 1; o_ALU_opcode <= `OP_SHIFT_LEFT; end
                    `FUNC_SRL:  begin o_flg_alu_src_b <= 1; o_ALU_opcode <= `OP_SHIFT_RIGHT; end
                    `FUNC_SRA:  begin o_flg_alu_src_b <= 1; o_ALU_opcode <= `OP_SHIFT_RIGHT_ARIT; end
                    `FUNC_SLLV: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SHIFT_LEFT; end
                    `FUNC_SRLV: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SHIFT_RIGHT; end
                    `FUNC_SRAV: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SHIFT_RIGHT_ARIT; end
                    `FUNC_ADDU: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_ADD; end
                    `FUNC_SUBU: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SUB; end
                    `FUNC_AND:  begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_AND; end
                    `FUNC_OR:   begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_OR; end
                    `FUNC_XOR:  begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_XOR; end
                    `FUNC_NOR:  begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_NOR; end
                    `FUNC_SLT:  begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SLT; end
                endcase  
            end
            12'b1000000XXXX: begin     // JR
                o_flg_ALU_enable <= 0;

                o_flg_AGU_enable    <= 1;
                o_flg_AGU_src_addr  <= 0;
                o_flg_AGU_dst       <= 1;
                o_flg_AGU_opcode    <= 3'b000;

                o_flg_jump      <= 1;
                o_flg_branch    <= 0;
            end
            12'b1100000XXXX: begin     // JALR
                o_flg_ALU_enable <= 1;
                o_flg_ALU_src_a  <= 2'b00;          // The PC+4
                o_ALU_opcode     <= `OP_PASS;       // The ALU will be used to store the return address in the link register (RD)

                o_flg_AGU_enable    <= 1;
                o_flg_AGU_src_addr  <= 0;
                o_flg_AGU_dst       <= 1;
                o_flg_AGU_opcode    <= 3'b000;

                o_flg_jump   <= 1;
                o_flg_branch <= 0;
            end
            12'b0000011XXXX: begin     // LOAD & STORE   (Para 32 bits LW y LWU hacen lo mismo)
                o_flg_ALU_enable <= 0;
                
                o_flg_AGU_enable    <= 1;
                o_flg_AGU_src_addr  <= 0;
                o_flg_AGU_dst       <= 0;
                o_flg_AGU_opcode    <= 3'b001;   //TODO Verificar a la salida de la AGU el bus the excepciones segun sea direccion de byte, half word, o word

                o_flg_jump      <= 0;
                o_flg_branch    <= 0;
            end
            12'b00000100000: begin     // ARITHMETIC OPERATIONS WITH INMEDIATE VALUES
                o_flg_ALU_enable <= 1;
                o_flg_ALU_src_a  <= 2'b11;
                o_flg_ALU_src_b  <= 0;
                o_flg_ALU_dst    <= 2'b00;

                o_flg_AGU_enable <= 0;
                
                o_flg_jump   <= 0;
                o_flg_branch <= 0;

                case (i_funct):
                    `FUNC_ADDI: begin o_ALU_opcode <= `OP_SIGNED_ADD;   o_extend_sign <= `MODE_SIGN_EXT; end
                    `FUNC_ANDI: begin o_ALU_opcode <= `OP_AND;          o_extend_sign <= `MODE_SIGN_EXT; end
                    `FUNC_ORI:  begin o_ALU_opcode <= `OP_OR;           o_extend_sign <= `MODE_SIGN_EXT; end
                    `FUNC_XORI: begin o_ALU_opcode <= `OP_XOR;          o_extend_sign <= `MODE_SIGN_EXT; end
                    `FUNC_LUI:  begin o_ALU_opcode <= `OP_PASS;         o_extend_sign <= `MODE_ZERO_EXT_LOWER; end
                    `FUNC_SLTI: begin o_ALU_opcode <= `OP_SLT;          o_extend_sign <= `MODE_SIGN_EXT; end
                endcase
            end
            12'b1010X100000: begin      // BRANCH
                o_flg_ALU_enable    <= 1;
                o_flg_ALU_src_a     <= 2'b01;
                o_flg_ALU_src_b     <= 0;
                o_flg_ALU_dst       <= 2'b00;     // The destination doesn't matter because it will be used to decide if the branch is taken or not (check flag branch)
                o_ALU_opcode        <= `OP_CMP;

                o_flg_AGU_enable    <= 1;
                o_flg_AGU_src_addr  <= 1;
                o_flg_AGU_dst       <= 1;
                o_flg_AGU_opcode    <= 3'b010;

                o_flg_jump   <= 0;
                o_flg_branch <= 1;
            end
            12'b1X010000000: begin      // J and JAL
                if (i_flg_link_ret) begin
                    o_flg_ALU_enable    <= 1;
                    o_flg_ALU_src_a     <= 2'b00;
                    o_flg_ALU_dst       <= 2'b11;
                    o_ALU_opcode        <= `OP_PASS;
                end
                else begin
                    o_flg_ALU_enable    <= 0;
                end

                o_flg_AGU_enable    <= 1;
                o_flg_AGU_src_addr  <= 1;
                o_flg_AGU_dst       <= 1;
                o_flg_AGU_opcode    <= 3'b011;

                o_flg_jump      <= 1;
                o_flg_branch    <= 0;
            end
        endcase
    end
endmodule
