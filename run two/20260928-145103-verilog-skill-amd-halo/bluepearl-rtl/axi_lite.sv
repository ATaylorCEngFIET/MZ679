module axil_regs (
  input  logic        aclk, aresetn,
  input  logic        awvalid, output logic awready, input  logic [31:0] awaddr,
  input  logic        wvalid,  output logic wready,  input  logic [31:0] wdata, input  logic [3:0] wstrb,
  output logic        bvalid,  input  logic bready,  output logic [1:0] bresp,
  input  logic        arvalid, output logic arready, input  logic [31:0] araddr,
  output logic        rvalid,  input  logic rready,  output logic [31:0] rdata, output logic [1:0] rresp,
  output logic [31:0] reg0, reg1, reg2, reg3
);

  logic [31:0] regs [0:3];
  logic aw_full, w_full;
  logic [1:0]  awaddr_hold;
  logic [31:0] wdata_hold;
  logic [3:0]  wstrb_hold;
  wire aw_fire, w_fire, ar_fire, b_fire, r_fire;

  assign awready = !aw_full && !bvalid;
  assign wready  = !w_full && !bvalid;
  assign arready = !rvalid;

  assign aw_fire = awvalid && awready;
  assign w_fire  = wvalid && wready;
  assign ar_fire = arvalid && arready;
  assign b_fire  = bvalid && bready;
  assign r_fire  = rvalid && rready;

  assign bresp = 2'b00; // OKAY
  assign rresp = 2'b00; // OKAY
  assign reg0  = regs[0];
  assign reg1  = regs[1];
  assign reg2  = regs[2];
  assign reg3  = regs[3];

  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      aw_full     <= 1'b0;
      w_full      <= 1'b0;
      awaddr_hold <= '0;
      wdata_hold  <= '0;
      wstrb_hold  <= '0;
      bvalid      <= 1'b0;
      rvalid      <= 1'b0;
      rdata       <= '0;
      for (int i = 0; i < 4; i++) regs[i] <= '0;
    end else begin
      // Capture AW
      if (aw_fire) begin
        aw_full     <= 1'b1;
        awaddr_hold <= awaddr[3:2];
      end

      // Capture W
      if (w_fire) begin
        w_full     <= 1'b1;
        wdata_hold <= wdata;
        wstrb_hold <= wstrb;
      end

      // Commit Write
      if (aw_full && w_full && !bvalid) begin
        for (int i = 0; i < 4; i++) begin
          if (wstrb_hold[i]) begin
            regs[awaddr_hold][8*i +: 8] <= wdata_hold[8*i +: 8];
          end
        end
        aw_full <= 1'b0;
        w_full  <= 1'b0;
        bvalid  <= 1'b1;
      end

      // B Channel handshake
      if (b_fire) begin
        bvalid <= 1'b0;
      end

      // Capture AR and Read
      if (ar_fire) begin
        rdata  <= regs[araddr[3:2]];
        rvalid <= 1'b1;
      end

      // R Channel handshake
      if (r_fire) begin
        rvalid <= 1'b0;
      end
    end
  end

endmodule
