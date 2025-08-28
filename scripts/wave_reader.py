# def parse_uart(filename, baud_rate=9600):
#     bit_time_ps = int(1e12 / baud_rate)  # Tiempo de un bit en ns (≈ 104167 ns para 9600 bps)
#     samples = []

#     # Leer archivo de salida
#     with open(filename, "r") as f:
#         for line in f:
#             if not line.strip():
#                 continue
#             time_str, tx_str = line.strip().split()
#             time = int(time_str)
#             tx = int(tx_str)
#             samples.append((time, tx))

#     # Buscar bordes de bajada (start bit)
#     uart_bytes = []
#     i = 1
#     while i < len(samples):
#         prev_tx = samples[i - 1][1]
#         curr_tx = samples[i][1]

#         if prev_tx == 1 and curr_tx == 0:
#             start_time = samples[i][0]

#             bits = []
#             for bit_index in range(10):  # 1 start, 8 data, 1 stop
#                 sample_time = start_time + int((bit_index + 0.5) * bit_time_ps)

#                 # Buscar la muestra más cercana en el tiempo
#                 closest = min(samples, key=lambda x: abs(x[0] - sample_time))
#                 bits.append(closest[1])

#             if bits[0] != 0 or bits[-1] != 1:
#                 print("⚠️  Trama inválida detectada (start/stop incorrecto)")
#                 i += 1
#                 continue

#             # Decodificar byte
#             data_bits = bits[1:-1]
#             byte = 0
#             for j, bit in enumerate(data_bits):
#                 byte |= (bit << j)
#             uart_bytes.append(byte)

#             # Saltar 10 bits en tiempo
#             i += int(10 * bit_time_ps / (samples[1][0] - samples[0][0]))  # pasos en índice
#         else:
#             i += 1

#     return uart_bytes

# # Usar la función
# decoded_bytes = parse_uart(r"c:\Users\adrie\Desktop\mips\mips.sim\sim_1\behav\xsim\uart_tx_output_2.txt")
# print("📥 Bytes recibidos:", decoded_bytes)
# print("🔤 Texto recibido:", ''.join(chr(b) for b in decoded_bytes))

def parse_uart(filename, baud_rate=9600):
    bit_time_ps = int(1e12 / baud_rate)  # Tiempo de un bit en picosegundos
    samples = []

    # Leer archivo de salida
    with open(filename, "r") as f:
        for line in f:
            if not line.strip():
                continue
            time_str, tx_str = line.strip().split()
            time_ps = int(time_str)
            tx = int(tx_str)
            samples.append((time_ps, tx))

    # Buscar bordes de bajada (start bit)
    uart_bytes = []
    i = 1
    while i < len(samples):
        prev_tx = samples[i - 1][1]
        curr_tx = samples[i][1]

        if prev_tx == 1 and curr_tx == 0:
            start_time_ps = samples[i][0]

            bits = []
            for bit_index in range(10):  # 1 start, 8 data, 1 stop
                sample_time_ps = start_time_ps + int((bit_index + 0.5) * bit_time_ps)

                # Buscar la muestra más cercana en el tiempo
                closest = min(samples, key=lambda x: abs(x[0] - sample_time_ps))
                bits.append(closest[1])

            # Validar start y stop bits
            if bits[0] != 0 or bits[-1] != 1:
                print("⚠️  Trama inválida detectada (start/stop incorrecto)")
                i += 1
                continue

            # Decodificar byte
            data_bits = bits[1:-1]
            byte = 0
            for j, bit in enumerate(data_bits):
                byte |= (bit << j)
            uart_bytes.append(byte)

            # Saltar en tiempo 10 bits (para evitar sobrelectura de la misma trama)
            # Asumimos muestreo constante, así que estimamos el siguiente índice
            ps_step = samples[1][0] - samples[0][0]
            i += int(10 * bit_time_ps / ps_step)
        else:
            i += 1

    return uart_bytes

# Usar la función
decoded_bytes = parse_uart(r"c:\Users\adrie\Desktop\mips\mips.sim\sim_1\behav\xsim\uart_tx_output_2.txt")
print("📥 Bytes recibidos:", decoded_bytes)
print("🔢 Hex recibido:", ' '.join(f'0x{b:02X}' for b in decoded_bytes))
