`include "adder.v"

module Top;
  reg x;
  reg y;
  wire s;
  wire c_out;

  half_adder ha(x, y, s, c_out);

  initial
    begin
      $monitor($time, " x = %b, y = %b, s = %b, c_out = %b",
               x, y, s, c_out);
      $dumpfile("adder_tb.vcd");
      $dumpvars;

      x = 0; y = 0;
      #5 x = 1; y = 0;
      #5 x = 0; y = 1;
      #5 x = 1; y = 1;
    end
endmodule // Top
