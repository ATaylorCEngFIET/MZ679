module mux_reg (
  input  logic clk, rst, sel,
  input  logic [7:0] a, b,
  output logic [7:0] q);

  logic [7:0] r;

  always_comb begin
    if (sel == 1'b1) r = a;
    else r = b;
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      q <= '0;
    end else begin
      q <= r;
    end
  end
endmodule
