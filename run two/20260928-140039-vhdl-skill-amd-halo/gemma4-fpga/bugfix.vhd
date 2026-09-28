library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity mux_reg is
  port (
    clk  : in  std_logic;
    rst  : in  std_logic;
    sel  : in  std_logic;
    a    : in  std_logic_vector(7 downto 0);
    b    : in  std_logic_vector(7 downto 0);
    q    : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of mux_reg is
  signal q_r : std_logic_vector(7 downto 0);
begin
  q <= q_r;

  process(clk)
    begin
    if rising_edge(clk) then
      if rst = '1' then
        q_r <= (others => '0');
      else
        if sel = '1' then
          q_r <= a;
        else
          q_r <= b;
        end if;
      end if;
    end if;
  end process;
end architecture;
