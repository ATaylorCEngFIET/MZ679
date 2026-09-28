module axil_regs (
  input  logic        aclk,
  input  logic        aresetn,
  // AW Channel
  input  logic        awvalid,
  output logic        awready,
  input  logic [31:0] awaddr,
  // W Channel
  input  logic        wvalid,
  output logic        wready,
  input  logic [31:0] wdata,
  input  logic [3:0]  wstrb,
  // B Channel
  output logic        bvalid,
  input  logic        bready,
  output logic [1:0]  bresp,
  // AR Channel
  input  logic        arvalid,
  output logic        arready,
  input  logic [31:0] araddr,
  // R Channel
  output logic        rvalid,
  input  logic        rready,
  output logic [31:0] rdata,
  output logic [1:0]  rresp,
  // Register Outputs
  output logic [31:0] reg0,
  output logic [31:0] reg1,
  output logic [31:0] reg2,
  output logic [31:0] reg3
);

  logic [31:0] regs [0:3];
  logic aw_full, w_full;
  logic [1:0] aw_addr_hold;
  logic [31:0] wdata_hold;
  logic [3:0] wstrb_hold;
  logic [31:0] rdata_hold;
  logic [1:0]  rresp_hold;

  wire aw_fire, w_fire, ar_fire, b_fire, r_fire;

  // Ready signals depend only on registered state
  assign awready = !aw_full && !bvalid;
  assign wready  = !w_full && !bvalid;
  assign arready = !rvalid;
  
  assign aw_fire = awvalid && awready;
  assign w_fire  = wvalid && wready;
  assign ar_fire = arvalid && arready;
  assign b_fire  = bvalid && bready;
  assign r_fire  = rvalid && rready;

  assign bresp = 2'b00;
  assign rresp = rresp_hold;

  assign reg0 = regs[0];
  assign reg1 = regs[1];
  assign reg2 = regs[2];
  assign reg3 = regs[3];
  assign rdata = rdata_hold;

  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      aw_full       <= 1'b0;
      w_full        <= 1'b0;
      aw_addr_hold  <= 2'b00;
      wdata_hold    <= 32'h0;
      wstrb_hold    <= 4'h0;
      bvalid        <= 1'b0;
      rvalid        <= 1'b0;
      rdata_hold    <= 32'h0;
      rresp_hold    <= 2'b00;
      for (int i = 0; i < 4; i++) regs[i] <= 32'h0;
    end else begin
      // AW Channel Logic
      if (aw_fire) begin
        aw_full      <= 1'b1;
        aw_addr_hold <= awaddr[3:2];
      end
      
      // W Channel Logic
      if (w_fire) begin
        w_full       <= 1'b1;
        wdata_hold   <= wdata;
        wstrb_hold   <= wstrb;
      end

      // Commit Write (AW and W both captured)
      if (aw_full && w_full && !bvalid) begin
        for (int i = 0; i < 4; i++) begin
          if (wstrb_hold[i]) begin
            regs[aw_addr_hold] <= wdata_hold[8*i +: 8];
          end
        end
        aw_full      <= 1'b0;
        w_full       <= 1'b0;
        bvalid       <= 1'b1;
      end

      // B Channel Logic
      if (b_fire) begin
        bvalid       <= 1'b0;
      end

      // AR Channel Logic
      if (ar_fire) begin
        rdata_hold   <= regs[araddr[3:2]];
        rvalid        <= 1'b1;
      end

      // R Channel Logic
      if (r_fire) begin
        rvalid        <= 1'b0;
      end
    end
  end

endmodule
