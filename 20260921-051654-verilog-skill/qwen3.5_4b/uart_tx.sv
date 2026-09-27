module uart_tx (
    input logic clk,
    input logic rst_n,
    input logic [7:0] data,
    input logic data_valid,
    output logic tx,
    output logic busy
);

    localparam CLK_FREQ = 10_000_000;
    localparam BAUD_RATE = 9600;
    localparam BITS_PER_FRAME = 10; // 1 start + 8 data + 1 stop
    localparam TICKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    typedef enum logic [3:0] {
        IDLE,
        START,
        DATA_0,
        DATA_1,
        DATA_2,
        DATA_3,
        DATA_4,
        DATA_5,
        DATA_6,
        DATA_7,
        STOP
    } state_t;

    // Internal registers (synchronous active-high reset)
    reg logic [3:0] state_reg;
    reg logic data_valid_reg;
    reg logic [7:0] data_reg;
    reg logic busy_reg;
    reg logic tx_reg;
    
    // Baud counter
    reg logic [16:0] baud_counter;
    wire logic baud_tick = (baud_counter == TICKS_PER_BIT - 1);

    // State machine next state logic
    always_comb begin
        state_reg = IDLE;
        data_valid_reg = data_valid;
        data_reg = data;
        busy_reg = 0;
        tx_reg = 1'b0;
        
        if (rst_n) begin
            state_reg <= IDLE;
            data_valid_reg <= 0;
            data_reg <= 8'd0;
            busy_reg <= 0;
            baud_counter <= 0;
        end else begin
            case (state_reg)
                IDLE: begin
                    if (data_valid_reg) begin
                        state_reg <= START;
                        data_valid_reg <= 1'b1;
                        data_reg <= data;
                        busy_reg <= 1'b1;
                    end
                end
                START: begin
                    state_reg <= DATA_0;
                end
                DATA_0: begin
                    if (baud_tick) begin
                        state_reg <= DATA_1;
                        tx_reg <= data_reg[7]; // LSB first
                    end
                end
                DATA_1: begin
                    if (baud_tick) begin
                        state_reg <= DATA_2;
                        tx_reg <= data_reg[6];
                    end
                end
                DATA_2: begin
                    if (baud_tick) begin
                        state_reg <= DATA_3;
                        tx_reg <= data_reg[5];
                    end
                end
                DATA_3: begin
                    if (baud_tick) begin
                        state_reg <= DATA_4;
                        tx_reg <= data_reg[4];
                    end
                end
                DATA_4: begin
                    if (baud_tick) begin
                        state_reg <= DATA_5;
                        tx_reg <= data_reg[3];
                    end
                end
                DATA_5: begin
                    if (baud_tick) begin
                        state_reg <= DATA_6;
                        tx_reg <= data_reg[2];
                    end
                end
                DATA_6: begin
                    if (baud_tick) begin
                        state_reg <= DATA_7;
                        tx_reg <= data_reg[1];
                    end
                end
                DATA_7: begin
                    if (baud_tick) begin
                        state_reg <= STOP;
                        tx_reg <= 1'b1;
                    end
                end
                STOP: begin
                    if (baud_tick) begin
                        state_reg <= IDLE;
                        data_valid_reg <= 0;
                        busy_reg <= 0;
                        baud_counter <= 0;
                    end
                end
                default: state_reg = IDLE;
            endcase
        end
    end

    // Baud counter logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            baud_counter <= 0;
        end else begin
            baud_counter <= baud_counter + 1'b1;
        end
    end

    // Output assignment
    assign tx = tx_reg;
    assign busy = busy_reg;

endmodule
