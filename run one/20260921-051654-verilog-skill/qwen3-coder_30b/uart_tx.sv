module uart_tx #(
    parameter longint CLK_HZ = 50_000_000,
    parameter int BAUD = 115200
)(
    input  logic clk,
    input  logic rst,
    input  logic [7:0] data,
    input  logic data_valid,
    output logic tx,
    output logic busy
);

    localparam int CNT_WIDTH = $clog2(CLK_HZ/BAUD);
    localparam int TX_WIDTH = 10; // 1 start + 8 data + 1 stop

    typedef enum logic [1:0] {
        IDLE,
        TRANSMITTING,
        DONE
    } state_t;

    state_t state, next_state;
    logic [CNT_WIDTH-1:0] baud_cnt;
    logic [TX_WIDTH-1:0] tx_shift_reg;
    logic tx_done;
    logic tx_start;

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data_valid)
                    next_state = TRANSMITTING;
                else
                    next_state = IDLE;
            end
            TRANSMITTING: begin
                if (tx_done)
                    next_state = DONE;
                else
                    next_state = TRANSMITTING;
            end
            DONE: begin
                next_state = IDLE;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            baud_cnt <= '0;
            tx_shift_reg <= '0;
            tx <= '1;
            busy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_valid) begin
                        tx_shift_reg <= {1'b1, data, 1'b0}; // start=1'b1, data, stop=1'b0
                        baud_cnt <= '0;
                        busy <= 1'b1;
                        tx <= 1'b1;
                    end else begin
                        busy <= 1'b0;
                    end
                end
                TRANSMITTING: begin
                    if (tx_done) begin
                        tx <= 1'b1;
                        busy <= 1'b0;
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                        if (baud_cnt == CLK_HZ/BAUD - 1) begin
                            baud_cnt <= '0;
                            tx <= tx_shift_reg[0];
                            tx_shift_reg <= {tx_shift_reg >> 1};
                        end
                    end
                end
                DONE: begin
                    // stay in DONE until next data_valid
                end
            endcase
        end
    end

    assign tx_done = (state == TRANSMITTING) && (baud_cnt == CLK_HZ/BAUD - 1) && (tx_shift_reg == '0);

endmodule
