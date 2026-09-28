# AXI4-Stream protocol guidance (VHDL-2008)

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
Use VHDL-2008 with numeric_std, declarations before the architecture begin, explicit conversions
and one driver per register. Signal assignments take effect after the process; use variables
only for deliberate next-value calculations. Compile dependencies before their users.

## Reference: axis_fifo2

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity axis_fifo2 is
 generic(DATA_W:positive:=32;USER_W:positive:=4);
 port(clk,rst:in std_logic;s_valid:in std_logic;s_ready:out std_logic;
 s_data:in std_logic_vector(DATA_W-1 downto 0);s_keep:in std_logic_vector(DATA_W/8-1 downto 0);
 s_last:in std_logic;s_user:in std_logic_vector(USER_W-1 downto 0);
 m_valid:out std_logic;m_ready:in std_logic;m_data:out std_logic_vector(DATA_W-1 downto 0);
 m_keep:out std_logic_vector(DATA_W/8-1 downto 0);m_last:out std_logic;m_user:out std_logic_vector(USER_W-1 downto 0));
end entity;
architecture rtl of axis_fifo2 is
 constant PAYLOAD_W:positive:=DATA_W+DATA_W/8+1+USER_W;
 type slot_array is array(0 to 1) of std_logic_vector(PAYLOAD_W-1 downto 0);
 signal slots:slot_array;
 signal rd_ptr,wr_ptr:natural range 0 to 1;
 signal count:natural range 0 to 2;
 signal ready_i,valid_i,push,pop:std_logic;
begin
 ready_i<='1' when count<2 else '0';valid_i<='1' when count/=0 else '0';
 s_ready<=ready_i;m_valid<=valid_i;
 m_data<=slots(rd_ptr)(DATA_W-1 downto 0);
 m_keep<=slots(rd_ptr)(DATA_W+DATA_W/8-1 downto DATA_W);
 m_last<=slots(rd_ptr)(DATA_W+DATA_W/8);
 m_user<=slots(rd_ptr)(PAYLOAD_W-1 downto DATA_W+DATA_W/8+1);
 push<=s_valid and ready_i;pop<=valid_i and m_ready;
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then count<=0;rd_ptr<=0;wr_ptr<=0;slots<=(others=>(others=>'0'));
   else
    if push='1' then slots(wr_ptr)<=s_user & s_last & s_keep & s_data;wr_ptr<=1-wr_ptr;end if;
    if pop='1' then rd_ptr<=1-rd_ptr;end if;
    if push='1' and pop='0' then count<=count+1;
    elsif pop='1' and push='0' then count<=count-1;end if;
   end if;
  end if;
 end process;
end architecture;
```

## Specification and validation

[Arm AXI4-Stream specification, IHI 0051](https://documentation-service.arm.com/static/642583d7314e245d086bc8c9). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
