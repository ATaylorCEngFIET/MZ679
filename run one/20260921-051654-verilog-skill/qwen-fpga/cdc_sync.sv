module cdc_sync #(
    parameter STAGES = 2
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  data_in,
    output logic                 data_out
);

    // Generate number of stages from parameter
    localparam int WIDTH_STAGES = $clog2(STAGES + 1);
    
    // Internal state to hold the synchronised value
    typedef enum logic [WIDTH_STAGES-1:0] {
        STAGE_0,
        STAGE_1,
        STAGE_2
    } stage_t;

    stage_t current_stage;
    stage_t next_stage;
    logic data_reg;

    // Next state logic
    always_comb begin
        next_stage = current_stage;
        case (current_stage)
            STAGE_0: if (data_in) next_stage = STAGE_1;
            STAGE_1: if (data_reg) next_stage = STAGE_2;
            default: next_stage = current_stage;
        endcase
    end

    // Synchroniser stages
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_stage <= STAGE_0;
            data_reg     <= '0;
        end else begin
            current_stage <= next_stage;
            
            case (current_stage)
                STAGE_0: data_reg <= data_in;
                STAGE_1: data_reg <= data_reg; // Hold value from stage 0
                STAGE_2: data_reg <= data_reg; // Hold final value
                default: ;
            endcase
        end
    end

    // Output is the last stage's data
    assign data_out = (current_stage == STAGE_2) ? data_reg : '0;

endmodule
