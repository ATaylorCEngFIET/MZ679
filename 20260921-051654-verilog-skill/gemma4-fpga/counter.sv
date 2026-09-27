// Module: counter4
// Description: 4-bit counter with synchronous active-high reset and enable.
module counter4 (
    input  logic        clk,
    input  logic        rst,
    input  logic        en,
    output logic [3:0]  count
);

    // Internal register for the counter
    logic [3:0] count_reg;

    // Sequential logic for the counter
    always_ff @(posedge clk) begin
        if (rst) begin
            count_reg <= 4'h0;
        end else if (en) begin
            count_reg <= count_reg + 1'b1;
        end
    end

    // Continuous assignment for output
    assign count = count_reg;

endmodule
