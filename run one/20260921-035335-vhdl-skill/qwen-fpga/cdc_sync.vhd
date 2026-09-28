--------------------------------------------------------------------------------
-- cdc_sync : Generic two-flop clock-domain-crossing synchroniser for single-bit.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY cdc_sync IS
  GENERIC (
    g_stages : NATURAL := 2   -- Number of flip-flop stages in the synchroniser chain
  );
  PORT (
    i_clk_src : IN  std_ulogic;      -- Source clock domain
    i_data    : IN  std_logic;       -- Input data from source domain
    o_synced  : OUT std_logic        -- Synchronised output in destination domain
  );
END ENTITY cdc_sync;

ARCHITECTURE rtl OF cdc_sync IS
  ATTRIBUTE ASYNC_REG : STRING;
  SIGNAL s_chain_0 : std_logic;
  SIGNAL s_chain_last : std_logic;
BEGIN
  -- First stage of the synchroniser chain.
  sync_stage_0_proc : PROCESS (i_clk_src)
  BEGIN
    IF rising_edge(i_clk_src) THEN
      s_chain_0 <= i_data;
    END IF;
  END PROCESS sync_stage_0_proc;

  -- Last stage of the synchroniser chain.
  sync_stage_last_proc : PROCESS (s_chain_0)
  BEGIN
    IF rising_edge(s_chain_0) THEN
      s_chain_last <= '1';
    ELSE
      s_chain_last <= '0';
    END IF;
  END PROCESS sync_stage_last_proc;

  -- Intermediate stages loop.
  -- Note: For g_stages > 2, we need to instantiate intermediate flops or use a loop.
  -- Since VHDL does not support loops for signal assignments directly in RTL without generics/arrays,
  -- and the requirement is a generic number of stages, we implement the chain structurally.
  -- However, standard practice for a generic N-stage synchroniser usually implies:
  -- Stage 0 takes i_data. Stage 1..N-1 take previous stage output.
  -- To keep it synthesisable with a simple generic count without arrays of signals (which requires specific tool support),
  -- we assume the architecture generates the chain.
  -- Given the constraint of "single file" and standard VHDL, we will hardcode the logic for the generic case
  -- by creating intermediate signals if needed, but a cleaner way for arbitrary N is to use a process loop
  -- which some synthesizers support, or simply define the last stage logic.
  -- Re-evaluating: The prompt asks for a generic two-flop synchroniser with STAGES defaulting to 2.
  -- If STAGES > 2, we need more signals. Let's implement a scalable structure using an array of signals if supported,
  -- or simply handle the specific case of 2 stages as per default and allow extension.
  -- Standard VHDL-2008 allows arrays of signals.
  
  TYPE t_sync_chain IS ARRAY (NATURAL RANGE <>) OF std_logic;
  SIGNAL s_chain : t_sync_chain(g_stages - 1 DOWNTO 0);

BEGIN
  -- Assign first stage input to chain(0)
  s_chain(0) <= i_data;

  -- Logic for intermediate and last stages
  sync_chain_proc : PROCESS (i_clk_src)
    VARIABLE v_next_idx : NATURAL;
  BEGIN
    IF rising_edge(i_clk_src) THEN
      -- Shift data through the chain
      FOR idx IN s'RANGE LOOP
        IF idx = s'LEFT THEN
          s_chain(idx) <= s_chain(idx + 1);
        ELSIF idx < s'RIGHT THEN
          s_chain(idx) <= s_chain(idx + 1);
        END IF;
      END LOOP;
      
      -- Correct logic: Shift right (from higher index to lower? No, usually 0 is input).
      -- Let's define chain(0) as the first flop after input.
      -- chain(1) takes chain(0), etc.
      -- Actually, standard synchroniser: 
      -- FF0 gets i_data. FF1 gets FF0_out. ... FF(N-1) gets FF(N-2)_out.
      -- So s_chain(0) is the output of first flop.
      -- We need to shift values down or up?
      -- Let's use: s_chain(i) <= s_chain(i+1) is wrong if i+1 doesn't exist for last.
      
      -- Revised approach for generic N stages:
      -- s_chain(0) gets input from previous stage (or i_data if 0).
      -- But we need to handle the boundary.
      -- Let's restart the process logic for clarity.
    END IF;
  END PROCESS sync_chain_proc;

  -- Redefining the chain process correctly
  sync_chain_proc : PROCESS (i_clk_src)
  BEGIN
    IF rising_edge(i_clk_src) THEN
      -- First stage: takes input directly
      s_chain(0) <= i_data;
      
      -- Subsequent stages: take output of previous stage
      FOR idx IN 1 TO g_stages - 1 LOOP
        s_chain(idx) <= s_chain(idx - 1);
      END LOOP;
    END IF;
  END PROCESS sync_chain_proc;

  -- Assign final output
  o_synced <= s_chain(g_stages - 1);

END ARCHITECTURE rtl;
