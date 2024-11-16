`timescale 1ns / 1ps

//// Stalls necesarios para el pipeline
// Loads
// Branches y Jumps


//- Cuando el LOAD pasa a la etapa MA se mete el stall en la etapa de EX.
//- El stall solo debe meterse si la instruccion que sigue al load usa el registro en el que se va a cargar el valor de memoria.
//- Para los branches no haría falta meter stall ya que la direccion de memoria a saltar y la decisión del salto se calculan en la misma etapa (EX). Solo se tiene que se va a ejecutar el delay slot. El stall en el simulador no se debe a el caluclo del valor del ADDI (para eso se tiene el forwarding) sino a que calculan la direccion de memoria en la etapa de ID.
//- Para las instrucciones JR, JALR se deben ejecutar tres stalls cuando la instruccion anterior modifica el registro que contiene la direccion a saltar.


module Hazard_Unit(
    input wire [4:0] i_rt_EX,
    input wire       i_flg_WB_src_EX,
    input wire       i_flg_mem_op_EX,
    input wire [4:0] i_rs_ID, i_rt_ID, 
    output reg       o_hazard_detected
);

    initial begin
        o_hazard_detected <= 0;
    end

    always @ (*) begin
        if (~i_flg_WB_src_EX & i_flg_mem_op_EX) begin     // Detect LOAD instruction in EX
            if (i_rt_EX == i_rs_ID | i_rt_EX == i_rt_ID) begin
                o_hazard_detected <= 1;
            end else begin
                o_hazard_detected <= 0;
            end
        end else begin
            o_hazard_detected <= 0;
        end
    end

endmodule