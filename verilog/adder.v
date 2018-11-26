module adder4(input wire [3:0] x,
              input wire [3:0] y,
              input wire c_in,
              output wire [3:0] s,
              output wire c_out);
  assign s = x + y + c_in;
  assign c_out = (x + y + c_in) > 16;
endmodule

module adder8(input wire [7:0] x,
              input wire [7:0] y,
              input wire c_in,
              output wire [7:0] s,
              output wire c_out);
  wire [3:0] s0;
  wire [3:0] s1;
  wire c0;
  adder4 a0(x[3:0], y[3:0], c_in, s0, c0);
  adder4 a1(x[7:4], y[7:4], c0, s1, c_out);
  assign s[3:0] = s0;
  assign s[7:4] = s1;
endmodule
