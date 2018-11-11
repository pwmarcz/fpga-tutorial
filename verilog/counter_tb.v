`include "counter.v"

module Top;
  reg clk = 1;
  reg en = 0;
  reg rst = 0;
  wire [3:0] count;

  counter c(clk, en, rst, count);

  initial
    forever #1 clk = ~clk;

  initial
    begin
      $monitor($time, " clk = %b, en = %b, rst = %b, count = %b",
               clk, en, rst, count);
      $dumpfile("counter_tb.vcd");
      $dumpvars;

      #4 en = 1; rst = 0;
      #8 en = 1; rst = 1;
      #2 en = 1; rst = 0;
      #6 en = 0; rst = 0;
      #2 $finish;
    end
endmodule // Top
