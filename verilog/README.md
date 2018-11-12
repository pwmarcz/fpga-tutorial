# Verilog basics

## Prerequisites

You will need the following:

- An editor that understands Verilog. Atom or Sublime Text should be fine.
- [Icarus Verilog](http://iverilog.icarus.com/). Your system should have it
  packaged:
    - `apt install iverilog`
    - `brew install icarus-verilog`
    - ...
- Optionally [GTKWave](http://gtkwave.sourceforge.net/). This should also be
  available from your system.

## Makefile targets

To run `adder_tb.v`, use:

    make run-adder

To run `adder.v` and view the results in GTKWave, use:

    make sim-adder_tb

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
using Verilog.

You can run the test-bench (`adder_tb.v`) and print values to test the adder.

Later, check that you can do the same using an arithmetic expression: `assign s = x + y`.

## SR (NAND) latch

![SR latch](https://upload.wikimedia.org/wikipedia/commons/9/92/SR_Flip-flop_Diagram.svg)

What does it do? Draw a table, it will help with the next exercise.

Optionally: implement and test in Verilog.

## Data flip-flop (DFF)

Here is a D flip-flop:

![Edge triggered D flip flop](https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Edge_triggered_D_flip_flop.svg/448px-Edge_triggered_D_flip_flop.svg.png)

What does it output? Draw a table.

Implement it and test it in Verilog using primitive components (`nand` gates).

Now implement the same using a `reg` and `always @(posedge clock)`.

## Counter

Implement a counter:

    module counter(input wire clk,
                   input wire en,
                   input wire rst,
                   output reg [3:0] count);

You can use the provided `counter.v` and `counter_tb.v`.

The counter should increase on a positive clock edge whenever `en` (enable) is
set, and reset to 0 whenever `rst` (reset) is set:

![counter wave](counter.png)

## Traffic light controller

    module traffic(input wire clk,
                   input wire go,
                   output wire red,
                   output wire yellow,
                   output wire green);

You can use the provided `traffic.v` and `traffic_tb.v`.

- Initially, the `red` light should be lit (1).
- When `go` is set to 1, you should light up `red` and `yellow` for 3 cycles,
  then switch to `green`.
- When `go` is set back to 0, you should light `yellow` for 3 cycles, then
  switch to `red`.

![traffic wave](traffic.png)

## Other exercises

- **Clock divider**: Given a clock signal, output a slower clock signal that
  changes every 1024 (`1 << 10`) cycles.
- **Shift register**: Output the bits from input wire, delayed by 8 clock
  cycles.
- (TODO describe) **SPI transmit module**: Given a byte, transmit it as a
  series of bits.
- (TODO describe) **Memory module**: Implement a 256-byte memory with separate
  read and write ports.

## Links

- [Verilog cheatsheet](https://www.cl.cam.ac.uk/teaching/0910/ECAD+Arch/files/verilogcheatsheet.pdf) (PDF)
