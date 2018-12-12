`include "fpga-tools/components/oled.v"

// Draw a 8x8-pixel checkerboard.

module pattern(input wire       clk,
               input wire       read,
               input wire [5:0] row_idx,
               input wire [6:0] column_idx,
               output reg [7:0] data,
               output reg       ack);

  wire page_odd = row_idx & 1;
  wire column_field_odd = ((column_idx >> 3) & 1);
  wire field_black = page_odd ^ column_field_odd;
  wire column_odd = column_idx & 1;

  always @(posedge clk) begin
    ack <= 0;
    if (read) begin
      ack <= 1;
      if (field_black)
        data <= 8'b00000000;
      else if (column_odd)
        data <= 8'b10101010;
      else
        data <= 8'b01010101;
    end
  end
endmodule

module top(input wire  CLK,
           output wire PIO1_02,
           output wire PIO1_03,
           output wire PIO1_04,
           output wire PIO1_05,
           output wire PIO1_06);

  wire       read;
  wire [5:0] row_idx;
  wire [6:0] column_idx;
  wire [7:0] data;
  wire       ack;

  oled o(.clk(CLK),
         .pin_din(PIO1_02),
         .pin_clk(PIO1_03),
         .pin_cs(PIO1_04),
         .pin_dc(PIO1_05),
         .pin_res(PIO1_06),
         .read(read),
         .row_idx(row_idx),
         .column_idx(column_idx),
         .data(data),
         .ack(ack));

  pattern p(.clk(CLK),
            .read(read),
            .row_idx(row_idx),
            .column_idx(column_idx),
            .data(data),
            .ack(ack));
endmodule
