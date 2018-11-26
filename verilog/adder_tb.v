`include "adder.v"

module Top;
  reg [7:0] x;
  reg [7:0] y;
  reg c_in;
  wire [7:0] s;
  wire c_out;

  adder8 a(x, y, c_in, s, c_out);

  initial
    begin
      $monitor($time, " x = %x, y = %x, c_in = %x, s = %x, c_out = %x",
               x, y, c_in, s, c_out);
      $dumpfile("adder_tb.vcd");
      $dumpvars;

      x <= 'h00; y <= 'h00; c_in <= 1;    // sum = 'h01
      #5 x <= 'hA0; y <= 'h0B; c_in <= 0; // sum = 'hAB
      #5 x <= 'h08; y <= 'h18; c_in <= 0; // sum = 'h20
      #5 x <= 'h7F; y <= 'hA0; c_in <= 0; // sum = 'h11F
      #5 $finish;
    end
endmodule // Top
