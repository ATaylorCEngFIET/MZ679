module cdc_sync #(parameter int STAGES = 2) (
  input  logic clk,
  input  logic rst,
  input  logic async_in,
  output logic sync_out
);

  (* ASYNC_REG = "TRUE" *) logic [STAGES-1:0] sync_regs;

  always_ff @(posedge clk) begin
    if (rst) begin
      sync_regs <= '0;
    end else begin
      sync_regs <= {sync_regs[STAGES-2:0], async_in};
    end
  end

  assign sync_out = sync_regs[STAGES-1];

endmodule
