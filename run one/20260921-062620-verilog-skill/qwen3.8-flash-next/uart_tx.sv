module uart_tx #(
    parameter int CLK_HZ = 100_000_000,
    parameter int BAUD   = 115_200
) (
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] data,
    input  logic       data_valid,
    output logic       tx,
    output logic       busy
);

    localparam int TICK_MAX = (CLK_HZ / BAUD) - 1;
    localparam int TICK_W   = (TICK_MAX > 0) ? $clog2(TICK_MAX + 1) : 1;

    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3
    } state_t;

    state_t state;
    state_t next_state;

    logic [TICK_W-1:0] tick_cnt;
    logic [TICK_W-1:0] next_tick_cnt;
    logic [7:0] tx_data;
    logic [2:0] bit_idx;
    logic [2:0] next_bit_idx;
    logic       tx_reg;
    logic       busy_reg;
    logic       tick;

    always_comb begin
        tick = (tick_cnt == TICK_MAX[TICK_W-1:0]);
    end

    always_comb begin
        next_state = state;
        next_tick_cnt = tick_cnt;
        next_bit_idx = bit_idx;
        tx_reg = tx;
        busy_reg = busy;

        case (state)
            IDLE: begin
                tx_reg = 1'b1;
                busy_reg = 1'b0;
                next_tick_cnt = '0;
                next_bit_idx = '0;

                if (data_valid) begin
                    next_state = START;
                    busy_reg = 1'b1;
                    if (tick) begin
                        next_tick_cnt = '0;
                    end else begin
                        next_tick_cnt = tick_cnt + TICK_W'(1);
                    end
                end
            end

            START: begin
                tx_reg = 1'b0;
                busy_reg = 1'b1;

                if (tick) begin
                    next_tick_cnt = '0;
                    next_state = DATA;
                    next_bit_idx = '0;
                end else begin
                    next_tick_cnt = tick_cnt + TICK_W'(1);
                end
            end

            DATA: begin
                tx_reg = tx_data[bit_idx];
                busy_reg = 1'b1;

                if (tick) begin
                    next_tick_cnt = '0;
                    if (bit_idx == 3'd7) begin
                        next_state = STOP;
                        next_bit_idx = '0;
                    end else begin
                        next_bit_idx = bit_idx + 3'd1;
                    end
                end else begin
                    next_tick_cnt = tick_cnt + TICK_W'(1);
                end
            end

            STOP: begin
                tx_reg = 1'b1;
                busy_reg = 1'b1;

                if (tick) begin
                    next_tick_cnt = '0;
                    next_state = IDLE;
                    busy_reg = 1'b0;
                end else begin
                    next_tick_cnt = tick_cnt + TICK_W'(1);
                end
            end

            default: begin
                next_state = IDLE;
                next_tick_cnt = '0;
                next_bit_idx = '0;
                tx_reg = 1'b1;
                busy_reg = 1'b0;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            tick_cnt  <= '0;
            tx_data   <= '0;
            bit_idx   <= '0;
            tx        <= 1'b1;
            busy      <= 1'b0;
        end else begin
            state     <= next_state;
            tick_cnt  <= next_tick_cnt;
            bit_idx   <= next_bit_idx;
            tx        <= tx_reg;
            busy      <= busy_reg;

            if ((state == IDLE) && data_valid) begin
                tx_data <= data;
            end
        end
    end

endmodule
