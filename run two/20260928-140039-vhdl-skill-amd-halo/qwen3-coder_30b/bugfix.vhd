library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
  process(clk, rst) begin
    if rst = '1' then
      r <= (others => '0');
    elsif rising_edge(clk) then
      if sel = '1' then
        r <= a;
      else
        r <= b;
      end if;
    end if;
  end process;
  
  process(clk, rst) begin
    if rst = '1' then
      q <= (others => '0');
    elsif rising_edge(clk) then
      q <= r;
    end if;
  end process;
end architecture;
