
// This shows how to configure internal pull-up.
// Connect button to ground and to the input pin.

module top(input wire  PIO1_02,
           output wire LED0,
           output wire LED1,
           output wire LED2,
           output wire LED3,
           output wire LED4);
  wire pin;

  pullup pu(PIO1_02, pin);

  // Check both 'pin' and '~pin' to make sure both button states work
  // correctly.
  assign LED0 = ~pin;
  assign LED1 = ~pin;
  assign LED2 = ~pin;
  assign LED3 = ~pin;
  assign LED4 = pin;
endmodule

module pullup(input wire package_pin,
              input wire data_in);
  // PIN_TYPE: <output_type=0>_<input=1>
  SB_IO #(.PIN_TYPE(6'b0000_01),
          .PULLUP(1'b1))
  io(.PACKAGE_PIN(package_pin), .D_IN_0(data_in));
endmodule
