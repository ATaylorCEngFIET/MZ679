# AXI4-Stream protocol guidance (SystemVerilog)

Apply this guide only when the request uses this protocol. The requested interface and features
take priority over these example names, widths, resets and implementation choices. Preserve the
protocol invariants when adapting code; do not silently reduce the requested feature set.

## Scope and interface contract
Use for a streaming source, sink or pipeline. This reference is a two-entry, single-clock FIFO,
not a clock-domain crossing. It carries DATA, KEEP, LAST and USER together. Specify data width,
packet boundaries, optional STRB/ID/DEST/USER, reset and throughput before implementing a different interface.
`DATA_W` must be at least 8 and a multiple of 8; `USER_W` must be positive in this reference.
For an absent USER port, remove it consistently rather than creating zero-width vectors.

## Rules that prevent lost or corrupted beats
- Count a beat only at a rising edge with VALID and READY both high. The source must not wait
  for READY before offering a valid beat. A stalled source holds VALID and the entire payload.
- TLAST terminates a packet only when its beat is accepted. Do not increment packet counters
  merely because LAST is high; do not reconstruct LAST from a free-running counter.
- KEEP qualifies bytes on every beat. Preserve sparse and all-zero KEEP beats in a transparent
  pipeline, including a zero-byte packet boundary. If STRB is present, position and data bytes
  have different meanings; never silently replace STRB with KEEP.
- Buffer all enabled sidebands with DATA. Define widths for USER, ID and DEST from the prompt;
  data ordering and packet identity must survive stalls.
- Avoid combinational input-to-output paths at an AXI interface. The reference derives READY
  and VALID from registered occupancy; it does not implement `s_ready = !valid || m_ready`.
- Never overwrite a full queue. Push and pop together leave occupancy unchanged. The full
  queue in this reference reopens one cycle after a pop; that bubble is an explicit tradeoff.
- Reset discards buffered beats and clears VALID. A packet dropped by reset needs a documented
  system-level recovery policy. For unrelated clocks, use an asynchronous FIFO and CDC review.

## Reference architecture
Store `{USER,LAST,KEEP,DATA}` as one payload. Read and write pointers are independent; occupancy
is 0, 1 or 2. The head is overwritten only after it is consumed. This supports one beat per clock
in steady state when occupancy is one and both ends transfer. No packet-size limit is imposed.
The example uses synchronous active-high reset; adapt it to the requested interface reset contract.

## Verification
The supplied regression scores accepted payloads across 1,000 stimulus cycles, source gaps,
receiver stalls, simultaneous push/pop, all KEEP masks, LAST/USER preservation, drain and reset.
When extending: test minimum/maximum widths, packet boundaries at full capacity, reset while
stalled, optional sidebands and independent clock ratios for a CDC variant. Assert payload
stability while stalled and equality of accepted input/output counts after drain.

## Language-specific implementation
Use SystemVerilog with explicit widths, nonblocking clocked assignments and one driver per
register. Do not declare a dynamic address as a localparam, initialize a static local variable
from a live signal, or split one state register across multiple always_ff blocks.

## Reference: axis_fifo2

```systemverilog
module axis_fifo2 #(parameter int DATA_W=32, USER_W=4)(
 input logic clk, rst,
 input logic s_valid, output logic s_ready,
 input logic [DATA_W-1:0] s_data, input logic [DATA_W/8-1:0] s_keep,
 input logic s_last, input logic [USER_W-1:0] s_user,
 output logic m_valid, input logic m_ready,
 output logic [DATA_W-1:0] m_data, output logic [DATA_W/8-1:0] m_keep,
 output logic m_last, output logic [USER_W-1:0] m_user);
 localparam int PAYLOAD_W=DATA_W+DATA_W/8+1+USER_W;
 logic [PAYLOAD_W-1:0] slots[0:1];
 logic rd_ptr,wr_ptr; logic [1:0] count;
 logic push,pop;
 assign s_ready=(count<2);
 assign m_valid=(count!=0);
 assign {m_user,m_last,m_keep,m_data}=slots[rd_ptr];
 assign push=s_valid && s_ready; assign pop=m_valid && m_ready;
 always_ff @(posedge clk) begin
  if(rst) begin
   count<=0;rd_ptr<=0;wr_ptr<=0;slots[0]<='0;slots[1]<='0;
  end else begin
   if(push) begin slots[wr_ptr]<={s_user,s_last,s_keep,s_data};wr_ptr<=!wr_ptr;end
   if(pop) rd_ptr<=!rd_ptr;
   case({push,pop})
    2'b10: count<=count+1'b1;
    2'b01: count<=count-1'b1;
    default: ;
   endcase
  end
 end
endmodule
```

## Specification and validation

[Arm AXI4-Stream specification, IHI 0051](https://documentation-service.arm.com/static/642583d7314e245d086bc8c9). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
