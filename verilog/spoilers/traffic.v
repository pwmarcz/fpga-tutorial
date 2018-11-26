module traffic(input wire  clk,
               input wire  go,
               output wire red,
               output wire yellow,
               output wire green);
  // 0: stop, 1: starting, 2: stopping, 3: go
  reg [1:0] state = 0;
  reg [1:0] counter;
  assign red = (state == 0 || state == 1);
  assign yellow = (state == 1 || state == 2);
  assign green = (state == 3);

  always @(posedge clk) begin
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
  end
endmodule
