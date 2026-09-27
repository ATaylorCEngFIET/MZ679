module mux_reg (
    input  logic       clk,
    input  logic       rst,
    input  logic       sel,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] q
);

    logic [7:0] r;

    always_comb begin
        if (sel == 1'b1) begin
            r = a;
        end else begin
            r = b;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            q <= 8'h00;
        end else begin
            q <= r;
        end
    end

endmodule
