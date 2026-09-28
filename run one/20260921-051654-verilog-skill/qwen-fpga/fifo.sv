module sync_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic                      clk,
    input  logic                      rst,
    input  logic                      wr_en,
    input  logic [WIDTH-1:0]         wr_data,
    input  logic                      rd_en,
    output logic [WIDTH-1:0]         rd_data,
    output logic                     full,
    output logic                     empty
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    logic [ADDR_WIDTH+1:0] wr_ptr;
    logic [ADDR_WIDTH+1:0] rd_ptr;
    logic [WIDTH-1:0] mem [DEPTH-1:0];

    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else if (wr_en) begin
            wr_ptr <= wr_ptr + 1'b1;
        end
        if (rd_en) begin
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= '0;
        end else if (wr_en && wr_ptr[ADDR_WIDTH] == rd_ptr[ADDR_WIDTH]) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
        end
    end

    always_comb begin
        rd_data = '0;
        if (rd_ptr < DEPTH) begin
            rd_data = mem[rd_ptr];
        end
    end

    full = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && 
           (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    empty = (wr_ptr == rd_ptr);

endmodule
