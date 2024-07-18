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


module Control_Unit(
    input reg [5:0] i_funct,         // Function code for R type instructions or in the case of aritmetic operations with inmediate values (I type instructions) the lower 3 bits represent the lower 3 bits of the opcode
    input reg [4:0] i_rs,
    input reg [4:0] i_rt,
    input reg [4:0] i_rd,
    input reg [4:0] i_sa,
    input reg [15:0] i_imm,
    input reg [25:0] i_addr_offset,
    input reg i_flg_pc_modify,          // 1 if jump/branch, 0 if not
    input reg i_flg_link_ret,           // 1 if saves the return address, 0 if not
    input reg [1:0] i_flg_addr_type,    // 00 if address comes from register, 01 if the address is obtained by replacing the low 28 bits of the PC with the 26-bit offset, 10 if the address is obtained by adding the 16-bit offset to the base address shifted 2 bits
    input reg [4:0] i_link_reg,         // Link register for JAL and JALR
    input reg [4:0] i_addr_reg,         // Address register for JR and JALR
    input reg i_flg_cmp,                // 1 if compare, 0 if not
    input reg i_flg_equal,              // 1 if the compare checks if it's equal, 0 if not
    input reg i_flg_inmediate,          // 1 if the instruction is an I type instruction, 0 if not
    input reg i_flg_mem_op,             // 1 if the instruction is a memory operation, 0 if not
    input reg i_flg_mem_type,           // 0 if load, 1 if store
    input reg [1:0] i_flg_mem_size,     // 00 if byte, 01 if halfword, 11 if word
    input reg i_flg_unsign,             // 1 if the operation is unsigned, 0 if not
    output reg o_flg_ALU_enable,        // 1 if the ALU is enabled, 0 if not
    output reg [1:0] o_flg_ALU_src_a,   // 01 if the ALU source A is the value of the register RT, 00 if is the PC+4, 11 if the source is the inmediate value
    output reg o_flg_ALU_src_b,         // 1 if the ALU source B is the SA value in the instruction, 0 if the soure is the register RS
    output reg o_flg_ALU_dst,           // 1 if the ALU destination is the register RD, 0 if the destination is RT
    output reg [3:0] o_ALU_opcode,
    output reg o_make_jump,             // 1 if the instruction is a jump, 0 if not (this should change the mux that controls the AGU output to either PC or RD) 
    output reg o_flg_AGU_enable,        // 1 if the AGU is enabled, 0 if not
    output reg [3:0] o_flg_AGU_opcode
    output reg o_flg_AGU_src_addr,      // 0 if the address is the content of the RS register
    output reg o_flg_AGU_src_off,       ////
    output reg o_flg_AGU_dst            // 1 if the PC is the destination, 0 if for memory addressing (load and store)  //// Capaz se pueda deducir de la flag "o_make_jump"
    );

    always @ (*) begin
        wire [11:0] flags = {
            i_flg_pc_modify,
            i_flg_link_ret,
            i_flg_addr_type,
            i_flg_cmp,
            i_flg_equal,
            i_flg_inmediate,
            i_flg_mem_op,
            i_flg_mem_type,
            i_flg_mem_size,
            i_flg_unsign
        };
        case (flags):
            12'b0XXXXX0XXXXX: begin
                // SLL
                // Indicar a la ALU que tiene como operando A el valor del registro RT y como operando B el valor de SA
                o_flg_alu_src_a <= 2'b01;
                o_flg_alu_dst <= 1;
                o_make_jump <= 0;
                o_flg_ALU_enable <= 1;
                o_flg_AGU_enable <= 0;
                case (i_funct):
                    `FUNC_SLL: begin o_flg_alu_src_b <= 1; o_ALU_opcode <= `OP_SHIFT_LEFT; end
                    `FUNC_SRL: begin o_flg_alu_src_b <= 1; o_ALU_opcode <= `OP_SHIFT_RIGHT; end
                    `FUNC_SRA: begin o_flg_alu_src_b <= 1; o_ALU_opcode <= `OP_SHIFT_RIGHT_ARIT; end
                    `FUNC_SLLV: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SHIFT_LEFT; end
                    `FUNC_SRLV: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SHIFT_RIGHT; end
                    `FUNC_SRAV: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SHIFT_RIGHT_ARIT; end
                    `FUNC_ADDU: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_ADD; end
                    `FUNC_SUBU: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SUB; end
                    `FUNC_AND: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_AND; end
                    `FUNC_OR: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_OR; end
                    `FUNC_XOR: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_XOR; end
                    `FUNC_NOR: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_NOR; end
                    `FUNC_SLT: begin o_flg_alu_src_b <= 0; o_ALU_opcode <= `OP_SLT; end
                endcase  
            end
            12'b10000000XXXX: begin     // JR
                o_make_jump <= 1;
                o_flg_AGU_dst <= 1;         // Puede que se termine deduciendo de la flag o_make_jump
                o_flg_AGU_opcode <= 3'b000;
                o_flg_AGU_src_addr <= 0;       /////// Puede que no haga falta
                o_flg_AGU_dst <= 0;
                o_flg_ALU_enable <= 0;
                o_flg_AGU_enable <= 1;
            end
            12'b11000000XXXX: begin     // JALR
                o_make_jump <= 1;
                o_flg_AGU_dst <= 1;
                o_flg_AGU_opcode <= 3'b000;
                o_flg_AGU_src_addr <= 0;        /////// Puede que no haga falta
                o_flg_ALU_enable <= 1;
                o_flg_AGU_enable <= 1;
                o_ALU_opcode <= `OP_ADD;  // The ALU will be used to store the return address in the link register (RD)
                o_flg_alu_src_a <= 2'b00;    // The PC+4
                o_flg_alu_src_b <= 0;     // Como SA en la instrucción JALR vale 0, se usa el registro $zero (por lo que la suma da el mismo valor de PC+4)
            end
            12'b00000011XXXX: begin     // LOAD & STORE   (Para 32 bits LW y LWU hacen lo mismo)
                o_make_jump <= 0;
                o_flg_AGU_dst <= 0;
                o_flg_AGU_opcode <= 3'b001;   // Verificar a la salida de la AGU el bus the excepciones segun sea direccion de byte, half word, o word
                o_flg_AGU_src_addr <= 0;      /////// Puede que no haga falta
                o_flg_ALU_enable <= 0;
                o_flg_AGU_enable <= 1;
            end
            12'b000000100000: begin     // ARITHMETIC OPERATIONS WITH INMEDIATE VALUES
                o_make_jump <= 0;
                o_flg_ALU_enable <= 1;
                o_flg_AGU_enable <= 0;
                o_flg_alu_dst <= 0;
                o_flg_alu_src_a <= 2'b11;
                o_flg_alu_src_b <= 0;
                case (i_funct):
                    `FUNC_ADDI: begin o_ALU_opcode <= `OP_SIGNED_ADD; end   ////////////////  Agregar extensor de signo y flag que salga hacia esa unidad desde la unidad de control

                endcase
            end
        endcase
    end

endmodule
