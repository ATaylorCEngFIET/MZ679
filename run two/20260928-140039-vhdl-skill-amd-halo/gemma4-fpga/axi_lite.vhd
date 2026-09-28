library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity axil_regs is
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    awvalid     : in  std_logic;
    awready     : out std_logic;
    awaddr      : in  std_logic_vector(31 downto 0);
    wvalid      : in  std_logic;
    wready      : out std_logic;
    wdata       : in  std_logic_vector(31 downto 0);
    wstrb       : in  std_logic_vector(3 downto 0);
    bvalid      : out std_logic;
    bready      : in  std_logic;
    bresp       : out std_logic_vector(1 downto 0);
    arvalid     : in  std_logic;
    arready     : out std_logic;
    araddr      : in  std_logic_vector(31 downto 0);
    rvalid      : out std_logic;
    rready      : in  std_logic;
    rdata       : out std_logic_vector(31 downto 0);
    rresp        : out std_logic_vector(1 downto 0);
    reg0        : out std_logic_vector(31 downto 0);
    reg1        : out std_logic_vector(31 downto 0);
    reg2        : out std_logic_vector(31 downto 0);
    reg3        : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of axil_regs is
  type reg_array is array (0 to 3) of std_logic_vector(31 downto 0);
  signal regs           : reg_array;
  
  signal aw_full        : std_logic;
  signal w_full         : std_logic;
  signal aw_addr_hold   : std_logic_vector(1 downto 0);
  signal wdata_hold     : std_logic_vector(31 downto 0);
  signal wstrb_hold     : std_logic_vector(3 downto 0);
  
  signal bvalid_r       : std_logic;
  signal rvalid_r       : std_logic;
  
  signal aw_ready_i     : std_logic;
  signal w_ready_i      : std_logic;
  signal ar_ready_i     : std_logic;
  
  signal aw_fire        : std_logic;
  signal w_fire         : std_logic;
  signal ar_fire        : std_logic;
  signal b_fire         : std_logic;
  signal r_fire         : std_logic;

begin
  -- Ready signals depend on internal state, not external valid
  aw_ready_i  <= not aw_full and not bvalid_r;
  w_ready_i   <= not w_full and not bvalid_r;
  ar_ready_i  <= not rvalid_r;

  awready     <= aw_ready_i;
  wready      <= w_ready_i;
  arready     <= ar_ready_i;

  -- Handshake signals
  aw_fire      <= awvalid and aw_ready_i;
  w_fire       <= wvalid and w_ready_i;
  ar_fire      <= arvalid and ar_ready_i;
  b_fire       <= bvalid_r and bready;
  r_fire       <= rvalid_r and rready;

  -- Outputs
  bvalid      <= bvalid_r;
  rvalid      <= rvalid_r;
  bresp       <= "00";
  rresp        <= "00";
  reg0        <= regs(0);
  reg1        <= regs(1);
  reg2        <= regs(2);
  reg3        <= regs(3);

  process(clk)
    variable i : integer range 0 to 3;
  begin
    if rising_edge(clk) then
      if rst = '1' then
        aw_full        <= '0';
        w_full         <= '0';
        aw_addr_hold   <= (others => '0');
        wdata_hold     <= (others => '0');
        wstrb_hold     <= (others => '0');
        bvalid_r       <= '0';
        rvalid_r       <= '0';
        regs           <= (others => (others => '0'));
      else
        -- Capture AW
        if aw_fire = '1' then
          aw_full       <= '1';
          aw_addr_hold  <= awaddr(3 downto 2);
        end if;

        -- Capture W
        if w_fire = '1' then
          w_full         <= '1';
          wdata_hold     <= wdata;
          wstrb_hold     <= wstrb;
        end if;

        -- Commit Write
        if aw_full = '1' and w_full = '1' and bvalid_r = '0' then
          for i in 0 to 3 loop
            if wstrb_hold(i) = '1' then
              regs(to_integer(unsigned(aw_addr_hold)))(8*i+7 downto 8*i) 
                <= wdata_hold(8*i+7 downto 8*i);
            end if;
          end loop;
          aw_full        <= '0';
          w_full         <= '0';
          bvalid_r       <= '1';
        end if;

        -- B Response
        if b_fire = '1' then
          bvalid_r       <= '0';
        end if;

        -- Capture Read
        if ar_fire = '1' then
          rdata          <= regs(to_integer(unsigned(araddr(3 downto 2))));
          rvalid_r       <= '1';
        end if;

        -- R Response
        if r_fire = '1' then
          rvalid_r       <= '0';
        end if;
      end if;
    end if;
  end process;
end architecture;
