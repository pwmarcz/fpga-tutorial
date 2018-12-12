`include "components/uart.v"

module transmit_hello(input wire  iCE_CLK,
                      input wire  RS232_Rx_TTL,
                      output wire RS232_Tx_TTL,
                      output wire LED0,
	              output wire LED1,
	              output wire LED2,
	              output wire LED3,
                      output wire LED4);

  assign LED0 = 0;
  assign LED1 = 0;
  assign LED2 = 0;
  assign LED3 = 0;
  assign LED4 = 1;

`define GREETING_SIZE 12

  wire [7:0] greeting[0:11];
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

  reg        transmitted = 0;

  wire       reset = 0;
  reg        transmit;
  reg [7:0]  tx_byte;
  wire       received;
  wire [7:0] rx_byte;
  wire       is_receiving;
  wire       is_transmitting;
  wire       recv_error;

  uart #(.baud_rate(9600), .sys_clk_freq(12000000))
  uart0(.clk(iCE_CLK),                    // The master clock for this module
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

  always @(posedge iCE_CLK) begin
    if (!is_transmitting && !transmitted) begin
      transmit = 1;
      tx_byte = greeting[idx];
      if (idx == `GREETING_SIZE - 1) begin
        idx <= 0;
      end else begin
        idx <= idx + 1;
      end
      transmitted = 1;
    end else begin
      transmitted = 0;
      transmit = 0;
    end
  end // always @ (posedge iCE_CLK)
endmodule // transmit_hello
