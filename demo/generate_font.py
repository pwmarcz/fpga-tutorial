# Dump 8x8 font as vertical (1 byte 1 column) hex format.
# Bitmap font taken from: http://pelulamu.net/unscii/

fname = 'unscii-8-thin.hex'

font = {}

with open(fname, 'r') as f:
    for line in f:
        num, bits = line.split(':')
        font[num] = bits.strip()

for i in range(0x20, 0x80):
    bits = font['%04X' % i]
    row_data = [int(bits[i:i+2], 16) for i in range(0, len(bits), 2)]
    col_data = []
    for i in range(8):
        col = [(row_byte >> (7-i)) & 1 for row_byte in row_data]
        col_byte = sum(col[j] * (1<<j) for j in range(8))
        col_data.append(col_byte)

    print(' '.join('%02X' % col_byte for col_byte in col_data))
