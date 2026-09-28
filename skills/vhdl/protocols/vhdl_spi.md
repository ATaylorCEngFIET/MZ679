# SPI master and slave protocol guidance (VHDL-2008)

Apply this guide only when the request uses this protocol. The requested interface and features
take priority over these example names, widths, resets and implementation choices. Preserve the
protocol invariants when adapting code; do not silently reduce the requested feature set.

## Choose the role and wire contract
Cover both master/controller and slave/target. SPI device framing comes from the peripheral
register/timing specification; there is no universal address, ACK or packet format. Specify
MODE, bit order, word width, chip-select polarity, CS setup/hold/inactive times and maximum SCLK.
These references use active-low CS, eight bits, MSB first and static MODE=0..3.

| Mode | CPOL | CPHA | Sample | Change data |
|---|---:|---:|---|---|
| 0 | 0 | 0 | Leading/rising | Trailing/falling |
| 1 | 0 | 1 | Trailing/falling | Leading/rising |
| 2 | 1 | 0 | Leading/falling | Trailing/rising |
| 3 | 1 | 1 | Trailing/rising | Leading/falling |

With CPHA=0, preload the first bit BEFORE the first sampling edge. With CPHA=1, launch it on
the first leading edge. Do not omit the final trailing edge or deassert CS before the final
sample/hold interval. Receive and transmit proceed simultaneously, even for a software "read".

## Master reference
`spi_byte_master` latches TX at `start && !busy`; changes to TX while busy cannot corrupt a word.
It creates SCLK from clock enables in the system-clock process, not from an internally routed
SCLK clock. HALF_CYCLES>=1 gives `f_sclk=f_clk/(2*HALF_CYCLES)`; derive it from the device limits.
Sixteen edges transfer one byte. CS setup and final hold are each one half-period. RX and the
one-cycle done pulse appear when CS deasserts. A level-held start can request another transaction
once idle: pulse it or implement a proper command handshake in the surrounding design.

This master ends CS after each byte. For command+address+payload devices, add an explicit word
count/keep-CS command contract and data buffering; do not glue together these one-byte commands
and assume CS stays low. MODE is fixed per instance; latch it per command if made programmable.
Reset aborts the frame, releases CS and returns SCLK to CPOL. The device may need protocol recovery.

## Slave reference
`spi_byte_slave` oversamples SCLK/CS/MOSI using synchronizers in the system-clock domain. This is
for slow SCLK: budget **at least eight system clocks per SCLK half-period**, at least eight for
CS setup and inactive time, plus board/device timing margin. The master regression uses twelve.
A faster target needs a proper SCLK-clocked design, I/O constraints and a CDC mailbox/FIFO to the
system clock. Two synchronizer flops do not make an arbitrary SPI frequency safe.

The target preloads TX on selection and reloads at byte boundaries while CS remains low.
TX must be ready before that reload; RX is a one-cycle pulse with no backpressure. Add FIFOs or
a documented overrun/underrun policy for a real data producer/consumer. Raising CS discards any
partial byte and resets the bit position. The reference permits multiple bytes per selection.
Use the target's `miso_oe` for the I/O tri-state; MISO must not drive a shared bus while unselected.
At the pad, use a tri-state buffer driven by `miso` and `miso_oe`; internal fabric signals are not
tristate buses. If the application needs LSB-first or non-8-bit words, change counters and preload
logic together and test both ends against an independent bit-level model.

## Verification
The regression runs all four modes, checks exact serial edge/sample counts and MOSI ordering,
exchanges independent TX/RX bytes, changes TX after start, checks MISO release, and uses an
independent host driver for continuous-CS target transfers and partial-byte abort/reselection.
Extend with minimum timing margins, asynchronous clock phase sweeps, reset mid-word, FIFO
underflow/overflow, and actual device-specific framing. Physical I/O timing is not established
by these functional simulations.

## Language-specific implementation
Use VHDL-2008 with numeric_std, declarations before the architecture begin, explicit conversions
and one driver per register. Signal assignments take effect after the process; use variables
only for deliberate next-value calculations. Compile dependencies before their users.

## Reference: spi_byte_master

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity spi_byte_master is
 generic(MODE:natural range 0 to 3:=0;HALF_CYCLES:positive:=4);
 port(clk,rst,start:in std_logic;tx_data:in std_logic_vector(7 downto 0);miso:in std_logic;
 busy,done,cs_n,sclk,mosi:out std_logic;rx_data:out std_logic_vector(7 downto 0));
end entity;
architecture rtl of spi_byte_master is
 function polarity return std_logic is
 begin if MODE>=2 then return '1';else return '0';end if;end function;
 constant CPOL:std_logic:=polarity;constant CPHA:natural:=MODE mod 2;
 type state_type is (ST_IDLE,ST_SHIFT,ST_HOLD);signal state:state_type;
 signal timer:natural range 0 to HALF_CYCLES-1;signal edge_index:natural range 0 to 15;
 signal tx_shift,rx_shift:std_logic_vector(7 downto 0);signal sclk_r:std_logic;
begin
 busy<='1' when state/=ST_IDLE else '0';sclk<=sclk_r;
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then
    state<=ST_IDLE;timer<=0;edge_index<=0;tx_shift<=(others=>'0');rx_shift<=(others=>'0');
    done<='0';cs_n<='1';sclk_r<=CPOL;mosi<='0';rx_data<=(others=>'0');
   else
    done<='0';
    case state is
     when ST_IDLE => if start='1' then
      tx_shift<=tx_data;rx_shift<=(others=>'0');edge_index<=0;timer<=HALF_CYCLES-1;
      cs_n<='0';sclk_r<=CPOL;if CPHA=0 then mosi<=tx_data(7);else mosi<='0';end if;state<=ST_SHIFT;
     end if;
     when ST_SHIFT => if timer/=0 then timer<=timer-1;
      else
       timer<=HALF_CYCLES-1;sclk_r<=not sclk_r;
       if edge_index mod 2=CPHA then rx_shift<=rx_shift(6 downto 0) & miso;
       elsif CPHA=1 then mosi<=tx_shift(7);tx_shift<=tx_shift(6 downto 0) & '0';
       elsif edge_index/=15 then tx_shift<=tx_shift(6 downto 0) & '0';mosi<=tx_shift(6);end if;
       if edge_index=15 then state<=ST_HOLD;else edge_index<=edge_index+1;end if;
      end if;
     when ST_HOLD => if timer/=0 then timer<=timer-1;
      else cs_n<='1';rx_data<=rx_shift;done<='1';state<=ST_IDLE;end if;
    end case;
   end if;
  end if;
 end process;
end architecture;
```

## Reference: spi_byte_slave

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity spi_byte_slave is
 generic(MODE:natural range 0 to 3:=0);
 port(clk,rst,cs_n,sclk,mosi:in std_logic;tx_data:in std_logic_vector(7 downto 0);
 miso,miso_oe,rx_valid:out std_logic;rx_data:out std_logic_vector(7 downto 0));
end entity;
architecture rtl of spi_byte_slave is
 function polarity return std_logic is
 begin if MODE>=2 then return '1';else return '0';end if;end function;
 constant CPOL:std_logic:=polarity;constant CPHA:natural:=MODE mod 2;
 signal cs_sync,sck_sync,mosi_sync:std_logic_vector(1 downto 0);
 attribute ASYNC_REG:string;
 attribute ASYNC_REG of cs_sync:signal is "TRUE";
 attribute ASYNC_REG of sck_sync:signal is "TRUE";
 attribute ASYNC_REG of mosi_sync:signal is "TRUE";
 signal cs_prev,sck_prev,selected,reload:std_logic;
 signal bit_count:unsigned(2 downto 0);signal tx_shift,rx_shift:std_logic_vector(7 downto 0);
 signal leading,trailing,sample_edge,launch_edge:std_logic;
begin
 miso_oe<=not cs_n;
 leading<='1' when sck_sync(1)/=sck_prev and sck_sync(1)/=CPOL else '0';
 trailing<='1' when sck_sync(1)/=sck_prev and sck_sync(1)=CPOL else '0';
 sample_edge<=trailing when CPHA=1 else leading;launch_edge<=leading when CPHA=1 else trailing;
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then cs_sync<="11";sck_sync<=(others=>CPOL);mosi_sync<="00";
   else cs_sync<=cs_sync(0) & cs_n;sck_sync<=sck_sync(0) & sclk;mosi_sync<=mosi_sync(0) & mosi;end if;
  end if;
 end process;
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then
    cs_prev<='1';sck_prev<=CPOL;selected<='0';reload<='0';bit_count<=(others=>'0');
    tx_shift<=(others=>'0');rx_shift<=(others=>'0');rx_data<=(others=>'0');rx_valid<='0';miso<='0';
   else
    cs_prev<=cs_sync(1);sck_prev<=sck_sync(1);rx_valid<='0';
    if cs_sync(1)='1' then selected<='0';bit_count<=(others=>'0');reload<='0';
    elsif cs_prev='1' then
     selected<='1';bit_count<=(others=>'0');reload<='0';tx_shift<=tx_data;rx_shift<=(others=>'0');
     if CPHA=0 then miso<=tx_data(7);else miso<='0';end if;
    elsif selected='1' then
     if sample_edge='1' then
      rx_shift<=rx_shift(6 downto 0) & mosi_sync(1);bit_count<=bit_count+1;
      if bit_count=7 then rx_data<=rx_shift(6 downto 0) & mosi_sync(1);rx_valid<='1';reload<='1';end if;
     end if;
     if launch_edge='1' then
      if reload='1' then
       miso<=tx_data(7);reload<='0';
       if CPHA=1 then tx_shift<=tx_data(6 downto 0) & '0';else tx_shift<=tx_data;end if;
      elsif CPHA=1 then miso<=tx_shift(7);tx_shift<=tx_shift(6 downto 0) & '0';
      else miso<=tx_shift(6);tx_shift<=tx_shift(6 downto 0) & '0';end if;
     end if;
    end if;
   end if;
  end if;
 end process;
end architecture;
```

## Specification and validation

[Microchip SPI introduction and device timing documentation](https://developerhelp.microchip.com/xwiki/bin/view/applications/SPI/). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
