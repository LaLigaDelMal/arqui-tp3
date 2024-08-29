`timescale 1ns / 1ps

module ALU(

    input wire [3:0] i_opcode,
    input wire [31:0] i_op_A,
    input wire [31:0] i_op_B,
    output wire [31:0] o_rslt,
    output wire o_zero,
    output wire o_carry,
    output wire o_ovfl_exception
    );

    reg [32:0] result;
    reg overflow;

    always @ (i_op_code, i_op_A, i_op_B) begin
        case (i_op_code)
                4'b0000: begin                                                         // LSR
                        result = i_op_A >> i_op_B[4:0];
                end
                4'b0001: begin                                                         // LSL
                        result = i_op_A << i_op_B[4:0];
                end
                4'b0010: begin                                                         // ASR
                        result = $signed(i_op_A) >>> i_op_B[4:0];
                end
                4'b0011: begin                                                         // Passthrough of source A
                        result = i_op_A;
                end
                4'b0100: begin                                                         // UADD
                        result = i_op_A + i_op_B;
                end
                4'b0101: begin                                                         // USUB
                        result = i_op_B - i_op_A;                                      // Subtraction is done in reverse order to avoid using more flags to select the ALU input in the Control unit
                end
                4'b0110: begin                                                         // AND
                        result = i_op_A & i_op_B;
                end
                4'b0111: begin                                                         // OR
                        result = i_op_A | i_op_B;
                end
                4'b1000: begin                                                         // XOR
                        result = i_op_A ^ i_op_B;
                end
                4'b1001: begin                                                         // NOR
                        result = ~(i_op_A | i_op_B);
                end
                4'b1010: begin                                                         // GT
                        result = ($signed(i_op_A) > $signed(i_op_B)) ? 1 : 0;
                end
                4'b1011: begin                                                         // CMP
                        result = (i_op_A == i_op_B) ? 1 : 0;
                end
                4'b1100: begin                                                         // ADD
                        result = $signed(i_op_A) + $signed(i_op_B);
                        overflow = (i_op_A[31] ^ i_op_B[31]) ? 0 : (result[31] != i_op_A[31]);
                end
        endcase
    end

    assign o_rslt = result;
    assign o_zero = ~|result;
    assign o_carry = result[32];
    assign o_ovfl_exception = overflow;

endmodule