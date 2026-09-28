library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity sync_fifo is
  generic (WIDTH : positive := 8; DEPTH : positive := 16);   -- DEPTH power of two
  port (clk : in std_logic; rst : in std_logic;
        wr_en : in std_logic; wr_data : in std_logic_vector(WIDTH-1 downto 0);
        rd_en : in std_logic; rd_data : out std_logic_vector(WIDTH-1 downto 0);
        full : out std_logic; empty : out std_logic);
end entity;

architecture rtl of sync_fifo is
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
