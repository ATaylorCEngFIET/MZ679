--------------------------------------------------------------------------------
-- sync_fifo : Synchronous FIFO using single-clock inferred block RAM.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sync_fifo IS
  GENERIC (
    g_width : POSITIVE := 8                    -- data width in bits
    ; g_depth : POSITIVE := 256                -- FIFO depth in words (power of two)
  );
  PORT (
    i_clk   : IN  std_ulogic;                  -- system clock
    ; i_rst   : IN  std_ulogic;                  -- reset, active high
    ; i_wr_en : IN  std_ulogic;                  -- write enable
    ; i_wr_data : IN  std_logic_vector(g_width-1 DOWNTO 0)  -- data to write
    ; i_rd_en : IN  std_ulogic;                 -- read enable
    ; i_rd_data : OUT std_logic_vector(g_width-1 DOWNTO 0)  -- data to read
    ; o_full : OUT std_ulogic;                 -- full flag
    ; o_empty : OUT std_ulogic                   -- empty flag
  );
END ENTITY sync_fifo;

ARCHITECTURE rtl OF sync_fifo IS
  --------------------------------------------------------------------------
  -- Type definitions and constants
  --------------------------------------------------------------------------
  TYPE t_state_type IS (IDLE, FULL, EMPTY);
  
  CONSTANT c_depth : INTEGER := g_depth;
  CONSTANT c_width : INTEGER := g_width;
  
  --------------------------------------------------------------------------
  -- Signals
  --------------------------------------------------------------------------
  SIGNAL s_clk   : std_ulogic;
  SIGNAL s_wr_ptr : unsigned(c_depth + 1 DOWNTO 0); -- write pointer (width = depth + 1)
  SIGNAL s_rd_ptr : unsigned(c_depth + 1 DOWNTO 0); -- read pointer (width = depth + 1)
  SIGNAL s_data   : std_logic_vector(g_width-1 DOWNTO 0); -- FIFO data storage
  SIGNAL s_full   : std_ulogic;
  SIGNAL s_empty  : std_ulogic;

BEGIN
  --------------------------------------------------------------------------
  -- Clock signal assignment (synchronous to i_clk)
  --------------------------------------------------------------------------
  clk_assign_proc : PROCESS
  BEGIN
    s_clk <= i_clk;
  END PROCESS clk_assign_proc;

  --------------------------------------------------------------------------
  -- FIFO Logic: Single clocked process with rising edge detection.
  --------------------------------------------------------------------------
  fifo_logic_proc : PROCESS (s_clk, i_rst)
  BEGIN
    IF rising_edge(s_clk) THEN
      ----------------------------------------------------------------------
      -- Reset logic: Clear pointers and data on active high reset.
      ----------------------------------------------------------------------
      IF i_rst = '1' THEN
        s_wr_ptr <= (OTHERS => '0');
        s_rd_ptr <= (OTHERS => '0');
        s_data   <= (OTHERS => '0');
        s_full   <= '0';
        s_empty  <= '1';
      ELSIF i_rst = '0' THEN
        ------------------------------------------------------------------
        -- Read logic: Update read pointer and output data when enabled.
        ------------------------------------------------------------------
        IF i_rd_en = '1' THEN
          IF s_wr_ptr > s_rd_ptr THEN
            s_rd_ptr <= s_rd_ptr + 1;
          ELSE
            s_rd_ptr <= s_rd_ptr + 1; -- Increment even if full to prevent wrap issues in next cycle
          END IF;
        END IF;

        ------------------------------------------------------------------
        -- Write logic: Update write pointer and data when enabled.
        ------------------------------------------------------------------
        IF i_wr_en = '1' THEN
          s_wr_ptr <= s_wr_ptr + 1;
          s_data(i_wr_data) <= i_wr_data; -- Store data at current write pointer
        END IF;

        ------------------------------------------------------------------
        -- Full/Empty detection logic:
        -- Empty: Read pointer == Write pointer (both start at 0).
        -- Full:   Write pointer == Read pointer + 1 (modulo depth).
        ------------------------------------------------------------------
        IF s_wr_ptr = s_rd_ptr THEN
          s_empty <= '1';
          s_full  <= '0';
        ELSIF s_wr_ptr = s_rd_ptr + 1 THEN
          s_empty <= '0';
          s_full  <= '1';
        ELSE
          s_empty <= '0';
          s_full  <= '0';
        END IF;

        ------------------------------------------------------------------
        -- Output data assignment: Read from FIFO if enabled and not empty.
        ------------------------------------------------------------------
        IF i_rd_en = '1' AND NOT s_empty THEN
          i_rd_data <= s_data(s_rd_ptr(g_width-1 DOWNTO 0));
        ELSE
          i_rd_data <= (OTHERS => '0');
        END IF;

      END IF;
    END IF;
  END PROCESS fifo_logic_proc;

END ARCHITECTURE rtl;
