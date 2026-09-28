# AXI4 Full (memory mapped) protocol guidance (VHDL-2008)

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
Use VHDL-2008 with numeric_std, declarations before the architecture begin, explicit conversions
and one driver per register. Signal assignments take effect after the process; use variables
only for deliberate next-value calculations. Compile dependencies before their users.

## Reference: axif_burst_cursor

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity axif_burst_cursor is
 port(clk,rst,cmd_valid:in std_logic;cmd_ready:out std_logic;
 cmd_addr:in std_logic_vector(31 downto 0);cmd_len:in std_logic_vector(7 downto 0);
 cmd_size:in std_logic_vector(2 downto 0);cmd_burst:in std_logic_vector(1 downto 0);cmd_id:in std_logic_vector(3 downto 0);
 beat_valid:out std_logic;beat_ready:in std_logic;beat_addr:out std_logic_vector(31 downto 0);
 beat_id:out std_logic_vector(3 downto 0);beat_last,done,bad_request:out std_logic);
end entity;
architecture rtl of axif_burst_cursor is
 signal active,legal:std_logic;signal left_minus_one:unsigned(7 downto 0);
 signal burst_hold:std_logic_vector(1 downto 0);signal addr_r,wrap_mask:unsigned(31 downto 0);
begin
 process(all)
  variable ok:boolean;variable n:natural range 0 to 255;
 begin
  n:=to_integer(unsigned(cmd_len));ok:=cmd_size="010" and cmd_addr(1 downto 0)="00";
  case cmd_burst is
   when "00" => ok:=ok and n<16;
   when "01" => ok:=ok and to_integer(unsigned(cmd_addr(11 downto 0)))+n*4+3<4096;
   when "10" => ok:=ok and (n=1 or n=3 or n=7 or n=15);
   when others => ok:=false;
  end case;
  if ok then legal<='1';else legal<='0';end if;
 end process;
 cmd_ready<=not active;beat_valid<=active;beat_addr<=std_logic_vector(addr_r);
 beat_last<='1' when active='1' and left_minus_one=0 else '0';
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then
    active<='0';left_minus_one<=(others=>'0');burst_hold<="00";wrap_mask<=(others=>'0');
    addr_r<=(others=>'0');beat_id<=(others=>'0');done<='0';bad_request<='0';
   else
    done<='0';
    if cmd_valid='1' and active='0' then
     bad_request<=not legal;
     if legal='1' then
      active<='1';addr_r<=unsigned(cmd_addr);beat_id<=cmd_id;left_minus_one<=unsigned(cmd_len);burst_hold<=cmd_burst;
      wrap_mask<=to_unsigned((to_integer(unsigned(cmd_len))+1)*4-1,32);
     else done<='1';end if;
    end if;
    if active='1' and beat_ready='1' then
     if left_minus_one=0 then active<='0';done<='1';
     else
      left_minus_one<=left_minus_one-1;
      if burst_hold="01" then addr_r<=addr_r+4;
      elsif burst_hold="10" then addr_r<=(addr_r and not wrap_mask) or ((addr_r+4) and wrap_mask);end if;
     end if;
    end if;
   end if;
  end if;
 end process;
end architecture;
```

## Specification and validation

[Arm AXI/ACE specification, IHI 0022H, AXI4 chapters](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/IHI0022H_amba_axi_protocol_spec.pdf). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
