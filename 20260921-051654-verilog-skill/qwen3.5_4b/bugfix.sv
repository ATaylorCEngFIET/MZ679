module mux_reg(
    input logic clk,
    input logic rst,
    input logic sel,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] q
);
  localparam WIDTH = 8;

  always_comb begin
    if (sel == 1'b1)
      q <= a;
    else
      q <= b;
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      q <= 8'h00;
    else
      q <= q; // No change needed, mux_comb handles selection
  end
endmodule
