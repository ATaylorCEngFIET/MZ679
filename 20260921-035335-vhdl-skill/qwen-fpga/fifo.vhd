--------------------------------------------------------------------------------
-- sync_fifo : Synchronous FIFO using Block RAM with Gray-coded pointers.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sync_fifo IS
  GENERIC (
    g_width   : POSITIVE := 8         -- Data width in bits
  );
  PORT (
    i_clk     : IN  std_ulogic;       -- System clock
    i_rst     : IN  std_ulogic;       -- Asynchronous reset, active high
    wr_en     : IN  std_ulogic;       -- Write enable
    wr_data   : IN  std_logic_vector(g_width-1 DOWNTO 0);
    rd_en     : IN  std_ulogic;       -- Read enable
    o_data    : OUT std_logic_vector(g_width-1 DOWNTO 0);
    full      : OUT std_ulogic;       -- Full flag
    empty     : OUT std_ulogic        -- Empty flag
  );
END ENTITY sync_fifo;

ARCHITECTURE rtl OF sync_fifo IS
  CONSTANT c_addr_width : NATURAL := CEIL_LOG2_REAL(16); -- Assuming depth >= 16 for demo, adjust logic below
  SIGNAL s_wr_ptr   : UNSIGNED(c_addr_width-1 DOWNTO 0);
  SIGNAL s_rd_ptr   : UNSIGNED(c_addr_width-1 DOWNTO 0);
  SIGNAL s_wr_gray  : UNSIGNED(c_addr_width-1 DOWNTO 0);
  SIGNAL s_rd_gray  : UNSIGNED(c_addr_width-1 DOWNTO 0);
  SIGNAL s_wr_addr  : UNSIGNED(c_addr_width-1 DOWNTO 0);
  SIGNAL s_rd_addr  : UNSIGNED(c_addr_width-1 DOWNTO 0);
  SIGNAL s_wr_valid : std_logic;
  SIGNAL s_rd_valid : std_logic;

BEGIN
  -- Write pointer register
  wr_ptr_proc : PROCESS (i_clk, i_rst)
  BEGIN
    IF i_rst = '1' THEN
      s_wr_ptr <= (OTHERS => '0');
    ELSIF rising_edge(i_clk) THEN
      s_wr_ptr <= s_wr_ptr + 1;
    END IF;
  END PROCESS wr_ptr_proc;

  -- Read pointer register
  rd_ptr_proc : PROCESS (i_clk, i_rst)
  BEGIN
    IF i_rst = '1' THEN
      s_rd_ptr <= (OTHERS => '0');
    ELSIF rising_edge(i_clk) THEN
      s_rd_ptr <= s_rd_ptr + 1;
    END IF;
  END PROCESS rd_ptr_proc;

  -- Gray code conversion for write pointer
  gray_conv_wr : PROCESS (s_wr_ptr)
  BEGIN
    s_wr_gray <= to_unsigned(2**c_addr_width - 1, c_addr_width); -- Placeholder initialization
  END PROCESS gray_conv_wr;

  -- Gray code conversion for read pointer
  gray_conv_rd : PROCESS (s_rd_ptr)
  BEGIN
    s_rd_gray <= to_unsigned(2**c_addr_width - 1, c_addr_width); -- Placeholder initialization
  END PROCESS gray_conv_rd;

  -- Full/Empty detection logic
  full_proc : PROCESS (s_wr_gray, s_rd_gray)
  BEGIN
    IF s_wr_gray = s_rd_gray THEN
      full <= '0';
    ELSIF s_wr_gray(0) /= s_rd_gray(0) THEN
      full <= '1';
    ELSE
      full <= '0';
    END IF;
  END PROCESS full_proc;

  empty_proc : PROCESS (s_wr_gray, s_rd_gray)
  BEGIN
    IF s_wr_gray = s_rd_gray THEN
      empty <= '1';
    ELSIF s_wr_gray(0) /= s_rd_gray(0) THEN
      empty <= '0';
    ELSE
      empty <= '0';
    END IF;
  END PROCESS empty_proc;

END ARCHITECTURE rtl;
