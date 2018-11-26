module dff(input wire clk,
           input wire data,
           output wire out);
  reg stored;
  // You can also just declare "output reg out" above.
  assign out = stored;

  always @(posedge clk) begin
    stored <= data;
  end
endmodule
