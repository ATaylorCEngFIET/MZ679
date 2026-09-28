module axil_regs (
  input  logic        aclk, aresetn,
  input  logic        awvalid, output logic awready, input logic [31:0] awaddr,
  input  logic        wvalid,  output logic wready,  input logic [31:0] wdata, input logic [3:0] wstrb,
  output logic        bvalid,  input  logic bready,  output logic [1:0] bresp,
  input  logic        arvalid, output logic arready, input logic [31:0] araddr,
  output logic        rvalid,  input  logic rready,  output logic [31:0] rdata, output logic [1:0] rresp,
  output logic [31:0] reg0, reg1, reg2, reg3);

  logic [31:0] regs [0:3];
  logic aw_full, w_full;
  logic [3:0] awaddr_decoded; // Decode bits [3:2] to select register index
  logic [31:0] wdata_hold;
  logic [3:0] wstrb_hold;
  wire aw_fire, w_fire, ar_fire, b_fire, r_fire;

  // Address decoding: bits [3:2] map to registers 0..3. 
  // Other bits are ignored for this minimal example (aliasing).
  assign awaddr_decoded = awaddr[3:2];
  assign araddr_decoded = araddr[3:2];

  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      aw_full <= 1'b0; w_full <= 1'b0; bvalid <= 1'b0; rvalid <= 1'b0;
      for (int i = 0; i < 4; i++) regs[i] <= '0;
    end else begin
      // Capture Address on AW fire
      if (aw_fire) begin
        aw_full <= 1'b1;
      end
      
      // Capture Data and Strobe on W fire
      if (w_fire) begin
        w_full <= 1'b1;
      end

      // Commit Write when both buffers full and no B response pending
      if (aw_full && w_full && !bvalid) begin
        // Apply write to the selected register based on decoded address
        int idx = awaddr_decoded;
        if (idx >= 0 && idx < 4) begin
          regs[idx] <= wdata_hold;
        end
        // Clear buffers and assert BVALID
        aw_full <= 1'b0; 
        w_full <= 1'b0; 
        bvalid <= 1'b1;
      end

      // Assert BREADY when master is ready to receive response
      if (b_fire) begin
        bvalid <= 1'b0;
      end

      // Capture Read Address on AR fire
      if (ar_fire) begin
        rdata <= regs[araddr_decoded];
        rvalid <= 1'b1;
      end

      // Assert RREADY when master is ready to receive data
      if (r_fire) begin
        rvalid <= 1'b0;
      end
    end
  end
endmodule
