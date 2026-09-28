# AHB / AHB-Lite protocol guidance (VHDL-2008)

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
Use VHDL-2008 with numeric_std, declarations before the architecture begin, explicit conversions
and one driver per register. Signal assignments take effect after the process; use variables
only for deliberate next-value calculations. Compile dependencies before their users.

## Reference: ahb_regs

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity ahb_regs is
 port(clk,rst,hsel,hready,hwrite:in std_logic;
 htrans:in std_logic_vector(1 downto 0);hsize:in std_logic_vector(2 downto 0);
 haddr,hwdata:in std_logic_vector(31 downto 0);
 hreadyout,hresp:out std_logic;hrdata,reg0,reg1,reg2,reg3:out std_logic_vector(31 downto 0));
end entity;
architecture rtl of ahb_regs is
 type reg_array is array(0 to 3) of std_logic_vector(31 downto 0);
 signal regs:reg_array;
 signal pending,write_hold,bad_hold,error_second:std_logic;
 signal addr_hold:std_logic_vector(1 downto 0);
begin
 hresp<=pending and bad_hold;
 hreadyout<=not(pending and bad_hold and not error_second);
 hrdata<=regs(to_integer(unsigned(addr_hold))) when pending='1' and bad_hold='0' else (others=>'0');
 reg0<=regs(0);reg1<=regs(1);reg2<=regs(2);reg3<=regs(3);
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then
    pending<='0';write_hold<='0';bad_hold<='0';error_second<='0';addr_hold<="00";regs<=(others=>(others=>'0'));
   else
    -- Advance ERROR even though HREADY is low in its first cycle.
    if pending='1' and bad_hold='1' and error_second='0' then error_second<='1';end if;
    if hready='1' then
     -- HWDATA belongs to the saved address, never the current HADDR.
     if pending='1' and write_hold='1' and bad_hold='0' then regs(to_integer(unsigned(addr_hold)))<=hwdata;end if;
     pending<=hsel and htrans(1);error_second<='0';
     if hsel='1' and htrans(1)='1' then
      addr_hold<=haddr(3 downto 2);write_hold<=hwrite;
      if unsigned(haddr(31 downto 4))/=0 or haddr(1 downto 0)/="00" or hsize/="010" then bad_hold<='1';else bad_hold<='0';end if;
     end if;
    end if;
   end if;
  end if;
 end process;
end architecture;
```

## Specification and validation

[Arm AHB specification, IHI 0033C](https://documentation-service.arm.com/static/6141bf0d674a052ae36ca811). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
