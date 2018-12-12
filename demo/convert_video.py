
# Usage:
#
# sudo apt install ffmpeg youtube-dl
# pip3 install --user ffmpeg-python
#
# youtube-dl ...
# python3 convert_video.py < bad_apple.webm > bad_apple.raw

import base64
import ffmpeg

width = 128
height = 64

out, _ = (
    ffmpeg
    .input('bad_apple.webm')
    .filter('scale', width, -1)
    .filter('crop', width, height)
    .output('pipe:', format='rawvideo', pix_fmt='gray')
    .run(capture_stdout=True)
)

for i in range(0, len(out), width * height):
    frame = out[i:i + width * height]

    frame_bytes = bytearray()
    for y in range(0, height, 8):
        for x in range(width):
            pixels = [
                out[i + (y + j) * width + x]
                for j in range(8)
            ]
            frame_bytes.append(sum(
                int(b > 128) << j
                for j, b in enumerate(pixels)
            ))
    print(base64.b64encode(frame_bytes).decode('ascii'))
