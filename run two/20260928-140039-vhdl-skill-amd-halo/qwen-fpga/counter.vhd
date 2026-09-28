library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity counter4 is
  port (clk : in std_logic; rst : in std_logic; en : in std_logic; count : out unsigned(3 downto 0));
end entity;

architecture rtl of counter4 is
begin
  process(clk) begin
    if rising_edge(clk) then
      if rst = '1' then
        count <= (others => '0');
      elsif en = '1' then
        count <= count + 1;
      end if;
    end if;
  end process;
end architecture;
