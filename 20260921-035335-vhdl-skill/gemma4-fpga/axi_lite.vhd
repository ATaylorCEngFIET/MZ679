--------------------------------------------------------------------------------
-- axil_regs : AXI4-Lite slave with four 32-bit registers.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY axil_regs IS
  GENERIC (
    g_addr_width : POSITIVE := 8
  );
  PORT (
    i_clk         : IN  std_logic;
    i_rst         : IN  std_logic;
    -- Write Address Channel
    i_awaddr       : IN  std_logic_vector(g_addr_width-1 DOWNTO 0);
    i_awvalid      : IN  std_logic;
    o_awready      : OUT std_logic;
    -- Write Data Channel
    i_wdata        : IN  std_logic_vector(31 DOWNTO 0);
    i_wstrb        : IN  std_logic_vector(3 DOWNTO 0);
    i_wvalid       : IN  std_logic;
    o_wready       : OUT std_logic;
    -- Write Response Channel
    o_bvalid       : OUT std_logic;
    o_bresp        : OUT std_logic_vector(1 DOWNTO 0);
    i_bready       : IN  std_logic;
    -- Read Address Channel
    i_araddr       : IN  std_logic_vector(g_addr_width-1 DOWNTO 0);
    i_arvalid      : IN  std_logic;
    o_arready      : OUT std_logic;
    -- Read Data Channel
    o_rdata        : OUT std_logic_vector(31 DOWNTO 0);
    o_rvalid       : OUT std_logic;
    o_rresp         : OUT std_logic_vector(1 DOWNTO 0);
    i_rready       : IN  std_logic
  );
END ENTITY axil_regs;

ARCHITECTURE rtl OF axil_regs IS
  -- Register storage
  SIGNAL s_reg0    : unsigned(31 DOWNTO 0);
  SIGNAL s_reg1    : unsigned(31 DOWNTO 0);
  SIGNAL s_reg2    : unsigned(31 DOWNTO 0);
  SIGNAL s_reg3    : unsigned(31 DOWNTO 0);

  -- Internal state for handshake tracking
  SIGNAL s_aw_done : std_logic;
  SIGNAL s_w_done  : std_logic;
  SIGNAL s_ar_done : std_logic;

  -- Internal registers for response logic
  SIGNAL s_b_valid  : std_logic;
  SIGNAL s_b_resp   : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_r_valid  : std_logic;
  SIGNAL s_r_resp    : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_r_data   : std_logic_vector(31 DOWNTO 0);

  -- Internal state for decoding
  SIGNAL s_aw_addr  : std_logic_vector(g_addr_width-1 DOWNTO 0);

  -- Internal logic to determine if a write is complete
  SIGNAL s_write_complete : std_logic;

BEGIN

  -- Register update and handshake logic
  write_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_aw_done        <= '0';
        s_w_done         <= '0';
        s_b_valid         <= '0';
        s_b_resp          <= "00";
        s_write_complete  <= '0';
        s_aw_addr         <= (OTHERS => '0');
      ELSE
        -- AW Channel Logic
        IF i_awvalid = '1' AND o_awready = '1' THEN
          s_aw_done <= '1';
          s_aw_addr <= i_awaddr;
        ELSE
          -- If not currently being accepted, clear the "done" state 
          -- to allow for subsequent transactions in a multi-cycle scenario.
          -- In AXI4-Lite, this is simplified as a single-cycle handshake.
          IF i_awvalid = '0' THEN
            s_aw_done <= '0';
          END IF;
        END IF;
        
        -- W Channel Logic
        IF i_wvalid = '1' AND o_wready = '1' THEN
          s_w_done <= '1';
        ELSE
          IF i_wvalid = '0' THEN
            s_w_done <= '0';
          END IF;
        END IF;

        -- Write Completion Logic
        s_write_complete <= s_aw_done AND s_w_done;

        -- B_RESP Logic
        s_b_resp <= "00";
        IF s_write_complete = '1' THEN
          s_b_valid <= '1';
        ELSE
          s_b_valid <= '0';
        END IF;

        -- Register Update Logic
        -- Update registers only when both AW and W are valid and accepted.
        IF s_write_complete = '1' THEN
          IF (s_aw_addr(3 DOWNTO 2) = "00") THEN
            s_reg0 <= to_unsigned(to_integer(signed(i_wdata)), 32);
          ELSIF (s_aw_addr(3 DOWNTO 2) = "01") THEN
            s_reg1 <= to_unsigned(to_integer(signed(i_wdata)), 32);
          ELSIF (s_aw_addr(3 DOWNTO 2) = "10") THEN
            s_reg2 <= to_unsigned(to_integer(signed(i_wdata)), 32);
          ELSE
            s_reg3 <= to_unsigned(to_integer(signed(i_wdata)), 32);
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS write_proc;

  -- Read logic
  read_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_ar_done     <= '0';
        s_r_valid     <= '0';
        s_r_resp       <= "00";
        s_r_data       <= (OTHERS => '0');
      ELSE
        -- AR Channel Logic
        IF i_arvalid = '1' AND o_arready = '1' THEN
          s_ar_done <= '1';
        ELSE
          IF i_arvalid = '0' THEN
            s_ar_done <= '0';
          END IF;
        END IF;

        -- R Data Logic
        IF s_ar_done = '1' THEN
          s_r_valid <= '1';
          s_r_resp   <= "00";
          -- Select data based on address
          IF (i_araddr(3 DOWNTO 2) = "00") THEN
            s_r_data <= std_logic_vector(s_reg0);
          ELSIF (i_araddr(3 DOWNTO 2) = "01") THEN
            s_r_data <= std_logic_vector(s_reg1);
          ELSIF (i_araddr(3 DOWNTO 2) = "10") THEN
            s_r_data <= std_logic_vector(s_reg2);
          ELSE
            s_r_data <= std_logic_vector(s_reg3);
          END IF;
        ELSE
          s_r_valid <= '0';
        END IF;
      END IF;
    END IF;
  END PROCESS read_proc;

  -- Concurrent assignments for outputs
  o_awready      <= '1';
  o_wready       <= '1';
  o_bvalid       <= s_b_valid;
  o_bresp        <= s_b_resp;
  o_arready      <= '1';
  o_rvalid       <= s_r_valid;
  o_rresp         <= s_r_resp;
  o_rdata        <= s_r_data;

END ARCHITECTURE rtl;
