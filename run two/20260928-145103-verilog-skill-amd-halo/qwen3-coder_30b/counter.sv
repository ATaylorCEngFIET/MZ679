module counter4 (
  input  logic clk, rst, en,
  output logic [3:0] count);

  always_ff @(posedge clk) begin
    if (rst) begin
      count <= '0;
    end else begin
      if (en) begin
        if (count == 4'hF) count <= '0; else count <= count + 1'b1;
      end
    end
  end
endmodule
