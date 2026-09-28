--------------------------------------------------------------------------------
-- axil_regs : Minimal AXI4-Lite slave with four 32-bit read/write registers.
-- Registers are exposed as outputs reg0..reg3.
-- Byte offsets: 0x0, 0x4, 0x8, 0xC.
-- Synchronous active-high reset.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY axil_regs IS
  GENERIC (
    g_addr_width : POSITIVE := 4;  -- address width for 4 registers (0x0..0xC)
    g_data_width : POSITIVE := 32  -- data width
  );
  PORT (
    i_clk     : IN  std_ulogic;
    i_rst     : IN  std_ulogic;

    -- Write address channel
    i_awaddr  : IN  std_ulogic_vector(g_addr_width-1 DOWNTO 0);
    i_awvalid : IN  std_ulogic;
    o_awready : OUT std_ulogic;

    -- Write data channel
    i_wdata   : IN  std_ulogic_vector(g_data_width-1 DOWNTO 0);
    i_wstrb   : IN  std_ulogic_vector(g_data_width/8-1 DOWNTO 0);
    i_wvalid  : IN  std_ulogic;
    o_wready  : OUT std_ulogic;

    -- Write response channel
    o_bresp   : OUT std_ulogic_vector(1 DOWNTO 0);
    o_bvalid  : OUT std_ulogic;
    i_bready  : IN  std_ulogic;

    -- Read address channel
    i_araddr  : IN  std_ulogic_vector(g_addr_width-1 DOWNTO 0);
    i_arvalid : IN  std_ulogic;
    o_arready : OUT std_ulogic;

    -- Read data channel
    o_rdata   : OUT std_ulogic_vector(g_data_width-1 DOWNTO 0);
    o_rresp   : OUT std_ulogic_vector(1 DOWNTO 0);
    o_rvalid  : OUT std_ulogic;
    i_rready  : IN  std_ulogic;

    -- Register outputs
    o_reg0    : OUT std_ulogic_vector(g_data_width-1 DOWNTO 0);
    o_reg1    : OUT std_ulogic_vector(g_data_width-1 DOWNTO 0);
    o_reg2    : OUT std_ulogic_vector(g_data_width-1 DOWNTO 0);
    o_reg3    : OUT std_ulogic_vector(g_data_width-1 DOWNTO 0)
  );
END ENTITY axil_regs;

ARCHITECTURE rtl OF axil_regs IS

  TYPE reg_array_type IS ARRAY (0 TO 3) OF std_ulogic_vector(g_data_width-1 DOWNTO 0);

  SIGNAL s_reg      : reg_array_type := (OTHERS => (OTHERS => '0'));
  SIGNAL s_aw_addr  : std_ulogic_vector(g_addr_width-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_w_data   : std_ulogic_vector(g_data_width-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_w_strb   : std_ulogic_vector(g_data_width/8-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_ar_addr  : std_ulogic_vector(g_addr_width-1 DOWNTO 0) := (OTHERS => '0');

  SIGNAL s_aw_ready : std_ulogic := '0';
  SIGNAL s_w_ready  : std_ulogic := '0';
  SIGNAL s_ar_ready : std_ulogic := '0';
  SIGNAL s_b_valid  : std_ulogic := '0';
  SIGNAL s_r_valid  : std_ulogic := '0';

  SIGNAL s_aw_fire  : std_ulogic := '0';
  SIGNAL s_w_fire   : std_ulogic := '0';
  SIGNAL s_ar_fire  : std_ulogic := '0';

  SIGNAL s_write_done : std_ulogic := '0';

  CONSTANT c_resp_okay : std_ulogic_vector(1 DOWNTO 0) := "00";

BEGIN

  -- AW channel handshake
  s_aw_fire <= i_awvalid AND s_aw_ready;

  aw_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_aw_ready <= '0';
      ELSE
        IF s_aw_fire = '1' THEN
          s_aw_ready <= '0';
        ELSIF s_b_valid = '1' AND i_bready = '1' THEN
          s_aw_ready <= '1';
        ELSIF s_aw_ready = '0' AND s_b_valid = '0' THEN
          s_aw_ready <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS aw_ready_proc;

  -- W channel handshake
  s_w_fire <= i_wvalid AND s_w_ready;

  w_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_w_ready <= '0';
      ELSE
        IF s_w_fire = '1' THEN
          s_w_ready <= '0';
        ELSIF s_b_valid = '1' AND i_bready = '1' THEN
          s_w_ready <= '1';
        ELSIF s_w_ready = '0' AND s_b_valid = '0' THEN
          s_w_ready <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS w_ready_proc;

  -- AR channel handshake
  s_ar_fire <= i_arvalid AND s_ar_ready;

  ar_ready_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_ar_ready <= '0';
      ELSE
        IF s_ar_fire = '1' THEN
          s_ar_ready <= '0';
        ELSIF s_r_valid = '1' AND i_rready = '1' THEN
          s_ar_ready <= '1';
        ELSIF s_ar_ready = '0' AND s_r_valid = '0' THEN
          s_ar_ready <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS ar_ready_proc;

  -- Capture write address
  aw_addr_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_aw_addr <= (OTHERS => '0');
      ELSIF s_aw_fire = '1' THEN
        s_aw_addr <= i_awaddr;
      END IF;
    END IF;
  END PROCESS aw_addr_proc;

  -- Capture write data and strobe
  w_data_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_w_data <= (OTHERS => '0');
        s_w_strb <= (OTHERS => '0');
      ELSIF s_w_fire = '1' THEN
        s_w_data <= i_wdata;
        s_w_strb <= i_wstrb;
      END IF;
    END IF;
  END PROCESS w_data_proc;

  -- Capture read address
  ar_addr_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_ar_addr <= (OTHERS => '0');
      ELSIF s_ar_fire = '1' THEN
        s_ar_addr <= i_araddr;
      END IF;
    END IF;
  END PROCESS ar_addr_proc;

  -- Write completion: assert when both AW and W have been captured
  write_done_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_write_done <= '0';
      ELSIF s_aw_fire = '1' AND s_w_fire = '1' THEN
        s_write_done <= '1';
      ELSIF s_aw_fire = '1' THEN
        s_write_done <= '0';
      ELSIF s_w_fire = '1' THEN
        s_write_done <= '1';
      ELSIF s_b_valid = '1' AND i_bready = '1' THEN
        s_write_done <= '0';
      END IF;
    END IF;
  END PROCESS write_done_proc;

  -- Register file update
  reg_file_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_reg(0) <= (OTHERS => '0');
        s_reg(1) <= (OTHERS => '0');
        s_reg(2) <= (OTHERS => '0');
        s_reg(3) <= (OTHERS => '0');
      ELSIF s_write_done = '1' THEN
        CASE s_aw_addr(3 DOWNTO 2) IS
          WHEN "00" =>
            FOR i IN 0 TO g_data_width/8-1 LOOP
              IF s_w_strb(i) = '1' THEN
                s_reg(0)(8*i+7 DOWNTO 8*i) <= s_w_data(8*i+7 DOWNTO 8*i);
              END IF;
            END LOOP;
          WHEN "01" =>
            FOR i IN 0 TO g_data_width/8-1 LOOP
              IF s_w_strb(i) = '1' THEN
                s_reg(1)(8*i+7 DOWNTO 8*i) <= s_w_data(8*i+7 DOWNTO 8*i);
              END IF;
            END LOOP;
          WHEN "10" =>
            FOR i IN 0 TO g_data_width/8-1 LOOP
              IF s_w_strb(i) = '1' THEN
                s_reg(2)(8*i+7 DOWNTO 8*i) <= s_w_data(8*i+7 DOWNTO 8*i);
              END IF;
            END LOOP;
          WHEN "11" =>
            FOR i IN 0 TO g_data_width/8-1 LOOP
              IF s_w_strb(i) = '1' THEN
                s_reg(3)(8*i+7 DOWNTO 8*i) <= s_w_data(8*i+7 DOWNTO 8*i);
              END IF;
            END LOOP;
          WHEN OTHERS =>
            NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS reg_file_proc;

  -- B channel valid
  b_valid_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_b_valid <= '0';
      ELSIF s_write_done = '1' THEN
        s_b_valid <= '1';
      ELSIF s_b_valid = '1' AND i_bready = '1' THEN
        s_b_valid <= '0';
      END IF;
    END IF;
  END PROCESS b_valid_proc;

  -- R channel valid
  r_valid_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_r_valid <= '0';
      ELSIF s_ar_fire = '1' THEN
        s_r_valid <= '1';
      ELSIF s_r_valid = '1' AND i_rready = '1' THEN
        s_r_valid <= '0';
      END IF;
    END IF;
  END PROCESS r_valid_proc;

  -- Read data mux
  r_data_proc : PROCESS (s_ar_addr)
  BEGIN
    CASE s_ar_addr(3 DOWNTO 2) IS
      WHEN "00" =>
        o_rdata <= s_reg(0);
      WHEN "01" =>
        o_rdata <= s_reg(1);
      WHEN "10" =>
        o_rdata <= s_reg(2);
      WHEN "11" =>
        o_rdata <= s_reg(3);
      WHEN OTHERS =>
        o_rdata <= (OTHERS => '0');
    END CASE;
  END PROCESS r_data_proc;

  -- Output assignments
  o_awready <= s_aw_ready;
  o_wready  <= s_w_ready;
  o_arready <= s_ar_ready;
  o_bvalid  <= s_b_valid;
  o_bresp   <= c_resp_okay;
  o_rvalid  <= s_r_valid;
  o_rresp   <= c_resp_okay;

  o_reg0 <= s_reg(0);
  o_reg1 <= s_reg(1);
  o_reg2 <= s_reg(2);
  o_reg3 <= s_reg(3);

END ARCHITECTURE rtl;
