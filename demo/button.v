
// This shows how to configure internal pull-up.
// Connect button to ground and to PIO1_02.

module keypad(input wire PIO1_02,
              output wire LED0,
              output wire LED1,
              output wire LED2,
              output wire LED3,
              output wire LED4);
  wire pin;

  // PIN_TYPE: <output_type=0>_<input=1>
  SB_IO #(.PIN_TYPE(6'b0000_01),
          .PULLUP(1'b1))
  pin_pio1_07(.PACKAGE_PIN(PIO1_02),
              .D_IN_0(pin));

  assign LED0 = ~pin;
  assign LED1 = ~pin;
  assign LED2 = ~pin;
  assign LED3 = ~pin;
  assign LED4 = pin;
endmodule
