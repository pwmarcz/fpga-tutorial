module counter(input wire       clk,
               input wire       en,
               input wire       rst,
               output reg [3:0] count);
  always @(posedge clk) begin
    if (rst)
      count <= 0;
    else if (en)
      count <= count + 1;
  end
endmodule
