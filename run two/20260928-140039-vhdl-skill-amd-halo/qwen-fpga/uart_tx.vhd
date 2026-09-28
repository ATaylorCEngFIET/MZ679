library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity uart_tx is
  generic (CLK_HZ : positive := 100_000_000; BAUD : positive := 115_200);
  port (clk : in std_logic; rst : in std_logic;
        data : in std_logic_vector(7 downto 0); data_valid : in std_logic;
        tx : out std_logic; busy : out std_logic);
end entity;

architecture rtl of uart_tx is
  constant CYCLES_PER_BIT : positive := CLK_HZ / BAUD;
  type state_type is (ST_IDLE, ST_START, ST_DATA, ST_STOP);
  signal state_r : state_type := ST_IDLE;
  signal baud_r  : natural range 0 to CYCLES_PER_BIT-1 := 0;
  signal bit_r   : natural range 0 to 7 := 0;
  signal shift_r : std_logic_vector(7 downto 0) := (others => '0');
  signal tick    : std_logic;
begin
  tick <= '1' when baud_r = CYCLES_PER_BIT-1 else '0';
  busy <= '0' when state_r = ST_IDLE else '1';

  process(clk) begin
    if rising_edge(clk) then
      if rst = '1' then
        state_r <= ST_IDLE; baud_r <= 0; bit_r <= 0; tx <= '1';
      else
        -- baud counter runs whenever a frame is in flight
        if state_r = ST_IDLE or tick = '1' then baud_r <= 0; else baud_r <= baud_r + 1; end if;

        case state_r is
          when ST_IDLE =>
            tx <= '1';
            if data_valid = '1' then shift_r <= data; bit_r <= 0; state_r <= ST_START; end if;
          when ST_START =>
            tx <= '0';
            if tick = '1' then state_r <= ST_DATA; end if;
          when ST_DATA =>
            tx <= shift_r(0);                                  -- LSB first
            if tick = '1' then
              shift_r <= '0' & shift_r(7 downto 1);
              if bit_r = 7 then state_r <= ST_STOP; else bit_r <= bit_r + 1; end if;
            end if;
          when ST_STOP =>
            tx <= '1';
            if tick = '1' then state_r <= ST_IDLE; end if;
        end case;
      end if;
    end if;
  end process;
end architecture;
