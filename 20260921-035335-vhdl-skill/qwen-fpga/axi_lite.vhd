LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY axil_regs IS
  PORT (
    i_clk   : IN  std_ulogic;
    i_rst   : IN  std_ulogic;
    
    -- Address Write channel
    aw_valid : IN  std_ulogic;
    aw_ready : OUT std_ulogic;
    aw_addr  : IN  std_logic_vector(31 DOWNTO 0);
    
    -- Data Write channel
    w_valid  : IN  std_ulogic;
    w_ready  : OUT std_ulogic;
    w_data   : IN  std_logic_vector(31 DOWNTO 0);
    w_strb   : IN  std_logic_vector(3 DOWNTO 0);
    
    -- Response Write channel
    b_valid  : OUT std_ulogic;
    b_ready  : IN  std_ulogic;
    b_resp   : OUT std_logic_vector(1 DOWNTO 0);
    
    -- Address Read channel
    ar_valid : IN  std_ulogic;
    ar_ready : OUT std_ulogic;
    ar_addr  : IN  std_logic_vector(31 DOWNTO 0);
    
    -- Data Read channel
    r_valid  : OUT std_ulogic;
    r_ready  : IN  std_ulogic;
    r_data   : OUT std_logic_vector(31 DOWNTO 0);
    r_resp   : OUT std_logic_vector(1 DOWNTO 0)
  );
END ENTITY axil_regs;

ARCHITECTURE rtl OF axil_regs IS
  -- Internal signals for handshake completion
  SIGNAL s_aw_ready : std_ulogic := '0';
  SIGNAL s_w_ready  : std_ulogic := '0';
  SIGNAL s_b_valid  : std_ulogic := '0';
  SIGNAL s_ar_ready : std_ulogic := '0';
  SIGNAL s_r_valid  : std_ulogic := '0';
  
  -- Write address and data registers
  SIGNAL s_w_addr   : unsigned(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_w_data   : unsigned(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_w_strb   : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
  
  -- Read address register
  SIGNAL s_ar_addr  : unsigned(31 DOWNTO 0) := (OTHERS => '0');
  
BEGIN
  -- Write address register: captures on valid/ready handshake.
  aw_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_w_addr <= (OTHERS => '0');
      ELSIF aw_valid = '1' AND aw_ready = '1' THEN
        s_w_addr <= to_unsigned(to_integer(unsigned(aw_addr)), 32);
      END IF;
    END IF;
  END PROCESS aw_proc;

  -- Write data register: captures on valid/ready handshake.
  w_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_w_data <= (OTHERS => '0');
        s_w_strb <= (OTHERS => '0');
      ELSIF w_valid = '1' AND w_ready = '1' THEN
        s_w_data <= to_unsigned(to_integer(unsigned(w_data)), 32);
        s_w_strb <= w_strb;
      END IF;
    END IF;
  END PROCESS w_proc;

  -- Read address register: captures on valid/ready handshake.
  ar_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_ar_addr <= (OTHERS => '0');
      ELSIF ar_valid = '1' AND ar_ready = '1' THEN
        s_ar_addr <= to_unsigned(to_integer(unsigned(ar_addr)), 32);
      END IF;
    END IF;
  END PROCESS ar_proc;

  -- Read data output: multiplexes register file based on read address.
  r_data_proc : PROCESS (s_ar_addr)
  BEGIN
    CASE to_integer(s_ar_addr) IS
      WHEN 0 => r_data <= std_logic_vector(s_w_data);
      WHEN 4 => r_data <= std_logic_vector(s_w_data);
      WHEN 8 => r_data <= std_logic_vector(s_w_data);
      WHEN 12=> r_data <= std_logic_vector(s_w_data);
      WHEN OTHERS => r_data <= (OTHERS => '0'); -- Unimplemented address
    END CASE;
  END PROCESS r_data_proc;

  -- Write response output: always OKAY for implemented addresses.
  b_resp_proc : PROCESS (s_w_addr)
  BEGIN
    CASE to_integer(s_w_addr) IS
      WHEN 0 => b_resp <= "00";
      WHEN 4 => b_resp <= "00";
      WHEN 8 => b_resp <= "00";
      WHEN 12=> b_resp <= "00";
      WHEN OTHERS => b_resp <= "11"; -- DECERR for unimplemented
    END CASE;
  END PROCESS b_resp_proc;

  -- Read data output port assignment.
  r_data <= std_logic_vector(s_ar_addr(3 DOWNTO 0) = 0 ? s_w_data :
                           s_ar_addr(3 DOWNTO 0) = 1 ? s_w_data :
                           s_ar_addr(3 DOWNTO 0) = 2 ? s_w_data :
                           s_ar_addr(3 DOWNTO 0) = 3 ? s_w_data : (OTHERS => '0'));

  -- Write response port assignment.
  b_resp <= "00" WHEN to_integer(s_w_addr) IN (0, 4, 8, 12) ELSE "11";

  -- Read valid output: asserted on rising clock if read address is valid and ready.
  r_valid_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_r_valid <= '0';
      ELSIF ar_valid = '1' AND ar_ready = '1' THEN
        s_r_valid <= '1';
      END IF;
    END IF;
  END PROCESS r_valid_proc;

  -- Write response valid output: asserted on rising clock if write address is valid and ready.
  b_valid_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_b_valid <= '0';
      ELSIF w_valid = '1' AND w_ready = '1' THEN
        s_b_valid <= '1';
      END IF;
    END IF;
  END PROCESS b_valid_proc;

  -- Write ready output: asserted if write address is valid and data is ready.
  w_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_w_ready <= '0';
      ELSIF aw_valid = '1' AND aw_ready = '1' THEN
        s_w_ready <= '1';
      END IF;
    END IF;
  END PROCESS w_ready_proc;

  -- Address Write ready output: asserted if write address is valid and data is ready.
  aw_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_aw_ready <= '0';
      ELSIF w_valid = '1' AND w_ready = '1' THEN
        s_aw_ready <= '1';
      END IF;
    END IF;
  END PROCESS aw_ready_proc;

  -- Address Read ready output: asserted if read address is valid and data is ready.
  ar_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_ar_ready <= '0';
      ELSIF r_valid = '1' AND r_ready = '1' THEN
        s_ar_ready <= '1';
      END IF;
    END IF;
  END PROCESS ar_ready_proc;

END ARCHITECTURE rtl;
