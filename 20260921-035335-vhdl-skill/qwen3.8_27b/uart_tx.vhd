--------------------------------------------------------------------------------
-- uart_tx : 8N1 UART transmitter, LSB-first, one start and one stop bit.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_tx IS
  GENERIC (
    g_clk_hz : NATURAL := 100_000_000;  -- system clock frequency in Hz
    g_baud   : NATURAL := 115200       -- baud rate in bits per second
  );
  PORT (
    i_clk        : IN  std_ulogic;
    i_rst        : IN  std_ulogic;
    i_data       : IN  std_ulogic_vector(7 DOWNTO 0);
    i_data_valid : IN  std_ulogic;
    o_tx         : OUT std_ulogic;
    o_busy       : OUT std_ulogic
  );
END ENTITY uart_tx;

ARCHITECTURE rtl OF uart_tx IS

  TYPE t_state_type IS (s_idle, s_start, s_data, s_stop);

  CONSTANT c_baud_div : NATURAL := g_clk_hz / g_baud;
  CONSTANT c_bit_cnt  : NATURAL := c_baud_div - 1;

  SIGNAL s_state      : t_state_type;
  SIGNAL s_bit_cnt    : NATURAL RANGE 0 TO c_bit_cnt;
  SIGNAL s_bit_idx    : NATURAL RANGE 0 TO 7;
  SIGNAL s_tx_reg     : std_ulogic;
  SIGNAL s_busy_reg   : std_ulogic;

BEGIN

  -- Baud-rate tick generator: counts to c_bit_cnt then wraps.
  tick_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_bit_cnt <= c_bit_cnt;
      ELSIF s_bit_cnt = 0 THEN
        s_bit_cnt <= c_bit_cnt;
      ELSE
        s_bit_cnt <= s_bit_cnt - 1;
      END IF;
    END IF;
  END PROCESS tick_proc;

  -- Main transmitter state machine.
  tx_fsm : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_state    <= s_idle;
        s_bit_idx  <= 0;
        s_tx_reg   <= '1';
        s_busy_reg <= '0';
      ELSE
        IF s_bit_cnt = 0 THEN
          CASE s_state IS
            WHEN s_idle =>
              IF i_data_valid = '1' THEN
                s_state    <= s_start;
                s_tx_reg   <= '0';
                s_busy_reg <= '1';
              END IF;

            WHEN s_start =>
              s_state   <= s_data;
              s_bit_idx <= 0;
              s_tx_reg  <= i_data(0);

            WHEN s_data =>
              IF s_bit_idx = 7 THEN
                s_state  <= s_stop;
                s_tx_reg <= '1';
              ELSE
                s_bit_idx <= s_bit_idx + 1;
                s_tx_reg  <= i_data(s_bit_idx + 1);
              END IF;

            WHEN s_stop =>
              s_state    <= s_idle;
              s_tx_reg   <= '1';
              s_busy_reg <= '0';
          END CASE;
        END IF;
      END IF;
    END IF;
  END PROCESS tx_fsm;

  o_tx   <= s_tx_reg;
  o_busy <= s_busy_reg;

END ARCHITECTURE rtl;
