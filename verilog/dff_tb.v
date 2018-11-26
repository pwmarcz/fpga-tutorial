`include "dff.v"

module Top;
  reg clk;
  reg data;
  wire out;

  dff dff0(clk, data, out);

  initial
    begin
      $monitor($time, " clk = %b, data = %b, out = %b",
               clk, data, out);
      $dumpfile(`VCD_FILE);
      $dumpvars;

      // Your test code here:
      clk <= 0; data <= 0;
      // TODO

      #2 $finish;
    end
endmodule // Top
