module cdc_sync #(
  parameter int STAGES = 2
) (
  input  logic clk, rst,
  input  logic din,
  output logic dout
);

  (* ASYNC_REG = "TRUE" *) logic [STAGES-1:0] sync;

  always_ff @(posedge clk) begin
    if (rst) begin
      sync <= '0;
    end else begin
      sync <= {sync[STAGES-2:0], din};
    end
  end

  assign dout = sync[STAGES-1];

endmodule
