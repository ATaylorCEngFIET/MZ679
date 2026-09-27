--------------------------------------------------------------------------------
-- sync_fifo : synchronous fifo with width and depth generics.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY sync_fifo IS
  GENERIC (
    g_width : POSITIVE := 8;   -- data width in bits
    g_depth : POSITIVE := 16   -- fifo depth (must be power of two)
  );
  PORT (
    i_clk     : IN  std_ulogic;                     -- system clock
    i_rst     : IN  std_ulogic;                     -- reset, active high
    i_wr_en   : IN  std_ulogic;                     -- write enable
    i_wr_data : IN  std_ulogic_vector(g_width-1 DOWNTO 0);  -- write data
    i_rd_en   : IN  std_ulogic;                     -- read enable
    o_rd_data : OUT std_ulogic_vector(g_width-1 DOWNTO 0);   -- read data
    o_full    : OUT std_ulogic;                     -- fifo full flag
    o_empty   : OUT std_ulogic                      -- fifo empty flag
  );
END ENTITY sync_fifo;

ARCHITECTURE rtl OF sync_fifo IS
  TYPE t_ram_type IS ARRAY (0 TO g_depth-1) OF
    std_ulogic_vector(g_width-1 DOWNTO 0);
  SIGNAL s_ram : t_ram_type;
  
  CONSTANT c_ptr_width : POSITIVE := LOG2(g_depth);
  
  SIGNAL s_wr_ptr : UNSIGNED(c_ptr_width DOWNTO 0);  -- write pointer with wrap bit
  SIGNAL s_rd_ptr : UNSIGNED(c_ptr_width DOWNTO 0);  -- read pointer with wrap bit
  
  SIGNAL s_full   : std_ulogic;
  SIGNAL s_empty  : std_ulogic;
  
BEGIN
  -- fifo full/empty detection
  o_full  <= s_full;
  o_empty <= s_empty;
  
  -- read data output register
  o_rd_data <= s_ram(TO_INTEGER(s_rd_ptr(c_ptr_width-1 DOWNTO 0)));
  
  -- fifo operation process
  fifo_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_wr_ptr <= (OTHERS => '0');
        s_rd_ptr <= (OTHERS => '0');
        s_full   <= '0';
        s_empty  <= '1';
      ELSE
        -- write operation
        IF i_wr_en = '1' THEN
          s_ram(TO_INTEGER(s_wr_ptr(c_ptr_width-1 DOWNTO 0))) <= i_wr_data;
          s_wr_ptr(c_ptr_width-1 DOWNTO 0) <= s_wr_ptr(c_ptr_width-1 DOWNTO 0) + 1;
          s_wr_ptr(c_ptr_width) <= NOT s_wr_ptr(c_ptr_width);
        END IF;
        
        -- read operation
        IF i_rd_en = '1' THEN
          s_rd_ptr(c_ptr_width-1 DOWNTO 0) <= s_rd_ptr(c_ptr_width-1 DOWNTO 0) + 1;
          s_rd_ptr(c_ptr_width) <= NOT s_rd_ptr(c_ptr_width);
        END IF;
        
        -- update full/empty flags
        s_full  <= (s_wr_ptr(c_ptr_width) XOR s_rd_ptr(c_ptr_width)) AND
                   (s_wr_ptr(c_ptr_width-1 DOWNTO 0) = s_rd_ptr(c_ptr_width-1 DOWNTO 0));
        s_empty <= NOT (s_wr_ptr(c_ptr_width) XOR s_rd_ptr(c_ptr_width)) AND
                   (s_wr_ptr(c_ptr_width-1 DOWNTO 0) = s_rd_ptr(c_ptr_width-1 DOWNTO 0));
      END IF;
    END IF;
  END PROCESS fifo_proc;

END ARCHITECTURE rtl;
