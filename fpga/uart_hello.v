`include "uart.v"

module top(input wire  CLK,
           input wire  RS232_Rx_TTL,
           output wire RS232_Tx_TTL,
           output wire LED4);

  parameter baud_rate = 9600;

  parameter n = 12;
  wire [7:0] greeting[0:n-1];
  assign greeting[0]  = "H";
  assign greeting[1]  = "e";
  assign greeting[2]  = "l";
  assign greeting[3]  = "l";
  assign greeting[4]  = "o";
  assign greeting[5]  = " ";
  assign greeting[6]  = "W";
  assign greeting[7]  = "o";
  assign greeting[8]  = "r";
  assign greeting[9]  = "l";
  assign greeting[10] = "d";
  assign greeting[11] = "!";
  reg [3:0]  idx;

  wire       reset = 0;
  reg        transmit;
  reg [7:0]  tx_byte;
  wire       received;
  wire [7:0] rx_byte;
  wire       is_receiving;
  wire       is_transmitting;
  wire       recv_error;

  uart #(.baud_rate(9600), .sys_clk_freq(12000000))
  uart0(.clk(CLK),                        // The master clock for this module
        .rst(reset),                      // Synchronous reset
        .rx(RS232_Tx_TTL),                // Incoming serial line
        .tx(RS232_Tx_TTL),                // Outgoing serial line
        .transmit(transmit),              // Signal to transmit
        .tx_byte(tx_byte),                // Byte to transmit
        .received(received),              // Indicated that a byte has been received
        .rx_byte(rx_byte),                // Byte received
        .is_receiving(is_receiving),      // Low when receive line is idle
        .is_transmitting(is_transmitting),// Low when transmit line is idle
        .recv_error(recv_error)           // Indicates error in receiving packet.
        );

  // Only start new transmission when clk_counter == 0
  reg [21:0] clk_counter = 0;

  // Blink the LED when we're waiting/transmitting
  assign LED4 = (idx > 0);

  always @(posedge CLK) begin
    clk_counter <= clk_counter + 1;

    if (transmit) begin
      transmit <= 0;
    end else if (!is_transmitting) begin
      // If idx == 0 (new transmission), only start when clk_counter rolls
      // over.
      if (idx > 0 || clk_counter == 0) begin
        transmit <= 1;
        tx_byte <= greeting[idx];
        idx <= (idx + 1) % n;
      end
    end
  end
endmodule
