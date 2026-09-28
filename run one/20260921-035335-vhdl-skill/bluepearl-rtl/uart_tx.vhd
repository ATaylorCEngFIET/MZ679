--------------------------------------------------------------------------------
-- uart_tx : UART transmitter with programmable baud rate.
-- Framing: 8N1 (8 data bits, no parity, 1 stop bit).
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_tx IS
  GENERIC (
    g_clk_hz : POSITIVE := 50_000_000; -- Input clock frequency in Hz
    g_baud   : POSITIVE := 115_200     -- Target baud rate
  );
  PORT (
    i_clk        : IN  std_ulogic;                     -- System clock
    i_rst        : IN  std_ulogic;                     -- Synchronous reset, active high
    i_data       : IN  std_ulogic_vector(7 DOWNTO 0);  -- Data byte to transmit
    i_data_valid : IN  std_ulogic;                     -- Pulse to start transmission
    o_tx         : OUT std_ulogic;                     -- UART TX line
    o_busy       : OUT std_ulogic                      -- High while transmitting
  );
END ENTITY uart_tx;

ARCHITECTURE rtl OF uart_tx IS

  TYPE t_state IS (IDLE, START, DATA, STOP);
  SIGNAL s_state : t_state;

  -- Baud rate calculation
  CONSTANT c_baud_ticks : integer := g_clk_hz / g_baud;

  SIGNAL s_baud_cnt : integer range 0 TO c_baud_ticks;
  SIGNAL s_bit_cnt  : integer range 0 TO 7;
  SIGNAL s_tx_reg   : std_ulogic_vector(7 DOWNTO 0);
  SIGNAL s_busy     : std_ulogic;

BEGIN

  -- Main FSM and Baud Generator
  tx_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_state     <= IDLE;
        s_baud_cnt  <= 0;
        s_bit_cnt   <= 0;
        s_tx_reg    <= (OTHERS => '0');
        s_busy      <= '0';
        o_tx        <= '1';
      ELSE
        CASE s_state IS

          WHEN IDLE =>
            o_tx    <= '1';
            s_busy  <= '0';
            s_baud_cnt <= 0;
            s_bit_cnt  <= 0;
            IF i_data_valid = '1' THEN
              s_tx_reg <= i_data;
              s_busy   <= '1';
              s_state  <= START;
            END IF;

          WHEN START =>
            o_tx <= '0'; -- Start bit
            IF s_baud_cnt >= c_baud_ticks - 1 THEN
              s_baud_cnt <= 0;
              s_state     <= DATA;
            ELSE
              s_baud_cnt <= s_baud_cnt + 1;
            END IF;

          WHEN DATA =>
            o_tx <= s_tx_reg(s_bit_cnt);
            IF s_baud_cnt >= c_baud_ticks - 1 THEN
              s_baud_cnt <= 0;
              IF s_bit_cnt = 7 THEN
                s_bit_cnt <= 0;
                s_state   <= STOP;
              ELSE
                s_bit_cnt <= s_bit_cnt + 1;
              END IF;
            ELSE
              s_baud_cnt <= s_baud_cnt + 1;
            END IF;

          WHEN STOP =>
            o_tx <= '1'; -- Stop bit
            IF s_baud_cnt >= c_baud_ticks - 1 THEN
              s_baud_cnt <= 0;
              s_busy     <= '0';
              s_state    <= IDLE;
            ELSE
              s_baud_cnt <= s_baud_cnt + 1;
            END IF;

          WHEN OTHERS =>
            s_state <= IDLE;

        END CASE;
      END IF;
    END IF;
  END PROCESS tx_proc;

  o_busy <= s_busy;

END ARCHITECTURE rtl;
