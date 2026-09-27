--------------------------------------------------------------------------------
-- uart_tx : 8-bit UART transmitter with configurable baud rate.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_tx IS
  GENERIC (
    g_clk_hz : NATURAL := 50000000   -- System clock frequency in Hz
  );
  PORT (
    clk       : IN  std_logic;        -- System clock
    rst       : IN  std_logic;        -- Synchronous reset, active high
    data      : IN  std_logic_vector(7 DOWNTO 0); -- Data to transmit
    data_valid : IN  std_logic;       -- Valid flag for new data
    tx        : OUT std_logic;        -- Transmit line output
    busy      : OUT std_logic         -- Transmitter busy indicator
  );
END ENTITY uart_tx;

ARCHITECTURE rtl OF uart_tx IS
  CONSTANT c_divisor_max : NATURAL := g_clk_hz / 9600 - 1;
  TYPE state_type IS (IDLE, START, DATA_0, DATA_1, DATA_2, DATA_3, DATA_4, DATA_5, DATA_6, DATA_7, STOP);
  SIGNAL s_state : state_type := IDLE;
  SIGNAL s_count : NATURAL RANGE 0 TO c_divisor_max := 0;
  SIGNAL s_data_reg : std_logic_vector(7 DOWNTO 0) := (OTHERS => 'Z');
  SIGNAL s_busy_int : std_logic := '0';
BEGIN
  -- Baud rate counter: generates ticks for TX shift register.
  baud_counter_proc : PROCESS (clk, rst)
  BEGIN
    IF rising_edge(clk) THEN
      IF rst = '1' THEN
        s_count <= 0;
      ELSIF s_state /= IDLE THEN
        -- Count down during transmission phases
        IF s_count > 0 THEN
          s_count <= s_count - 1;
        ELSE
          s_count <= c_divisor_max;
        END IF;
      END IF;
    END IF;
  END PROCESS baud_counter_proc;

  -- State machine: controls TX line and data loading.
  tx_fsm_proc : PROCESS (clk, rst)
  BEGIN
    IF rising_edge(clk) THEN
      IF rst = '1' THEN
        s_state <= IDLE;
        s_data_reg <= (OTHERS => 'Z');
        s_busy_int <= '0';
      ELSIF s_state = IDLE THEN
        -- Load new data if valid and not busy
        IF data_valid = '1' AND s_busy_int = '0' THEN
          s_data_reg <= data;
          s_state <= START;
          s_busy_int <= '1';
        END IF;
      ELSIF s_state = START THEN
        -- Send start bit (logic 0)
        s_state <= DATA_0;
      ELSIF s_state = DATA_0 THEN
        s_state <= DATA_1;
      ELSIF s_state = DATA_1 THEN
        s_state <= DATA_2;
      ELSIF s_state = DATA_2 THEN
        s_state <= DATA_3;
      ELSIF s_state = DATA_3 THEN
        s_state <= DATA_4;
      ELSIF s_state = DATA_4 THEN
        s_state <= DATA_5;
      ELSIF s_state = DATA_5 THEN
        s_state <= DATA_6;
      ELSIF s_state = DATA_6 THEN
        s_state <= DATA_7;
      ELSIF s_state = DATA_7 THEN
        s_state <= STOP;
      ELSIF s_state = STOP THEN
        -- Return to idle after stop bit
        s_state <= IDLE;
        s_busy_int <= '0';
      END IF;
    END IF;
  END PROCESS tx_fsm_proc;

  -- TX output: driven by state machine, high impedance when idle.
  tx <= '0' WHEN s_state = START OR s_state = DATA_0 OR s_state = DATA_1 OR
        s_state = DATA_2 OR s_state = DATA_3 OR s_state = DATA_4 OR s_state = DATA_5 OR
        s_state = DATA_6 OR s_state = DATA_7 ELSE '1';

  -- Busy output: high during transmission sequence.
  busy <= s_busy_int;

END ARCHITECTURE rtl;
