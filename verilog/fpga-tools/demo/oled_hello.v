`include "components/oled.v"


module text_display(input wire       clk,
                    input wire       d_read,
                    input wire [2:0] d_page_idx,
                    input wire [6:0] d_column_idx,
                    output reg [7:0] d_data,
                    output reg       d_ack);

  reg [7:0]  font[0:128*8-1];
  reg [10:0] font_idx;
  reg        font_idx_ready = 0;

  reg [7:0]  text[0:16*8-1];
  reg [6:0]  text_idx;
  reg        text_idx_ready = 0;

  initial begin
    $readmemh("font.mem", font);
    $readmemh("text.mem", text);
    d_ack <= 0;
  end

  always @(posedge clk) begin
    d_ack <= 0;
    text_idx_ready <= 0;
    font_idx_ready <= 0;
    if (d_read) begin
      text_idx <= d_page_idx * 16 + d_column_idx / 8;
      text_idx_ready <= 1;
    end else if (text_idx_ready) begin
      font_idx <= (text[text_idx] - 'h20) * 8 + d_column_idx % 8;
      font_idx_ready <= 1;
    end else if (font_idx_ready) begin
      d_data <= font[font_idx];
      d_ack <= 1;
    end
  end
endmodule

module top(input wire  iCE_CLK,
           output wire PIO1_02,
           output wire PIO1_03,
           output wire PIO1_04,
           output wire PIO1_05,
           output wire PIO1_06);

  wire       d_read;
  wire [2:0] d_page_idx;
  wire [6:0] d_column_idx;
  wire [7:0] d_data;
  wire       d_ack;

  oled o(.clk(iCE_CLK),
         .pin_din(PIO1_02),
         .pin_clk(PIO1_03),
         .pin_cs(PIO1_04),
         .pin_dc(PIO1_05),
         .pin_res(PIO1_06),
         .read(d_read),
         .page_idx(d_page_idx),
         .column_idx(d_column_idx),
         .data(d_data),
         .ack(d_ack));

  text_display td(.clk(iCE_CLK),
                  .d_read(d_read),
                  .d_page_idx(d_page_idx),
                  .d_column_idx(d_column_idx),
                  .d_data(d_data),
                  .d_ack(d_ack));
endmodule
