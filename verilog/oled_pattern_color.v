`include "fpga-tools/components/oled.v"

module pattern(input wire        clk,
               input wire        read,
               input wire [5:0]  row_idx,
               input wire [6:0]  column_idx,
               output reg [15:0] data_rgb,
               output reg        ack);

  wire [4:0] r = row_idx >> 1;
  wire [5:0] g = column_idx >> 1;
  wire [4:0] b = 63 - (row_idx >> 1);
  wire [15:0] rgb = {r, g, b};

  always @(posedge clk) begin
    ack <= 0;
    if (read) begin
      ack <= 1;
      data_rgb <= rgb;
    end
  end
endmodule

module top(input wire  CLK,
           output wire PIO1_02,
           output wire PIO1_03,
           output wire PIO1_04,
           output wire PIO1_05,
           output wire PIO1_06);

  wire        read;
  wire [5:0]  row_idx;
  wire [6:0]  column_idx;
  wire [15:0] data_rgb;
  wire        ack;

  oled #(.color(1))
  o(.clk(CLK),
    .pin_din(PIO1_02),
    .pin_clk(PIO1_03),
    .pin_cs(PIO1_04),
    .pin_dc(PIO1_05),
    .pin_res(PIO1_06),
    .read(read),
    .row_idx(row_idx),
    .column_idx(column_idx),
    .data_rgb(data_rgb),
    .ack(ack));

  pattern p(.clk(CLK),
            .read(read),
            .row_idx(row_idx),
            .column_idx(column_idx),
            .data_rgb(data_rgb),
            .ack(ack));
endmodule
