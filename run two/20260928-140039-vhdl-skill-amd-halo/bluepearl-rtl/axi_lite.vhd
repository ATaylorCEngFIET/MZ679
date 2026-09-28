library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity axil_regs is
  port (aclk : in std_logic; aresetn : in std_logic;
        awvalid : in std_logic; awready : out std_logic; awaddr : in std_logic_vector(31 downto 0);
        wvalid  : in std_logic; wready  : out std_logic; wdata  : in std_logic_vector(31 downto 0);
        wstrb   : in std_logic_vector(3 downto 0);
        bvalid  : out std_logic; bready : in std_logic; bresp : out std_logic_vector(1 downto 0);
        arvalid : in std_logic; arready : out std_logic; araddr : in std_logic_vector(31 downto 0);
        rvalid  : out std_logic; rready : in std_logic; rdata : out std_logic_vector(31 downto 0);
        rresp   : out std_logic_vector(1 downto 0);
        reg0, reg1, reg2, reg3 : out std_logic_vector(31 downto 0));
end entity;

architecture rtl of axil_regs is
  type reg_array is array (0 to 3) of std_logic_vector(31 downto 0);
  signal regs : reg_array := (others => (others => '0'));
  signal aw_full, w_full : std_logic;
  signal awaddr_hold : std_logic_vector(1 downto 0);
  signal wdata_hold : std_logic_vector(31 downto 0);
  signal wstrb_hold : std_logic_vector(3 downto 0);
  signal awready_i, wready_i, arready_i : std_logic;
  signal bvalid_r, rvalid_r : std_logic;
  signal aw_fire, w_fire, ar_fire, b_fire, r_fire : std_logic;
begin
  awready_i <= not aw_full and not bvalid_r;
  wready_i  <= not w_full and not bvalid_r;
  arready_i <= not rvalid_r;

  awready <= awready_i;
  wready  <= wready_i;
  arready <= arready_i;
  aw_fire <= awvalid and awready_i;
  w_fire  <= wvalid and wready_i;
  ar_fire <= arvalid and arready_i;
  b_fire  <= bvalid_r and bready;
  r_fire  <= rvalid_r and rready;

  bvalid <= bvalid_r;
  rvalid <= rvalid_r;
  bresp  <= "00";
  rresp  <= "00";
  reg0 <= regs(0);
  reg1 <= regs(1);
  reg2 <= regs(2);
  reg3 <= regs(3);

  process(aclk) begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        aw_full <= '0';
        w_full <= '0';
        awaddr_hold <= (others => '0');
        wdata_hold <= (others => '0');
        wstrb_hold <= (others => '0');
        bvalid_r <= '0';
        rvalid_r <= '0';
        rdata <= (others => '0');
        regs <= (others => (others => '0'));
      else
        if aw_fire = '1' then
          aw_full <= '1';
          awaddr_hold <= awaddr(3 downto 2);
        end if;

        if w_fire = '1' then
          w_full <= '1';
          wdata_hold <= wdata;
          wstrb_hold <= wstrb;
        end if;

        if aw_full = '1' and w_full = '1' and bvalid_r = '0' then
          for i in 0 to 3 loop
            if wstrb_hold(i) = '1' then
              regs(to_integer(unsigned(awaddr_hold)))(8*i+7 downto 8*i)
                <= wdata_hold(8*i+7 downto 8*i);
            end if;
          end loop;
          aw_full <= '0';
          w_full <= '0';
          bvalid_r <= '1';
        end if;

        if b_fire = '1' then
          bvalid_r <= '0';
        end if;

        if ar_fire = '1' then
          rdata <= regs(to_integer(unsigned(araddr(3 downto 2))));
          rvalid_r <= '1';
        end if;

        if r_fire = '1' then
          rvalid_r <= '0';
        end if;
      end if;
    end if;
  end process;
end architecture;
