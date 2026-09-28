module uart_tx #(
    parameter int unsigned CLK_HZ = 100_000_000,
    parameter int unsigned BAUD   = 115200
) (
    input  logic        clk,
    input  logic        rst,
    input  logic [7:0]  data,
    input  logic        data_valid,
    output logic        tx,
    output logic        busy
);

    localparam int unsigned BAUD_DIV = (CLK_HZ / BAUD) - 1;
    localparam int unsigned CNT_W    = $clog2(BAUD_DIV + 1);

    typedef enum logic [2:0] {
        ST_IDLE,
        ST_START,
        ST_DATA,
        ST_STOP
    } state_t;

    state_t       state;
    state_t       next_state;
    logic [2:0]   bit_idx;
    logic [CNT_W-1:0] cnt;
    logic         cnt_tick;
    logic         tx_next;

    always_comb begin
        next_state = state;
        tx_next    = 1'b1;
        case (state)
            ST_IDLE: begin
                if (data_valid) next_state = ST_START;
            end
            ST_START: begin
                if (cnt_tick) next_state = ST_DATA;
            end
            ST_DATA: begin
                if (cnt_tick) begin
                    if (bit_idx == 3'd7) next_state = ST_STOP;
                    else                 next_state = ST_DATA;
                end
            end
            ST_STOP: begin
                if (cnt_tick) next_state = ST_IDLE;
            end
            default: next_state = ST_IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state    <= ST_IDLE;
            bit_idx  <= 3'd0;
            cnt      <= '0;
            tx       <= 1'b1;
            busy     <= 1'b0;
        end else begin
            state <= next_state;
            tx    <= (state == ST_START) ? 1'b0 :
                     (state == ST_DATA)  ? data[bit_idx] :
                     (state == ST_STOP)  ? 1'b1 : 1'b1;

            if (state == ST_IDLE) begin
                bit_idx <= 3'd0;
                cnt     <= '0;
                busy    <= data_valid;
            end else begin
                busy <= 1'b1;
                if (cnt_tick) begin
                    if (state == ST_DATA) begin
                        if (bit_idx == 3'd7) bit_idx <= 3'd0;
                        else                 bit_idx <= bit_idx + 3'd1;
                    end
                    cnt <= '0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

    always_comb begin
        cnt_tick = (cnt == CNT_W'(BAUD_DIV));
    end

endmodule
