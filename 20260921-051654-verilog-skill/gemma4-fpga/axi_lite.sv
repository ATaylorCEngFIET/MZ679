// AXI4-Lite Slave with 4 registers at 0x0, 0x4, 0x8, 0xC
module axil_regs (
    input  logic        clk,
    input  logic        rst_n,

    // AXI4-Lite Slave Interface
    input  logic [31:0] s_awaddr,
    input  logic        s_awvalid,
    output logic        s_awready,
    input  logic [31:0] s_wdata,
    input  logic [3:0]  s_wstrb,
    input  logic        s_wvalid,
    output logic        s_wready,
    output logic [1:0]  s_bresp,
    output logic        s_bvalid,
    input  logic        s_bready,

    input  logic [31:0] s_araddr,
    input  logic        s_arvalid,
    output logic        s_arready,
    output logic [31:0] s_rdata,
    output logic [1:0]  s_rresp,
    output logic        s_rvalid,
    input  logic        s_rready,

    // Register Outputs
    output logic [31:0] reg0,
    output logic [31:0] reg1,
    output logic [31:0] reg2,
    output logic [31:0] reg3
);

    // Internal registers
    logic [31:0] r_data_hold;

    // Combinational logic
    assign s_awready = s_awvalid;
    assign s_wready  = s_wvalid;
    assign s_arready = s_arvalid;
    assign s_bresp   = 2'b00; // OKAY
    assign s_rresp   = 2'b00;  // OKAY

    // Sequential logic
    always_ff @(posedge clk) begin
        if (rst_n) begin
            reg0        <= 32'h0;
            reg1        <= 32'h0;
            reg2        <= 32'h0;
            reg3        <= 32'h0;
            r_data_hold <= 32'h0;
            s_bvalid     <= 1'b0;
            s_rvalid      <= 1'b0;
        end else begin
            // Write Logic: Update registers based on AW address and W data
            if (s_awvalid && s_awready && s_wvalid && s_wready) begin
                case (s_awaddr[3:2])
                    2'd0: begin
                        if (s_wstrb[0]) reg0[7:0]   <= s_wdata[7:0];
                        if (s_wstrb[1]) reg0[15:8]  <= s_wdata[15:8];
                        if (s_wstrb[2]) reg0[23:16] <= s_wdata[23:16];
                        if (s_wstrb[3]) reg0[31:24] <= s_wdata[31:24];
                    end
                    2'd1: begin
                        if (s_wstrb[0]) reg1[7:0]   <= s_wdata[7:0];
                        if (s_wstrb[1]) reg1[15:8]  <= s_wdata[15:8];
                        if (s_wstrb[2]) reg1[23:16] <= s_wdata[23:16];
                        if (s_wstrb[3]) reg1[31:24] <= s_wdata[31:24];
                    end
                    2'd2: begin
                        if (s_wstrb[0]) reg2[7:0]   <= s_wdata[7:0];
                        if (s_wstrb[1]) reg2[15:8]  <= s_wdata[15:8];
                        if (s_wstrb[2]) reg2[23:16] <= s_wdata[23:16];
                        if (s_wstrb[3]) reg2[31:24] <= s_wdata[31:24];
                    end
                    2'd3: begin
                        if (s_wstrb[0]) reg3[7:0]   <= s_wdata[7:0];
                        if (s_wstrb[1]) reg3[15:8]  <= s_wdata[15:8];
                        if (s_wstrb[2]) reg3[23:16] <= s_wdata[23:16];
                        if (s_wstrb[3]) reg3[31:24] <= s_wdata[31:24];
                    end
                    default: ;
                endcase
            end

            // Read Logic
            if (s_arvalid && s_arready) begin
                r_data_hold <= (s_araddr[3:2] == 2'd0) ? reg0 :
                               (s_araddr[3:2] == 2'd1) ? reg1 :
                               (s_araddr[3:2] == 2'd2) ? reg2 :
                               (s_araddr[3:2] == 2'd3) ? reg3 : 32'h0;
            end
            
            s_rdata  <= r_data_hold;
            s_rvalid <= s_arvalid && s_arready;
            s_bvalid <= s_awvalid && s_awready && s_wvalid && s_wready;
        end
    end

endmodule
