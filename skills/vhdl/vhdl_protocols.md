# Protocol rules (VHDL-2008)

Each section: the rules, then a reference module that compiles with `ghdl -a --std=08` and has been
simulated. Copy the structure — including *where* each declaration sits — and change only what the
prompt asks for (names, widths, generics).

## Synchronous FIFO  (most failures: clog2 placement, full/empty logic, ram write outside the clock)
- Pointers one bit wider than the address: `unsigned(ADDR_W downto 0)`. `full` = MSBs differ and the
  rest equal; `empty` = pointers equal. Both are concurrent assignments outside the process.
- RAM is an array type declared in the architecture; write and read only inside `rising_edge(clk)`
  (that is what infers block RAM). Address = pointer without its MSB.
- ADDR_W comes from `clog2(DEPTH)` and the function is the **first** declaration in the architecture
  (declare before use; nothing after `end architecture`). No `ieee.math_real`, no `log2`/`ceil`.
- Never `wr_ptr <= wr_ptr + 1` when full, never read when empty. Reset clears the pointers, not the RAM.

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity fifo_sc is
  generic (WIDTH : positive := 8; DEPTH : positive := 16);   -- DEPTH power of two
  port (clk : in std_logic; rst : in std_logic;
        wr_en : in std_logic; wr_data : in std_logic_vector(WIDTH-1 downto 0);
        rd_en : in std_logic; rd_data : out std_logic_vector(WIDTH-1 downto 0);
        full : out std_logic; empty : out std_logic);
end entity;

architecture rtl of fifo_sc is
  function clog2(n : positive) return natural is     -- FIRST declaration: used by ADDR_W below
    variable r : natural := 0; variable v : natural := n - 1;
  begin
    while v > 0 loop v := v / 2; r := r + 1; end loop;
    return r;
  end function;
  constant ADDR_W : natural := clog2(DEPTH);
  type ram_type is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
  signal ram    : ram_type;
  signal wr_ptr : unsigned(ADDR_W downto 0) := (others => '0');  -- one extra wrap bit
  signal rd_ptr : unsigned(ADDR_W downto 0) := (others => '0');
  signal full_i, empty_i : std_logic;
begin
  full_i  <= '1' when wr_ptr(ADDR_W) /= rd_ptr(ADDR_W) and
                      wr_ptr(ADDR_W-1 downto 0) = rd_ptr(ADDR_W-1 downto 0) else '0';
  empty_i <= '1' when wr_ptr = rd_ptr else '0';
  full <= full_i; empty <= empty_i;

  process(clk) begin
    if rising_edge(clk) then
      if rst = '1' then
        wr_ptr <= (others => '0'); rd_ptr <= (others => '0');
      else
        if wr_en = '1' and full_i = '0' then
          ram(to_integer(wr_ptr(ADDR_W-1 downto 0))) <= wr_data;
          wr_ptr <= wr_ptr + 1;
        end if;
        if rd_en = '1' and empty_i = '0' then
          rd_data <= ram(to_integer(rd_ptr(ADDR_W-1 downto 0)));
          rd_ptr <= rd_ptr + 1;
        end if;
      end if;
    end if;
  end process;
end architecture;
```

## UART transmitter  (most failures: state named DATA/START clashing with the port, clog2 for the baud counter, missing start bit)
- 8N1: line idles '1', start bit '0', eight data bits LSB first, stop bit '1'. Four states,
  every one prefixed: `ST_IDLE, ST_START, ST_DATA, ST_STOP`.
- Baud counter is `natural range 0 to CYCLES_PER_BIT-1` — an integer subtype needs no clog2 and no
  vector width. `tick` is '1' on its last count; every state advances on `tick`.
- `busy` is a concurrent assignment: '1' whenever not ST_IDLE. Data is latched into a shift register
  in ST_IDLE; in ST_DATA drive `tx <= shift_r(0)` and shift right **only inside `if tick = '1'`** — a
  shift on every clock sends the whole byte in 8 clocks instead of 8 bit periods (the commonest
  functional bug: it compiles, and the frame is garbage).

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity uart_tx8 is
  generic (CLK_HZ : positive := 100_000_000; BAUD : positive := 115_200);
  port (clk : in std_logic; rst : in std_logic;
        data : in std_logic_vector(7 downto 0); data_valid : in std_logic;
        tx : out std_logic; busy : out std_logic);
end entity;

architecture rtl of uart_tx8 is
  constant CYCLES_PER_BIT : positive := CLK_HZ / BAUD;
  type state_type is (ST_IDLE, ST_START, ST_DATA, ST_STOP);   -- prefixed: never DATA (clashes with port)
  signal state_r : state_type := ST_IDLE;
  signal baud_r  : natural range 0 to CYCLES_PER_BIT-1 := 0;  -- no clog2 needed
  signal bit_r   : natural range 0 to 7 := 0;
  signal shift_r : std_logic_vector(7 downto 0) := (others => '0');
  signal tick    : std_logic;                                  -- '1' once per bit period
begin
  tick <= '1' when baud_r = CYCLES_PER_BIT-1 else '0';
  busy <= '0' when state_r = ST_IDLE else '1';

  process(clk) begin
    if rising_edge(clk) then
      if rst = '1' then
        state_r <= ST_IDLE; baud_r <= 0; bit_r <= 0; tx <= '1';
      else
        -- baud counter runs whenever a frame is in flight
        if state_r = ST_IDLE or tick = '1' then baud_r <= 0; else baud_r <= baud_r + 1; end if;

        case state_r is
          when ST_IDLE =>
            tx <= '1';
            if data_valid = '1' then shift_r <= data; bit_r <= 0; state_r <= ST_START; end if;
          when ST_START =>
            tx <= '0';
            if tick = '1' then state_r <= ST_DATA; end if;
          when ST_DATA =>
            tx <= shift_r(0);                                  -- LSB first
            if tick = '1' then
              shift_r <= '0' & shift_r(7 downto 1);
              if bit_r = 7 then state_r <= ST_STOP; else bit_r <= bit_r + 1; end if;
            end if;
          when ST_STOP =>
            tx <= '1';
            if tick = '1' then state_r <= ST_IDLE; end if;
        end case;
      end if;
    end if;
  end process;
end architecture;
```

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

Use VHDL-2008. Declare arrays and holding signals in the architecture before `begin`.
Use the captured address as `to_integer(unsigned(awaddr_hold))` when committing the write.

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity axil_slave is
  port (aclk : in std_logic; aresetn : in std_logic;
        awvalid : in std_logic; awready : out std_logic; awaddr : in std_logic_vector(31 downto 0);
        wvalid  : in std_logic; wready  : out std_logic; wdata  : in std_logic_vector(31 downto 0);
        wstrb   : in std_logic_vector(3 downto 0);
        bvalid  : out std_logic; bready : in std_logic; bresp : out std_logic_vector(1 downto 0);
        arvalid : in std_logic; arready : out std_logic; araddr : in std_logic_vector(31 downto 0);
        rvalid  : out std_logic; rready : in std_logic; rdata : out std_logic_vector(31 downto 0);
        rresp   : out std_logic_vector(1 downto 0);
        reg0, reg1, reg2, reg3 : out std_logic_vector(31 downto 0));
end entity;

architecture rtl of axil_slave is
  type reg_array is array (0 to 3) of std_logic_vector(31 downto 0);
  signal regs : reg_array;
  signal aw_full, w_full : std_logic;
  signal awaddr_hold : std_logic_vector(1 downto 0);
  signal wdata_hold : std_logic_vector(31 downto 0);
  signal wstrb_hold : std_logic_vector(3 downto 0);
  signal awready_i, wready_i, arready_i : std_logic;
  signal bvalid_r, rvalid_r : std_logic;
  signal aw_fire, w_fire, ar_fire, b_fire, r_fire : std_logic;
begin
  -- READY is derived from registered state, never from incoming VALID.
  awready_i <= not aw_full and not bvalid_r;
  wready_i <= not w_full and not bvalid_r;
  arready_i <= not rvalid_r;
  awready <= awready_i; wready <= wready_i; arready <= arready_i;
  aw_fire <= awvalid and awready_i;
  w_fire <= wvalid and wready_i;
  ar_fire <= arvalid and arready_i;
  b_fire <= bvalid_r and bready;
  r_fire <= rvalid_r and rready;
  bvalid <= bvalid_r; rvalid <= rvalid_r;
  bresp <= "00"; rresp <= "00";
  reg0 <= regs(0); reg1 <= regs(1); reg2 <= regs(2); reg3 <= regs(3);

  process(aclk) begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        aw_full <= '0'; w_full <= '0';
        awaddr_hold <= (others => '0'); wdata_hold <= (others => '0');
        wstrb_hold <= (others => '0');
        bvalid_r <= '0'; rvalid_r <= '0'; rdata <= (others => '0');
        regs <= (others => (others => '0'));
      else
        if aw_fire = '1' then
          aw_full <= '1'; awaddr_hold <= awaddr(3 downto 2);
        end if;
        if w_fire = '1' then
          w_full <= '1'; wdata_hold <= wdata; wstrb_hold <= wstrb;
        end if;
        -- Flags below describe transfers accepted on previous edges.
        if aw_full = '1' and w_full = '1' and bvalid_r = '0' then
          for i in 0 to 3 loop
            if wstrb_hold(i) = '1' then
              regs(to_integer(unsigned(awaddr_hold)))(8*i+7 downto 8*i)
                <= wdata_hold(8*i+7 downto 8*i);
            end if;
          end loop;
          aw_full <= '0'; w_full <= '0'; bvalid_r <= '1';
        end if;
        if b_fire = '1' then bvalid_r <= '0'; end if;
        if ar_fire = '1' then
          rdata <= regs(to_integer(unsigned(araddr(3 downto 2))));
          rvalid_r <= '1';
        end if;
        if r_fire = '1' then rvalid_r <= '0'; end if;
      end if;
    end if;
  end process;
end architecture;
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

## Clock-domain crossing  (most failures: attribute after `begin`, attribute on a bit slice, per-bit flops)
- Single bit: one vector `sync_r(STAGES-1 downto 0)`, shifted in one clocked process
  (`sync_r <= sync_r(STAGES-2 downto 0) & async_in;`), output `sync_r(STAGES-1)`.
- Attribute declaration and specification are both declarations: in the architecture, before `begin`,
  after the signal: `attribute ASYNC_REG : string; attribute ASYNC_REG of sync_r : signal is "TRUE";`
  Applied to the whole signal, never to a slice or inside the process.
- No logic between the stages. A reset is optional (only if asked). Multi-bit: never per-bit
  synchronisers — gray-coded pointers or a handshake with a held bus.
- The full module is the reference at the end of the coding rules.
