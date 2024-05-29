`timescale 1ns / 1ps

`define OP_SHIFT_LEFT 4'b0001
`define FUNC_SLL 6'b000000

module Control_Unit(
    input reg [5:0] i_funct,         // Function code for R type instructions or in the case of aritmetic operations with inmediate values (I type instructions) the lower 3 bits represent the lower 3 bits of the opcode
    input reg [4:0] i_rs,
    input reg [4:0] i_rt,
    input reg [4:0] i_rd,
    input reg [4:0] i_sa,
    input reg [15:0] i_imm,
    input reg [25:0] i_addr_offset,
    input reg i_flg_pc_modify,       // 1 if jump/branch, 0 if not
    input reg i_flg_link_ret,        // 1 if saves the return address, 0 if not
    input reg [1:0] i_flg_addr_type, // 00 if address comes from register, 01 if the address is obtained by replacing the low 28 bits of the PC with the 26-bit offset, 10 if the address is obtained by adding the 16-bit offset to the base address shifted 2 bits
    input reg [4:0] i_link_reg,      // Link register for JAL and JALR
    input reg [4:0] i_addr_reg,      // Address register for JR and JALR
    input reg i_flg_cmp,             // 1 if compare, 0 if not
    input reg i_flg_equal,           // 1 if the compare checks if it's equal, 0 if not
    input reg i_flg_inmediate,       // 1 if the instruction is an I type instruction, 0 if not
    input reg i_flg_mem_op,          // 1 if the instruction is a memory operation, 0 if not
    input reg i_flg_mem_type,        // 0 if load, 1 if store
    input reg [1:0] i_flg_mem_size,  // 00 if byte, 01 if halfword, 11 if word
    input reg i_flg_unsign,          // 1 if the operation is unsigned, 0 if not
    output reg o_flg_ALU_src_a,      // 1 if the ALU source A is the value of the register RT, 0 if not   ///////////////// Puede que no haga falta
    output reg o_flg_ALU_src_b,      // 1 if the ALU source B is the SA value in the instruction, 0 if not   ///////////////// Puede que no haga falta
    output reg o_flg_ALU_dst,        // 1 if the ALU destination is the register RD, 0 if not            ///////////////// Puede que no haga falta
    output reg [3:0] o_ALU_opcode,

    );

    always @ (*) begin
        wire [11:0] flags = {o_flg_pc_modify, o_flg_link_ret, o_flg_addr_type, o_flg_cmp, o_flg_equal, o_flg_inmediate, o_flg_mem_op, o_flg_mem_type, o_flg_mem_size, o_flg_unsign};
        case (flags):
            12'b0XXXXX0XXXXX: begin
                // SLL
                // Indicar a la ALU que tiene como operando A el valor del registro RT y como operando B el valor de SA
                o_flg_alu_src_a <= 1;
                o_flg_alu_src_b <= 1;
                o_flg_alu_dst <= 1;
                // Flag para indicar operacion de ALU ???
                case (i_funct)
                    `FUNC_SLL: begin o_ALU_opcode <= `OP_SHIFT_LEFT; end
                endcase
                    
            end
        endcase
    end

endmodule
