
module top(input wire  CLK,
           output wire LED0,
           output wire LED1,
           output wire LED2,
           output wire LED3,
           output wire LED4);

  parameter n = 26;
  reg [n-1:0] clk_counter = 0;

  always @(posedge CLK) begin
    clk_counter <= clk_counter + 1;
  end

  // Display 5 highest bits of counter with LEDs.
  assign LED0 = clk_counter[n-5];
  assign LED1 = clk_counter[n-4];
  assign LED2 = clk_counter[n-3];
  assign LED3 = clk_counter[n-2];
  assign LED4 = clk_counter[n-1];
endmodule
