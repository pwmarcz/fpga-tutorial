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

## Adders

### On paper

Let's design a 4-bit adder. The adder will have the following ports:
- input numbers (4 bit): `x`, `y`,
- carry-in: `c_in`,
- sum (4 bit): `s`,
- carry-out: `c_out`.

How to connect two 4-bit adders to produce an 8-bit adder?

Now, let's try to design the same for BCD ([binary-coded
decimals](https://en.wikipedia.org/wiki/Binary-coded_decimal)). What kind of
inputs and outputs we'll have? What kind of logic?

### In Verilog

In `adder.v`, there is a 4-bit and 8-bit adder implemented. Try running the
testbench (`make run V=adder_tb.v`) and see the values. Try to also view the
waveform (`make sim V=adder_tb.v`).

Now, try to implement a BCD adder. Test it using the provided testbench.

## Latch and flip-flop

Let's go back to [NAND game](http://www.nandgame.com/) and examine latch and
data flip-flop.

There is a simple data flip-flop (DFF) implemented in `dff.v`. Let's read it.

Modify the testbench (`dff_tb.v`) to check if it works as it should.

Now, create a data flip-flop with an `en` (enable) input. The value should
change only if `en` is set to 1. Test it using the provided testbench.

```verilog
module dff_en(input wire clk,
              input wire en,
              input wire data,
              output wire out);
```

## Counter

Implement a counter:

```verilog
module counter(input wire clk,
               input wire en,
               input wire rst,
               output reg [3:0] count);
```

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

```verilog
module clock_divider(input wire clk_in,
                     output wire clk_out);
```

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

```verilog
module traffic(input wire clk,
               input wire go,
               output wire red,
               output wire yellow,
               output wire green);
```

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

```verilog
module serial(input wire clk,
              input wire in,
              input wire [7:0] data,
              output wire ready,
              output wire out);
```

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

```verilog
module memory(input wire clk,
              input wire ren,
              input wire [7:0] raddr,
              output reg [7:0] rdata,
              input wire wen,
              input wire [7:0] waddr,
              input wire [7:0] wdata);
```

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
