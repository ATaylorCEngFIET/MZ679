# AXI4 Full (memory mapped) protocol guidance (SystemVerilog)

Apply this guide only when the request uses this protocol. The requested interface and features
take priority over these example names, widths, resets and implementation choices. Preserve the
protocol invariants when adapting code; do not silently reduce the requested feature set.

## Scope and interface contract
"Full" here means AXI4 memory-mapped, not AXI4-Lite, AXI3, AXI5 or ACE. Specify manager/subordinate,
address/data/ID widths, outstanding depth, burst support, alignment, byte lanes, memory map,
reset and error policy. Never claim a small AXI-Lite register bank is AXI4 by merely adding LEN.

The executable reference below is **only an aligned 32-bit burst-address cursor**. It accepts a
captured command and produces addresses/ID/LAST under a local ready/valid handshake. It is NOT
an AXI slave or master: it has no WDATA queue, memory, B/R channels or full-endpoint compliance
claim. Use it inside an endpoint whose channel and response machinery is implemented separately.

## Channel and burst rules
- Capture every AW/AR descriptor field on its handshake. AW and W are independent; if W is
  accepted early, save DATA, STRB and LAST. Alternatively keep WREADY low until storage exists.
  A manager must offer WVALID without waiting for AWREADY. AXI4 has no WID/interleaved write data.
- LEN encodes beats minus one. INCR permits 1..256 beats; FIXED permits 1..16; WRAP lengths are
  2, 4, 8 or 16. SIZE encodes log2(bytes per beat). A burst cannot cross a 4-KiB boundary.
- Advance only on the corresponding accepted data beat. WLAST/RLAST belong to the final beat,
  including while stalled. A zero-strobe write beat still consumes one beat.
- Send one B response after accepted AW and the final W beat. Read responses contain exactly
  LEN+1 accepted beats. Preserve ID and order within an ID. Hold VALID, response and payload
  stable under backpressure; VALID cannot depend on response READY.
- Unsupported operations still need a defined endpoint error path. Accepted read errors retain
  the requested beat count; an accepted write must be drained before its single error response.
  Do not interpret malformed WLAST as permission to silently truncate a burst.

## Endpoint implementation recipe
For a modest subordinate, start with one read descriptor and one write descriptor, independently
active. Give the write path a W-beat holding register containing DATA/STRB/LAST, a write cursor,
and a B response slot containing BID/BRESP. Give reads an address cursor and an R holding register
containing RID/RDATA/RRESP/RLAST. Consume the cursor when the associated operation really commits
or its result is safely buffered, not just when an upstream VALID is observed. A stalled R slot
must never be overwritten. Decouple memory-port arbitration from external response acceptance.
If accepting multiple descriptors, add descriptor queues and track each outstanding response;
do not reuse a single ID register. An ID width does not imply multiple outstanding support.

For a manager, keep request descriptors and outgoing data until their handshakes and reserve
space for incoming responses. Do not advance the software request queue on address acceptance
alone when completion means the B response or final accepted R beat.

## Address and error handling
The reference supports aligned SIZE=2 only. FIXED holds the address; INCR adds four; WRAP uses
`base = floor(start/span)*span`, `span = 4*(LEN+1)`, then wraps within that window. Its validation
uses widened arithmetic for the 4-KiB check; truncated address arithmetic can hide a boundary crossing.
The WRAP start must be word aligned but need not equal the wrap-window base.

A rejected local command pulses `done` with `bad_request` and produces no cursor beats. This is
an internal interface policy, NOT an AXI bus error response. An endpoint must map unsupported
narrow, unaligned, exclusive, protection or decode requests to its documented bus behavior.
The cursor does not process LOCK/CACHE/PROT/QOS/REGION/USER. Add or explicitly terminate optional
signals according to the actual integration contract. Never assert EXOKAY without exclusive support.
Narrow or unaligned support requires real byte-lane/address rules; deleting the checks is not support.

## Verification
The cursor regression checks stalls, captured IDs/addresses, 256-beat INCR, FIXED, all legal WRAP
lengths and non-base wrap starts, final-beat completion, and rejection of boundary crossing,
misalignment, unsupported SIZE, illegal WRAP/FIXED lengths and reserved BURST.
For a full endpoint also test independent AW/W skew, all byte strobes, WLAST errors, B/R stalls,
multiple IDs if supported, concurrent reads/writes, reset in flight and exact response counts.
Cursor tests alone do not validate those endpoint features.

## Language-specific implementation
Use SystemVerilog with explicit widths, nonblocking clocked assignments and one driver per
register. Do not declare a dynamic address as a localparam, initialize a static local variable
from a live signal, or split one state register across multiple always_ff blocks.

## Reference: axif_burst_cursor

```systemverilog
module axif_burst_cursor(
 input logic clk,rst,cmd_valid,output logic cmd_ready,
 input logic [31:0] cmd_addr,input logic [7:0] cmd_len,
 input logic [2:0] cmd_size,input logic [1:0] cmd_burst,input logic [3:0] cmd_id,
 output logic beat_valid,input logic beat_ready,
 output logic [31:0] beat_addr,output logic [3:0] beat_id,
 output logic beat_last,done,bad_request);
 logic active;logic [7:0] left_minus_one;logic [1:0] burst_hold;
 logic [31:0] wrap_mask;logic legal;
 always_comb begin
  legal=(cmd_size==3'd2 && cmd_addr[1:0]==0);
  case(cmd_burst)
   2'b00: legal=legal && (cmd_len<16);
   2'b01: legal=legal && (({1'b0,cmd_addr[11:0]}+({5'b0,cmd_len}<<2)+13'd3)<13'd4096);
   2'b10: legal=legal && (cmd_len==1 || cmd_len==3 || cmd_len==7 || cmd_len==15);
   default: legal=0;
  endcase
 end
 assign cmd_ready=!active;assign beat_valid=active;
 assign beat_last=active && left_minus_one==0;
 always_ff @(posedge clk) begin
  if(rst) begin
   active<=0;left_minus_one<=0;burst_hold<=0;wrap_mask<=0;
   beat_addr<=0;beat_id<=0;done<=0;bad_request<=0;
  end else begin
   done<=0;
   if(cmd_valid && cmd_ready) begin
    bad_request<=!legal;
    if(legal) begin
     active<=1;beat_addr<=cmd_addr;beat_id<=cmd_id;
     left_minus_one<=cmd_len;burst_hold<=cmd_burst;
     wrap_mask<=((32'(cmd_len)+32'd1)<<2)-32'd1;
    end else done<=1;
   end
   if(beat_valid && beat_ready) begin
    if(left_minus_one==0) begin active<=0;done<=1;end
    else begin
     left_minus_one<=left_minus_one-1'b1;
     if(burst_hold==2'b01) beat_addr<=beat_addr+32'd4;
     else if(burst_hold==2'b10) beat_addr<=(beat_addr & ~wrap_mask) | ((beat_addr+32'd4) & wrap_mask);
    end
   end
  end
 end
endmodule
```

## Specification and validation

[Arm AXI/ACE specification, IHI 0022H, AXI4 chapters](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/IHI0022H_amba_axi_protocol_spec.pdf). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
