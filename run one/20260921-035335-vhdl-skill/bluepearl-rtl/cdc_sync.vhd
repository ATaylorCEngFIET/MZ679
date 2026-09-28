--------------------------------------------------------------------------------
-- cdc_sync : Generic N-stage single-bit synchroniser.
-- Synchronises a single-bit signal from one clock domain to another.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cdc_sync IS
  GENERIC (
    g_stages : POSITIVE := 2                      -- Number of synchroniser stages
  );
  PORT (
    i_clk   : IN  std_ulogic;                     -- Destination clock domain
    i_rst   : IN  std_ulogic;                     -- Synchronous reset, active high
    i_async : IN  std_ulogic;                     -- Asynchronous input signal
    o_sync  : OUT std_ulogic                      -- Synchronised output signal
  );
END ENTITY cdc_sync;

ARCHITECTURE rtl OF cdc_sync IS

  -- Attribute for Xilinx tools to identify synchroniser flops
  ATTRIBUTE ASYNC_REG : STRING;

  -- Array type for the chain of synchroniser flops
  TYPE t_sync_chain IS ARRAY (0 TO g_stages) OF std_ulogic;
  SIGNAL s_sync_reg : t_sync_chain;

BEGIN

  -- Apply ASYNC_REG attribute to the synchroniser chain for Xilinx synthesis
  ATTRIBUTE ASYNC_REG OF s_sync_reg : SIGNAL IS "TRUE";

  -- Synchroniser chain process
  -- The input is sampled into the first flop, then shifted through the chain.
  sync_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_sync_reg <= (OTHERS => '0');
      ELSE
        -- Shift the chain: input goes to index 0, others follow
        s_sync_reg(0) <= i_async;
        FOR i IN 1 TO g_stages LOOP
          s_sync_reg(i) <= s_sync_reg(i-1);
        END LOOP;
      END IF;
    END IF;
  END PROCESS sync_proc;

  -- Output the last stage of the synchroniser
  o_sync <= s_sync_reg(g_stages);

END ARCHITECTURE rtl;
