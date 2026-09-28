--------------------------------------------------------------------------------
-- axil_regs : Minimal AXI4-Lite slave with four 32-bit registers.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY axil_regs IS
  PORT (
    i_clk      : IN  std_ulogic;                     -- system clock
    i_rst      : IN  std_ulogic;                     -- reset, active high
    -- Write Address Channel
    i_awvalid  : IN  std_ulogic;                     -- write address valid
    o_awready  : OUT std_ulogic;                     -- write address ready
    i_awaddr   : IN  std_ulogic_vector(31 DOWNTO 0); -- write address
    -- Write Data Channel
    i_wvalid   : IN  std_ulogic;                     -- write data valid
    o_wready   : OUT std_ulogic;                     -- write data ready
    i_wdata    : IN  std_ulogic_vector(31 DOWNTO 0); -- write data
    i_wstrb    : IN  std_ulogic_vector(3 DOWNTO 0);  -- write strobes
    -- Write Response Channel
    o_bvalid   : OUT std_ulogic;                     -- write response valid
    i_bready   : IN  std_ulogic;                     -- write response ready
    o_bresp    : OUT std_ulogic_vector(1 DOWNTO 0); -- write response
    -- Read Address Channel
    i_arvalid  : IN  std_ulogic;                     -- read address valid
    o_arready  : OUT std_ulogic;                     -- read address ready
    i_araddr   : IN  std_ulogic_vector(31 DOWNTO 0); -- read address
    -- Read Data Channel
    o_rvalid   : OUT std_ulogic;                     -- read data valid
    i_rready   : IN  std_ulogic;                     -- read data ready
    o_rdata    : OUT std_ulogic_vector(31 DOWNTO 0); -- read data
    o_rresp    : OUT std_ulogic_vector(1 DOWNTO 0); -- read response
    -- User Registers
    o_reg0     : OUT std_ulogic_vector(31 DOWNTO 0); -- register 0 (offset 0x0)
    o_reg1     : OUT std_ulogic_vector(31 DOWNTO 0); -- register 1 (offset 0x4)
    o_reg2     : OUT std_ulogic_vector(31 DOWNTO 0); -- register 2 (offset 0x8)
    o_reg3     : OUT std_ulogic_vector(31 DOWNTO 0)  -- register 3 (offset 0xC)
  );
END ENTITY axil_regs;

ARCHITECTURE rtl OF axil_regs IS

  TYPE t_reg_array IS ARRAY(0 TO 3) OF unsigned(31 DOWNTO 0);
  SIGNAL s_regs      : t_reg_array := (others => (others => '0'));
  
  SIGNAL s_aw_addr   : unsigned(31 DOWNTO 0);
  SIGNAL s_aw_done   : std_ulogic;
  SIGNAL s_w_done    : std_ulogic;
  SIGNAL s_ar_addr   : unsigned(31 DOWNTO 0);
  SIGNAL s_ar_done   : std_ulogic;
  
  SIGNAL s_awready   : std_ulogic;
  SIGNAL s_wready    : std_ulogic;
  SIGNAL s_bvalid    : std_ulogic;
  SIGNAL s_arready   : std_ulogic;
  SIGNAL s_rvalid    : std_ulogic;

  -- Helper to avoid slice mismatch with unresolved types
  FUNCTION to_unsigned_vec(val : unsigned; width : integer) RETURN std_ulogic_vector IS
  BEGIN
    return std_logic_vector(val);
  END FUNCTION to_unsigned_vec;

BEGIN

  -- Write Address Handshake
  aw_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_awready <= '0';
        s_aw_done <= '0';
        s_aw_addr <= (others => '0');
      ELSIF i_awvalid = '1' AND s_awready = '0' THEN
        s_awready <= '1';
        s_aw_addr  <= unsigned(i_awaddr);
        s_aw_done  <= '1';
      ELSIF i_awvalid = '0' OR s_awready = '1' THEN
        s_awready <= '0';
        s_aw_done <= '0';
      END IF;
    END IF;
  END PROCESS aw_ready_proc;

  -- Write Data Handshake
  w_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_wready <= '0';
        s_w_done  <= '0';
      ELSIF i_wvalid = '1' AND s_wready = '0' THEN
        s_wready <= '1';
        s_w_done  <= '1';
      ELSIF i_wvalid = '0' OR s_wready = '1' THEN
        s_wready <= '0';
        s_w_done  <= '0';
      END IF;
    END IF;
  END PROCESS w_ready_proc;

  -- Write Logic (Register Update)
  write_logic_proc : PROCESS (i_clk)
    VARIABLE v_reg_idx : integer;
    VARIABLE v_data    : unsigned(31 DOWNTO 0);
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_regs <= (others => (others => '0'));
      ELSIF s_aw_done = '1' AND s_w_done = '1' THEN
        v_reg_idx := to_integer(s_aw_addr(3 downto 2));
        v_data    := unsigned(i_wdata);
        
        IF v_reg_idx <= 3 THEN
          IF i_wstrb(0) = '1' THEN s_regs(v_reg_idx)(7 downto 0)   <= v_data(7 downto 0);   END IF;
          IF i_wstrb(1) = '1' THEN s_regs(v_reg_idx)(15 downto 8)  <= v_data(15 downto 8);  END IF;
          IF i_wstrb(2) = '1' THEN s_regs(v_reg_idx)(23 downto 16) <= v_data(23 downto 16); END IF;
          IF i_wstrb(3) = '1' THEN s_regs(v_reg_idx)(31 downto 24) <= v_data(31 downto 24); END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS write_logic_proc;

  -- Write Response Channel
  b_resp_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_bvalid <= '0';
        o_bresp  <= "00";
      ELSIF (s_aw_done = '1' AND s_w_done = '1') AND s_bvalid = '0' THEN
        s_bvalid <= '1';
        IF s_aw_addr(31 downto 2) <= 3 THEN
          o_bresp <= "00"; -- OKAY
        ELSE
          o_bresp <= "11"; -- DECERR
        END IF;
      ELSIF s_bvalid = '1' AND i_bready = '1' THEN
        s_bvalid <= '0';
      END IF;
    END IF;
  END PROCESS b_resp_proc;

  -- Read Address Handshake
  ar_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_arready <= '0';
        s_ar_done <= '0';
        s_ar_addr <= (others => '0');
      ELSIF i_arvalid = '1' AND s_arready = '0' THEN
        s_arready <= '1';
        s_ar_addr <= unsigned(i_araddr);
        s_ar_done <= '1';
      ELSIF i_arvalid = '0' OR s_arready = '1' THEN
        s_arready <= '0';
        s_ar_done <= '0';
      END IF;
    END IF;
  END PROCESS ar_ready_proc;

  -- Read Data Channel
  r_data_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_rvalid <= '0';
        o_rdata  <= (others => '0');
        o_rresp  <= "00";
      ELSIF s_ar_done = '1' AND s_rvalid = '0' THEN
        s_rvalid <= '1';
        IF s_ar_addr(31 downto 2) <= 3 THEN
          o_rdata <= std_logic_vector(s_regs(to_integer(s_ar_addr(3 downto 2))));
          o_rresp <= "00"; -- OKAY
        ELSE
          o_rdata <= (others => '0');
          o_rresp <= "11"; -- DECERR
        END IF;
      ELSIF s_rvalid = '1' AND i_rready = '1' THEN
        s_rvalid <= '0';
      END IF;
    END IF;
  END PROCESS r_data_proc;

  -- Output assignments
  o_awready <= s_awready;
  o_wready  <= s_wready;
  o_bvalid  <= s_bvalid;
  o_arready <= s_arready;
  o_rvalid  <= s_rvalid;
  o_reg0    <= std_logic_vector(s_regs(0));
  o_reg1    <= std_logic_vector(s_regs(1));
  o_reg2    <= std_logic_vector(s_regs(2));
  o_reg3    <= std_logic_vector(s_regs(3));

END ARCHITECTURE rtl;
