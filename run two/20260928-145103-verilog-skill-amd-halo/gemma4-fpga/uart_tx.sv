module uart_tx #(
  parameter int CLK_HZ = 100_000_000,
  parameter int BAUD   = 115_200
) (
  input  logic        clk,
  input  logic        rst,
  input  logic [7:0]  data,
  input  logic        data_valid,
  output logic        tx,
  output logic        busy
);

  localparam int CYCLES_PER_BIT = CLK_HZ / BAUD;

  typedef enum logic [1:0] {
    ST_IDLE,
    ST_START,
    ST_DATA,
    ST_STOP
  } state_t;

  state_t     state;
  logic [31:0] baud_cnt;
  logic [2:0]  bit_cnt;
  logic [7:0]  shift_reg;
  logic         tick;

  assign tick = (baud_cnt == CYCLES_PER_BIT - 1'b1);
  assign busy = (state != ST_IDLE);

  always_ff @(posedge clk) begin
    if (rst) begin
      state     <= ST_IDLE;
      baud_cnt  <= 32'h0;
      bit_cnt   <= 3'h0;
      shift_reg <= 8'h0;
      tx        <= 1'b1;
    end else begin
      // Baud counter logic: reset on tick or when in IDLE state
      if (state == ST_IDLE || tick) begin
        baud_cnt <= 32'h0;
      end else begin
        baud_cnt <= baud_cnt + 1'b1;
      end

      case (state)
        ST_IDLE: begin
          tx <= 1'b1;
          if (data_valid) begin
            shift_reg <= data;
            bit_cnt   <= 3'h0;
            state     <= ST_START;
          end
        end

        ST_START: begin
          tx <= 1'b0;
          if (tick) begin
            state <= ST_DATA;
          end
        end

        ST_DATA: begin
          tx <= shift_reg[0];
          if (tick) begin
            shift_reg <= {1'b0, shift_reg[7:1]};
            if (bit_cnt == 3'd7) begin
              state <= ST_STOP;
            end else begin
              bit_cnt <= bit_cnt + 1'b1;
            end
          end
        end

        ST_STOP: begin
          tx <= 1'b1;
          if (tick) begin
            state <= ST_IDLE;
          end
        end

        default: begin
          state <= ST_IDLE;
        end
      endcase
    end
  end

endmodule
