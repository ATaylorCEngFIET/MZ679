# AHB / AHB-Lite protocol guidance (SystemVerilog)

Apply this guide only when the request uses this protocol. The requested interface and features
take priority over these example names, widths, resets and implementation choices. Preserve the
protocol invariants when adapting code; do not silently reduce the requested feature set.

## Scope and interface contract
Use AHB-Lite for this reference: a single-manager transfer interface, not classic multi-manager
AHB arbitration/SPLIT/RETRY and not AHB5 security/exclusive extensions. State which variant the
prompt requires. The example is a 32-bit, word-only register subordinate at offsets 0,4,8,12.
Byte/halfword or out-of-aperture requests return ERROR. HPROT/HBURST/HMASTLOCK policy is outside
this small interface; add required signals for integration rather than claiming full AHB5 support.

## Address phase versus data phase
- Accept address/control only when global HREADY is high, HSEL is asserted, and HTRANS denotes
  NONSEQ or SEQ (`HTRANS[1]`). IDLE and BUSY never create register operations.
- HADDR/HWRITE/HSIZE describe the address phase. HWDATA belongs to the previously accepted write.
  Save selection, address, direction and size before the data phase. Never pair live HADDR with HWDATA.
- Data completion and next-address acceptance can occur at the same edge. Current HSEL may
  already point elsewhere; it must not cancel the previous selected transfer's completion.
- Hold pending state across low HREADY. HREADYOUT is this subordinate's response; HREADY is the
  interconnect's selected/global completion signal. Wire them together only for an appropriate
  single-subordinate test setup, not blindly inside a reusable interconnect component.
- AHB-Lite ERROR needs two response cycles: first HRESP=1/HREADYOUT=0, then HRESP=1/HREADYOUT=1.
  The error sequencer must advance even though HREADY is low in the first error cycle.

## Architecture and limitations
The example stores one pending address phase and completes normal transfers without wait states.
It supports pipelined address/data traffic. Registers change only on successful write completion;
errors never write. Global wait-state holding and the two-cycle error path are explicit. It does
not generate general data-latency waits. For a RAM or slow peripheral, add pending-result state
and control HREADYOUT until the correct data is ready. Never use HREADY as a generated clock.
Read data comes from the saved address. Reset is synchronous active-high for this wrapper;
adapt HRESETn as specified and define reset of incomplete operations.

For byte/halfword support, derive lane enables from the SAVED HSIZE/HADDR, check alignment and
use the corresponding HWDATA lanes. There is no AXI-style WSTRB to copy onto an AHB-Lite port.
A simple register subordinate can process SEQ beats individually; burst generation, wrapping
and boundary rules belong in a manager/bridge that promises those features.

## Manager guidance
Track which transfer occupies the data phase while presenting the next address. Retain the
current data-phase write data during waits, and apply the specified cancellation behavior on
ERROR. Never treat address presentation alone as completed software-visible work.

## Verification
Tests cover overlapping writes to different addresses, HSEL removal during the prior data
phase, global waits, IDLE/BUSY rejection, saved read address, unsupported size/address errors,
the two ERROR cycles and absence of failed-write side effects. Add general subordinate wait
latency, endian/lane cases, bursts and multi-subordinate switching when those are implemented.

## Language-specific implementation
Use SystemVerilog with explicit widths, nonblocking clocked assignments and one driver per
register. Do not declare a dynamic address as a localparam, initialize a static local variable
from a live signal, or split one state register across multiple always_ff blocks.

## Reference: ahb_regs

```systemverilog
module ahb_regs(
 input logic clk,rst,hsel,hready,hwrite,
 input logic [1:0] htrans,input logic [2:0] hsize,
 input logic [31:0] haddr,hwdata,
 output logic hreadyout,hresp,output logic [31:0] hrdata,
 output logic [31:0] reg0,reg1,reg2,reg3);
 logic [31:0] regs[0:3];
 integer i;
 logic pending,write_hold,bad_hold,error_second;
 logic [1:0] addr_hold;
 assign hresp=pending && bad_hold;
 assign hreadyout=!(pending && bad_hold && !error_second);
 assign hrdata=(pending && !bad_hold) ? regs[addr_hold] : 32'b0;
 assign reg0=regs[0];assign reg1=regs[1];assign reg2=regs[2];assign reg3=regs[3];
 always_ff @(posedge clk) begin
  if(rst) begin
   pending<=0;write_hold<=0;bad_hold<=0;error_second<=0;addr_hold<=0;
   for(i=0;i<4;i++) regs[i]<='0;
  end else begin
   // Advance the first ERROR cycle even though HREADY is low.
   if(pending && bad_hold && !error_second) error_second<=1;
   if(hready) begin
    // HWDATA belongs to the SAVED address, never the current HADDR.
    if(pending && write_hold && !bad_hold) regs[addr_hold]<=hwdata;
    pending<=hsel && htrans[1];error_second<=0;
    if(hsel && htrans[1]) begin
     addr_hold<=haddr[3:2];write_hold<=hwrite;
     bad_hold<=(haddr[31:4]!=0 || haddr[1:0]!=0 || hsize!=3'd2);
    end
   end
  end
 end
endmodule
```

## Specification and validation

[Arm AHB specification, IHI 0033C](https://documentation-service.arm.com/static/6141bf0d674a052ae36ca811). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
