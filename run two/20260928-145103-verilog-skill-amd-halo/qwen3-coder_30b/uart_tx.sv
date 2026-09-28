module uart_tx #(parameter int CLK_HZ = 100_000_000, parameter int BAUD = 115_200) (
  input  logic       clk, rst,
  input  logic [7:0] data,
  input  logic       data_valid,
  output logic       tx, busy);

  localparam int CYCLES_PER_BIT = CLK_HZ / BAUD;
  typedef enum logic [1:0] {ST_IDLE, ST_START, ST_DATA, ST_STOP} state_t;
  state_t     state;
  logic [$clog2(CYCLES_PER_BIT)-1:0] baud_cnt;
  logic [2:0] bit_cnt;
  logic [7:0] shift;
  logic       tick;

  assign tick = (baud_cnt == CYCLES_PER_BIT-1);
  assign busy = (state != ST_IDLE);

  always_ff @(posedge clk) begin
    if (rst) begin
      state <= ST_IDLE; baud_cnt <= '0; bit_cnt <= '0; tx <= 1'b1;
    end else begin
      if (state == ST_IDLE || tick) baud_cnt <= '0; else baud_cnt <= baud_cnt + 1'b1;
      case (state)
        ST_IDLE:  begin tx <= 1'b1;
                        if (data_valid) begin shift <= data; bit_cnt <= '0; state <= ST_START; end end
        ST_START: begin tx <= 1'b0; if (tick) state <= ST_DATA; end
        ST_DATA:  begin tx <= shift[0];                          // LSB first
                        if (tick) begin shift <= {1'b0, shift[7:1]};
                          if (bit_cnt == 3'd7) state <= ST_STOP; else bit_cnt <= bit_cnt + 1'b1; end end
        ST_STOP:  begin tx <= 1'b1; if (tick) state <= ST_IDLE; end
        default:  state <= ST_IDLE;
      endcase
    end
  end
endmodule
