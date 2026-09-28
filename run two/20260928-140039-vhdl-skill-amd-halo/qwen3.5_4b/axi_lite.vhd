library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity axil_regs is
  generic (ADDR_WIDTH : integer := 32);
  port (aclk : in std_logic; aresetn : in std_logic;
        awvalid : in std_logic; awready : out std_logic; awaddr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        wvalid  : in std_logic; wready  : out std_logic; wdata  : in std_logic_vector(31 downto 0);
        wstrb   : in std_logic_vector(3 downto 0);
        bvalid  : out std_logic; bready : in std_logic; bresp : out std_logic_vector(1 downto 0);
        arvalid : in std_logic; arready : out std_logic; araddr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        rvalid  : out std_logic; rready : in std_logic; rdata : out std_logic_vector(31 downto 0);
        rresp   : out std_logic_vector(1 downto 0);
        reg0, reg1, reg2, reg3 : out std_logic_vector(31 downto 0));
end entity;

architecture rtl of axil_regs is
  type reg_array is array (0 to 3) of std_logic_vector(31 downto 0);
  signal regs : reg_array := (others => (others => '0'));
  
  -- Handshake flags and hold signals declared before use
  signal aw_ready_i, w_ready_i, ar_ready_i : std_logic;
  signal b_valid_r, r_valid_r : std_logic;
  signal aw_full, w_full : std_logic;
  
  -- Hold registers for AW (address) and W (data/strobe)
  signal aw_addr_hold : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal w_data_hold : std_logic_vector(31 downto 0);
  signal w_strb_hold : std_logic_vector(3 downto 0);

begin
  -- Register outputs
  reg0 <= regs(0);
  reg1 <= regs(1);
  reg2 <= regs(2);
  reg3 <= regs(3);

  -- Ready signals derived from registered state (no combinational path to inputs)
  aw_ready_i <= not aw_full and not b_valid_r;
  w_ready_i <= not w_full and not b_valid_r;
  ar_ready_i <= not r_valid_r;
  
  awready <= aw_ready_i;
  wready <= w_ready_i;
  arready <= ar_ready_i;

  -- Fire signals: valid AND ready (registered) - declared as signals to allow concurrent assignment
  signal aw_fire : std_logic;
  signal w_fire : std_logic;
  signal ar_fire : std_logic;
  
  b_valid_r <= '0'; r_valid_r <= '0';
  bresp <= "00"; rresp <= "00";

  -- Concurrent assignments for fire signals
  aw_fire <= awvalid and aw_ready_i;
  w_fire <= wvalid and w_ready_i;
  ar_fire <= arvalid and ar_ready_i;

  process(aclk) begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        aw_full <= '0'; w_full <= '0';
        aw_addr_hold <= (others => '0');
        w_data_hold <= (others => '0');
        w_strb_hold <= (others => '0');
        b_valid_r <= '0'; r_valid_r <= '0';
        regs <= (others => (others => '0'));
      else
        -- Handle Write Address capture
        if aw_fire = '1' then
          aw_full <= '1';
          aw_addr_hold <= awaddr;
        end if;

        -- Handle Write Data/Strobe capture
        if w_fire = '1' then
          w_full <= '1';
          w_data_hold <= wdata;
          w_strb_hold <= wstrb;
        end if;

        -- Commit Write: Only when both AW and W are full, B is not valid yet
        if aw_full = '1' and w_full = '1' and b_valid_r = '0' then
          for i in 0 to 3 loop
            if w_strb_hold(i) = '1' then
              regs(to_integer(unsigned(aw_addr_hold)))(8*i+7 downto 8*i) <= w_data_hold(8*i+7 downto 8*i);
            end if;
          end loop;
          aw_full <= '0'; w_full <= '0';
          b_valid_r <= '1';
        end if;

        -- Handle BVALID release (acknowledge master)
        if b_valid_r = '1' and bready = '1' then
          b_valid_r <= '0';
        end if;

        -- Handle Read Data capture
        if ar_fire = '1' then
          rdata <= regs(to_integer(unsigned(ar_addr_hold)));
          r_valid_r <= '1';
        end if;

        -- Handle RVALID release (acknowledge master)
        if r_valid_r = '1' and rready = '1' then
          r_valid_r <= '0';
        end if;
      end if;
    end if;
  end process;
end architecture;
