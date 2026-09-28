--------------------------------------------------------------------------------
-- counter4 : 4-bit synchronous up counter with enable.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY counter4 IS
  GENERIC (
    g_width : POSITIVE := 4                       -- counter width in bits
  );
  PORT (
    i_clk   : IN  std_ulogic;                     -- system clock
    i_rst   : IN  std_ulogic;                     -- reset, active high synchronous
    i_en    : IN  std_ulogic;                     -- count enable
    o_count : OUT std_ulogic_vector(g_width-1 DOWNTO 0)  -- count value
  );
END ENTITY counter4;

ARCHITECTURE rtl OF counter4 IS
  SIGNAL s_count : unsigned(g_width-1 DOWNTO 0);
BEGIN
  -- Counter register: clears on reset, increments when enabled.
  count_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_count <= (OTHERS => '0');
      ELSIF i_en = '1' THEN
        s_count <= s_count + 1;
      END IF;
    END IF;
  END PROCESS count_proc;

  o_count <= std_ulogic_vector(s_count);
END ARCHITECTURE rtl;
