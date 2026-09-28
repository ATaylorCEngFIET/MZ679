module axil_regs #(
    parameter DATA_WIDTH = 32
)(
    input  logic                    clk,
    // AW Channel
    input  logic                   awvalid,
    output logic                  awready,
    input  logic [31:0]            awaddr,
    input  logic [1:0]             awprot,
    // W Channel
    input  logic                   wvalid,
    output logic                  wready,
    input  logic [DATA_WIDTH-1:0]  wdata,
    input  logic [DATA_WIDTH/8-1:0] wstrb,
    // B Channel
    output logic                   bvalid,
    input  logic                  bready,
    output logic [1:0]            bresp,
    // AR Channel
    input  logic                   arvalid,
    output logic                  arready,
    input  logic [31:0]            araddr,
    // R Channel
    output logic                   rvalid,
    input  logic                  rready,
    output logic [DATA_WIDTH-1:0]  rdata,
    output logic [1:0]            rresp
);

    typedef enum logic [3:0] {
        IDLE = 4'd0,
        AW_WAIT = 4'd1,
        W_WAIT = 4'd2,
        B_DONE = 4'd3,
        AR_WAIT = 4'd4,
        R_WAIT = 4'd5
    } state_t;

    state_t current_state, next_state;

    // Register array
    logic [DATA_WIDTH-1:0] reg_array [3];

    // State Machine
    always_ff @(posedge clk) begin
        case (next_state)
            IDLE: current_state <= IDLE;
            default: current_state <= next_state;
        endcase
    end

    always_comb begin
        next_state = current_state;
        awready = 1'b0;
        wready = 1'b0;
        bvalid = 1'b0;
        arready = 1'b0;
        rvalid = 1'b0;
        bresp = 2'b11; // DECERR default
        rdata = '0;
        rresp = 2'b11; // DECERR default

        case (current_state)
            IDLE: begin
                if (awvalid && !awready) next_state = AW_WAIT;
                else if (arvalid && !arready) next_state = AR_WAIT;
                awready = 1'b1;
                arready = 1'b1;
            end

            AW_WAIT: begin
                // Hold AW ready until W channel is ready or B is done
                if (wvalid && wready) next_state = W_WAIT;
                else if (bvalid && !bready) next_state = B_DONE;
                awready = 1'b1;
            end

            W_WAIT: begin
                // Wait for all writes to complete
                if (!wvalid || !wready) next_state = AW_WAIT;
                wready = 1'b1;
            end

            B_DONE: begin
                bvalid = 1'b0;
                next_state = IDLE;
            end

            AR_WAIT: begin
                // Hold AR ready until R is done
                if (rvalid && rready) next_state = R_WAIT;
                arready = 1'b1;
            end

            R_WAIT: begin
                rvalid = 1'b0;
                next_state = IDLE;
            end
        endcase
    end

    // Write logic
    always_ff @(posedge clk) begin
        if (current_state == AW_WAIT && wvalid && wready) begin
            integer idx;
            idx = awaddr[3:2]; // 0x0, 0x4, 0x8, 0xC -> 0, 1, 2, 3
            
            if (idx < 4) begin
                reg_array[idx] <= wdata;
            end
        end
    end

    // Read logic
    always_ff @(posedge clk) begin
        if (current_state == AR_WAIT && rvalid && rready) begin
            integer idx;
            idx = araddr[3:2];
            
            if (idx < 4) begin
                rdata <= reg_array[idx];
                rresp <= 2'b00; // OKAY
            end else begin
                rdata <= '0;
                rresp <= 2'b11; // DECERR
            end
        end
    end

    // Output ports for registers
    assign reg0 = reg_array[0];
    assign reg1 = reg_array[1];
    assign reg2 = reg_array[2];
    assign reg3 = reg_array[3];

endmodule
