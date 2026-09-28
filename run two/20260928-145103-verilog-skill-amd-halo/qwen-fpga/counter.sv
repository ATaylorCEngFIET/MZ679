module counter4 (
  input  logic        clk,
  input  logic        rst,
  input  logic        en,
  output logic [3:0]  count
);

  always_ff @(posedge clk) begin
    if (rst) begin
      count <= '0;
    end else if (en) begin
      count <= count + 1'b1;
    end
  end

endmodule
