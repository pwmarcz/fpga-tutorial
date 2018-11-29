module traffic(input wire  clk,
               input wire  go,
               output reg red,
               output reg yellow,
               output reg green);
  // 0: stop, 1: starting, 2: stopping, 3: go
  reg [1:0] state = 0;
  reg [1:0] counter;

  always @(*)
    case (state)
      0: {red, yellow, green} = 3'b100;
      1: {red, yellow, green} = 3'b110;
      2: {red, yellow, green} = 3'b010;
      3: {red, yellow, green} = 3'b101;
    endcase

  always @(posedge clk)
    case (state)
      0: begin
        if (go) begin
          state <= 1;
          counter <= 2;
        end
      end
      1: begin
        if (counter == 0)
          state <= 3;
        else
          counter <= counter - 1;
      end
      2: begin
        if (counter == 0)
          state <= 0;
        else
          counter <= counter - 1;
      end
      3: if (!go) begin
        state <= 2;
        counter <= 2;
      end
    endcase

endmodule
