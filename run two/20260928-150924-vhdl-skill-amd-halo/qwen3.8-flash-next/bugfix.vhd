library ieee;
use ieee.std_logic_1164.all;

entity mux_reg is
  port (
    clk : in std_logic;
    rst : in std_logic;
    sel : in std_logic;
    a   : in std_logic_vector(7 downto 0);
    b   : in std_logic_vector(7 downto 0);
    q   : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of mux_reg is
  signal r : std_logic_vector(7 downto 0);
begin

  -- Combinational multiplexer with default assignment to prevent latch inference
  process(all)
  begin
    if sel = '1' then
      r <= a;
    else
      r <= b;
    end if;
  end process;

  -- Synchronous reset register
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        q <= (others => '0');
      else
        q <= r;
      end if;
    end if;
  end process;

end architecture;
