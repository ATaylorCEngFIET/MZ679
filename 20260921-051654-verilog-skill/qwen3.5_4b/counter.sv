module counter4 (
    input logic clk,
    input logic rst_n,
    input logic en,
    output logic [3:0] count
);

    localparam WIDTH = 4;

    always_ff @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            count <= 4'd0;
        end else begin
            if (en) begin
                count <= count + 1'b1;
            end else begin
                count <= count;
            end
        end
    end

endmodule
