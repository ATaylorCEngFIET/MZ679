module sync_fifo (
    input logic clk,
    input logic rst,
    input logic wr_en,
    input logic [WIDTH-1:0] wr_data,
    input logic rd_en,
    output logic full,
    output logic empty
);

    parameter DEPTH = 8; // Fixed default for synthesis if not provided by user context
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam WR_PTR_WIDTH = ADDR_WIDTH + 1;
    localparam RD_PTR_WIDTH = ADDR_WIDTH + 1;

    typedef enum logic [ADDR_WIDTH-1:0] {
        EMPTY,
        FULL
    } state_t;

    // RAM declaration
    logic [WIDTH-1:0] data_mem [DEPTH];
    logic [WR_PTR_WIDTH-1:0] wr_ptr;
    logic [RD_PTR_WIDTH-1:0] rd_ptr;

    // State machine for full/empty detection
    typedef enum logic [ADDR_WIDTH-1:0] {
        IDLE,
        WR_FULL,
        RD_EMPTY
    } fsm_state_t;

    fsm_state_t current_fsm_state = IDLE;

    // Pointer registers (synchronous)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            current_fsm_state <= IDLE;
        end else begin
            if (wr_en && !rd_en) begin
                wr_ptr <= wr_ptr + 1'b1;
                if (current_fsm_state == WR_FULL) begin
                    current_fsm_state <= RD_EMPTY;
                end else begin
                    current_fsm_state <= IDLE;
                end
            end else if (!wr_en && rd_en) begin
                rd_ptr <= rd_ptr + 1'b1;
                if (current_fsm_state == RD_EMPTY) begin
                    current_fsm_state <= WR_FULL;
                end else begin
                    current_fsm_state <= IDLE;
                end
            end else begin
                // Both enabled: check for overflow/underflow conditions
                if (wr_ptr == rd_ptr + 1'b1 && current_fsm_state != RD_EMPTY) begin
                    current_fsm_state <= WR_FULL;
                end else if (rd_ptr == wr_ptr + 1'b1 && current_fsm_state != WR_FULL) begin
                    current_fsm_state <= RD_EMPTY;
                end else begin
                    current_fsm_state <= IDLE;
                end
            end
        end
    end

    // Full/Empty logic based on FSM state and pointer positions
    always_comb begin
        empty = (current_fsm_state == RD_EMPTY) || (rd_ptr == wr_ptr);
        full = (current_fsm_state == WR_FULL) || (wr_ptr == rd_ptr + 1'b1);
    end

endmodule
