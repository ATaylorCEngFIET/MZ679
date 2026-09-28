module axil_regs (
    input  logic        clk,
    input  logic        rst,

    // Write address channel
    input  logic        awvalid,
    input  logic [31:0] awaddr,
    output logic        awready,

    // Write data channel
    input  logic        wvalid,
    input  logic [31:0] wdata,
    input  logic [3:0]  wstrb,
    output logic        wready,

    // Write response channel
    output logic        bvalid,
    input  logic        bready,
    output logic [1:0]  bresp,

    // Read address channel
    input  logic        arvalid,
    input  logic [31:0] araddr,
    output logic        arready,

    // Read data channel
    output logic        rvalid,
    output logic [31:0] rdata,
    output logic [1:0]  rresp,

    // Register outputs
    output logic [31:0] reg0,
    output logic [31:0] reg1,
    output logic [31:0] reg2,
    output logic [31:0] reg3
);

    typedef enum logic [1:0] {
        WR_IDLE = 2'b00,
        WR_WAIT = 2'b01,
        WR_RESP = 2'b10
    } wr_state_t;

    wr_state_t wr_state;
    wr_state_t wr_next_state;

    logic aw_pending;
    logic w_pending;
    logic aw_fire;
    logic w_fire;
    logic wr_done;

    logic [31:0] aw_addr_reg;
    logic [31:0] w_data_reg;
    logic [3:0]  w_strb_reg;

    logic [31:0] regs [0:3];

    assign reg0 = regs[0];
    assign reg1 = regs[1];
    assign reg2 = regs[2];
    assign reg3 = regs[3];

    assign aw_fire = awvalid && awready;
    assign w_fire  = wvalid  && wready;
    assign wr_done = (wr_state == WR_RESP) && bvalid && bready;

    always_comb begin
        awready = 1'b0;
        wready  = 1'b0;
        bvalid  = 1'b0;
        bresp   = 2'b00;

        wr_next_state = wr_state;

        case (wr_state)
            WR_IDLE: begin
                aw_pending = 1'b0;
                w_pending  = 1'b0;

                if (awvalid && wvalid) begin
                    awready = 1'b1;
                    wready  = 1'b1;
                    wr_next_state = WR_RESP;
                end else if (awvalid) begin
                    awready = 1'b1;
                    wr_next_state = WR_WAIT;
                end else if (wvalid) begin
                    wready = 1'b1;
                    wr_next_state = WR_WAIT;
                end
            end

            WR_WAIT: begin
                aw_pending = 1'b1;
                w_pending  = 1'b1;

                if (aw_pending && w_pending) begin
                    wr_next_state = WR_RESP;
                end else if (aw_pending) begin
                    wready = 1'b1;
                end else if (w_pending) begin
                    awready = 1'b1;
                end
            end

            WR_RESP: begin
                aw_pending = 1'b1;
                w_pending  = 1'b1;
                bvalid = 1'b1;
                bresp  = 2'b00;

                if (bready) begin
                    wr_next_state = WR_IDLE;
                end
            end

            default: begin
                wr_next_state = WR_IDLE;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            wr_state    <= WR_IDLE;
            aw_pending  <= 1'b0;
            w_pending   <= 1'b0;
            aw_addr_reg <= '0;
            w_data_reg  <= '0;
            w_strb_reg  <= '0;
            regs[0]     <= '0;
            regs[1]     <= '0;
            regs[2]     <= '0;
            regs[3]     <= '0;
        end else begin
            wr_state <= wr_next_state;

            if (aw_fire) begin
                aw_addr_reg <= awaddr;
            end

            if (w_fire) begin
                w_data_reg <= wdata;
                w_strb_reg <= wstrb;
            end

            if (wr_done) begin
                case (aw_addr_reg[3:2])
                    2'b00: begin
                        for (int i = 0; i < 4; i++) begin
                            if (w_strb_reg[i]) begin
                                regs[0][8*i +: 8] <= w_data_reg[8*i +: 8];
                            end
                        end
                    end
                    2'b01: begin
                        for (int i = 0; i < 4; i++) begin
                            if (w_strb_reg[i]) begin
                                regs[1][8*i +: 8] <= w_data_reg[8*i +: 8];
                            end
                        end
                    end
                    2'b10: begin
                        for (int i = 0; i < 4; i++) begin
                            if (w_strb_reg[i]) begin
                                regs[2][8*i +: 8] <= w_data_reg[8*i +: 8];
                            end
                        end
                    end
                    2'b11: begin
                        for (int i = 0; i < 4; i++) begin
                            if (w_strb_reg[i]) begin
                                regs[3][8*i +: 8] <= w_data_reg[8*i +: 8];
                            end
                        end
                    end
                    default: begin
                        // No action for unimplemented address
                    end
                endcase
            end
        end
    end

    logic ar_fire;
    logic [31:0] ar_addr_reg;
    logic [31:0] r_data_reg;

    assign ar_fire = arvalid && arready;

    always_comb begin
        arready = 1'b0;
        rvalid  = 1'b0;
        rdata   = '0;
        rresp   = 2'b00;

        if (arvalid) begin
            arready = 1'b1;
        end

        if (rvalid) begin
            rdata = r_data_reg;
            rresp = 2'b00;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            ar_addr_reg <= '0;
            r_data_reg  <= '0;
            rvalid      <= 1'b0;
        end else begin
            if (ar_fire) begin
                ar_addr_reg <= araddr;
                rvalid      <= 1'b1;

                case (araddr[3:2])
                    2'b00: r_data_reg <= regs[0];
                    2'b01: r_data_reg <= regs[1];
                    2'b10: r_data_reg <= regs[2];
                    2'b11: r_data_reg <= regs[3];
                    default: r_data_reg <= '0;
                endcase
            end else if (rvalid && !arvalid) begin
                rvalid <= 1'b0;
            end
        end
    end

endmodule
