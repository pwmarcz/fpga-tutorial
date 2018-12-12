# pip3 install --user pyserial
# python3 play_video.py < bad_apple.raw

import serial
import sys
import base64
import time

BAUD_RATE = 115300
FPS = 24

t_prev = time.time()
t_frame = 1 / FPS


def rle_encode(frame):
    result = bytearray()
    i = 0
    while i < len(frame):
        n = 0
        while i + n < len(frame) and frame[i] == frame[i + n] and n < 256:
            n += 1
        result.append(n - 1)
        result.append(frame[i])
        i += n
    return result


print('Reading')
rle_frames = []
for line in sys.stdin:
    frame = base64.b64decode(line)
    rle_frames.append(rle_encode(frame))

print('Playing')
with serial.Serial('/dev/ttyUSB1', BAUD_RATE) as ser:
    for rle_frame in rle_frames:
        t = time.time()
        dt = t - t_prev
        if (dt <= t_frame):
            time.sleep(t_frame - dt)
        else:
            print(f'Frame is late by {dt - t_frame} s!')
        t_prev = time.time()

        ser.write(rle_frame)
