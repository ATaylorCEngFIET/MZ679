# APB protocol guidance (VHDL-2008)

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
Use VHDL-2008 with numeric_std, declarations before the architecture begin, explicit conversions
and one driver per register. Signal assignments take effect after the process; use variables
only for deliberate next-value calculations. Compile dependencies before their users.

## Reference: apb_regs

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity apb_regs is
 generic(WAIT_CYCLES:natural:=1);
 port(clk,rst,psel,penable,pwrite:in std_logic;
 paddr,pwdata:in std_logic_vector(31 downto 0);pstrb:in std_logic_vector(3 downto 0);
 pready,pslverr:out std_logic;prdata,reg0,reg1,reg2,reg3:out std_logic_vector(31 downto 0));
end entity;
architecture rtl of apb_regs is
 type reg_array is array(0 to 3) of std_logic_vector(31 downto 0);
 signal regs:reg_array;signal remaining:natural range 0 to WAIT_CYCLES;
 signal bad_addr,ready_i,complete:std_logic;
begin
 bad_addr<='1' when unsigned(paddr(31 downto 4))/=0 or paddr(1 downto 0)/="00" else '0';
 ready_i<='1' when remaining=0 else '0';pready<=ready_i;
 complete<=psel and penable and ready_i;pslverr<=complete and bad_addr;
 prdata<=regs(to_integer(unsigned(paddr(3 downto 2)))) when bad_addr='0' else (others=>'0');
 reg0<=regs(0);reg1<=regs(1);reg2<=regs(2);reg3<=regs(3);
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then remaining<=0;regs<=(others=>(others=>'0'));
   else
    if psel='1' and penable='0' then remaining<=WAIT_CYCLES;
    elsif psel='1' and penable='1' and remaining>0 then remaining<=remaining-1;end if;
    if complete='1' and pwrite='1' and bad_addr='0' then
     for i in 0 to 3 loop
      if pstrb(i)='1' then regs(to_integer(unsigned(paddr(3 downto 2))))(8*i+7 downto 8*i)<=pwdata(8*i+7 downto 8*i);end if;
     end loop;
    end if;
   end if;
  end if;
 end process;
end architecture;
```

## Specification and validation

[Arm APB specification, IHI 0024E](https://documentation-service.arm.com/static/63fe2c1356ea36189d4e79f3). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
