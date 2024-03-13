`timescale 1ns / 1ps

module Program_Counter #(
    parameter   NBIT = 32
)(
    input wire              i_clk,
    input wire              i_rst,
    input wire              i_wr_en,              // PC Write enable
    input wire              i_jump_en,
    input wire  [NBIT-1:0]  i_jump_addr,          // Target address for jump
    input wire  [NBIT-1:0]  i_pc,                 // Input program counter (for exceptions, etc.)
    output wire [NBIT-1:0]  o_pc
    output wire [NBIT-1:0]  o_pc_4
    output wire [NBIT-1:0]  o_pc_8
);

reg [NBIT-1:0] current_pc;

//initial begin
//    current_pc = {NBITS{1'b0}};                 // Initialize PC to 0
//end

always @(negedge clk) begin                 // ATENCION: POSEDGE
    if ( i_rst ) begin
        current_pc <= {NBITS{1'b0}};            // Reset PC to 0
    end 

    else begin
        if ( i_wr_en ) begin
            if (i_jump_en) 
                current_pc <= i_jump_addr;
            else 
                current_pc <= current_pc+4; 
        end
    end
end

assign o_pc     = current_pc;
assign o_pc_4   = current_pc + 4;
assign o_pc_8   = current_pc + 8;

endmodule

