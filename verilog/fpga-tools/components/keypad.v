module keypad(input wire clk,
              output reg [3:0]  column_pins,
              input wire [3:0]   row_pins,
              output reg [15:0] keys);

  reg [1:0] column = 0;

  initial begin
    column_pins = 4'b1110;
    keys = 0;
  end

  integer i;

  always @(posedge clk) begin
    for (i = 0; i < 4; i++)
      keys[i*4 + column] <= (row_pins[i] == 0);
    column <= (column + 1) % 4;
    column_pins <= (column_pins << 1) + (column_pins >> 3);
  end
endmodule

module pullup(output wire pin, output wire d_in);
  SB_IO #(.PIN_TYPE(6'b1), .PULLUP(1'b1)) io(.PACKAGE_PIN(pin), .D_IN_0(d_in));
endmodule

module top(input wire  iCE_CLK,
           input wire  PIO1_02,
           input wire  PIO1_03,
           input wire  PIO1_04,
           input wire  PIO1_05,
           output wire PIO1_06,
           output wire PIO1_07,
           output wire PIO1_08,
           output wire PIO1_09,
           output wire LED0,
           output wire LED1,
           output wire LED2,
           output wire LED3,
           output wire LED4);

  wire [3:0] row_pins;
  wire [3:0] column_pins;
  wire [15:0] keys;

  keypad k(iCE_CLK, column_pins, row_pins, keys);

  assign column_pins = {PIO1_09, PIO1_08, PIO1_07, PIO1_06};
  pullup io1(PIO1_02, row_pins[0]);
  pullup io2(PIO1_03, row_pins[1]);
  pullup io3(PIO1_04, row_pins[2]);
  pullup io4(PIO1_05, row_pins[3]);

  integer i;
  reg [3:0] key = 0;

  always @(posedge iCE_CLK) begin
    key <= 0;
    for (i = 0; i < 16; i++)
      if (keys[i])
        key <= i;
  end

  assign LED4 = !(|keys);
  assign LED0 = key[3];
  assign LED1 = key[2];
  assign LED2 = key[1];
  assign LED3 = key[0];
endmodule
