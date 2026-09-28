module counter4 #(parameter int WIDTH = 4) (
  input  logic        clk, rst,
  input  logic        en,
  output logic [WIDTH-1:0] count);

  always_ff @(posedge clk) begin
    if (rst) begin
      count <= '0;
    end else begin
      if (en) begin
        count <= count + 1'b1;
      end
    end
  end
endmodule
