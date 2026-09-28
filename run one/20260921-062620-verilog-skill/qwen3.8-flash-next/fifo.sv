module sync_fifo #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             wr_en,
    input  logic [WIDTH-1:0] wr_data,
    input  logic             rd_en,
    output logic [WIDTH-1:0] rd_data,
    output logic             full,
    output logic             empty
);

    localparam int PTR_BITS = $clog2(DEPTH);

    logic [WIDTH-1:0] mem [0:DEPTH-1];

    logic [PTR_BITS:0] wr_ptr;
    logic [PTR_BITS:0] rd_ptr;

    logic wr_fire;
    logic rd_fire;

    always_comb begin
        wr_fire = wr_en && !full;
        rd_fire = rd_en && !empty;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            if (wr_fire) begin
                mem[wr_ptr[PTR_BITS-1:0]] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
            end

            if (rd_fire) begin
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            rd_data <= '0;
        end else if (rd_fire) begin
            rd_data <= mem[rd_ptr[PTR_BITS-1:0]];
        end
    end

    always_comb begin
        empty = (wr_ptr == rd_ptr);
        full  = (wr_ptr[PTR_BITS] != rd_ptr[PTR_BITS]) &&
                (wr_ptr[PTR_BITS-1:0] == rd_ptr[PTR_BITS-1:0]);
    end

endmodule
