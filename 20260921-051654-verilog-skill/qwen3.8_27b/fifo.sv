module sync_fifo #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16
) (
    input  logic              clk,
    input  logic              rst,
    input  logic              wr_en,
    input  logic [WIDTH-1:0]  wr_data,
    input  logic              rd_en,
    output logic [WIDTH-1:0]  rd_data,
    output logic              full,
    output logic              empty
);

    localparam int ADDR_W = $clog2(DEPTH);
    localparam int PTR_W  = ADDR_W + 1;

    logic [PTR_W-1:0] wr_ptr;
    logic [PTR_W-1:0] rd_ptr;
    logic [WIDTH-1:0] mem [DEPTH-1:0];

    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr[ADDR_W-1:0]] <= wr_data;
                wr_ptr <= wr_ptr + PTR_W'(1);
            end
            if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + PTR_W'(1);
            end
        end
    end

    always_comb begin
        rd_data = mem[rd_ptr[ADDR_W-1:0]];
        full    = (wr_ptr[PTR_W-1] != rd_ptr[PTR_W-1]) && (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);
        empty   = (wr_ptr == rd_ptr);
    end

endmodule
