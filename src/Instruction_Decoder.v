module Instruction_Decode (
    input [31:0] i_instr,
    output reg [5:0] o_funct,
    output reg [4:0] o_rs,
    output reg [4:0] o_rt,
    output reg [4:0] o_rd,
    output reg [4:0] o_sa,
    output reg [15:0] o_imm,
    output reg [25:0] o_addr_offset,
    output reg o_flg_pc_modify,       // 1 if jump/branch, 0 if not
    output reg o_flg_link_ret,        // 1 if saves the return address, 0 if not
    output reg [1:0] o_flg_addr_type, // 00 if address comes from register, 01 if the address is obtained by replacing the low 28 bits of the PC with the 26-bit offset, 10 if the address is obtained by adding the 16-bit offset to the base address shifted 2 bits
    output reg [4:0] o_link_reg,      // Link register for JAL and JALR
    output reg [4:0] o_addr_reg,      // Address register for JR and JALR
    output reg o_flg_cmp,             // 1 if compare, 0 if not
    output reg o_flg_equal            // 1 if the compare checks if it's equal, 0 if not
);

reg [5:0] opcode;

always @(instruction) begin
    opcode = i_instr[31:26];

    case (opcode)
        6'b000000: begin                                            // R type
            o_funct = i_instr[5:0];
            case (o_funct)
                6'b001000: begin            // JR
                    o_funct = 6'b0;
                    o_rs = i_instr[25:21];
                    o_rt = 5'b0;
                    o_rd = 5'b0;
                    o_sa = 5'b0;
                    o_imm = 16'b0;
                    o_addr_offset = 26'b0;
                    o_flg_pc_modify = 1'b1;
                    o_flg_link_ret = 1'b0;
                    o_flg_addr_type = 2'b00;
                    o_link_reg = 5'b0;
                    o_addr_reg = i_instr[25:21];
                    o_flg_cmp = 1'b0;
                    o_flg_equal = 1'b0;
                end
                6'b001001: begin            // JALR
                    o_funct = 6'b0;
                    o_rs = i_instr[25:21];
                    o_rt = 5'b0;
                    o_rd = i_instr[15:11];
                    o_sa = 5'b0;
                    o_imm = 16'b0;
                    o_addr_offset = 26'b0;
                    o_flg_pc_modify = 1'b1;
                    o_flg_link_ret = 1'b1;
                    o_flg_addr_type = 2'b00;
                    o_link_reg = i_instr[15:11];
                    o_addr_reg = i_instr[25:21];
                    o_flg_cmp = 1'b0;
                    o_flg_equal = 1'b0;
                end
                default: begin
                    o_funct = i_instr[5:0];
                    o_rs = i_instr[25:21];
                    o_rt = i_instr[20:16];
                    o_rd = i_instr[15:11];
                    o_sa = i_instr[10:6];
                    o_imm = 16'b0;
                    o_addr_offset = 26'b0;
                    o_flg_pc_modify = 1'b0;
                    o_flg_link_ret = 1'b0;
                    o_flg_addr_type = 2'b00;
                    o_link_reg = 5'b0;
                    o_addr_reg = 5'b0;
                    o_flg_cmp = 1'b0;
                    o_flg_equal = 1'b0;
                end
            endcase
        6'b000010: begin                            // J
            o_funct = 6'b0;
            o_rs = 5'b0;
            o_rt = 5'b0;
            o_rd = 5'b0;
            o_sa = 5'b0;
            o_imm = 16'b0;
            o_addr_offset = i_instr[25:0];
            o_flg_pc_modify = 1'b1;
            o_flg_link_ret = 1'b0;
            o_flg_addr_type = 2'b01;
            o_link_reg = 5'b0;
            o_addr_reg = 5'b0;
            o_flg_cmp = 1'b0;
            o_flg_equal = 1'b0;
        end
        6'b000011: begin                            // JAL
            o_funct = 6'b0;
            o_rs = 5'b0;
            o_rt = 5'b0;
            o_rd = 5'b0;
            o_sa = 5'b0;
            o_imm = 16'b0;
            o_addr_offset = i_instr[25:0];
            o_flg_pc_modify = 1'b1;
            o_flg_link_ret = 1'b1;
            o_flg_addr_type = 2'b01;
            o_link_reg = 5'b11111;    // GPR 31
            o_addr_reg = 5'b0;
            o_flg_cmp = 1'b0;
            o_flg_equal = 1'b0;
        end

        default: begin
            case (opcode[5:3])
                3'b000: begin
                    if (opcode[0] == 1'b0) begin    // BEQ
                        o_funct = 6'b0;
                        o_rs = i_instr[25:21];
                        o_rt = i_instr[20:16];
                        o_rd = 5'b0;
                        o_sa = 5'b0;
                        o_imm = 16'b0;
                        o_addr_offset = {10'b0, i_instr[15:0]};
                        o_flg_pc_modify = 1'b1;
                        o_flg_link_ret = 1'b0;
                        o_flg_addr_type = 2'b10;
                        o_link_reg = 5'b0;
                        o_addr_reg = 5'b0;
                        o_flg_cmp = 1'b1;
                        o_flg_equal = 1'b1;
                    end else begin                  // BNE
                        o_funct = 6'b0;
                        o_rs = i_instr[25:21];
                        o_rt = i_instr[20:16];
                        o_rd = 5'b0;
                        o_sa = 5'b0;
                        o_imm = 16'b0;
                        o_addr_offset = {10'b0, i_instr[15:0]};
                        o_flg_pc_modify = 1'b1;
                        o_flg_link_ret = 1'b0;
                        o_flg_addr_type = 2'b10;
                        o_link_reg = 5'b0;
                        o_addr_reg = 5'b0;
                        o_flg_cmp = 1'b1;
                        o_flg_equal = 1'b0;
                    end
        // Chequear todas las flags y metodos de direccionamiento
        // Below TBC
                end
                3'b010: begin
                    o_rs = i_instr[25:21];
                    o_rt = i_instr[20:16];
                    o_rd = 5'b0;
                    o_sa = 5'b0;
                    o_imm = i_instr[15:0];
                    o_addr_offset = 26'b0;
                    o_flg_pc_modify = 1'b0;
                    o_flg_link_ret = 1'b0;
                    o_flg_addr_type = 1'b0;
                    o_link_reg = 5'b0;
                    o_addr_reg = 5'b0;
                end
                3'b011: begin
                    o_rs = i_instr[25:21];
                    o_rt = i_instr[20:16];
                    o_rd = 5'b0;
                    o_sa = 5'b0;
                    o_imm = i_instr[15:0];
                    o_addr_offset = 26'b0;
                    o_flg_pc_modify = 1'b0;
                    o_flg_link_ret = 1'b0;
                    o_flg_addr_type = 1'b0;
                    o_link_reg = 5'b0;
                    o_addr_reg = 5'b0;
                end
                default: begin
                    o_rs = i_instr[25:21];
                    o_rt = i_instr[20:16];
                    o_rd = 5'b0;
                    o_sa = 5'b0;
                    o_imm = i_instr[15:0];
                    o_addr_offset = 26'b0;
                    o_flg_pc_modify = 1'b0;
                    o_flg_link_ret = 1'b0;
                    o_flg_addr_type = 1'b0;
                    o_link_reg = 5'b0;
                    o_addr_reg = 5'b0;
                end
            end
        end