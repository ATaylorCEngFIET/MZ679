//
// UART Transmitter Module
// Parameters:
//   CLK_HZ: Input clock frequency in Hz
//   BAUD:   UART baud rate
//
module uart_tx #(
    parameter logic [31:0] CLK_HZ = 50_000_000,
    parameter logic [16:0] BAUD  = 115_200
)(
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    data_valid,
    input  logic [7:0]             data_in,
    output logic                    tx,
    output logic                   busy
);

    localparam logic [31:0] TICK_COUNT = CLK_HZ / BAUD;

    // State Machine Definitions
    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        START = 3'b001,
        DATA  = 3'b010,
        STOP  = 3'b011
    } state_t;

    state_t state;
    logic [31:0] tick_cnt;
    logic [2:0]  bit_idx;
    logic [7:0]  tx_buffer;
    logic         tx_busy_reg;

    // Internal logic for state machine and counters
    always_ff @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            tick_cnt     <= 32'h0;
            bit_idx      <= 3'd0;
            tx_buffer    <= 8'h00;
            tx_busy_reg  <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx_busy_reg <= data_valid ? 1'b1 : 1'b0;
                    if (data_valid) begin
                        tx_buffer <= data_in;
                        tick_cnt  <= 32'h0;
                        bit_idx   <= 3'd0;
                        state     <= START;
                    end else begin
                        state     <= IDLE;
                    end
                end

                START: begin
                    if (tick_cnt == TICK_COUNT - 1) begin
                        tick_cnt  <= 32'h0;
                        bit_idx   <= 3'd0;
                        state     <= DATA;
                    end else begin
                        tick_cnt  <= tick_cnt + 1;
                    end
                end

                DATA: begin
                    if (tick_cnt == TICK_COUNT - 1) begin
                        tick_cnt  <= 32'h0;
                        if (bit_idx == 3'd7) begin
                            state     <= STOP;
                        end else begin
                            bit_idx   <= bit_idx + 1;
                        end
                    end else begin
                        tick_cnt  <= tick_cnt + 1;
                    end
                end

                STOP: begin
                    if (tick_cnt == TICK_COUNT - 1) begin
                        tx_busy_reg <= 1'b0;
                        state       <= IDLE;
                    end else begin
                        tick_cnt    <= tick_cnt + 1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Combinational logic for outputs
    // tx is 0 during START, tx_buffer[bit_idx] during DATA, and 1 during STOP/IDLE
    always_comb begin
        tx   = 1'b1;
        busy = tx_busy_reg;
        
        case (state)
            IDLE:  tx = 1'b1;
            START: tx = 1'b0;
            DATA:  tx = tx_buffer[bit_idx];
            STOP:  tx = 1'b1;
            default: tx = 1'b1;
        endcase
    end

endmodule
