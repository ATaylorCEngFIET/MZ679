--------------------------------------------------------------------------------
-- axil_regs : minimal AXI4-Lite slave with four 32-bit read/write registers.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY axil_regs IS
  PORT (
    i_aclk    : IN  std_ulogic;
    i_aresetn : IN  std_ulogic;

    i_awvalid : IN  std_ulogic;
    i_awaddr  : IN  std_ulogic_vector(31 DOWNTO 0);
    o_awready : OUT std_ulogic;

    i_wvalid  : IN  std_ulogic;
    i_wdata   : IN  std_ulogic_vector(31 DOWNTO 0);
    i_wstrb   : IN  std_ulogic_vector(3 DOWNTO 0);
    o_wready  : OUT std_ulogic;

    o_bvalid  : OUT std_ulogic;
    i_bready  : IN  std_ulogic;
    o_bresp   : OUT std_ulogic_vector(1 DOWNTO 0);

    i_arvalid : IN  std_ulogic;
    i_araddr  : IN  std_ulogic_vector(31 DOWNTO 0);
    o_arready : OUT std_ulogic;

    o_rvalid  : OUT std_ulogic;
    i_rready  : IN  std_ulogic;
    o_rdata   : OUT std_ulogic_vector(31 DOWNTO 0);
    o_rresp   : OUT std_ulogic_vector(1 DOWNTO 0);

    o_reg0    : OUT std_ulogic_vector(31 DOWNTO 0);
    o_reg1    : OUT std_ulogic_vector(31 DOWNTO 0);
    o_reg2    : OUT std_ulogic_vector(31 DOWNTO 0);
    o_reg3    : OUT std_ulogic_vector(31 DOWNTO 0)
  );
END ENTITY axil_regs;

ARCHITECTURE rtl OF axil_regs IS
  TYPE t_state IS (s_idle, s_aw, s_w, s_b, s_ar, s_r);
  SIGNAL s_state   : t_state;
  SIGNAL s_awaddr  : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_wdata   : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_wstrb   : std_ulogic_vector(3 DOWNTO 0);
  SIGNAL s_araddr  : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_reg0    : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_reg1    : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_reg2    : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_reg3    : std_ulogic_vector(31 DOWNTO 0);
BEGIN
  -- Main FSM: handles all AXI4-Lite channel handshakes.
  fsm_proc : PROCESS (i_aclk)
  BEGIN
    IF rising_edge(i_aclk) THEN
      IF i_aresetn = '0' THEN
        s_state  <= s_idle;
        s_awaddr <= (OTHERS => '0');
        s_wdata  <= (OTHERS => '0');
        s_wstrb  <= (OTHERS => '0');
        s_araddr <= (OTHERS => '0');
        s_reg0   <= (OTHERS => '0');
        s_reg1   <= (OTHERS => '0');
        s_reg2   <= (OTHERS => '0');
        s_reg3   <= (OTHERS => '0');
      ELSE
        CASE s_state IS
          WHEN s_idle =>
            IF i_awvalid = '1' THEN
              s_state  <= s_aw;
              s_awaddr <= i_awaddr;
            ELSIF i_arvalid = '1' THEN
              s_state  <= s_ar;
              s_araddr <= i_araddr;
            END IF;

          WHEN s_aw =>
            IF i_wvalid = '1' THEN
              s_state  <= s_w;
              s_wdata  <= i_wdata;
              s_wstrb  <= i_wstrb;
            END IF;

          WHEN s_w =>
            IF i_bready = '1' THEN
              s_state <= s_idle;
            END IF;

          WHEN s_b =>
            IF i_bready = '1' THEN
              s_state <= s_idle;
            END IF;

          WHEN s_ar =>
            IF i_rready = '1' THEN
              s_state <= s_idle;
            END IF;

          WHEN s_r =>
            IF i_rready = '1' THEN
              s_state <= s_idle;
            END IF;
        END CASE;
      END IF;
    END IF;
  END PROCESS fsm_proc;

  -- Write data register update on W handshake.
  write_proc : PROCESS (i_aclk)
  BEGIN
    IF rising_edge(i_aclk) THEN
      IF i_aresetn = '0' THEN
        s_reg0 <= (OTHERS => '0');
        s_reg1 <= (OTHERS => '0');
        s_reg2 <= (OTHERS => '0');
        s_reg3 <= (OTHERS => '0');
      ELSIF (s_state = s_w) AND (i_wvalid = '1') THEN
        CASE s_awaddr(3 DOWNTO 2) IS
          WHEN "00" =>
            IF s_wstrb(0) = '1' THEN s_reg0(7 DOWNTO 0)   <= s_wdata(7 DOWNTO 0);   END IF;
            IF s_wstrb(1) = '1' THEN s_reg0(15 DOWNTO 8)  <= s_wdata(15 DOWNTO 8);  END IF;
            IF s_wstrb(2) = '1' THEN s_reg0(23 DOWNTO 16) <= s_wdata(23 DOWNTO 16); END IF;
            IF s_wstrb(3) = '1' THEN s_reg0(31 DOWNTO 24) <= s_wdata(31 DOWNTO 24); END IF;
          WHEN "01" =>
            IF s_wstrb(0) = '1' THEN s_reg1(7 DOWNTO 0)   <= s_wdata(7 DOWNTO 0);   END IF;
            IF s_wstrb(1) = '1' THEN s_reg1(15 DOWNTO 8)  <= s_wdata(15 DOWNTO 8);  END IF;
            IF s_wstrb(2) = '1' THEN s_reg1(23 DOWNTO 16) <= s_wdata(23 DOWNTO 16); END IF;
            IF s_wstrb(3) = '1' THEN s_reg1(31 DOWNTO 24) <= s_wdata(31 DOWNTO 24); END IF;
          WHEN "10" =>
            IF s_wstrb(0) = '1' THEN s_reg2(7 DOWNTO 0)   <= s_wdata(7 DOWNTO 0);   END IF;
            IF s_wstrb(1) = '1' THEN s_reg2(15 DOWNTO 8)  <= s_wdata(15 DOWNTO 8);  END IF;
            IF s_wstrb(2) = '1' THEN s_reg2(23 DOWNTO 16) <= s_wdata(23 DOWNTO 16); END IF;
            IF s_wstrb(3) = '1' THEN s_reg2(31 DOWNTO 24) <= s_wdata(31 DOWNTO 24); END IF;
          WHEN "11" =>
            IF s_wstrb(0) = '1' THEN s_reg3(7 DOWNTO 0)   <= s_wdata(7 DOWNTO 0);   END IF;
            IF s_wstrb(1) = '1' THEN s_reg3(15 DOWNTO 8)  <= s_wdata(15 DOWNTO 8);  END IF;
            IF s_wstrb(2) = '1' THEN s_reg3(23 DOWNTO 16) <= s_wdata(23 DOWNTO 16); END IF;
            IF s_wstrb(3) = '1' THEN s_reg3(31 DOWNTO 24) <= s_wdata(31 DOWNTO 24); END IF;
          WHEN OTHERS =>
            NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS write_proc;

  o_awready <= '1' WHEN s_state = s_idle AND i_awvalid = '1' ELSE '0';
  o_wready  <= '1' WHEN s_state = s_aw AND i_wvalid = '1' ELSE '0';
  o_bvalid  <= '1' WHEN s_state = s_w ELSE '0';
  o_bresp   <= "00";
  o_arready <= '1' WHEN s_state = s_idle AND i_arvalid = '1' ELSE '0';
  o_rvalid  <= '1' WHEN s_state = s_ar ELSE '0';
  o_rresp   <= "00";

  o_rdata <= s_reg0 WHEN s_araddr(3 DOWNTO 2) = "00" ELSE
             s_reg1 WHEN s_araddr(3 DOWNTO 2) = "01" ELSE
             s_reg2 WHEN s_araddr(3 DOWNTO 2) = "10" ELSE
             s_reg3 WHEN s_araddr(3 DOWNTO 2) = "11" ELSE
             (OTHERS => '0');

  o_reg0 <= s_reg0;
  o_reg1 <= s_reg1;
  o_reg2 <= s_reg2;
  o_reg3 <= s_reg3;
END ARCHITECTURE rtl;
