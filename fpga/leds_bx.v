
// Adapted from the official example:
//  https://github.com/tinyfpga/TinyFPGA-BX/blob/master/apio_template/top.v

module top(input wire  CLK,
           output wire LED);

  parameter n = 26;
  reg [n-1:0] clk_counter = 0;

  always @(posedge CLK) begin
    clk_counter <= clk_counter + 1;
  end

  // SOS pattern
  wire[31:0] blink_pattern = 32'b101010001110111011100010101;

  assign LED = blink_pattern[clk_counter[n-1:n-5]];
endmodule
