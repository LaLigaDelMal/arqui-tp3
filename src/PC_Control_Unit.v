`timescale 1ns / 1ps

module PC_Control_Unit (
    input wire i_flg_jump,
    input wire i_flg_branch,
    input wire i_flg_equal,
    input wire i_rslt_lsb,
    output reg o_pc_mux_ctrl
);  
    reg should_branch;

    always @(*) begin
        should_branch = ((i_flg_equal & i_rslt_lsb) | (~i_flg_equal & ~i_rslt_lsb));
        o_pc_mux_ctrl = (should_branch & i_flg_branch) | i_flg_jump;
    end

endmodule
