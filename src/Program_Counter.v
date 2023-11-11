`timescale 1ns / 1ps

module Program_Counter (
    input wire clk,
    input wire rst,
    input wire i_en,                        // Enable control signal
    input wire [31:0] i_jump_trgt,          // Target address for jump
    input wire i_jump_en,                   // Jump control signal
    input wire [31:0] i_pc,                 // Input program counter (for exceptions, etc.)
    output wire [31:0] o_pc                 // Output program counter
);

reg [31:0] current_pc;

initial begin
    current_pc = 32'h00000;  // Initialize PC to 0
end

always @(posedge clk) begin   // ATENCION: POSEDGE
    if (rst || !i_en) begin
        current_pc <= 32'b00000;  // Reset PC to 0
    end else begin
        if (i_en) begin
            if (i_jump_en) 
                current_pc <= i_jump_trgt;
            else 
                current_pc <= i_pc; 
        end
    end
end

assign o_pc = current_pc;

endmodule

