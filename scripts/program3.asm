# Inicializamos registros
ORI    R1, R0, 10            # R1 = 5
NOP
NOP
# --- Branch + delay slot (ejecutar sí o sí) ---
BEQ    R1, R0, 1            # Branch taken (R1 == R1)
ORI    R2, R1, 2            # Esto se ejecuta pero da 7 en vez de 2, teoria: puede embromar el forwarding
ORI    R3, R0, 3            # Esto se ejecuta pero no deberia, ademas tambien da 7
ORI    R4, R0, 4
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
ORI    R4, R0, 6            # R1 = 5
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
