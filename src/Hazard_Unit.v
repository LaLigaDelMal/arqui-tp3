`timescale 1ns / 1ps

//// Stalls necesarios para el pipeline
// Loads
// Branches y Jumps


// Recordatorio: Modificar la esta de decode para que impida la escritura en reg y mem (ver grafico del turco)

// Implementar el forwarding para los Stores (no hace falta ningun stall, el turco menciona los ST en la unidad de hazard puede que sea para descartar esos casos)

module Hazard_Unit(
    output reg o_hazard_detected
);

    initial begin
        o_hazard_detected <= 0;
    end

    always @ (*) begin
        o_hazard_detected <= 0;
    end

endmodule