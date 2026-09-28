library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity counter4 is
  generic (WIDTH : positive := 4);
  port (clk : in std_logic; rst : in std_logic; en : in std_logic;
        count : out std_logic_vector(WIDTH-1 downto 0));
end entity;

architecture rtl of counter4 is
  type reg_array is array (natural range <>) of unsigned(WIDTH-1 downto 0);
  signal cnt_r : reg_array(0 to 0) := (others => (others => '0'));
begin
  count <= std_logic_vector(cnt_r(0));

  process(clk) begin
    if rising_edge(clk) then
      if rst = '1' then
        cnt_r(0) <= (others => '0');
      elsif en = '1' then
        cnt_r(0) <= to_unsigned(to_integer(cnt_r(0)) + 1, WIDTH);
      end if;
    end if;
  end process;
end architecture;
