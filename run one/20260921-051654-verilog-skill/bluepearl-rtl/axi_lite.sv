module axil_regs (
    input  logic        clk,
    input  logic        rst,

    // Write Address Channel
    input  logic [31:0] awaddr,
    input  logic        awvalid,
    output logic        awready,

    // Write Data Channel
    input  logic [31:0] wdata,
    input  logic [3:0]  wstrb,
    input  logic        wvalid,
    output logic        wready,

    // Write Response Channel
    output logic [1:0]  bresp,
    output logic        bvalid,
    input  logic        bready,

    // Read Address Channel
    input  logic [31:0] araddr,
    input  logic        arvalid,
    output logic        arready,

    // Read Data Channel
    output logic [31:0] rdata,
    output logic [1:0]  rresp,
    output logic        rvalid,
    input  logic        rready,

    // Register Outputs
    output logic [31:0] reg0,
    output logic [31:0] reg1,
    output logic [31:0] reg2,
    output logic [31:0] reg3
);

    // Internal Registers
    logic [31:0] regs [0:3];
    assign reg0 = regs[0];
    assign reg1 = regs[1];
    assign reg2 = regs[2];
    assign reg3 = regs[3];

    // FSM States
    typedef enum logic [1:0] {
        IDLE,
        WRITE_WAIT_W,
        WRITE_RESP,
        READ_WAIT_DATA
    } state_t;

    state_t w_state, r_state;

    // Write Channel Handshaking Logic
    logic aw_accepted;
    logic w_accepted;

    always_ff @(posedge clk) begin
        if (rst) begin
            regs[0] <= 32'h0;
            regs[1] <= 32'h0;
            regs[2] <= 32'h0;
            regs[3] <= 32'h0;
            w_state <= IDLE;
            awready <= 1'b0;
            wready  <= 1'b0;
            bvalid  <= 1'b0;
            bresp   <= 2'b00;
            aw_accepted <= 1'b0;
            w_accepted  <= 1'b0;
        end else begin
            // AW Channel
            awready <= (w_state == IDLE);
            if (awvalid && awready) begin
                aw_accepted <= 1'b1;
            end else begin
                aw_accepted <= 1'b0;
            end

            // W Channel
            wready <= (w_state == IDLE || w_state == WRITE_WAIT_W);
            if (wvalid && wready) begin
                w_accepted <= 1'b1;
            end else begin
                w_accepted <= 1'b0;
            end

            // Write FSM
            case (w_state)
                IDLE: begin
                    if (aw_accepted && w_accepted) begin
                        w_state <= WRITE_RESP;
                        // Apply wstrb
                        for (int i = 0; i < 4; i++) begin
                            if (wstrb[i]) begin
                                regs[awaddr[3:2]][8*i +: 8] <= wdata[8*i +: 8];
                            end
                        end
                    end
                end
                WRITE_RESP: begin
                    bvalid <= 1'b1;
                    bresp  <= 2'b00; // OKAY
                    if (bvalid && bready) begin
                        bvalid <= 1'b0;
                        w_state <= IDLE;
                    end
                end
                default: w_state <= IDLE;
            endcase
        end
    end

    // Read Channel Handshaking Logic
    always_ff @(posedge clk) begin
        if (rst) begin
            r_state <= IDLE;
            arready <= 1'b0;
            rvalid  <= 1'b0;
            rdata   <= 32'h0;
            rresp   <= 2'b00;
        end else begin
            case (r_state)
                IDLE: begin
                    arready <= 1'b1;
                    if (arvalid && arready) begin
                        r_state <= READ_WAIT_DATA;
                    end
                end
                READ_WAIT_DATA: begin
                    arready <= 1'b0;
                    rvalid  <= 1'b1;
                    rresp   <= 2'b00;
                    // Decode address
                    if (araddr[3:2] == 2'b00)      rdata <= regs[0];
                    else if (araddr[3:2] == 2'b01) rdata <= regs[1];
                    else if (araddr[3:2] == 2'b10) rdata <= regs[2];
                    else if (araddr[3:2] == 2'b11) rdata <= regs[3];
                    else                           rdata <= 32'hDEADBEEF; // DECERR logic could go here

                    if (rvalid && rready) begin
                        rvalid <= 1'b0;
                        r_state <= IDLE;
                    end
                end
                default: r_state <= IDLE;
            endcase
        end
    end

endmodule
