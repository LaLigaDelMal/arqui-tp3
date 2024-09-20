`timescale 1ns / 1ps


module Registers(

    input wire i_clk,
    input wire i_rst,
    input wire [4:0] i_rs_sel,
    input wire [4:0] i_rt_sel,
    input wire [4:0] i_rd_sel,
    input wire i_wr_en,
    input wire [31:0] i_wr_data,
    
    output reg [31:0] o_rs_data,
    output reg [31:0] o_rt_data
    
    );

    reg [31:0] zero_reg = 0;
    reg [31:0] reg_file [30:0];
    integer i;

    
    // Escritura
    always @(negedge i_clk) begin
        if (i_rst) begin
            for (i = 0; i < 31; i = i + 1) begin
                reg_file[i] <= 0;
            end
        end else begin
            if (i_wr_en) begin
                reg_file[i_rd_sel] <= i_wr_data;
            end
        end
    end

    // Lectura
    always @(*) begin
        if (i_rs_sel == 0) begin
            o_rs_data <= zero_reg;
        end else begin
            o_rs_data <= reg_file[i_rs_sel];
        end

        if (i_rt_sel == 0) begin
            o_rt_data <= zero_reg;
        end else begin
            o_rt_data <= reg_file[i_rt_sel];
        end
    end

endmodule