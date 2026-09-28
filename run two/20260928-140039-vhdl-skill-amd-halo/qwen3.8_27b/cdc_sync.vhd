library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity cdc_sync is
  generic (STAGES : positive := 2);
  port (clk : in std_logic; rst : in std_logic;
        async_in : in std_logic; sync_out : out std_logic);
end entity;

architecture rtl of cdc_sync is
  signal sync_r : std_logic_vector(STAGES-1 downto 0) := (others => '0');
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of sync_r : signal is "TRUE";
begin
  sync_out <= sync_r(STAGES-1);

  process(clk) begin
    if rising_edge(clk) then
      if rst = '1' then
        sync_r <= (others => '0');
      else
        sync_r <= sync_r(STAGES-2 downto 0) & async_in;
      end if;
    end if;
  end process;
end architecture;
