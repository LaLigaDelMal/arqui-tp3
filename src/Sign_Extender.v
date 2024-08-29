`timescale 1ns / 1ps

module Sign_Extender
    #(
        parameter NBITS = 32
    )
    (
        input   wire    [16-1:0]         i_inmediate,
        input   wire    [1:0]            i_mode,
        output  wire    [NBITS-1:0]      o_result
    );
    
    reg [NBITS-1:0] result;
                
    
    always @ (*)
        begin:
            case(i_mode)
                2'b00: result <= {{16{i_inmediate[16-1]}}, i_inmediate}; // Extend the sign of the inmediate to a full word
                2'b01: result <= {{16{1'b0}}, i_inmediate};              // Complete the upper part of the word with zeros
                2'b10: result <= {i_inmediate,{16{1'b0}}};               // Complete the lower part of the word with zeros
            endcase
        end

    assign o_result = result;

endmodule