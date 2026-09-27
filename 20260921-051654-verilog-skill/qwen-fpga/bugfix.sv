module mux_reg(
    input logic clk,
    input logic rst,
    input logic sel,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] q
);
  always_comb begin
    if (sel == 1'b1)
      q = a;
    else
      q = b;
  end
  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      q <= '0;
    else
      q <= q;
  end
endmodule
