//
// Module: sync_fifo
// Description: Synchronous FIFO with inferred Block RAM support.
//              Uses a pointer-based full/empty logic with an extra bit.
//

module sync_fifo #(
    parameter logic [3:0] WIDTH = 32,
    parameter integer DEPTH = 16  // Must be a power of two
)(
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    wr_en,
    input  logic [WIDTH-1:0]       wr_data,
    input  logic                    rd_en,
    output logic [WIDTH-1:0]       rd_data,
    output logic                    full,
    output logic                    empty
);

    localparam int ADDR_WIDTH = $clog2(DEPTH);
    
    // Internal signals
    logic [ADDR_WIDTH:0] wr_ptr;
    logic [ADDR_WIDTH:0] rd_ptr;

    // Memory array (Inferred Block RAM)
    logic [WIDTH-1:0] mem [DEPTH];

    // Combinational logic for status flags
    // Full: MSB differs, lower bits equal
    // Empty: All bits equal
    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && 
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    // Internal logic for valid operations
    logic wr_en_sync;
    logic rd_en_sync;

    assign wr_en_sync = wr_en && !full;
    assign rd_en_sync = rd_en && !empty;

    // Memory indexing
    logic [ADDR_WIDTH-1:0] write_addr;
    logic [ADDR_WIDTH-1:0] read_addr;

    assign write_addr = wr_ptr[ADDR_WIDTH-1:0];
    assign read_addr  = rd_ptr[ADDR_WIDTH-1:0];

    // Sequential logic
    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= {1'b0, {ADDR_WIDTH, 1'b0}};
            rd_ptr <= {1'b0, {ADDR_WIDTH, 1'b0}};
        end else begin
            if (wr_en_sync) begin
                mem[write_addr] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
            end
            
            if (rd_en_sync) begin
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

    // Combinational output for read data
    assign rd_data = mem[read_addr];

endmodule
