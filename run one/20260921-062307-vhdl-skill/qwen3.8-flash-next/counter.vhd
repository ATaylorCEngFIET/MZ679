--------------------------------------------------------------------------------
-- counter4 : 4-bit synchronous up counter with enable and synchronous reset.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY counter4 IS
  PORT (
    clk   : IN  std_logic;
    rst   : IN  std_logic;
    en    : IN  std_logic;
    count : OUT std_logic_vector(3 DOWNTO 0)
  );
END ENTITY counter4;

ARCHITECTURE rtl OF counter4 IS
  SIGNAL s_count : unsigned(3 DOWNTO 0);
BEGIN
  -- Counter register: clears on synchronous reset, increments when enabled.
  count_proc : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF rst = '1' THEN
        s_count <= (OTHERS => '0');
      ELSIF en = '1' THEN
        s_count <= s_count + 1;
      END IF;
    END IF;
  END PROCESS count_proc;

  count <= std_logic_vector(s_count);
END ARCHITECTURE rtl;
