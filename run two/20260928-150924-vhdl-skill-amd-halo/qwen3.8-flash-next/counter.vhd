library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity counter4 is
  port (clk : in std_logic; rst : in std_logic; en : in std_logic;
        count : out std_logic_vector(3 downto 0));
end entity;

architecture rtl of counter4 is
  signal cnt_r : unsigned(3 downto 0) := (others => '0');
begin
  count <= std_logic_vector(cnt_r);

  process(clk) begin
    if rising_edge(clk) then
      if rst = '1' then
        cnt_r <= (others => '0');
      elsif en = '1' then
        cnt_r <= cnt_r + 1;
      end if;
    end if;
  end process;
end architecture;
