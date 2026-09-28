# VHDL-2008 coding rules

Output only VHDL-2008. One entity + one architecture per answer, compilable as given (`ghdl -a --std=08`).

## Libraries
`library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;` — nothing else unless required. Never std_logic_arith / std_logic_unsigned, never ieee.math_real.

## Where things go (most common compile error)
Everything that *declares* — functions, constants, types, subtypes, signals, attributes — goes in the architecture declarative region, between `architecture rtl of X is` and `begin`, and **in dependency order**: a function or constant must appear above the first line that uses it. After `begin` only processes, concurrent assignments and instances. After `end architecture;` nothing at all. Nothing is declared inside an entity except generics and ports.

## Entity port list
`name : in std_logic;` — semicolon between ports, none after the last one. Types are std_logic / std_logic_vector / unsigned / signed / natural only. Generics the same way, in their own `generic ( ... );` block before `port ( ... );`. In an entity the keywords are `generic (` and `port (` — `generic map` / `port map` exist only inside a component instantiation, never in an entity.

## Names (second most common error)
- State names must not equal any port or signal name. Prefix every state: `ST_IDLE, ST_START, ST_DATA, ST_STOP`. Never a state called DATA, START, IDLE alone.
- Never declare the same identifier twice; never name a signal after a type or a port. Internal copies of output ports end in `_r` or `_i` (`bvalid_r`) and are assigned to the port concurrently.

## Registers, resets, assignments
- Clocked process: `process(clk) begin if rising_edge(clk) then if rst = '1' then ... else ... end if; end if; end process;` (synchronous, active-high, unless the prompt says otherwise).
- Signals are assigned with `<=` always — including `next_state <= ...` in a combinational process. `:=` is only for variables, constants and declaration initial values.
- Every register gets a reset value; aggregates as `(others => '0')`.

## Widths and log2
Prefer an integer subtype for counters (`natural range 0 to N-1`) — it needs no width and no log2. If a vector width must be derived, use the `clog2` function shown in the FIFO reference (protocol rules): it is the **first** declaration of the architecture, the constant that calls it comes after it. `log2`, `clog2`, `ceil` do not exist unless you define them.

## Attributes (ASYNC_REG, KEEP, MARK_DEBUG)
Two declarations, both before `begin`, after the signal they refer to:
```vhdl
signal sync_r : std_logic_vector(STAGES-1 downto 0);
attribute ASYNC_REG : string;                       -- 1. declare the attribute (once per architecture)
attribute ASYNC_REG of sync_r : signal is "TRUE";   -- 2. apply it to the whole signal
```
Never after `begin`, never inside a process, never in the entity, never on a slice.

## Shift registers
One statement, concatenation, in the clocked process — no loops, no per-bit assignments:
```vhdl
sr <= sr(N-2 downto 0) & din;   -- shift left: new bit enters at 0, oldest is sr(N-1)  (CDC synchroniser)
sr <= '0' & sr(7 downto 1);     -- shift right: LSB falls off first  (UART TX, tx <= sr(0))
```

## Types and arithmetic
- Arithmetic on `unsigned`/`signed`/integers; convert at ports: `count <= std_logic_vector(cnt_r);`
- Explicit conversions only: `unsigned(x)`, `std_logic_vector(u)`, `to_integer(u)`, `to_unsigned(i, width)`, `resize(u, width)`.
- `case` choices must be constants or enumeration literals — never a signal; use `if` chains or an array index for non-constant compares.

## Combinational processes
`process(all)` (VHDL-2008), default assignment to every output first, then `case`/`if`. Every `if` has an `else` or a preceding default — otherwise a latch is inferred. Never a clocked register and a combinational assignment to the same signal.

## Reference — this compiles; copy its structure
```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity sync_count is
  generic (STAGES : positive := 2; WIDTH : positive := 4);
  port (clk : in std_logic; rst : in std_logic; en : in std_logic;
        async_in : in std_logic; sync_out : out std_logic;
        count : out std_logic_vector(WIDTH-1 downto 0));
end entity;

architecture rtl of sync_count is
  -- declarations only, in dependency order; nothing declared after begin
  signal cnt_r  : unsigned(WIDTH-1 downto 0) := (others => '0');
  signal sync_r : std_logic_vector(STAGES-1 downto 0) := (others => '0');
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of sync_r : signal is "TRUE";
begin
  count    <= std_logic_vector(cnt_r);      -- concurrent: drive ports from internal registers
  sync_out <= sync_r(STAGES-1);

  process(clk) begin
    if rising_edge(clk) then
      sync_r <= sync_r(STAGES-2 downto 0) & async_in;   -- synchroniser: no reset, no logic between stages
      if rst = '1' then
        cnt_r <= (others => '0');
      elsif en = '1' then
        cnt_r <= cnt_r + 1;                             -- wraps at 2**WIDTH-1
      end if;
    end if;
  end process;
end architecture;
```
