`include "traffic.v"

module Top;
  reg clk = 1;
  reg go = 0;
  wire red, yellow, green;

  traffic t(clk, go, red, yellow, green);

  initial
    forever #1 clk = ~clk;

  initial
    begin
      $monitor($time, " clk = %b, go = %b, red = %b, yellow = %b, green = %b",
               clk, go, red, yellow, green);
      $dumpfile("traffic_tb.vcd");
      $dumpvars;

      #4 go = 1;
      #10 go = 0;
      #10 $finish;
    end
endmodule // Top
