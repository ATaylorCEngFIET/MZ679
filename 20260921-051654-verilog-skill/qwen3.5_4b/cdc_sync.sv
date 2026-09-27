module cdc_sync (
    input logic clk_src,
    input logic rst_n_src,
    input logic in_bit,
    output logic out_bit
);

    localparam integer STAGES = 2;
    localparam integer WIDTH = $clog2(STAGES) + 1;
    
    typedef enum logic [WIDTH-1:0] {
        IDLE,
        SYNC_1,
        SYNC_2
    } state_t;

    // State registers in source domain
    state_t state_reg_src;
    integer state_next_src;
    
    // State registers in destination domain (synchronised)
    state_t state_reg_dst;
    integer state_next_dst;

    // Output register in destination domain
    logic out_bit_reg;

    // Source domain combinational logic
    always_comb begin
        case (state_reg_src)
            IDLE: state_next_src = SYNC_1;
            SYNC_1: state_next_src = SYNC_2;
            SYNC_2: state_next_src = IDLE;
            default: state_next_src = IDLE;
        endcase
    end

    // Source domain sequential logic
    always_ff @(posedge clk_src or negedge rst_n_src) begin
        if (!rst_n_src) begin
            state_reg_src <= IDLE;
            out_bit_reg <= 1'b0;
        end else begin
            state_reg_src <= state_next_src;
        end
    end

    // Destination domain combinational logic (FSM for sync)
    always_comb begin
        case (state_reg_dst)
            IDLE: state_next_dst = SYNC_1;
            SYNC_1: state_next_dst = SYNC_2;
            SYNC_2: state_next_dst = IDLE;
            default: state_next_dst = IDLE;
        endcase
    end

    // Destination domain sequential logic (Two-flop synchroniser)
    always_ff @(posedge clk_src or negedge rst_n_src) begin
        if (!rst_n_src) begin
            state_reg_dst <= IDLE;
            out_bit_reg <= 1'b0;
        end else begin
            state_reg_dst <= state_next_dst;
            
            // Output the input bit only when in SYNC_2 state (after two clock cycles)
            if (state_reg_dst == SYNC_2) begin
                out_bit_reg <= in_bit;
            end
        end
    end

    // Final output registered to ensure clean synthesis and stability
    assign out_bit = out_bit_reg;

endmodule
