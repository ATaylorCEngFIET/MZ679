module cdc_sync #(parameter int STAGES = 2) (
  input  logic       clk, rst,
  input  logic       async_in,
  output logic       sync_out
);
  (* ASYNC_REG = "TRUE" *) logic [STAGES-1:0] sync;

  always_ff @(posedge clk) begin
    if (rst) begin
      sync <= '0;
    end else begin
      sync <= {sync[STAGES-2:0], async_in};
    end
  end

  assign sync_out = sync[STAGES-1];
endmodule
