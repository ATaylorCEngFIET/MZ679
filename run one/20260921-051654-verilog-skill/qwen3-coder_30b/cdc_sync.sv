module cdc_sync #(
    parameter int STAGES = 2
)(
    input  logic        clk_src,
    input  logic        clk_dst,
    input  logic        din,
    output logic        dout
);

logic [STAGES-1:0] sync_reg;

always_ff @(posedge clk_src) begin
    sync_reg[0] <= din;
end

for (genvar i = 1; i < STAGES; i++) begin : gen_sync_reg
    always_ff @(posedge clk_dst) begin
        (* ASYNC_REG = "TRUE" *)
        sync_reg[i] <= sync_reg[i-1];
    end
end

always_ff @(posedge clk_dst) begin
    dout <= sync_reg[STAGES-1];
end

endmodule
