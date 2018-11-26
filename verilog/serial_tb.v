`include "serial.v"

module Top;
  reg clk = 1;
  reg in = 0;
  reg [7:0] data;
  wire ready;
  wire out;

  serial s(.clk(clk), .in(in), .data(data), .ready(ready), .out(out));

  initial
    forever #1 clk = ~clk;

  initial
    begin
      $monitor($time, " clk = %b, in = %b, data = %b, ready = %b, out = %b",
               clk, in, data, ready, out);
      $dumpfile(`VCD_FILE);
      $dumpvars;

      #2 in <= 1; data <= 8'b10101101;
      #2 in <= 0; data <= 'bx;
      #20 $finish;
    end
endmodule // Top
