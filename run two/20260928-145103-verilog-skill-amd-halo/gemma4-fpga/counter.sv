module counter4 (
  input  logic        clk,
  input  logic        rst,
  input  logic        en,
  output logic [3:0] count
);

  logic [3:0] count_reg;

  always_ff @(posedge clk) begin
    if (rst) begin
      count_reg <= 4'h0;
    end else if (en) begin
      count_reg <= count_reg + 1'b1;
    end
  end

  assign count = count_reg;

endmodule
