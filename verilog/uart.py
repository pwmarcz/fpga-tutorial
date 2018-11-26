
# pip3 install --user pyserial
# https://pyserial.readthedocs.io/en/latest/pyserial_api.html
import serial

baud_rate = 9600
timeout = 0.2

with serial.Serial('/dev/ttyUSB1', baud_rate, timeout=timeout) as ser:
    try:
        while True:
            data = ser.read(20)
            print(data.decode('ascii'), end='', flush=True)
    except KeyboardInterrupt:
        print()
        print('Interrupted')
