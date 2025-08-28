`timescale 1ns / 1ps

//// Stalls necesarios para el pipeline
// Loads
// Branches y Jumps


//- Cuando el LOAD pasa a la etapa MA se mete el stall en la etapa de EX.
//- El stall solo debe meterse si la instruccion que sigue al load usa el registro en el que se va a cargar el valor de memoria.
//- Para los branches no haría falta meter stall ya que la direccion de memoria a saltar y la decisión del salto se calculan en la misma etapa (EX). Solo se tiene que se va a ejecutar el delay slot. El stall en el simulador no se debe a el caluclo del valor del ADDI (para eso se tiene el forwarding) sino a que calculan la direccion de memoria en la etapa de ID.
//- Para las instrucciones JR, JALR se deben ejecutar tres stalls cuando la instruccion anterior modifica el registro que contiene la direccion a saltar.


module Hazard_Unit(
    input wire [4:0] i_rd_EX, i_rt_EX,
    input wire [4:0] i_rd_MA, i_rt_MA,
    input wire [4:0] i_rd_WB, i_rt_WB,
    input wire       i_reg_wr_EX,
    input wire       i_reg_wr_MA,
    input wire       i_reg_wr_WB,
    input wire       i_flg_WB_src_EX,
    input wire       i_flg_mem_op_EX,
    input wire [4:0] i_rs_ID, i_rt_ID,
    input wire       i_flg_jmp_trg_reg,
    input wire       i_flg_halt,
    output reg       o_hazard_detected
);

    initial begin
        o_hazard_detected <= 0;
    end

    wire load_in_EX = ~i_flg_WB_src_EX & i_flg_mem_op_EX;
    wire reg_shr_in_EX = ((i_rs_ID == i_rt_EX) | (i_rs_ID == i_rd_EX) | (i_rt_ID == i_rt_EX) | (i_rt_ID == i_rd_EX)) & i_reg_wr_EX;
    wire reg_shr_in_MA = ((i_rs_ID == i_rt_MA) | (i_rs_ID == i_rd_MA) | (i_rt_ID == i_rt_MA) | (i_rt_ID == i_rd_MA)) & i_reg_wr_MA;
    wire reg_shr_in_WB = ((i_rs_ID == i_rt_WB) | (i_rs_ID == i_rd_WB) | (i_rt_ID == i_rt_WB) | (i_rt_ID == i_rd_WB)) & i_reg_wr_WB;

    wire stall_for_load = load_in_EX & reg_shr_in_EX;
    wire stall_for_jump_reg = i_flg_jmp_trg_reg & (reg_shr_in_EX | reg_shr_in_MA | reg_shr_in_WB);

    always @ (*) begin
        if (stall_for_load | stall_for_jump_reg) begin
            o_hazard_detected <= 1;
        end else if (i_flg_halt) begin
            o_hazard_detected <= 1;
        end else begin
            o_hazard_detected <= 0;
        end
    end

endmodule
