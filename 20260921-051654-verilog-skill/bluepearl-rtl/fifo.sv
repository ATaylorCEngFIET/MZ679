module sync_fifo #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  wr_en,
    input  logic [WIDTH-1:0]      wr_data,
    input  logic                  rd_en,
    output logic [WIDTH-1:0]      rd_data,
    output logic                  full,
    output logic                  empty
);

    localparam int ADDR_W = $clog2(DEPTH);

    // Pointers are one bit wider than address to handle wrap-around
    logic [ADDR_W:0] wr_ptr;
    logic [ADDR_W:0] rd_ptr;

    // Memory array
    logic [WIDTH-1:0] mem [DEPTH];

    // Status flags
    logic full_reg;
    logic empty_reg;

    // Write Logic
    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= '0;
        end else if (wr_en && !full_reg) begin
            mem[wr_ptr[ADDR_W-1:0]] <= wr_data;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // Read Logic
    always_ff @(posedge clk) begin
        if (rst) begin
            rd_ptr <= '0;
        end else if (rd_en && !empty_reg) begin
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // Combinational status flags
    // Empty: pointers are identical
    // Full: MSB differs, remaining bits are identical
    always_comb begin
        empty_reg = (wr_ptr == rd_ptr);
        full_reg  = (wr_ptr[ADDR_W] != rd_ptr[ADDR_W]) && 
                    (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);
    end

    // Output assignments
    assign full  = full_reg;
    assign empty = empty_reg;
    
    // Synchronous read from memory
    always_ff @(posedge clk) begin
        if (rst) begin
            rd_data <= '0;
        end else if (rd_en && !empty_reg) begin
            rd_data <= mem[rd_ptr[ADDR_W-1:0]];
        end else begin
            rd_data <= '0;
        end
    end

endmodule
