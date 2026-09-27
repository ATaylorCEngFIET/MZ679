--------------------------------------------------------------------------------
-- axil_regs : Minimal AXI4-Lite slave with four 32-bit registers.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY axil_regs IS
  PORT (
    i_clk   : IN  std_ulogic;                     -- system clock
    i_rst   : IN  std_ulogic;                     -- reset, active high
    i_awvalid : IN  std_ulogic;                   -- write address valid
    o_awready : OUT std_ulogic;                   -- write address ready
    i_awaddr  : IN  std_ulogic_vector(31 DOWNTO 0); -- write address
    i_wvalid  : IN  std_ulogic;                   -- write data valid
    o_wready  : OUT std_ulogic;                   -- write data ready
    i_wdata   : IN  std_ulogic_vector(31 DOWNTO 0); -- write data
    i_wstrb   : IN  std_ulogic_vector(3 DOWNTO 0);  -- write strobe
    o_bvalid  : OUT std_ulogic;                   -- write response valid
    i_bready  : IN  std_ulogic;                   -- write response ready
    o_bresp   : OUT std_ulogic_vector(1 DOWNTO 0); -- write response
    i_arvalid : IN  std_ulogic;                   -- read address valid
    o_arready : OUT std_ulogic;                   -- read address ready
    i_araddr  : IN  std_ulogic_vector(31 DOWNTO 0); -- read address
    o_rvalid  : OUT std_ulogic;                   -- read data valid
    i_rready  : IN  std_ulogic;                   -- read data ready
    o_rdata   : OUT std_ulogic_vector(31 DOWNTO 0); -- read data
    o_rresp   : OUT std_ulogic_vector(1 DOWNTO 0); -- read response
    o_reg0    : OUT std_ulogic_vector(31 DOWNTO 0); -- register 0
    o_reg1    : OUT std_ulogic_vector(31 DOWNTO 0); -- register 1
    o_reg2    : OUT std_ulogic_vector(31 DOWNTO 0); -- register 2
    o_reg3    : OUT std_ulogic_vector(31 DOWNTO 0)  -- register 3
  );
END ENTITY axil_regs;

ARCHITECTURE rtl OF axil_regs IS
  TYPE t_state_type IS (IDLE, WRITE_ADDR, WRITE_DATA, READ_ADDR, READ_DATA);
  SIGNAL s_state : t_state_type;
  SIGNAL s_awaddr_reg : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_wdata_reg : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_wstrb_reg : std_ulogic_vector(3 DOWNTO 0);
  SIGNAL s_araddr_reg : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_reg0 : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_reg1 : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_reg2 : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_reg3 : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL s_bvalid_reg : std_ulogic;
  SIGNAL s_rvalid_reg : std_ulogic;
  SIGNAL s_rdata_reg : std_ulogic_vector(31 DOWNTO 0);
BEGIN
  -- Register outputs
  o_reg0 <= s_reg0;
  o_reg1 <= s_reg1;
  o_reg2 <= s_reg2;
  o_reg3 <= s_reg3;

  -- AXI4-Lite slave process
  axi_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        s_state <= IDLE;
        o_awready <= '0';
        o_wready <= '0';
        o_bvalid <= '0';
        o_arready <= '0';
        o_rvalid <= '0';
        o_bresp <= "00";
        o_rresp <= "00";
        s_reg0 <= (OTHERS => '0');
        s_reg1 <= (OTHERS => '0');
        s_reg2 <= (OTHERS => '0');
        s_reg3 <= (OTHERS => '0');
      ELSE
        CASE s_state IS
          WHEN IDLE =>
            o_awready <= '1';
            o_wready <= '1';
            o_arready <= '1';
            o_bvalid <= '0';
            o_rvalid <= '0';
            IF i_awvalid = '1' THEN
              s_state <= WRITE_ADDR;
              s_awaddr_reg <= i_awaddr;
            ELSIF i_arvalid = '1' THEN
              s_state <= READ_ADDR;
              s_araddr_reg <= i_araddr;
            END IF;
          WHEN WRITE_ADDR =>
            o_awready <= '0';
            o_wready <= '1';
            IF i_wvalid = '1' THEN
              s_state <= WRITE_DATA;
              s_wdata_reg <= i_wdata;
              s_wstrb_reg <= i_wstrb;
            END IF;
          WHEN WRITE_DATA =>
            o_wready <= '0';
            o_bvalid <= '1';
            IF i_bready = '1' THEN
              CASE s_awaddr_reg(3 DOWNTO 2) IS
                WHEN "00" => -- reg0
                  FOR i IN 0 TO 3 LOOP
                    IF s_wstrb_reg(i) = '1' THEN
                      s_reg0(8*i+7 DOWNTO 8*i) <= s_wdata_reg(8*i+7 DOWNTO 8*i);
                    END IF;
                  END LOOP;
                WHEN "01" => -- reg1
                  FOR i IN 0 TO 3 LOOP
                    IF s_wstrb_reg(i) = '1' THEN
                      s_reg1(8*i+7 DOWNTO 8*i) <= s_wdata_reg(8*i+7 DOWNTO 8*i);
                    END IF;
                  END LOOP;
                WHEN "10" => -- reg2
                  FOR i IN 0 TO 3 LOOP
                    IF s_wstrb_reg(i) = '1' THEN
                      s_reg2(8*i+7 DOWNTO 8*i) <= s_wdata_reg(8*i+7 DOWNTO 8*i);
                    END IF;
                  END LOOP;
                WHEN OTHERS => -- reg3
                  FOR i IN 0 TO 3 LOOP
                    IF s_wstrb_reg(i) = '1' THEN
                      s_reg3(8*i+7 DOWNTO 8*i) <= s_wdata_reg(8*i+7 DOWNTO 8*i);
                    END IF;
                  END LOOP;
              END CASE;
              s_state <= IDLE;
            END IF;
          WHEN READ_ADDR =>
            o_arready <= '0';
            o_rvalid <= '1';
            CASE s_araddr_reg(3 DOWNTO 2) IS
              WHEN "00" => s_rdata_reg <= s_reg0;
              WHEN "01" => s_rdata_reg <= s_reg1;
              WHEN "10" => s_rdata_reg <= s_reg2;
              WHEN OTHERS => s_rdata_reg <= s_reg3;
            END CASE;
            s_state <= READ_DATA;
          WHEN READ_DATA =>
            o_rvalid <= '0';
            IF i_rready = '1' THEN
              s_state <= IDLE;
            END IF;
        END CASE;
      END IF;
    END IF;
  END PROCESS axi_proc;

  -- Response signals
  o_bresp <= "00"; -- OKAY
  o_rdata <= s_rdata_reg;
  o_rresp <= "00"; -- OKAY

END ARCHITECTURE rtl;
