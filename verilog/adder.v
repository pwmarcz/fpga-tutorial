module half_adder(input wire  x,
                  input wire  y,
                  output wire s,
                  output wire c_out);
  xor(s, x, y);
  and(c_out, x, y);
endmodule
