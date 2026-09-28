--------------------------------------------------------------------------------
-- mux_reg : 8-bit synchronous multiplexer with reset.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_reg is
  port (
    clk   : in  std_logic;                      -- system clock
    rst   : in  std_logic;                      -- asynchronous reset, active high
    sel   : in  std_logic;                      -- select input
    a     : in  std_logic_vector(7 downto 0);  -- data input A
    b     : in  std_logic_vector(7 downto 0);  -- data input B
    q     : out std_logic_vector(7 downto 0)   -- output data
  );
end entity mux_reg;

architecture rtl of mux_reg is
  signal s_mux : std_logic_vector(7 downto 0);
begin
  -- Combinational logic: selects between inputs a and b based on sel.
  mux_proc : process (sel, a, b)
  begin
    if sel = '1' then
      s_mux <= a;
    else
      s_mux <= b;
    end if;
  end process mux_proc;

  -- Sequential logic: registers the mux output and handles reset.
  reg_proc : process (clk, rst)
  begin
    if rst = '1' then
      q <= (others => '0');
    elsif rising_edge(clk) then
      q <= s_mux;
    end if;
  end process reg_proc;

  -- Output assignment.
  q <= s_mux;

end architecture rtl;
