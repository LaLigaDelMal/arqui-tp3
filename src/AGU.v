`timescale 1ns / 1ps

module AGU(

        input wire [2:0] i_opcode,
        input wire [31:0] i_addr,
        input wire [25:0] i_offset,
        output wire [31:0] o_eff_addr,
        output wire [1:0] o_addr_exception
    );

    reg [31:0] effective_address;
    reg [31:0] sign_ext_offset;
    reg [1:0] exception;

    always @ (i_op_code, i_addr, i_offset) begin
        case (i_op_code)
            3'b000: begin                                                         // Effective address from RS
                effective_address = i_addr                                        // This is supposed to be the value of the register RS (not considering any other address inputs)
                exception = {effective_address[1], effective_address[0]};
            end
            3'b001: begin                                                         // Effective address given base and a 16-bit signed offset
                sign_ext_offset = {{16{ i_offset[15]}}, i_offset[15:0]};
                effective_address = i_addr + $signed(sign_ext_offset);
                exception = {effective_address[1], effective_address[0]};         // TODO: Check if flag is reset after changing inputs
            end
            3'b010: begin                                                         // 16 bits signed offset shifted 2 bits is added to the address
                sign_ext_offset = {{14{ i_offset[15]}}, i_offset[15:0], 2'b0};
                effective_address = i_addr + $signed(sign_ext_offset);
            end
            3'b011: begin                                                         // 26 bits offset shifted 2 bits and completing the lower part of the address
                effective_address = {i_addr[31:28], i_offset, 2'b0};
            end
        endcase
    end

    assign o_eff_addr = effective_address;
    assign o_addr_exception = exception;

endmodule