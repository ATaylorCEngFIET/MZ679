--------------------------------------------------------------------------------
-- sync_fifo : Synchronous FIFO with inferred block RAM.
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
    i_wr_data : IN  std_ulogic_vector(g_width-1 DOWNTO 0);
    i_rd_en   : IN  std_ulogic;
    o_rd_data : OUT std_ulogic_vector(g_width-1 DOWNTO 0);
    o_full    : OUT std_ulogic;
    o_empty   : OUT std_ulogic
  );
END ENTITY sync_fifo;

ARCHITECTURE rtl OF sync_fifo IS
  CONSTANT c_addr_width : POSITIVE := 1 + (g_depth-1)'LENGTH;
  CONSTANT c_addr_mask  : POSITIVE := g_depth - 1;

  TYPE t_ram_type IS ARRAY (0 TO g_depth-1) OF std_ulogic_vector(g_width-1 DOWNTO 0);

  SIGNAL s_wr_ptr : unsigned(c_addr_width-1 DOWNTO 0);
  SIGNAL s_rd_ptr : unsigned(c_addr_width-1 DOWNTO 0);
  SIGNAL s_ram    : t_ram_type;
BEGIN
  -- Write pointer register: increments on write when not full.
  wr_ptr_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_wr_ptr <= (OTHERS => '0');
      ELSIF i_wr_en = '1' AND o_full = '0' THEN
        s_wr_ptr <= s_wr_ptr + 1;
      END IF;
    END IF;
  END PROCESS wr_ptr_proc;

  -- Read pointer register: increments on read when not empty.
  rd_ptr_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_rd_ptr <= (OTHERS => '0');
      ELSIF i_rd_en = '1' AND o_empty = '0' THEN
        s_rd_ptr <= s_rd_ptr + 1;
      END IF;
    END IF;
  END PROCESS rd_ptr_proc;

  -- Inferred block RAM: write on wr_en, read on rd_en.
  ram_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_wr_en = '1' AND o_full = '0' THEN
        s_ram(to_integer(s_wr_ptr(c_addr_width-2 DOWNTO 0))) <= i_wr_data;
      END IF;
    END IF;
  END PROCESS ram_proc;

  o_rd_data <= s_ram(to_integer(s_rd_ptr(c_addr_width-2 DOWNTO 0)));

  -- Full: pointers differ only in the MSB (wrap bit).
  o_full <= '1' WHEN s_wr_ptr(c_addr_width-1) /= s_rd_ptr(c_addr_width-1)
            AND s_wr_ptr(c_addr_width-2 DOWNTO 0) = s_rd_ptr(c_addr_width-2 DOWNTO 0)
            ELSE '0';

  -- Empty: pointers are identical.
  o_empty <= '1' WHEN s_wr_ptr = s_rd_ptr ELSE '0';

END ARCHITECTURE rtl;
