--------------------------------------------------------------------------------
-- cdc_sync : Two-flop clock-domain-crossing synchroniser for single-bit signals.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cdc_sync IS
  GENERIC (
    g_stages : POSITIVE := 2                       -- number of sync stages
  );
  PORT (
    i_clk_src   : IN  std_ulogic                   -- source clock domain
    i_clk_dst   : IN  std_ulogic                   -- destination clock domain
    i_in        : IN  std_ulogic                   -- input signal to synchronise
    o_out       : OUT std_ulogic                   -- synchronised output signal
  );
END ENTITY cdc_sync;

ARCHITECTURE rtl OF cdc_sync IS
  CONSTANT c_stages : POSITIVE := g_stages;
  
  TYPE t_state_type IS (IDLE, SYNC);
  
  SIGNAL s_state : t_state_type;
  SIGNAL s_reg_1 : std_ulogic;                     -- first stage register
  SIGNAL s_reg_2 : std_ulogic;                     -- second stage register
  
BEGIN
  -- State machine for synchronisation logic.
  sync_fsm_proc : PROCESS (i_clk_dst, i_in)
  BEGIN
    IF rising_edge(i_clk_dst) THEN
      CASE s_state IS
        WHEN IDLE =>
          IF i_in = '1' THEN
            s_state <= SYNC;
          ELSE
            s_state <= IDLE;
          END IF;
          
        WHEN SYNC =>
          s_state <= IDLE;
          
        WHEN OTHERS =>
          s_state <= IDLE;
      END CASE;
    END IF;
  END PROCESS sync_fsm_proc;

  -- First stage register with ASYNC_REG attribute.
  sync_ff_0 : INST cdc_sync_ff
    GENERIC MAP (g_stages => c_stages)
    PORT MAP (
      i_clk   => i_clk_dst,
      i_rst   => '0',
      i_in    => i_in,
      o_out   => s_reg_1
    );

  -- Second stage register with ASYNC_REG attribute.
  sync_ff_1 : INST cdc_sync_ff
    GENERIC MAP (g_stages => c_stages)
    PORT MAP (
      i_clk   => i_clk_dst,
      i_rst   => '0',
      i_in    => s_reg_1,
      o_out   => o_out
    );

END ARCHITECTURE rtl;
