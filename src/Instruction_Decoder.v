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
    output reg o_flg_branch,          // 1 if branch, 0 if jump
    output reg o_flg_addr_type,       // 0 if address comes from register, 1
    output reg [4:0] o_link_reg,      // Link register for JAL and JALR
    output reg [4:0] o_addr_reg       // Address register for JR and JALR
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
                    o_flg_branch = 1'b0;
                    o_flg_addr_type = 1'b0;
                    o_link_reg = 5'b0;
                    o_addr_reg = i_instr[25:21];
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
                    o_flg_branch = 1'b1;
                    o_flg_addr_type = 1'b0;
                    o_link_reg = i_instr[15:11];
                    o_addr_reg = i_instr[25:21];
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
                    o_flg_branch = 1'b0;
                    o_flg_addr_type = 1'b0;
                    o_link_reg = 5'b0;
                    o_addr_reg = 5'b0;
                end
            endcase
        endcase
    end
endmodule
        // Below TBC
        /*
        6'b000010: begin
            o_rs = 5'b0;
            o_rt = 5'b0;
            o_rd = 5'b0;
            o_sa = 5'b0;
            o_imm = 16'b0;
            o_addr = i_instr[25:0];
        end
        6'b000011: begin
            o_rs = 5'b0;
            o_rt = 5'b0;
            o_rd = 5'b0;
            o_sa = 5'b0;
            o_imm = 16'b0;
            o_addr = i_instr[25:0];
        end
        default: begin
            o_rs = i_instr[25:21];
            o_rt = i_instr[20:16];
            o_rd = 5'b0;
            o_sa = 5'b0;
            o_imm = i_instr[15:0];
            o_addr = 26'b0;
        end
    endcase

    if(o_opcode == 6'b000000) begin                                         // Can be R type or R with Jump -> Check funct

        o_funct = i_instr[5:0];
        if(o_function == 6'b001000 || o_function == 6'b001001) begin        // Is R/J type but with Jump ( JR or JALR )
            o_rs        = i_instr[25:21];
            o_rt        = 5'b0;
            o_rd        = 5'b0;   // Corregir salida del registro (debe respetar el formato tipo R) 
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
        o_immediate = i_instr[15:0];                                        // Also used for branch offset
        o_addr      = 26'b0;
    end
end

                                //// Levantar flag de excepcion de instruccion no reconocida (ver ALU y AGU)
endmodule
*/