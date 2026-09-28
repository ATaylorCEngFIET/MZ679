LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_tx IS
  GENERIC (
    g_clk_hz   : INTEGER := 50000000     -- system clock frequency in Hz
  );
  PORT (
    i_clk      : IN  std_ulogic          -- system clock
    i_rst      : IN  std_ulogic          -- reset, active high
    i_data     : IN  std_logic_vector(7 DOWNTO 0)   -- data to transmit
    i_data_valid : IN  std_ulogic         -- data valid flag
    o_tx       : OUT std_ulogic           -- tx output
    o_busy     : OUT std_ulogic           -- busy flag
  );
END ENTITY uart_tx;

ARCHITECTURE rtl OF uart_tx IS
  CONSTANT c_clk_hz   : INTEGER := g_clk_hz;
  CONSTANT c_baud     : INTEGER := 9600;
  TYPE state_type IS (IDLE, START, DATA, STOP);
  SIGNAL s_state      : state_type;
  SIGNAL s_tx_data    : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_busy       : std_ulogic;
BEGIN
  
  uart_tx_fsm : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_state <= IDLE;
        s_busy  <= '0';
        s_tx_data <= (OTHERS => '0');
      ELSIF i_data_valid = '1' AND s_state = IDLE THEN
        s_state <= START;
        s_busy  <= '1';
        s_tx_data <= i_data;
      END IF;
      
      CASE s_state IS
        WHEN IDLE =>
          o_tx <= '1';
        WHEN START =>
          o_tx <= s_tx_data(7);
          s_tx_data <= s_tx_data(6 DOWNTO 0) & '0';
        WHEN DATA =>
          IF s_tx_data(0) = '1' THEN
            s_state <= STOP;
          ELSE
            s_tx_data <= s_tx_data(6 DOWNTO 0) & '0';
          END IF;
          o_tx <= s_tx_data(7);
        WHEN STOP =>
          o_tx <= '1';
      END CASE;
    END IF;
    
    o_busy <= s_state /= IDLE;
  END PROCESS uart_tx_fsm;
END ARCHITECTURE rtl;
