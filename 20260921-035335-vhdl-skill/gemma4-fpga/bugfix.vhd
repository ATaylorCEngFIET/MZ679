--------------------------------------------------------------------------------
-- mux_reg : 8-bit multiplexer followed by a registered output.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_reg is
  port (
    i_clk   : in  std_logic;                    -- system clock
    i_rst   : in  std_logic;                   -- reset, active high
    i_sel   : in  std_logic;                   -- mux select
    i_a     : in  std_logic_vector(7 downto 0); -- input a
    i_b     : in  std_logic_vector(7 downto 0); -- input b
    o_q     : out std_logic_vector(7 downto 0)  -- registered output
  );
end entity mux_reg;

architecture rtl of mux_reg is
  signal s_mux : std_logic_vector(7 downto 0);
begin

  -- Combinational multiplexer logic.
  -- This process is now purely combinational with no possibility of latches.
  mux_proc : process (i_sel, i_a, i_b)
  begin
    if i_sel = '1' then
      s_mux <= i_a;
    else
      s_mux <= i_b;
    end if;
  end process mux_proc;

  -- Registered output.
  -- The reset is now handled synchronously or as a standard synchronous reset
  -- within the clocked process to ensure a clean, safe synthesis path.
  reg_proc : process (i_clk)
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        o_q <= (others => '0');
      else
        o_q <= s_mux;
      end if;
    end if;
  end process reg_proc;

end architecture rtl;
