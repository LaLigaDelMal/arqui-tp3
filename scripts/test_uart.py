import serial
from time import sleep
import os

LOAD=bytes([0b01101100])

class SerialInterface:
    def __init__(self):
        port = None
        if os.name == 'nt':
            port = 'COM6'
        else:
            port = '/dev/ttyUSB0'
            
        self.ser = serial.Serial(
            port=port,
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
        data = self.ser.read(1)
        return data

    def close(self):
        self.ser.close()


if __name__ == "__main__":
    serial_port = SerialInterface()
    while True:
        serial_port.send_data(LOAD)
        data = serial_port.receive_data()
        print("data:", data)
