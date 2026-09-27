--------------------------------------------------------------------------------
-- sync_fifo : Synchronous FIFO with power-of-two depth.
-- Uses binary pointers with an extra bit for full/empty detection.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY sync_fifo IS
  GENERIC (
    g_width : POSITIVE := 8;                -- Data width in bits
    g_depth : POSITIVE := 16                 -- FIFO depth (must be power of 2)
  );
  PORT (
    i_clk     : IN  std_ulogic;             -- System clock
    i_rst     : IN  std_ulogic;             -- Synchronous reset, active high
    i_wr_en   : IN  std_ulogic;             -- Write enable
    i_wr_data : IN  std_ulogic_vector(g_width-1 DOWNTO 0); -- Write data
    i_rd_en   : IN  std_ulogic;             -- Read enable
    o_rd_data : OUT std_ulogic_vector(g_width-1 DOWNTO 0); -- Read data
    o_full    : OUT std_ulogic;             -- FIFO full flag
    o_empty   : OUT std_ulogic              -- FIFO empty flag
  );
END ENTITY sync_fifo;

ARCHITECTURE rtl OF sync_fifo IS

  -- Constants and types
  -- Calculate log2 using math_real. ceil(log2(real(g_depth)))
  CONSTANT c_addr_width : INTEGER := INTEGER(CEIL(LOG2(REAL(g_depth))));
  TYPE t_mem_type IS ARRAY (0 TO g_depth-1) OF std_ulogic_vector(g_width-1 DOWNTO 0);

  -- Signals
  SIGNAL s_mem       : t_mem_type := (OTHERS => (OTHERS => '0'));
  SIGNAL s_wr_ptr    : unsigned(c_addr_width DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_rd_ptr    : unsigned(c_addr_width DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_full      : std_ulogic := '0';
  SIGNAL s_empty     : std_ulogic := '1';
  SIGNAL s_depth_u   : unsigned(c_addr_width DOWNTO 0) := to_unsigned(g_depth, c_addr_width + 1);

BEGIN

  -- Write Logic
  -- Increments write pointer and writes to memory if not full.
  write_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_wr_ptr <= (OTHERS => '0');
      ELSIF i_wr_en = '1' AND s_full = '0' THEN
        s_mem(to_integer(s_wr_ptr(c_addr_width-1 DOWNTO 0))) <= i_wr_data;
        s_wr_ptr <= s_wr_ptr + 1;
      END IF;
    END IF;
  END PROCESS write_proc;

  -- Read Logic
  -- Increments read pointer and updates empty flag if not empty.
  read_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_rd_ptr <= (OTHERS => '0');
      ELSIF i_rd_en = '1' AND s_empty = '0' THEN
        s_rd_ptr <= s_rd_ptr + 1;
      END IF;
    END IF;
  END PROCESS read_proc;

  -- Status Logic (Combinational)
  -- Full: MSB differs, remaining bits match.
  -- Empty: All bits match.
  full_empty_logic : PROCESS (s_wr_ptr, s_rd_ptr, s_depth_u)
  BEGIN
    IF s_wr_ptr = s_rd_ptr THEN
      s_empty <= '1';
      s_full  <= '0';
    ELSIF s_wr_ptr = s_rd_ptr + s_depth_u THEN
      s_empty <= '0';
      s_full   <= '1';
    ELSE
      s_empty <= '0';
      s_full   <= '0';
    END IF;
  END PROCESS full_empty_logic;

  -- Output assignments
  o_rd_data <= s_mem(to_integer(s_rd_ptr(c_addr_width-1 DOWNTO 0)));
  o_full    <= s_full;
  o_empty   <= s_empty;

END ARCHITECTURE rtl;
