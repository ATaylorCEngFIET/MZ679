module uart_tx #(
    parameter logic CLK_HZ = 50_000_000,
    parameter logic BAUD   = 115_200
)(
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] data,
    input  logic       data_valid,
    output logic       tx,
    output logic       busy
);

    localparam logic [31:0] CLK_PER_BIT = CLK_HZ / BAUD;

    typedef enum logic [2:0] {
        IDLE   = 3'b000,
        START  = 3'b001,
        DATA   = 3'b010,
        STOP   = 3'b011,
        DONE   = 3'b100
    } state_t;

    state_t state, next_state;

    logic [31:0] baud_cnt;
    logic [2:0]  bit_idx;
    logic [7:0]  shift_reg;

    always_ff @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            baud_cnt  <= '0;
            bit_idx   <= '0;
            shift_reg <= '0;
            tx        <= '1;
            busy      <= '0;
        end else begin
            case (state)
                IDLE: begin
                    tx    <= '1;
                    busy  <= '0;
                    baud_cnt <= '0;
                    bit_idx  <= '0;
                    if (data_valid) begin
                        state     <= START;
                        shift_reg <= data;
                        busy      <= '1;
                    end
                end

                START: begin
                    tx <= '0;
                    if (baud_cnt >= CLK_PER_BIT - 1) begin
                        baud_cnt <= '0;
                        state    <= DATA;
                    end else begin
                        baud_cnt <= baud_cnt + 1'b1;
                    end
                end

                DATA: begin
                    tx <= shift_reg[bit_idx];
                    if (baud_cnt >= CLK_PER_BIT - 1) begin
                        baud_cnt <= '0;
                        if (bit_idx == 7) begin
                            bit_idx <= '0;
                            state   <= STOP;
                        end else begin
                            bit_idx <= bit_idx + 1'b1;
                        end
                    end else begin
                        baud_cnt <= baud_cnt + 1'b1;
                    end
                end

                STOP: begin
                    tx <= '1;
                    if (baud_cnt >= CLK_PER_BIT - 1) begin
                        baud_cnt <= '0;
                        state    <= IDLE;
                    end else begin
                        baud_cnt <= baud_cnt + 1'b1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
