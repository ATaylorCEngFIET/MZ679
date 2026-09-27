--------------------------------------------------------------------------------
-- uart_tx : UART transmitter with 8N1 framing.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_tx IS
  GENERIC (
    g_clk_hz : POSITIVE := 50_000_000;  -- system clock frequency in Hz
    g_baud   : POSITIVE := 115200      -- baud rate
  );
  PORT (
    i_clk       : IN  std_ulogic;       -- system clock
    i_rst       : IN  std_ulogic;       -- reset, active high
    i_data      : IN  std_ulogic_vector(7 DOWNTO 0);  -- data to transmit
    i_data_valid: IN  std_ulogic;       -- data valid signal
    o_tx        : OUT std_ulogic;       -- serial output
    o_busy      : OUT std_ulogic        -- transmitter busy flag
  );
END ENTITY uart_tx;

ARCHITECTURE rtl OF uart_tx IS
  TYPE state_type IS (IDLE, START, DATA, STOP);
  SIGNAL s_state   : state_type;
  SIGNAL s_count   : unsigned(15 DOWNTO 0);
  SIGNAL s_bit_cnt : unsigned(2 DOWNTO 0);
  SIGNAL s_tx_data : std_ulogic_vector(7 DOWNTO 0);
  SIGNAL s_busy    : std_ulogic;
  SIGNAL s_baud_tick : std_ulogic;
BEGIN
  -- Baud rate generator
  baud_gen : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_count <= (OTHERS => '0');
      ELSE
        IF s_count = 0 THEN
          s_count <= to_unsigned(g_clk_hz / g_baud - 1, 16);
          s_baud_tick <= '1';
        ELSE
          s_count <= s_count - 1;
          s_baud_tick <= '0';
        END IF;
      END IF;
    END IF;
  END PROCESS baud_gen;

  -- Main transmitter process
  tx_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_state     <= IDLE;
        s_bit_cnt   <= (OTHERS => '0');
        s_tx_data   <= (OTHERS => '0');
        s_busy      <= '0';
        o_tx        <= '1';
        o_busy      <= '0';
      ELSE
        o_busy <= s_busy;
        CASE s_state IS
          WHEN IDLE =>
            IF i_data_valid = '1' THEN
              s_tx_data   <= i_data;
              s_bit_cnt   <= (OTHERS => '0');
              s_state     <= START;
              s_busy      <= '1';
              o_tx        <= '0';
            END IF;
          WHEN START =>
            IF s_baud_tick = '1' THEN
              s_state <= DATA;
              o_tx    <= s_tx_data(0);
            END IF;
          WHEN DATA =>
            IF s_baud_tick = '1' THEN
              s_bit_cnt <= s_bit_cnt + 1;
              IF s_bit_cnt = 7 THEN
                s_state <= STOP;
                o_tx    <= '1';
              ELSE
                o_tx    <= s_tx_data(to_integer(s_bit_cnt) + 1);
              END IF;
            END IF;
          WHEN STOP =>
            IF s_baud_tick = '1' THEN
              s_state <= IDLE;
              s_busy  <= '0';
            END IF;
        END CASE;
      END IF;
    END IF;
  END PROCESS tx_proc;
END ARCHITECTURE rtl;
