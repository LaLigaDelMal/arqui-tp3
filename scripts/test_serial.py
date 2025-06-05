# Test Serial
# Usar con el programa de simulación para recibir datos UART
# http://com0com.sourceforge.net/ y el programa 'setup command prompt'
# install PortName=COM5 PortName=COM6

import serial

# Configure the serial port (replace COM5 with your actual port)
ser = serial.Serial('COM12', 9600, timeout=1)

received_data = []

print("Listening on COM5... Press Ctrl+C to stop.")

try:
    while True:
        if ser.in_waiting:
            byte = ser.read()  # Read one byte
            hex_byte = byte.hex()
            received_data.append(hex_byte)
            print(f"Received: {hex_byte}")
except KeyboardInterrupt:
    print("\nStopped by user.")

# Optional: print all collected hex values
print("All received bytes (hex):")
print(received_data)

# Optional: Save to file
with open("received_hex.txt", "w") as f:
    f.write(" ".join(received_data))