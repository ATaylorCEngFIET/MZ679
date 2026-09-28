--------------------------------------------------------------------------------
-- sync_fifo : Synchronous FIFO with inferred single-clock block RAM.
--             Uses binary read/write pointers with one extra wrap bit.
--             DEPTH must be a power of two.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sync_fifo IS
  GENERIC (
    g_width : POSITIVE := 8;
    g_depth : POSITIVE := 16
  );
  PORT (
    i_clk     : IN  std_ulogic;
    i_rst     : IN  std_ulogic;
    i_wr_en   : IN  std_ulogic;
    i_wr_data : IN  std_ulogic_vector(g_width - 1 DOWNTO 0);
    i_rd_en   : IN  std_ulogic;
    o_rd_data : OUT std_ulogic_vector(g_width - 1 DOWNTO 0);
    o_full    : OUT std_ulogic;
    o_empty   : OUT std_ulogic
  );
END ENTITY sync_fifo;

ARCHITECTURE rtl OF sync_fifo IS

  FUNCTION log2_int(value : POSITIVE) RETURN NATURAL IS
    VARIABLE v_log : NATURAL := 0;
    VARIABLE v_val : NATURAL := value - 1;
  BEGIN
    WHILE v_val > 0 LOOP
      v_log := v_log + 1;
      v_val := v_val / 2;
    END LOOP;
    RETURN v_log;
  END FUNCTION log2_int;

  CONSTANT c_addr_bits : NATURAL := log2_int(g_depth);
  CONSTANT c_ptr_bits  : NATURAL := c_addr_bits + 1;

  TYPE t_mem_type IS ARRAY (0 TO g_depth - 1) OF std_ulogic_vector(g_width - 1 DOWNTO 0);

  SIGNAL s_mem      : t_mem_type := (OTHERS => (OTHERS => '0'));
  SIGNAL s_wr_ptr   : unsigned(c_ptr_bits - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_rd_ptr   : unsigned(c_ptr_bits - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_wr_addr  : unsigned(c_addr_bits - 1 DOWNTO 0);
  SIGNAL s_rd_addr  : unsigned(c_addr_bits - 1 DOWNTO 0);
  SIGNAL s_full     : std_ulogic := '0';
  SIGNAL s_empty    : std_ulogic := '1';
  SIGNAL s_wr_valid : std_ulogic := '0';
  SIGNAL s_rd_valid : std_ulogic := '0';

BEGIN

  s_wr_addr  <= s_wr_ptr(c_addr_bits - 1 DOWNTO 0);
  s_rd_addr  <= s_rd_ptr(c_addr_bits - 1 DOWNTO 0);
  s_wr_valid <= i_wr_en AND NOT s_full;
  s_rd_valid <= i_rd_en AND NOT s_empty;

  -- Write pointer register.
  wr_ptr_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_wr_ptr <= (OTHERS => '0');
      ELSIF s_wr_valid = '1' THEN
        s_wr_ptr <= s_wr_ptr + 1;
      END IF;
    END IF;
  END PROCESS wr_ptr_proc;

  -- Read pointer register.
  rd_ptr_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_rd_ptr <= (OTHERS => '0');
      ELSIF s_rd_valid = '1' THEN
        s_rd_ptr <= s_rd_ptr + 1;
      END IF;
    END IF;
  END PROCESS rd_ptr_proc;

  -- Inferred single-clock block RAM.
  mem_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF s_wr_valid = '1' THEN
        s_mem(to_integer(s_wr_addr)) <= i_wr_data;
      END IF;
    END IF;
  END PROCESS mem_proc;

  -- Registered read data output.
  rd_data_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        o_rd_data <= (OTHERS => '0');
      ELSIF s_rd_valid = '1' THEN
        o_rd_data <= s_mem(to_integer(s_rd_addr));
      END IF;
    END IF;
  END PROCESS rd_data_proc;

  -- Full and empty flags.
  flags_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_full  <= '0';
        s_empty <= '1';
      ELSE
        s_empty <= (s_wr_ptr = s_rd_ptr);
        s_full  <= (s_wr_ptr(c_ptr_bits - 1) /= s_rd_ptr(c_ptr_bits - 1))
                   AND (s_wr_ptr(c_addr_bits - 1 DOWNTO 0) = s_rd_ptr(c_addr_bits - 1 DOWNTO 0));
      END IF;
    END IF;
  END PROCESS flags_proc;

  o_full  <= s_full;
  o_empty <= s_empty;

END ARCHITECTURE rtl;
