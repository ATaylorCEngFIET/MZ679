// SPDX-License-Identifier: MIT
// Copyright (c) 2024 Senior FPGA Engineer

module cdc_sync #(
    parameter int STAGES = 2
) (
    input  logic clk_dest,
    input  logic rst_n,
    input  logic async_in,
    output logic sync_out
);

    // Internal signal to hold the synchronized value
    logic [STAGES-1:0] sync_regs;

    // Sequential logic for the synchronizer chain
    always_ff @(posedge clk_dest or negedge rst_n) begin
        if (!rst_n) begin
            sync_regs <= '0;
        end else begin
            // Shift the input through the chain
            // The first stage captures the asynchronous input
            // Subsequent stages provide the synchronization delay
            sync_regs <= {sync_regs[STAGES-2:0], async_in};
        end
    end

    // Assign the last flop in the chain to the output
    // Apply ASYNC_REG attribute to all flops in the chain to prevent optimization
    // and ensure they are placed in the same slice/slice-adjacent for timing.
    // Note: In SystemVerilog, attributes are applied to the signal/logic.
    // We use a generate block to apply the attribute to each bit of the register.

    genvar i;
    generate
        for (i = 0; i < STAGES; i++) begin : gen_sync_stages
            // This attribute tells synthesis tools that these flops are part of a CDC chain
            // and should not be optimized away or moved far from each other.
            (* ASYNC_REG = "TRUE" *) logic dummy_attr; 
        end
    endgenerate

    // In modern synthesis tools (Vivado/Quartus), the attribute is applied to the register itself.
    // Since we cannot apply attributes to individual bits of a vector easily in some tools 
    // without a generate block, we use a flattened approach or individual signals.
    // However, for a single module, we define the register and apply the attribute.
    
    // Re-defining sync_regs with attribute for the whole vector
    (* ASYNC_REG = "TRUE" *) logic [STAGES-1:0] sync_regs_attr;

    always_ff @(posedge clk_dest or negedge rst_n) begin
        if (!rst_n) begin
            sync_regs_attr <= '0;
        end else begin
            sync_regs_attr <= {sync_regs_attr[STAGES-2:0], async_in};
        end
    end

    assign sync_out = sync_regs_attr[STAGES-1];

endmodule
