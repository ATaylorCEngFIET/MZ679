# Protocol rules (SystemVerilog)

Each section: the rules, then a reference module that compiles with `iverilog -g2012`. Copy the
structure and change only what the prompt asks for (names, widths, parameters).

## AXI4-Lite slave (independent channel capture and response backpressure)
- Accept a channel only when VALID and READY are both asserted at the rising clock edge.
  Raising registered READY after that edge does not mean a transfer already happened.
- AW and W are independent: support address first, data first, and simultaneous arrival.
  Capture the address on `aw_fire`; capture **both WDATA and WSTRB** on `w_fire`.
  A done/full flag without its payload buffer is insufficient. After acceptance, the master
  may change the inputs; never use live WDATA/WSTRB to complete a previously accepted write.
- This reference allows one outstanding write and one independent outstanding read. READY
  depends only on registered occupancy/response state, with no combinational path from an
  AXI channel input to an output. Stop accepting a channel when its buffer is full.
- Commit once from the two captured payloads when both buffers are full and no B response is
  pending. Raise BVALID only after both handshakes; never wait for BREADY to raise it.
  Hold BVALID/BRESP until their handshake and prevent a new write from overwriting a stalled response.
- Accept AR only when the read response slot is free. Capture the selected register into RDATA
  at `ar_fire`, then assert RVALID. Hold RVALID/RDATA/RRESP unchanged until the R handshake,
  even if the selected register is written meanwhile. Never wait for RREADY to assert RVALID.
- This example uses a synchronous active-low reset: pending partial writes and responses are
  discarded, and all four registers reset to zero. Adapt reset timing/values to the prompt.
  Reset must be sampled before use; no transfers are counted during reset.
- Example address map: four 32-bit registers at byte offsets 0, 4, 8, 12; only bits [3:2]
  are decoded, so other addresses alias. Responses are always OKAY. Add full address/protection
  decoding and error responses if requested. A zero strobe writes no bytes but still returns B.
- A read accepted on the same edge as a write commit sees the old register value in this example.
  Throughput includes bubbles; add buffering only if the prompt requires higher throughput,
  while preserving the handshake, payload and response invariants above.

Every clocked destination is `logic` with one `always_ff` driver. Continuous assignments
only drive separate wiring/state decodes. Use SystemVerilog mode (`vlog -sv` or `iverilog -g2012`).

```systemverilog
module axil_slave (
  input  logic        aclk, aresetn,
  input  logic        awvalid, output logic awready, input logic [31:0] awaddr,
  input  logic        wvalid,  output logic wready,  input logic [31:0] wdata, input logic [3:0] wstrb,
  output logic        bvalid,  input  logic bready,  output logic [1:0] bresp,
  input  logic        arvalid, output logic arready, input logic [31:0] araddr,
  output logic        rvalid,  input  logic rready,  output logic [31:0] rdata, output logic [1:0] rresp,
  output logic [31:0] reg0, reg1, reg2, reg3);

  logic [31:0] regs [0:3];
  logic aw_full, w_full;
  logic [1:0] awaddr_hold;
  logic [31:0] wdata_hold;
  logic [3:0] wstrb_hold;
  wire aw_fire, w_fire, ar_fire, b_fire, r_fire;

  // READY is derived from registered state, never from incoming VALID.
  assign awready = !aw_full && !bvalid;
  assign wready  = !w_full && !bvalid;
  assign arready = !rvalid;
  assign aw_fire = awvalid && awready;
  assign w_fire  = wvalid && wready;
  assign ar_fire = arvalid && arready;
  assign b_fire  = bvalid && bready;
  assign r_fire  = rvalid && rready;
  assign bresp = 2'b00; assign rresp = 2'b00;
  assign reg0 = regs[0]; assign reg1 = regs[1];
  assign reg2 = regs[2]; assign reg3 = regs[3];

  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      aw_full <= 1'b0; w_full <= 1'b0;
      awaddr_hold <= '0; wdata_hold <= '0; wstrb_hold <= '0;
      bvalid <= 1'b0; rvalid <= 1'b0; rdata <= '0;
      for (int i = 0; i < 4; i++) regs[i] <= '0;
    end else begin
      if (aw_fire) begin
        aw_full <= 1'b1; awaddr_hold <= awaddr[3:2];
      end
      if (w_fire) begin
        w_full <= 1'b1; wdata_hold <= wdata; wstrb_hold <= wstrb;
      end
      // Flags below describe transfers accepted on previous edges.
      if (aw_full && w_full && !bvalid) begin
        for (int i = 0; i < 4; i++)
          if (wstrb_hold[i]) regs[awaddr_hold][8*i +: 8] <= wdata_hold[8*i +: 8];
        aw_full <= 1'b0; w_full <= 1'b0; bvalid <= 1'b1;
      end
      if (b_fire) bvalid <= 1'b0;
      if (ar_fire) begin
        rdata <= regs[araddr[3:2]]; rvalid <= 1'b1;
      end
      if (r_fire) rvalid <= 1'b0;
    end
  end
endmodule
```

### AXI validation when changing this reference
Compile the code extracted from this document and simulate it; compilation or ordinary lint
alone does not establish protocol correctness. Keep the tested RTL and this example identical.
Check AW-before-W, W-before-AW and simultaneous arrival with varied gaps. Change AWADDR,
WDATA and WSTRB immediately **after** their respective handshakes. Exercise every byte strobe,
including zero, and read back the result. Stall BREADY/RREADY and verify stable response payloads;
issue further requests while stalled to detect buffer overwrite. Count accepted transactions and
responses to detect early, missing or duplicate responses. Test reset with AW only, W only and
responses pending, then fresh transactions. Use protocol assertions for response causality and
stability as well as a functional scoreboard. Run the available lint flow separately and report
its findings; do not describe a passing finite regression as full AXI compliance proof.

## UART transmitter  (most failures: enum too narrow for its states, `state_t::IDLE` scoping, missing start bit)
- 8N1: idle 1, start 0, eight data bits LSB first, stop 1. `typedef enum logic [1:0] {ST_IDLE, ST_START,
  ST_DATA, ST_STOP} state_t;` — four states need two bits; refer to them bare (`ST_IDLE`), never `state_t::ST_IDLE`.
- `localparam int CYCLES_PER_BIT = CLK_HZ / BAUD;` baud counter `[$clog2(CYCLES_PER_BIT)-1:0]`;
  `tick` on its last count; every state advances on `tick`.
- `assign busy = (state != ST_IDLE);` shift register loaded in ST_IDLE, `tx <= shift[0]`, and the shift
  happens **only inside `if (tick)`** — shifting every clock sends the byte in 8 clocks, not 8 bit periods
  (compiles, frame is garbage). Sample `data_valid` every clock in ST_IDLE, not only on a bit boundary.

```systemverilog
module uart_tx8 #(parameter int CLK_HZ = 100_000_000, parameter int BAUD = 115_200) (
  input  logic       clk, rst,
  input  logic [7:0] data,
  input  logic       data_valid,
  output logic       tx, busy);

  localparam int CYCLES_PER_BIT = CLK_HZ / BAUD;
  typedef enum logic [1:0] {ST_IDLE, ST_START, ST_DATA, ST_STOP} state_t;
  state_t     state;
  logic [$clog2(CYCLES_PER_BIT)-1:0] baud_cnt;
  logic [2:0] bit_cnt;
  logic [7:0] shift;
  logic       tick;

  assign tick = (baud_cnt == CYCLES_PER_BIT-1);
  assign busy = (state != ST_IDLE);

  always_ff @(posedge clk) begin
    if (rst) begin
      state <= ST_IDLE; baud_cnt <= '0; bit_cnt <= '0; tx <= 1'b1;
    end else begin
      if (state == ST_IDLE || tick) baud_cnt <= '0; else baud_cnt <= baud_cnt + 1'b1;
      case (state)
        ST_IDLE:  begin tx <= 1'b1;
                        if (data_valid) begin shift <= data; bit_cnt <= '0; state <= ST_START; end end
        ST_START: begin tx <= 1'b0; if (tick) state <= ST_DATA; end
        ST_DATA:  begin tx <= shift[0];                          // LSB first
                        if (tick) begin shift <= {1'b0, shift[7:1]};
                          if (bit_cnt == 3'd7) state <= ST_STOP; else bit_cnt <= bit_cnt + 1'b1; end end
        ST_STOP:  begin tx <= 1'b1; if (tick) state <= ST_IDLE; end
        default:  state <= ST_IDLE;
      endcase
    end
  end
endmodule
```

## Synchronous FIFO  (most failures: full/empty logic, unpacked localparam, memory written outside the clock)
- `localparam int ADDR_W = $clog2(DEPTH);` pointers `[ADDR_W:0]` (one wrap bit). `full` = MSBs differ and
  the rest equal; `empty` = pointers equal; both `assign`.
- Memory `logic [WIDTH-1:0] mem [0:DEPTH-1]`, written and read only inside `always_ff` (block RAM).
  Reset clears the pointers, not the memory.

```systemverilog
module fifo_sc #(parameter int WIDTH = 8, parameter int DEPTH = 16) (   // DEPTH power of two
  input  logic             clk, rst,
  input  logic             wr_en,
  input  logic [WIDTH-1:0] wr_data,
  input  logic             rd_en,
  output logic [WIDTH-1:0] rd_data,
  output logic             full, empty);

  localparam int ADDR_W = $clog2(DEPTH);
  logic [WIDTH-1:0] mem [0:DEPTH-1];
  logic [ADDR_W:0]  wr_ptr, rd_ptr;                    // one extra wrap bit

  assign full  = (wr_ptr[ADDR_W] != rd_ptr[ADDR_W]) && (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);
  assign empty = (wr_ptr == rd_ptr);

  always_ff @(posedge clk) begin
    if (rst) begin
      wr_ptr <= '0; rd_ptr <= '0;
    end else begin
      if (wr_en && !full) begin
        mem[wr_ptr[ADDR_W-1:0]] <= wr_data;
        wr_ptr <= wr_ptr + 1'b1;
      end
      if (rd_en && !empty) begin
        rd_data <= mem[rd_ptr[ADDR_W-1:0]];
        rd_ptr <= rd_ptr + 1'b1;
      end
    end
  end
endmodule
```

## Clock-domain crossing
- Single bit: `(* ASYNC_REG = "TRUE" *) logic [STAGES-1:0] sync;` — the attribute sits immediately before
  the declaration it marks, nowhere else. One `always_ff` shifting `{sync[STAGES-2:0], din}`; output
  `sync[STAGES-1]`. No generate, no logic between stages, reset optional.
- Multi-bit: gray-coded pointers or a handshake with a held bus — never per-bit synchronisers.
