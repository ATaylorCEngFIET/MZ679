library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity mux_reg is
  generic (WIDTH : positive := 8);
  port (clk : in std_logic; rst : in std_logic; sel : in std_logic;
        a, b : in std_logic_vector(WIDTH-1 downto 0); q : out std_logic_vector(WIDTH-1 downto 0));
end entity;

architecture rtl of mux_reg is
  signal r : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
begin
  process(sel, a, b) begin
    r <= (others => '0');
    if sel = '1' then r <= a;
    elsif sel = '0' then r <= b;
    end if;
  end process;

  process(clk, rst) begin
    if rising_edge(clk) then
      if rst = '1' then
        q <= (others => '0');
      else
        q <= r;
      end if;
    end if;
  end process;
end architecture;
