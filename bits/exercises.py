
'''
You can run all the examples below using:

    pytest --doctest-modules -v exercises.py
'''


def combine_two_bytes(b1, b2):
    '''
    Combine two bytes into a word:

    >>> hex(combine_two_bytes(0xff, 0x12))
    '0xff12'

    >>> hex(combine_two_bytes(0, 0x32))
    '0x32'
    '''

    return 0


def split_ip_address(ip):
    '''
    Split a 4-byte number (IP address) into four numbers.

    >>> split_ip_address(0xc0a80164)
    (192, 168, 1, 100)

    >>> split_ip_address(0x7f000001)
    (127, 0, 0, 1)

    >>> split_ip_address(0x08080808)
    (8, 8, 8, 8)
    '''

    return (0, 0, 0, 0)


def flip_bit(a, n):
    '''
    Flip the Nth bit in a number (where 0 is the least significant bit).

    >>> bin(flip_bit(0b11111, 1))
    '0b11101'

    >>> bin(flip_bit(0b10000, 2))
    '0b10100'
    '''

    return 0


def clear_bit(a, n):
    '''
    Clear the Nth bit in a number (where 0 is the least significant bit).

    >>> bin(clear_bit(0b11111, 1))
    '0b11101'

    >>> bin(clear_bit(0b11011, 2))
    '0b11011'
    '''

    return 0


def count_bits(a):
    '''
    Count how many bits are set in a number.

    >>> count_bits(0)
    0

    >>> count_bits(0x7FFF)
    15

    >>> count_bits(0b101010)
    3
    '''

    return 0


def replace_lowest_byte(a, b):
    '''
    Replace the lowest byte of a with b.

    >>> hex(replace_lowest_byte(0xabcd, 0))
    '0xab00'

    >>> hex(replace_lowest_byte(0xabcd, 0x12))
    '0xab12'
    '''

    return 0


def bit_mask(n):
    '''
    Return a number consisting of 1s in N lowest positions.

    >>> bin(bit_mask(4))
    '0b1111'

    >>> bin(bit_mask(7))
    '0b1111111'
    '''

    return 0


def n_lowest(a, n):
    '''
    Truncate a number to N lowest bits.

    >>> bin(n_lowest(0b100100, 3))
    '0b100'

    >>> hex(n_lowest(0xdeadbeef, 16))
    '0xbeef'
    '''

    return 0
