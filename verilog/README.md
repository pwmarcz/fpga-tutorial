# Verilog basics

To run `adder.v`, use:

    make run-adder

To run `adder.v` and view the results in GTKWave, use:

    make sim-adder

## Adder

### On paper

Let's say we have `not`, `and`, `or`, `xor`, etc. Try to draw a half-adder. A
half-adder is a component that adds 2 bits (`x`, `y`), and outputs a sum (`s`)
and a carry bit (`c_out`):

    x  y    s c_out

    0  0    0  0
    0  1    1  0
    1  0    1  0
    1  1    0  1

Now, use half-adders to construct an adder. An adder adds two bits and a carry-in (`c_in`):

    x  y c_in   s c_out

    0  0  0     0  0
    0  0  1     1  0
    0  1  0     1  0
    0  1  1     0  1
    1  0  0     1  0
    1  0  1     0  1
    1  1  0     0  1
    1  1  1     1  1

Finally, use the adders to add a 4-bit number:

     x     y      s    c

    0000  0000   0000  0
    0000  0001   0001  0
    ...
    1001  0011   1100  0
    ...
    1111  0001   0000  1
    ...
    1111  1111   1110  1

### In Verilog

Now, implement the same (half-adder, adder, and 4-bit adder) in `adder.v`,
using Verilog. You can run the program and print values to test it.

Later, check that you can do the same using an arithmetic expression: `assign s = x + y`.

## Data flip-flop (DFF)

Here is a D flip-flop:

![Edge triggered D flip flop](https://en.wikipedia.org/wiki/File:Edge_triggered_D_flip_flop.svg)

What does it output? Draw a table.

Implement it and test it in Verilog using primitive components (`nand` gates).

Now implement the same using a `reg` and `always @(posedge clock)`.

## Counter

Implement a counter:

    module counter(input wire clk,
                   input wire en,
                   input wire rst,
                   output wire [7:0] count);

The counter should increase on a positive clock edge whenever `en` (enable) is
set, and reset to 0 whenever `rst` (reset) is set.
