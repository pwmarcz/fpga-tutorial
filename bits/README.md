# Bit operations exercises

Here are a few exercises on bit operations.

## Running the solutions

Edit `exercises.py`. Then load the code in Python interpreter:

    python3 -i exercises.py

    >>> hex(replace_lowest_byte(0xabcd, 12))
    '0x0'

## Running the tests

I recommend `pytest`. You can install it using:

    pip3 install --user pytest

Then just run:

    pytest --doctest-modules -v exercises.py

This will run all the examples in the file.

### Cheatsheet

    and: a & b
    or:  a | b
    xor: a ^ b
    not: ~a

    shift left:  a << b
    shift right: a >> b

You can write the numbers as hexadecimal and binary:

    0x12EF, 0xabcd, 0b10101010

Octal (`Oo666`) is also supported but you shouldn't need it.

Printing the numbers to hexadecimal and binary:

    >>> hex(127)
    0x7f

    >>> bin(42)
    0b101010

You can also insert _ for readability:

    0b1010_1111_0000_0001

### Useful links

- [Bit Manipulation](https://www.youtube.com/watch?v=7jkIUgLC29I) video by Make
  School
- [HackerEarth: Basics of bit manipulation](https://www.hackerearth.com/practice/basic-programming/bit-manipulation/basics-of-bit-manipulation/tutorial/)
