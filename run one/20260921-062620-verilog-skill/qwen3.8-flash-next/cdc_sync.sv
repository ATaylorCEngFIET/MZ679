module cdc_sync #(
    parameter int STAGES = 2
) (
    input  logic clk,
    input  logic rst,
    input  logic din,
    output logic dout
);

    logic [STAGES-1:0] sync_reg;

    always_ff @(posedge clk) begin
        if (rst) begin
            sync_reg <= '0;
        end else begin
            sync_reg <= {sync_reg[STAGES-2:0], din};
        end
    end

    (* ASYNC_REG = "TRUE" *) logic sync_reg_0;
    (* ASYNC_REG = "TRUE" *) logic sync_reg_1;

    always_ff @(posedge clk) begin
        if (rst) begin
            sync_reg_0 <= 1'b0;
            sync_reg_1 <= 1'b0;
        end else begin
            sync_reg_0 <= din;
            sync_reg_1 <= sync_reg_0;
        end
    end

    assign dout = sync_reg_1;

endmodule
