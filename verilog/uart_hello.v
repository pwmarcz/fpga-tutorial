`include "fpga-tools/components/uart.v"

module uart_node(input wire clk,
                 input wire is_receiving,
                 input wire is_transmitting,
                 output reg transmit = 0,
                 output reg [7:0] tx_byte,
                 input wire received,
                 input wire [7:0] rx_byte);

  parameter n = 13;
  parameter greeting = "Hello World!\n";
  wire [7:0] data[0:n-1];
  reg [3:0] idx;

  // Initialize data with a string. Sadly, Verilog string literals are just
  // huge numbers, so a conversion is necessary.
  generate
    genvar i;
    for (i = 0; i < n; i = i + 1) begin
      assign data[i] = greeting[8*(n-i)-1 : 8*(n-i)-8];
    end
  endgenerate


  always @(posedge clk) begin
    // Only raise transmit for 1 cycle
    if (transmit)
      transmit <= 0;

    if (!transmit && !is_transmitting) begin
      transmit <= 1;
      tx_byte <= data[idx];
      if (idx == n - 1)
        idx <= 0;
      else
        idx <= idx + 1;
    end
  end

endmodule


module top(input wire  CLK,
           input wire  RS232_Rx_TTL,
           output wire RS232_Tx_TTL,
           output wire LED4);

  parameter baud_rate = 9600;

  wire       reset = 0;
  wire        transmit;
  wire [7:0]  tx_byte;
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

  uart_node un(.clk(CLK),
               .is_receiving(is_receiving),
               .is_transmitting(is_transmitting),
               .transmit(transmit),
               .tx_byte(tx_byte),
               .received(received),
               .rx_byte(rx_byte));

  assign LED4 = (is_transmitting);
endmodule
