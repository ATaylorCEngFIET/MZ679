--------------------------------------------------------------------------------
-- cdc_sync : Generic two-flop clock-domain-crossing synchroniser for single-bit
--            signals with optional stage configuration.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cdc_sync IS
  GENERIC (
    g_stages : POSITIVE := 2  -- number of synchronisation stages, minimum 1
  );
  PORT (
    i_clk_src   : IN  std_ulogic;        -- source clock domain
    i_sig_src   : IN  std_ulogic;        -- signal in source domain
    i_clk_dst   : IN  std_ulogic;        -- destination clock domain
    o_sig_dst   : OUT std_ulogic         -- synchronised signal in dest domain
  );
END ENTITY cdc_sync;

ARCHITECTURE rtl OF cdc_sync IS
  TYPE t_sync_array IS ARRAY (0 TO g_stages-1) OF std_ulogic;
  SIGNAL s_sync_reg : t_sync_array;
  
  ATTRIBUTE ASYNC_REG : STRING;
  ATTRIBUTE ASYNC_REG OF s_sync_reg : SIGNAL IS "TRUE";
BEGIN
  sync_proc : PROCESS (i_clk_dst)
  BEGIN
    IF rising_edge(i_clk_dst) THEN
      s_sync_reg(0) <= i_sig_src;
      FOR i IN 1 TO g_stages-1 LOOP
        s_sync_reg(i) <= s_sync_reg(i-1);
      END LOOP;
    END IF;
  END PROCESS sync_proc;

  o_sig_dst <= s_sync_reg(g_stages-1);
END ARCHITECTURE rtl;
