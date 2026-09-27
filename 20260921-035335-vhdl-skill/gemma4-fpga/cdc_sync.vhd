--------------------------------------------------------------------------------
-- cdc_sync : multi-stage synchronizer for a single-bit signal across 
-- clock domains.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cdc_sync is
  generic map (
    g_stages : positive := 2  -- number of flip-flops in the synchronizer chain
  );
  port (
    i_clk   : in  std_logic;                               -- input clock
    i_rst   : in  std_logic;                               -- active-high reset
    i_data  : in  std_logic;                              -- input signal to be synchronized
    o_data  : out std_logic                                 -- synchronized output
  );
end entity cdc_sync;

architecture rtl of cdc_sync is
  -- internal signal to hold the chain of flip-flops
  signal s_sync_chain : std_logic_vector(g_stages-1 downto 0);
begin

  -- Synchronizer logic: shifts the input through the chain of flops.
  -- The output is the last stage of the chain.
  sync_proc : process (i_clk)
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        s_sync_chain <= (others => '0');
      else
        -- The first stage captures the input signal.
        s_sync_chain(0) <= i_data;
        -- Subsequent stages shift the value.
        for i in 1 to g_stages-1 loop
          s_sync_chain(i) <= s_sync_chain(i-1);
        end loop;
      end if;
    end if;
  end process sync_proc;

  -- Assign the last stage of the chain to the output port.
  o_data <= s_sync_chain(g_stages-1);

end architecture rtl;
