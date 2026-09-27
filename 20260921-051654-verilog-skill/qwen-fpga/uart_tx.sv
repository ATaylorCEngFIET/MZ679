module uart_tx #(
    parameter CLK_HZ = 100_000,
    parameter BAUD   = 9600
) (
    input  logic                  clk,
    input  logic                  rst,
    input  logic [7:0]            data,
    input  logic                  data_valid,
    output logic                  tx,
    output logic                  busy
);

    // Baud counter width calculation
    localparam int unsigned BAUD_COUNTER_WIDTH = $clog2((CLK_HZ / BAUD) + 1);
    localparam int unsigned DATA_WIDTH         = 8;

    // State machine typedef with explicit unique values to prevent overflow
    typedef enum logic [3:0] {
        IDLE     = 4'd0,
        START    = 4'd1,
        DATA_0   = 4'd2,
        DATA_1   = 4'd3,
        DATA_2   = 4'd4,
        DATA_3   = 4'd5,
        DATA_4   = 4'd6,
        DATA_5   = 4'd7,
        DATA_6   = 4'd8,
        DATA_7   = 4'd9,
        STOP     = 4'd10
    } state_t;

    state_t current_state, next_state;

    // Baud counter
    logic [BAUD_COUNTER_WIDTH-1:0] baud_counter;
    logic                          baud_tick;

    // State register
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (data_valid) begin
                    next_state = START;
                end
            end
            START: begin
                next_state = DATA_0;
            end
            DATA_0: begin
                next_state = DATA_1;
            end
            DATA_1: begin
                next_state = DATA_2;
            end
            DATA_2: begin
                next_state = DATA_3;
            end
            DATA_3: begin
                next_state = DATA_4;
            end
            DATA_4: begin
                next_state = DATA_5;
            end
            DATA_5: begin
                next_state = DATA_6;
            end
            DATA_6: begin
                next_state = DATA_7;
            end
            DATA_7: begin
                next_state = STOP;
            end
            STOP: begin
                next_state = IDLE;
            end
        endcase
    end

    // Baud counter logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            baud_counter <= '0;
        end else begin
            baud_counter <= baud_counter + 1'b1;
            if (baud_counter == (CLK_HZ / BAUD) - 1'b1) begin
                baud_tick   <= 1'b1;
                baud_counter <= '0;
            end else begin
                baud_tick   <= 1'b0;
            end
        end
    end

    // TX output register (shifted on baud tick)
    logic [DATA_WIDTH-1:0] shift_register;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_register <= '0;
        end else begin
            if (baud_tick) begin
                // Shift left, load LSB from current state data bit
                shift_register[DATA_WIDTH-1:1] <= shift_register[DATA_WIDTH-2:0];
                case (current_state)
                    DATA_0: shift_register[0] <= data[0];
                    DATA_1: shift_register[0] <= data[1];
                    DATA_2: shift_register[0] <= data[2];
                    DATA_3: shift_register[0] <= data[3];
                    DATA_4: shift_register[0] <= data[4];
                    DATA_5: shift_register[0] <= data[5];
                    DATA_6: shift_register[0] <= data[6];
                    DATA_7: shift_register[0] <= data[7];
                    default: shift_register[0] <= 1'b0;
                endcase
            end else begin
                // Hold value
                shift_register <= shift_register;
            end
        end
    end

    // TX output (MSB of shift register)
    assign tx = shift_register[DATA_WIDTH-1];

    // Busy signal: high when not in IDLE state
    assign busy = (current_state != IDLE);

endmodule
