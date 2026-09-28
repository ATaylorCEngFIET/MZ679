--------------------------------------------------------------------------------
-- cdc_sync : Generic multi-stage clock-domain-crossing synchroniser.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cdc_sync IS
  GENERIC (
    g_stages : POSITIVE := 2                     -- number of synchroniser stages
  );
  PORT (
    i_clk   : IN  std_ulogic;                    -- destination clock
    i_rst   : IN  std_ulogic;                    -- reset, active high
    i_data  : IN  std_ulogic;                    -- source-domain input bit
    o_data  : OUT std_ulogic                     -- destination-domain output bit
  );
END ENTITY cdc_sync;

ARCHITECTURE rtl OF cdc_sync IS
  ATTRIBUTE ASYNC_REG : STRING;
  SIGNAL s_sync : std_ulogic_vector(g_stages-1 DOWNTO 0);
BEGIN
  ATTRIBUTE ASYNC_REG OF s_sync : SIGNAL IS "TRUE";

  -- Synchroniser chain: each stage samples the previous stage on the clock.
  sync_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_sync <= (OTHERS => '0');
      ELSE
        s_sync(0) <= i_data;
        FOR i IN 1 TO g_stages-1 LOOP
          s_sync(i) <= s_sync(i-1);
        END LOOP;
      END IF;
    END IF;
  END PROCESS sync_proc;

  o_data <= s_sync(g_stages-1);
END ARCHITECTURE rtl;
