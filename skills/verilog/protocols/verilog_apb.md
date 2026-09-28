# APB protocol guidance (SystemVerilog)

Apply this guide only when the request uses this protocol. The requested interface and features
take priority over these example names, widths, resets and implementation choices. Preserve the
protocol invariants when adapting code; do not silently reduce the requested feature set.

## Scope and interface contract
Choose APB3 or APB4 explicitly. APB3 introduces wait/error signaling; APB4 adds byte strobes and
protection. The reference uses APB4-style PSTRB, a 32-bit data/address bus and four registers at
0, 4, 8 and 12. It does not enforce PPROT policy or implement APB5 extensions. Add required ports
and decode behavior for the target integration. `WAIT_CYCLES` is a nonnegative constant.

## Transfer rules
- SETUP has PSEL high and PENABLE low. ACCESS follows with both high. Complete only at a rising
  edge with PSEL, PENABLE and PREADY all high. Never write in SETUP or once per stalled cycle.
- The requester holds address, direction, write data, strobes and protection through ACCESS waits.
  After completion it drops PENABLE for the next SETUP even if PSEL remains high.
- PENABLE can be high while this peripheral is unselected. Qualify side effects with this PSEL.
- PSLVERR is interpreted at completion. The example qualifies it to that cycle and suppresses
  writes to bad addresses. Error side effects are a defined peripheral policy, not a universal
  promise of APB itself.
- Apply write strobes per byte. A zero-strobe write completes without changing storage. For APB3
  omit PSTRB and deliberately define full-word writes; do not accidentally leave strobes floating.

## Peripheral architecture
The setup edge loads a wait counter. Each stalled access decrements it; zero enables completion.
Both aligned address and full aperture are checked, preventing high addresses from aliasing low
registers. PRDATA is a combinational register-file read here, valid at completion; a RAM-backed
peripheral needs latency alignment and may need a response buffer. PREADY outside ACCESS is
irrelevant. Reset is synchronous active-high in this teaching wrapper and clears the registers.
Adapt the external PRESETn polarity/timing when required.

## Requester architecture
Use IDLE, SETUP and ACCESS states. Latch the command at entry to SETUP. Keep the same command
through ACCESS while PREADY is low, and sample PRDATA/PSLVERR only on completion. Back-to-back
requests still need a SETUP cycle. Specify how errors reach the upstream requester; APB has no
independent response VALID channel.

## Verification
The regression checks three wait cycles, consecutive accesses without deselecting, all byte
strobe masks, readback, zero-strobe writes, unaligned/unmapped errors, no SETUP side effects and
PENABLE while unselected. For extensions, add WAIT_CYCLES=0 and larger delays, reset in ACCESS,
protection failures if implemented, side-effect registers and bridge upstream backpressure.

## Language-specific implementation
Use SystemVerilog with explicit widths, nonblocking clocked assignments and one driver per
register. Do not declare a dynamic address as a localparam, initialize a static local variable
from a live signal, or split one state register across multiple always_ff blocks.

## Reference: apb_regs

```systemverilog
module apb_regs #(parameter int WAIT_CYCLES=1)(
 input logic clk,rst,psel,penable,pwrite,
 input logic [31:0] paddr,pwdata,input logic [3:0] pstrb,
 output logic pready,pslverr,output logic [31:0] prdata,
 output logic [31:0] reg0,reg1,reg2,reg3);
 logic [31:0] regs[0:3];
 integer i;
 integer remaining;
 logic bad_addr,complete;
 assign bad_addr=(paddr[31:4]!=0 || paddr[1:0]!=0);
 assign pready=(remaining==0);
 assign complete=psel && penable && pready;
 assign pslverr=complete && bad_addr;
 assign prdata=bad_addr ? 32'b0 : regs[paddr[3:2]];
 assign reg0=regs[0];assign reg1=regs[1];assign reg2=regs[2];assign reg3=regs[3];
 always_ff @(posedge clk) begin
  if(rst) begin
   remaining<=0;for(i=0;i<4;i++) regs[i]<='0;
  end else begin
   if(psel && !penable) remaining<=WAIT_CYCLES;
   else if(psel && penable && remaining>0) remaining<=remaining-1;
   if(complete && pwrite && !bad_addr)
    for(i=0;i<4;i++) if(pstrb[i]) regs[paddr[3:2]][8*i+:8]<=pwdata[8*i+:8];
  end
 end
endmodule
```

## Specification and validation

[Arm APB specification, IHI 0024E](https://documentation-service.arm.com/static/63fe2c1356ea36189d4e79f3). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
