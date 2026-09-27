--------------------------------------------------------------------------------
-- uart_tx : 8N1 UART transmitter, LSB first, one start bit, one stop bit.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_tx IS
  GENERIC (
    g_clk_hz : POSITIVE := 100_000_000;  -- System clock frequency in Hz
    g_baud   : POSITIVE := 115_200      -- UART baud rate
  );
  PORT (
    clk        : IN  std_ulogic;                   -- System clock
    rst        : IN  std_ulogic;                   -- Synchronous active-high reset
    data       : IN  std_ulogic_vector(7 DOWNTO 0);-- Byte to transmit, LSB first
    data_valid : IN  std_ulogic;                   -- Accept data when high and idle
    tx         : OUT std_ulogic;                   -- UART transmit line
    busy       : OUT std_ulogic                    -- Transmitter busy
  );
END ENTITY uart_tx;

ARCHITECTURE rtl OF uart_tx IS
  CONSTANT c_div_max : NATURAL := (g_clk_hz / g_baud) - 1;
  CONSTANT c_div_w   : POSITIVE := 32;

  TYPE state_type IS (
    s_idle,
    s_start,
    s_data,
    s_stop
  );

  SIGNAL s_state     : state_type := s_idle;
  SIGNAL s_baud_cnt  : unsigned(c_div_w - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_bit_cnt   : unsigned(2 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_shift     : std_ulogic_vector(7 DOWNTO 0) := (OTHERS => '1');
  SIGNAL s_tx_int    : std_ulogic := '1';
  SIGNAL s_busy_int  : std_ulogic := '0';
  SIGNAL s_baud_tick : std_ulogic := '0';
BEGIN

  -- Baud-rate tick generator.
  baud_proc : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF rst = '1' THEN
        s_baud_cnt  <= (OTHERS => '0');
        s_baud_tick <= '0';
      ELSIF s_busy_int = '1' THEN
        IF s_baud_cnt = c_div_max THEN
          s_baud_cnt  <= (OTHERS => '0');
          s_baud_tick <= '1';
        ELSE
          s_baud_cnt  <= s_baud_cnt + 1;
          s_baud_tick <= '0';
        END IF;
      ELSE
        s_baud_cnt  <= (OTHERS => '0');
        s_baud_tick <= '0';
      END IF;
    END IF;
  END PROCESS baud_proc;

  -- Transmit state machine.
  fsm_proc : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF rst = '1' THEN
        s_state    <= s_idle;
        s_bit_cnt  <= (OTHERS => '0');
        s_shift    <= (OTHERS => '1');
        s_tx_int   <= '1';
        s_busy_int <= '0';
      ELSE
        CASE s_state IS
          WHEN s_idle =>
            s_tx_int   <= '1';
            s_busy_int <= '0';
            s_bit_cnt  <= (OTHERS => '0');

            IF data_valid = '1' THEN
              s_state    <= s_start;
              s_busy_int <= '1';
            END IF;

          WHEN s_start =>
            s_tx_int <= '0';

            IF s_baud_tick = '1' THEN
              s_state <= s_data;
            END IF;

          WHEN s_data =>
            s_tx_int <= s_shift(0);

            IF s_baud_tick = '1' THEN
              s_shift   <= '1' & s_shift(7 DOWNTO 1);
              s_bit_cnt <= s_bit_cnt + 1;

              IF s_bit_cnt = 7 THEN
                s_state <= s_stop;
              END IF;
            END IF;

          WHEN s_stop =>
            s_tx_int <= '1';

            IF s_baud_tick = '1' THEN
              s_state <= s_idle;
            END IF;

          WHEN OTHERS =>
            s_state <= s_idle;
        END CASE;
      END IF;
    END IF;
  END PROCESS fsm_proc;

  tx   <= s_tx_int;
  busy <= s_busy_int;

END ARCHITECTURE rtl;
