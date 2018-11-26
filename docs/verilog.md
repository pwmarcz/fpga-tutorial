---
title: Verilog basics
---

# Verilog basics

We'll be working in the `verilog` directory.

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

    make run V=adder_tb.v

To run `adder.v` and view the results in GTKWave, use:

    make sim V=adder_tb.v

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

Finally, use the adders to construct a 4-bit adder:

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

What does it do?

- Hint: Analyze what happens when Clock = 0, then when Clock changes to 1,
  then when clock stays at 1 and Data changes.
- Spoilers:
  - [Clock = 0, Data = D](dff1.png)
  - [Clock = 1, Data = D](dff2.png)
  - [Clock = 1, Data = 0](dff3-0.png)
  - [Clock = 1, Data = 1](dff3-1.png)

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

<script type="WaveDrom">
{signal: [
  {name: 'clk', wave:   'p............'},
  {name: 'en',  wave:   '0..1.......0.'},
  {name: 'rst', wave:   '10...10......'},
  {name: 'count', wave: "x3..44344444.", data: ["0", "1", "2", "0", "1", "2", "3", "4", "5"]}
]}
</script>

## Clock divider

Given a clock signal, output a clock signal that is 4 times slower.

    module clock_divider(input wire clk_in,
                         output wire clk_out);

In other words, we should get:

<script type="WaveDrom">
{
  "signal" : [
    { "name": "clk_in", "wave": "p..........." },
    { "name": "clk_out", "wave": "p..", period: 4 },
  ]
}
</script>

Can you do the same, but 1024 times slower? (1024 = 2 to the 10th power, or
`1 << 10`).

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

<script type="WaveDrom">
{
  "signal" : [
    { "name": "clk", "wave":    "p............." },
    { "name": "go", "wave":     "0.1.....0....." },
    { "node": "...a..b..c..d"},
    { "name": "red",    "wave": "1.....0.....1." },
    { "name": "yellow", "wave": "0..1..0..1..0." },
    { "name": "green",  "wave": "0.....1..0...." }
  ],
  edge: [
    "a<->b 3 cycles", "c<->d 3 cycles"
  ]
}
</script>

## Parallel to serial

Write a module that receives an 8-bit value and converts it to single bits.

    module serial(input wire clk,
                  input wire in,
                  input wire [7:0] data,
                  output wire ready,
                  output wire out);

- Normally, `out` should be 0.
- The user should raise `in` to 1 for a single cycle, and set `data` to a
  desired value in the same cycle. After that, `in` will go back to 0.
- Then, during the following 8 cycles, `out` should contain consecutive bits
  of `data` (highest to lowest).
- After that, `out` should go back to 0.
- `ready` should be 1 whenever we're not sending, and 0 when we're sending.

<script type="WaveDrom">
{config: {hscale: 2},
 signal: [
  {name: 'clk', wave:   'p...........'},
  {name: 'in',  wave:   '010.........'},
  {name: 'data',  wave:   'x=x.........', data: ["10101101"]},
  {},
   {name: 'ready', wave: "1.0.......1."},
   {name: 'out', wave: "0.10101.010."},
]}
</script>

## Memory module

Implement a 256-byte memory module with read and write ports.

    module memory(input wire clk,
                  input wire ren,
                  input wire [7:0] raddr,
                  output reg [7:0] rdata,
                  input wire wen,
                  input wire [7:0] waddr,
                  input wire [7:0] wdata);

- When `ren` (read enable) is set, in the next cycle set `rdata` to the byte at
  `raddr` address.
- When `wen` (write enable) is set, in the next cycle set the byte at `waddr`
  address to `wdata`.
- Both operations (read and write) can happen in the same cycle.

Write a test bench. What will be the result of reading uninitialized memory?
How to initialize the memory to 0?

Hint: You can use a `$display` statement to print debug messages while the
module is working (for instance, `"Storing byte XX at address YY"`).

## Links

- [Verilog cheatsheet](https://www.cl.cam.ac.uk/teaching/0910/ECAD+Arch/files/verilogcheatsheet.pdf) (PDF)
- [HDLBits](https://hdlbits.01xz.net/wiki/Problem_sets) - online, interactive Verilog exercises
- [Verilog Beginner's Tutorial](http://zipcpu.com/tutorial/) by ZipCPU author
