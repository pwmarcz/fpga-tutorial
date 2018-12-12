`include "fpga-tools/components/uart.v"
`include "fpga-tools/components/oled.v"

`define BAUD_RATE 115300

module uart_display(input wire       clk,
                    input wire       d_read,
                    // input wire [2:0] d_page_idx,
                    // input wire [6:0] d_column_idx,
                    output reg [7:0] d_data,
                    output reg       d_ack,
                    input wire       uart_received,
                    input wire [7:0] uart_rx_byte);

  localparam DISPLAY_SIZE = 128*8;

  reg [7:0] data[0:DISPLAY_SIZE-1];
  reg [9:0] data_write_idx = 0;
  reg [9:0] data_read_idx = 0;

  reg byte_num = 0;
  reg [7:0] data_count = 0;
  reg [7:0] data_byte;

  always @(posedge clk) begin
    if (uart_received) begin
      if (byte_num == 0) begin
        data_count <= uart_rx_byte;
        byte_num <= 1;
      end else begin
        data_byte <= uart_rx_byte;
        data[data_write_idx] <= uart_rx_byte;
        data_write_idx <= (data_write_idx + 1) % DISPLAY_SIZE;
        byte_num <= 0;
      end
    end // if (uart_received)

    if (byte_num == 0 && data_count > 0) begin
      data[data_write_idx] <= data_byte;
      data_write_idx <= (data_write_idx + 1) % DISPLAY_SIZE;
      data_count <= data_count - 1;
    end

    if (d_read) begin
      d_data <= data[data_read_idx];
      d_ack <= 1;
      data_read_idx <= (data_read_idx + 1) % DISPLAY_SIZE;
    end else begin
      d_ack <= 0;
    end
  end
endmodule

module top(input wire  iCE_CLK,
           input wire  RS232_Rx_TTL,
           output wire PIO1_02,
           output wire PIO1_03,
           output wire PIO1_04,
           output wire PIO1_05,
           output wire PIO1_06);

  wire       d_read;
  // wire [2:0] d_page_idx;
  // wire [6:0] d_column_idx;
  wire [7:0] d_data;
  wire       d_ack;

  wire       uart_received;
  wire [7:0] uart_rx_byte;

  oled o(.clk(iCE_CLK),
         .pin_din(PIO1_02),
         .pin_clk(PIO1_03),
         .pin_cs(PIO1_04),
         .pin_dc(PIO1_05),
         .pin_res(PIO1_06),
         .read(d_read),
         // .page_idx(d_page_idx),
         // .column_idx(d_column_idx),
         .data(d_data),
         .ack(d_ack));

  uart #(.baud_rate(`BAUD_RATE), .sys_clk_freq(12000000))
  uart0(.clk(iCE_CLK),                    // The master clock for this module
        .rst(1'b0),                      // Synchronous reset
        .rx(RS232_Rx_TTL),                // Incoming serial line
        // .tx(RS232_Tx_TTL),                // Outgoing serial line
        .transmit(1'b0),              // Signal to transmit
        // .tx_byte(tx_byte),                // Byte to transmit
        .received(uart_received),              // Indicated that a byte has been received
        .rx_byte(uart_rx_byte)                // Byte received
        // .is_receiving(is_receiving),      // Low when receive line is idle
        // .is_transmitting(is_transmitting),// Low when transmit line is idle
        // .recv_error(recv_error)           // Indicates error in receiving packet.
        );

  uart_display ud(.clk(iCE_CLK),
                  .d_read(d_read),
                  .d_data(d_data),
                  .d_ack(d_ack),
                  .uart_received(uart_received),
                  .uart_rx_byte(uart_rx_byte));

endmodule
