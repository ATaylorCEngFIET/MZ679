module axil_regs (
    input  logic        clk,
    input  logic        rst,
    // AW channel
    input  logic        awvalid,
    output logic        awready,
    input  logic [31:0] awaddr,
    // W channel
    input  logic        wvalid,
    output logic        wready,
    input  logic [31:0] wdata,
    input  logic [3:0]  wstrb,
    // B channel
    output logic        bvalid,
    input  logic        bready,
    output logic [1:0]  bresp,
    // AR channel
    input  logic        arvalid,
    output logic        arready,
    input  logic [31:0] araddr,
    // R channel
    output logic        rvalid,
    input  logic        rready,
    output logic [31:0] rdata,
    output logic [1:0]  rresp,
    // Register outputs
    output logic [31:0] reg0,
    output logic [31:0] reg1,
    output logic [31:0] reg2,
    output logic [31:0] reg3
);

    // Internal register storage
    logic [31:0] r_reg0;
    logic [31:0] r_reg1;
    logic [31:0] r_reg2;
    logic [31:0] r_reg3;

    // Expose registers
    assign reg0 = r_reg0;
    assign reg1 = r_reg1;
    assign reg2 = r_reg2;
    assign reg3 = r_reg3;

    // Handshake state
    logic aw_pending;
    logic w_pending;
    logic [31:0] awaddr_latch;
    logic [31:0] wdata_latch;
    logic [3:0]  wstrb_latch;

    // AW channel
    assign awready = !aw_pending;

    // W channel
    assign wready = !w_pending;

    // B channel
    logic bvalid_int;
    assign bvalid = bvalid_int;
    assign bresp  = 2'b00;

    // AR channel
    assign arready = 1'b1;

    // R channel
    logic rvalid_int;
    assign rvalid = rvalid_int;
    assign rresp  = 2'b00;

    // Read data mux
    logic [31:0] rdata_int;
    always_comb begin
        case (araddr[3:2])
            2'd0: rdata_int = r_reg0;
            2'd1: rdata_int = r_reg1;
            2'd2: rdata_int = r_reg2;
            2'd3: rdata_int = r_reg3;
            default: rdata_int = 32'h0;
        endcase
    end
    assign rdata = rdata_int;

    // AW pending register
    always_ff @(posedge clk) begin
        if (rst) begin
            aw_pending <= 1'b0;
            w_pending  <= 1'b0;
            bvalid_int <= 1'b0;
            rvalid_int <= 1'b0;
            awaddr_latch <= 32'h0;
            wdata_latch  <= 32'h0;
            wstrb_latch  <= 4'h0;
        end else begin
            // AW handshake
            if (awvalid && awready) begin
                aw_pending   <= 1'b1;
                awaddr_latch <= awaddr;
            end
            if (bvalid_int && bready) begin
                aw_pending   <= 1'b0;
                bvalid_int   <= 1'b0;
            end

            // W handshake
            if (wvalid && wready) begin
                w_pending   <= 1'b1;
                wdata_latch <= wdata;
                wstrb_latch <= wstrb;
            end
            if (bvalid_int && bready) begin
                w_pending <= 1'b0;
            end

            // B valid: assert when both AW and W are pending
            if (aw_pending && w_pending) begin
                bvalid_int <= 1'b1;
            end

            // AR handshake: assert rvalid on AR accept
            if (arvalid && arready) begin
                rvalid_int <= 1'b1;
            end
            if (rvalid_int && rready) begin
                rvalid_int <= 1'b0;
            end
        end
    end

    // Write data application
    always_ff @(posedge clk) begin
        if (rst) begin
            r_reg0 <= 32'h0;
            r_reg1 <= 32'h0;
            r_reg2 <= 32'h0;
            r_reg3 <= 32'h0;
        end else begin
            if (bvalid_int && bready) begin
                case (awaddr_latch[3:2])
                    2'd0: begin
                        for (int i = 0; i < 4; i++)
                            if (wstrb_latch[i])
                                r_reg0[8*i +: 8] <= wdata_latch[8*i +: 8];
                    end
                    2'd1: begin
                        for (int i = 0; i < 4; i++)
                            if (wstrb_latch[i])
                                r_reg1[8*i +: 8] <= wdata_latch[8*i +: 8];
                    end
                    2'd2: begin
                        for (int i = 0; i < 4; i++)
                            if (wstrb_latch[i])
                                r_reg2[8*i +: 8] <= wdata_latch[8*i +: 8];
                    end
                    2'd3: begin
                        for (int i = 0; i < 4; i++)
                            if (wstrb_latch[i])
                                r_reg3[8*i +: 8] <= wdata_latch[8*i +: 8];
                    end
                    default: ;
                endcase
            end
        end
    end

endmodule
