# Inicializamos registros
ORI    R1, R0, 5            # R1 = 5
ORI    R2, R0, 10           # R2 = 10

# --- Forwarding: resultado de ADDU usado inmediatamente ---
ADDU   R3, R1, R2           # R3 = R1 + R2 -> 15
ADDU   R4, R3, R2           # R4 = R3 + R2 -> 25 (R3 debería forwardearse)
ADDU   R5, R4, R1           # R5 = R4 + R1 -> 30 (R4 también)

# --- Más forwarding con operación lógica ---
AND    R6, R5, R2           # R6 = R5 & R2 = 30 & 10 = 10
OR     R7, R6, R1           # R7 = R6 | R1 = 10 | 5 = 15

# --- Shift inmediato seguido por shift variable (dependencia) ---
SLL    R8, R1, 2            # R8 = R1 << 2 = 5 << 2 = 20
SLLV   R9, R2, R1           # R9 = R2 << R1 = 10 << 5 = 320

# --- Branch + delay slot (ejecutar sí o sí) ---
BEQ    R1, R1, 8            # Branch taken (R1 == R1)
ADDI   R10, R0, 1           # Delay slot: se ejecuta SIEMPRE
ADDI   R10, R10, 1          # NO se ejecuta si branch salta

# --- Otro branch con delay slot ---
BNE    R2, R1, 8            # Branch taken (10 != 5)
ADDI   R11, R0, 2           # Delay slot: se ejecuta
ADDI   R11, R11, 2          # No se ejecuta si salta

# --- Salto incondicional + delay slot ---
J      64                   # Salta
ADDI   R12, R0, 3           # Delay slot: se ejecuta

# --- Jump & Link para simular llamada a subrutina ---
JAL    80                   # PC+8 -> R31, salta a 80
ADDI   R13, R0, 4           # Delay slot: se ejecuta  (si salto el BEQ, se ejecuta a partir de aquí) por lo que R13 = 4

# --- Numeros magicos en registros para detectar errores ---
ORI    R14, R0, 3735928559   # 0xDEADBEEF
ORI    R15, R0, 3405691582   # 0xCAFEBABE
ORI    R16, R0, 3203383023   # 0xBEEFBEEF
ORI    R17, R0, 3203391148   # 0xBEEFC0DE
ORI    R18, R0, 3203383023   # 0xBEEFBEEF
ORI    R19, R0, 3203383023   # 0xBEEFBEEF
ORI    R20, R0, 3203383023   # 0xBEEFBEEF
