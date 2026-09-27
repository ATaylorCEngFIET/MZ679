--------------------------------------------------------------------------------
-- counter4 : 4-bit synchronous up counter with enable.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter4 is
  port (
    i_clk   : in  std_logic;                               -- system clock
    i_rst   : in  std_logic;                               -- reset, active high
    i_en    : in  std_logic;                               -- count enable
    o_count : out std_logic_vector(3 downto 0)            -- count value
  );
end entity counter4;

architecture rtl of counter4 is
  signal s_count : unsigned(3 downto 0);
begin

  -- Counter logic: increments on every clock cycle where en is high.
  -- The 'unsigned' type handles the wrap-around from 15 to 0 automatically.
  count_proc : process (i_clk)
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        s_count <= (others => '0');
      elsif i_en = '1' then
        s_count <= s_count + 1;
      end if;
    end if;
  end process count_proc;

  -- Assign internal counter to output port.
  o_count <= std_logic_vector(s_count);

end architecture rtl;
