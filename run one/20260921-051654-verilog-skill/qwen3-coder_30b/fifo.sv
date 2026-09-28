module sync_fifo #(
    parameter int WIDTH  = 8,
    parameter int DEPTH  = 16
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        wr_en,
    input  logic [WIDTH-1:0] wr_data,
    input  logic        rd_en,
    output logic [WIDTH-1:0] rd_data,
    output logic        full,
    output logic        empty
);

    localparam int PTR_WIDTH = $clog2(DEPTH);
    localparam int ADDR_WIDTH = PTR_WIDTH + 1;

    logic [PTR_WIDTH-1:0] wr_addr, rd_addr;
    logic wr_wrap, rd_wrap;
    logic [ADDR_WIDTH-1:0] ram_addr;
    logic [WIDTH-1:0] ram_data_out;
    logic [WIDTH-1:0] ram_data_in;
    logic ram_wr_en;

    // RAM instantiation
    logic [WIDTH-1:0] ram [0:DEPTH-1];

    // Address calculation
    assign ram_addr = {wr_wrap, wr_addr};
    assign ram_data_in = wr_data;
    assign ram_wr_en = wr_en;

    // Read address
    assign rd_data = ram_data_out;

    // Full/empty detection
    assign full = (wr_addr == rd_addr) && (wr_wrap != rd_wrap);
    assign empty = (wr_addr == rd_addr) && (wr_wrap == rd_wrap);

    always_comb begin
        wr_addr = wr_addr;
        rd_addr = rd_addr;
        wr_wrap = wr_wrap;
        rd_wrap = rd_wrap;

        if (wr_en && !full) begin
            wr_addr = wr_addr + 1;
            if (wr_addr == '0)
                wr_wrap = ~wr_wrap;
        end

        if (rd_en && !empty) begin
            rd_addr = rd_addr + 1;
            if (rd_addr == '0)
                rd_wrap = ~rd_wrap;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_addr <= '0;
            rd_addr <= '0;
            wr_wrap <= '0;
            rd_wrap <= '0;
        end else begin
            wr_addr <= wr_addr;
            rd_addr <= rd_addr;
            wr_wrap <= wr_wrap;
            rd_wrap <= rd_wrap;
        end
    end

    always_ff @(posedge clk) begin
        if (ram_wr_en)
            ram[ram_addr] <= ram_data_in;
        ram_data_out <= ram[rd_addr];
    end

endmodule
