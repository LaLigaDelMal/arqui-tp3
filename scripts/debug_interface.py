import serial
from time import sleep

#### Comandos que se pueden enviar
LOAD=bytes([0b01101100])
RUN=bytes([0b01110010])
STEP=bytes([0b01110011])
NEXT=bytes([0b01101110])

REPORT_SIZE_BYTES = 392
PROGRAM_FILE_PATH = "./assembled.hex"

def parse_debug_data(data: bytes):
    # Convert bytes to HEX
    data = data.hex()
    # Split HEX string into list of HEX values
    pc = data[0:8]
    cycles_count = data[8:16]
    registers = [data[i:i+8] for i in range(16, 272, 8)]
    memory = [data[i:i+8] for i in range(272, 784, 8)]
    return {
        "pc": pc,
        "cycles_count": cycles_count,
        "registers": registers,
        "memory": memory
    }

def read_program() -> bytes:
    with open(PROGRAM_FILE_PATH, "r") as file:
        data = file.read()
        data = data.replace("\n", "")
    return data.encode()


class SerialInterface:
    def __init__(self):
        self.ser = serial.Serial(
            port='/dev/ttyUSB0',
            baudrate=9600,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=1
        )
        sleep(2)
        print("Connected to serial port")

    def send_data(self, data):
        self.ser.write(data)

    def receive_data(self):
        data = self.ser.read(REPORT_SIZE_BYTES)
        return data

    def close(self):
        self.ser.close()


if __name__ == "__main__":
    serial_port = SerialInterface()

    # Parse interactive commands from user
    while True:
        command = input("Enter command: ")
        if command == "exit":
            break
        elif command == "l":
            serial_port.send_data(LOAD)
            serial_port.send_data(read_program())
        elif command == "r":
            serial_port.send_data(RUN)
            data = serial_port.receive_data()
            print(parse_debug_data(data))
        elif command == "s":
            serial_port.send_data(STEP)
            data = serial_port.receive_data()
            print(parse_debug_data(data))
        elif command == "n":
            serial_port.send_data(STEP)
            data = serial_port.receive_data()
            print(parse_debug_data(data))
        else:
            print("Command not recognized")
