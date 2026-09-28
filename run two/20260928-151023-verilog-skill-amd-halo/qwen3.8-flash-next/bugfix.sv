module mux_reg(input logic clk, rst, sel, input logic [7:0] a, b, output logic [7:0] q);
  logic [7:0] r;
  always_comb begin
    if (sel) r = a;
    else     r = b;
  end
  always_ff @(posedge clk) begin
    if (rst) q <= 8'h00;
    else     q <= r;
  end
endmodule
