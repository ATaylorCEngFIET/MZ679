module cdc_sync #(
    parameter int unsigned STAGES = 2
) (
    input  logic clk,
    input  logic rst,
    input  logic d,
    output logic q
);

    localparam int unsigned W = STAGES;

    logic [W-1:0] sync_reg;

    always_ff @(posedge clk) begin
        if (rst) begin
            sync_reg <= '0;
        end else begin
            sync_reg <= {sync_reg[W-2:0], d};
        end
    end

    assign q = sync_reg[W-1];

endmodule
