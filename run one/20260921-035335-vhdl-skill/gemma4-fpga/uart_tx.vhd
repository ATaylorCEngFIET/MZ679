--------------------------------------------------------------------------------
-- uart_tx : UART transmitter with 8N1 framing.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_tx IS
  GENERIC (
    g_clk_hz   : POSITIVE := 100000000; -- Example 100MHz
    g_baud     : POSITIVE := 115200
  );
  PORT (
    i_clk        : IN  std_logic;                         -- System clock
    i_rst        : IN  std_logic;                        -- Synchronous active-high reset
    i_data       : IN  std_logic_vector(7 DOWNTO 0);     -- Input data
    i_data_valid : IN  std_logic;                        -- Data valid input
    o_tx         : OUT std_logic;                        -- UART TX line
    o_busy       : OUT std_logic                         -- Transmitter busy status
  );
END ENTITY uart_tx;

ARCHITECTURE rtl OF uart_tx IS

  -- Constants for UART timing
  CONSTANT c_clk_per_bit : INTEGER := g_clk_hz / g_baud;

  -- State types
  TYPE t_state_type IS ENUM;
    TYPE t_state_type IS (
      s_idle,
      s_start,
      s_data,
      s_stop
    );
  END TYPE t_state_type;

  -- Internal signals
  SIGNAL s_state        : t_state_type;
  SIGNAL s_bit_idx      : integer range 0 TO 7;
  SIGNAL s_bit_cnt      : integer range 0 TO c_clk_per_bit - 1;
  SIGNAL s_tx_reg       : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_tx_busy       : std_logic;

BEGIN

  -- Main UART state machine and logic
  -- This process handles the state transitions and the bit counter.
  tx_main_proc : PROCESS (i_clk)
  BEGIN
    IF RISING_EDGE(i_clk) THEN
      IF i_rst = '1' THEN
        s_state        <= s_idle;
        s_bit_idx      <= 0;
        s_bit_cnt      <= 0;
        s_tx_reg       <= (OTHERS => '0');
        s_tx_busy       <= '0';
      ELSE
        CASE s_state IS

          WHEN s_idle =>
            s_tx_busy <= '0';
            IF i_data_valid = '1' THEN
              s_tx_reg       <= i_data;
              s_tx_busy       <= '1';
              s_state         <= s_start;
              s_bit_cnt       <= 0;
            END IF;

          WHEN s_start =>
            -- Start bit is '0'
            IF s_bit_cnt = c_clk_per_bit - 1 THEN
              s_state         <= s_data;
              s_bit_idx       <= 0;
              s_bit_cnt       <= 0;
            ELSE
              s_bit_cnt       <= s_bit_cnt + 1;
            END IF;

          WHEN s_data =>
            -- Data bits are sent LSB first
            IF s_bit_cnt = c_clk_per_bit - 1 THEN
              s_state         <= s_stop;
              s_bit_cnt       <= 0;
            ELSE
              s_bit_cnt       <= s_bit_cnt + 1;
            END IF;

          WHEN s_stop =>
            -- Stop bit is '1'
            IF s_bit_cnt = c_clk_per_bit - 1 THEN
              s_state         <= s_idle;
            ELSE
              s_bit_cnt       <= s_bit_cnt + 1;
            END IF;

        END CASE;
      END IF;
    END IF;
  END PROCESS tx_main_proc;

  -- Combinational logic for the TX line
  -- Maps the current state and counter to the physical TX pin.
  tx_line_logic : PROCESS (s_state, s_bit_cnt, s_bit_idx, s_tx_reg)
  BEGIN
    o_tx <= '1'; -- Default to high (idle)
    
    CASE s_state IS
      WHEN s_idle =>
        o_tx <= '1';
      WHEN s_start =>
        o_tx <= '0';
      WHEN s_data =>
        -- Select bit from register based on current index
        o_tx <= s_tx_reg(s_bit_idx);
      WHEN s_stop =>
        o_tx <= '1';
    END CASE;
  END PROCESS tx_line_logic;

  -- Output assignment for busy status
  o_busy <= s_tx_busy;

END ARCHITECTURE rtl;
