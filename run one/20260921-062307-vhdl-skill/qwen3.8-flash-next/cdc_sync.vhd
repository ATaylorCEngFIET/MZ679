--------------------------------------------------------------------------------
-- cdc_sync : Generic multi-stage clock-domain-crossing synchroniser for a single-bit
--            signal. Default STAGES = 2. Xilinx ASYNC_REG attribute applied to all
--            synchroniser flip-flops.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY cdc_sync IS
  GENERIC (
    g_stages : POSITIVE := 2  -- number of synchroniser stages
  );
  PORT (
    i_clk : IN  std_ulogic;  -- destination clock
    i_rst : IN  std_ulogic;  -- synchronous active-high reset
    i_d   : IN  std_ulogic;  -- asynchronous input from source domain
    o_q   : OUT std_ulogic   -- synchronised output in destination domain
  );
END ENTITY cdc_sync;

ARCHITECTURE rtl OF cdc_sync IS
  SIGNAL s_sync : std_ulogic_vector(g_stages - 1 DOWNTO 0);

  ATTRIBUTE ASYNC_REG : STRING;
  ATTRIBUTE ASYNC_REG OF s_sync : SIGNAL IS "TRUE";
BEGIN
  -- Synchroniser register chain: all stages are reset together and clocked by the
  -- destination clock. No logic is placed between synchroniser flip-flops.
  sync_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_sync <= (OTHERS => '0');
      ELSE
        s_sync <= s_sync(s_sync'LEFT - 1 DOWNTO 0) & i_d;
      END IF;
    END IF;
  END PROCESS sync_proc;

  o_q <= s_sync(s_sync'LEFT);
END ARCHITECTURE rtl;
