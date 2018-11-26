module serial(input wire clk,
              input wire in,
              input wire [7:0] data,
              output wire ready,
              output wire out);

  reg [3:0] counter = 0;
  reg [7:0] shift = 0;
  assign ready = counter > 0;
  assign out = shift[7];

  always @(posedge clk) begin
    if (in) begin
      shift <= data;
      counter <= 8;
    end else if (counter) begin
      counter <= counter - 1;
      shift <= shift << 1;
    end
  end
endmodule
