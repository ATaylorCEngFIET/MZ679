/**
 * @file cdc_sync.sv
 * @brief Multi-stage synchronizer for a single-bit signal crossing clock domains.
 * 
 * @details Uses the Xilinx ASYNC_REG attribute to suggest the synthesis tool
 * to place the registers in a location that minimizes metastability risks.
 */

module cdc_sync #(
    parameter int STAGES = 2
) (
    input  logic        clk,
    input  logic        rst,
    input  logic        _in,
    output logic        _out
);

    // Internal signals for the synchronization chain
    // The first stage is the primary synchronizer, subsequent stages 
    // are used if STAGES > 2.
    logic [STAGES-1:0] sync_chain;

    // Synthesis attributes for Xilinx tools
    // Note: The attribute is applied to the first stage of the synchronizer
    // to ensure it is placed in a dedicated sync_cell or optimized for CDC.
    (* ASYNC_REG = "TRUE" *) logic [0:0] sync_stage_0;

    // Logic for the first stage
    always_ff @(posedge clk) begin
        if (rst) begin
            sync_stage_0 <= 1'b0;
        end else begin
            sync_stage_0 <= _in;
        end
    end

    // Logic for subsequent stages
    // This loop handles cases where STAGES > 2.
    // If STAGES = 2, the loop runs once, and _out is assigned from sync_stage_1.
    logic [STAGES-2:0] internal_chain;

    // Assign the first stage to the start of the internal chain
    assign internal_chain[0] = sync_stage_0;

    // Generate block to instantiate the remaining stages
    genvar i;
    generate
        for (i = 0; i < STAGES - 1; i++) begin : gen_sync_chain
            // The logic for the next stage in the chain
            // If i=0, this is the second stage (index 1)
            // If STAGES=2, the loop runs once, and the result is the final output.
            // We use a shift-register style logic to handle the chain.
        end
    endgenerate

    // Simplified implementation for standard 2-stage and multi-stage logic
    // to ensure the output is correctly mapped regardless of STAGES.
    
    // Re-implementing logic to be strictly compliant with the requirement
    // while maintaining the ability to handle STAGES > 2.
    
    logic [STAGES-1:0] sync_regs;

    // The first stage is the one directly capturing the input signal.
    // The last stage is the one providing the output.
    
    // To strictly follow the "two-flop" requirement while allowing 
    // the parameter STAGES to be modified, we treat the first stage 
    // as the primary sync and the rest as additional safety stages.
    
    // Refined implementation:
    logic [STAGES-1:0] sync_pipeline;

    // First stage is the one that captures the cross-domain signal.
    (* ASYNC_REG = "TRUE" *) always_ff @(posedge clk) begin
        if (rst) begin
            sync_pipeline[0] <= 1'b0;
        end else begin
            sync_pipeline[0] <= _in;
        end
    end

    // Subsequent stages
    for (i = 1; i < STAGES; i++) begin : gen_sync
        always_ff @(posedge clk) begin
            if (rst) begin
                sync_pipeline[i] <= 1'b0;
            end else begin
                sync_pipeline[i] <= sync_pipeline[i-1];
            end
        end
    end

    // The output is the last stage of the pipeline.
    // If STAGES=2, this is index 1.
    assign _out = sync_pipeline[STAGES-1];

endmodule
