# I2C master and slave protocol guidance (VHDL-2008)

Apply this guide only when the request uses this protocol. The requested interface and features
take priority over these example names, widths, resets and implementation choices. Preserve the
protocol invariants when adapting code; do not silently reduce the requested feature set.

## Role, electrical behavior and timing
Cover master/controller and slave/target. Define 7-bit versus 10-bit addressing, bus speed,
clock stretching, repeated START, supported message lengths, reset and timeout/error reporting.
The references use one active controller, 7-bit addresses and byte transfers. They do not provide
10-bit/general-call/high-speed support, complete multi-controller clock synchronization, or
SMBus/PMBus features. Choose a non-reserved target address; the example is 0x42.

SDA and SCL are open drain: drive zero or release, NEVER drive one. The reference ports are
`*_low` enables, not push-pull bus outputs. In a top-level pad wrapper, zero is driven when the
enable is high and Z otherwise; external pull-ups produce one. Wire the pad input back separately.
Resolve every participant's drive in the testbench. Do not infer a push-pull output from `not bit`.

START is SDA falling with SCL high; STOP is SDA rising with SCL high. Otherwise SDA changes while
SCL is low. Transfer eight bits MSB first followed by a ninth ACK/NACK clock. The byte transmitter
releases SDA for the receiver's acknowledgement. A controller reading its last byte sends NACK
before STOP. Releasing SCL does not establish a high phase until the observed line is high.

## Master/controller reference
`i2c_byte_master` performs START, address+R/W, address ACK, one data byte, data ACK/NACK and STOP.
It captures address/direction/TX on `start && !busy`. Writes report target NACK; reads drive the
final NACK themselves. `done` pulses once and `nack`/`error` remain until the next command/reset.
A wrong address stops after address NACK without sending the data byte. Clock stretching is
handled by the bit engine. Bus-busy and stretch timeouts release the bus and set error.
Arbitration loss releases both lines without deliberately issuing STOP; a higher-level retry
policy must wait for bus-free state. This conflict detector is not a complete multi-controller implementation.

The master intentionally implements only a one-byte transaction ending in STOP. To perform the
common register-pointer write followed by repeated-START read, add a message sequencer that
retains ownership and issues repeated START without STOP. Do not substitute two STOP-separated
transactions when the target requires a combined transaction. Latch each message descriptor and
propagate NACK/timeout status; bound retries according to the caller's policy, not indefinitely.

`i2c_bit_engine` is a helper, not a whole controller. Command it only after a surrounding sequencer
owns the bus and holds SCL low. A successful bit returns with SCL held low; an abort releases both
outputs. It synchronizes bus observations. LOW_CYCLES/HIGH_CYCLES are clock counts, NOT a declared
bus rate: derive them from the actual system clock and the selected mode's minimum low/high,
START/STOP setup/hold, data timing, rise/fall and bus-free requirements. The small defaults and
accelerated regression counts illustrate sequencing; they are not a 100-kHz timing configuration.
Allow synchronizer/filter latency. TIMEOUT_CYCLES is a local recovery policy, not an I2C-specified
mandatory timeout. Add spike filtering and timing constraints for the real pads as needed.

## Slave/target reference
`i2c_byte_slave` detects START/STOP on synchronized bus samples, compares address and direction,
ACKs only its own address, receives multiple bytes, and transmits bytes until controller NACK.
Repeated START discards partial transaction state and begins a new address. A nonmatching target
remains released. It changes its SDA drive on falling SCL edges and samples on rising edges.
ACK occupies the entire ninth clock; do not release it immediately after counting eight bits.
On reads, the target releases SDA for the controller ACK/NACK and stops transmitting after NACK.

This target never stretches SCL. TX must be available at address acceptance and subsequent byte
reloads; RX pulses must always be consumed. Add a holding register/FIFO if the application cannot
meet those requirements. To implement target stretching, add a separate open-drain SCL enable,
assert it while SCL is low, retain protocol state until data is available, then release and wait
for observed SCL high. Do not acknowledge unavailable receive storage and then discard the byte.

Both examples use synchronous reset that releases their drive enables; reset is an abort, not a
valid bus STOP. Require system-clock oversampling with at least eight clocks in each external
SCL half-period for the target example, plus timing margin. Do not run it at arbitrary SCL speed.
Bus-clear recovery (up to nine clocks and STOP, when appropriate) is a separate system policy;
do not initiate recovery while another controller legitimately owns the bus.

## Verification
Tests use resolved wired-AND bus behavior, addressed reads/writes, nonmatching-address NACK,
TX capture, stretching, bus-busy timeout and reset recovery. An independent bit-banged controller
checks target multi-byte writes, repeated START, continued reads after ACK and release after final
NACK/STOP. Bit-engine tests separately check arbitration loss, stretch timeout and pad release.
Add checks for physical timing/filtering, target RX overflow/TX starvation, mid-byte STOP/reset,
long messages, repeated-START controller support and multiple-controller operation only when
those features are actually implemented. Do not claim tests of an omitted feature have passed.

## Language-specific implementation
Use VHDL-2008 with numeric_std, declarations before the architecture begin, explicit conversions
and one driver per register. Signal assignments take effect after the process; use variables
only for deliberate next-value calculations. Compile dependencies before their users.

## Reference: i2c_bit_engine

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity i2c_bit_engine is
 generic(LOW_CYCLES:positive:=8;HIGH_CYCLES:positive:=8;TIMEOUT_CYCLES:positive:=1024);
 port(clk,rst,cmd_valid:in std_logic;cmd_ready:out std_logic;
 tx_bit,arbitration_check,scl_in,sda_in:in std_logic;
 scl_low,sda_low,done,rx_bit,arbitration_lost,timed_out:out std_logic);
end entity;
architecture rtl of i2c_bit_engine is
 type state_type is (ST_IDLE,ST_LOW,ST_WAIT_HIGH,ST_HIGH);signal state:state_type;
 signal scl_sync,sda_sync:std_logic_vector(1 downto 0);
 attribute ASYNC_REG:string;
 attribute ASYNC_REG of scl_sync:signal is "TRUE";
 attribute ASYNC_REG of sda_sync:signal is "TRUE";
 signal tx_hold,check_hold:std_logic;signal timer:natural;
 signal stretch_timer:natural range 0 to TIMEOUT_CYCLES-1;
begin
 cmd_ready<='1' when state=ST_IDLE else '0';
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then scl_sync<="11";sda_sync<="11";
   else scl_sync<=scl_sync(0) & scl_in;sda_sync<=sda_sync(0) & sda_in;end if;
  end if;
 end process;
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then
    state<=ST_IDLE;scl_low<='0';sda_low<='0';done<='0';rx_bit<='1';arbitration_lost<='0';timed_out<='0';
    tx_hold<='1';check_hold<='0';timer<=0;stretch_timer<=0;
   else
    done<='0';
    case state is
     when ST_IDLE => if cmd_valid='1' then
      scl_low<='1';sda_low<=not tx_bit;tx_hold<=tx_bit;check_hold<=arbitration_check;
      arbitration_lost<='0';timed_out<='0';timer<=LOW_CYCLES-1;state<=ST_LOW;
     end if;
     when ST_LOW => if timer/=0 then timer<=timer-1;
      else scl_low<='0';stretch_timer<=0;state<=ST_WAIT_HIGH;end if;
     when ST_WAIT_HIGH => if scl_sync(1)='1' then timer<=HIGH_CYCLES-1;state<=ST_HIGH;
      elsif stretch_timer=TIMEOUT_CYCLES-1 then
       scl_low<='0';sda_low<='0';timed_out<='1';done<='1';state<=ST_IDLE;
      else stretch_timer<=stretch_timer+1;end if;
     when ST_HIGH => if timer/=0 then timer<=timer-1;
      else
       rx_bit<=sda_sync(1);done<='1';state<=ST_IDLE;
       if check_hold='1' and tx_hold='1' and sda_sync(1)='0' then
        arbitration_lost<='1';scl_low<='0';sda_low<='0';
       else scl_low<='1';end if;
      end if;
    end case;
   end if;
  end if;
 end process;
end architecture;
```

## Reference: i2c_byte_master

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity i2c_byte_master is
 generic(LOW_CYCLES:positive:=8;HIGH_CYCLES:positive:=8;TIMEOUT_CYCLES:positive:=1024);
 port(clk,rst,start,read_transfer:in std_logic;address:in std_logic_vector(6 downto 0);tx_data:in std_logic_vector(7 downto 0);
 scl_in,sda_in:in std_logic;scl_low,sda_low,busy,done,nack,error:out std_logic;rx_data:out std_logic_vector(7 downto 0));
end entity;
architecture rtl of i2c_byte_master is
 type state_type is (ST_IDLE,ST_FREE,ST_START,ST_START_LOW,ST_ISSUE,ST_WAIT,
 ST_STOP_LOW,ST_STOP_WAIT,ST_STOP_HIGH,ST_STOP_RELEASE,ST_ABORT);signal state:state_type;
 signal seq_scl,seq_sda,engine_reset,engine_cmd,engine_ready,engine_scl,engine_sda:std_logic;
 signal engine_done,engine_rx,engine_lost,engine_timeout,send_bit,check_bit:std_logic;
 signal addr_hold,data_hold,rx_r:std_logic_vector(7 downto 0);signal read_hold:std_logic;
 signal index:natural range 0 to 17;signal timer:natural;signal timeout:natural range 0 to TIMEOUT_CYCLES-1;
 signal scl_sync,sda_sync:std_logic_vector(1 downto 0);
 attribute ASYNC_REG:string;
 attribute ASYNC_REG of scl_sync:signal is "TRUE";
 attribute ASYNC_REG of sda_sync:signal is "TRUE";
begin
 busy<='1' when state/=ST_IDLE else '0';scl_low<=seq_scl or engine_scl;sda_low<=seq_sda or engine_sda;rx_data<=rx_r;
 engine_reset<='1' when rst='1' or state=ST_IDLE or state=ST_STOP_LOW or state=ST_ABORT else '0';
 engine_cmd<='1' when state=ST_ISSUE else '0';
 process(all) begin
  send_bit<='1';check_bit<='0';
  if index<8 then send_bit<=addr_hold(7-index);check_bit<='1';
  elsif index>=9 and index<=16 and read_hold='0' then send_bit<=data_hold(16-index);check_bit<='1';end if;
 end process;
 bit_engine:entity work.i2c_bit_engine
 generic map(LOW_CYCLES=>LOW_CYCLES,HIGH_CYCLES=>HIGH_CYCLES,TIMEOUT_CYCLES=>TIMEOUT_CYCLES)
 port map(clk=>clk,rst=>engine_reset,cmd_valid=>engine_cmd,cmd_ready=>engine_ready,tx_bit=>send_bit,arbitration_check=>check_bit,
 scl_in=>scl_in,sda_in=>sda_in,scl_low=>engine_scl,sda_low=>engine_sda,done=>engine_done,rx_bit=>engine_rx,arbitration_lost=>engine_lost,timed_out=>engine_timeout);
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then scl_sync<="11";sda_sync<="11";
   else scl_sync<=scl_sync(0) & scl_in;sda_sync<=sda_sync(0) & sda_in;end if;
  end if;
 end process;
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then
    state<=ST_IDLE;seq_scl<='0';seq_sda<='0';addr_hold<=(others=>'0');data_hold<=(others=>'0');read_hold<='0';
    index<=0;timer<=0;timeout<=0;done<='0';nack<='0';error<='0';rx_r<=(others=>'0');
   else
    done<='0';
    case state is
     when ST_IDLE => if start='1' then
      addr_hold<=address & read_transfer;data_hold<=tx_data;read_hold<=read_transfer;
      index<=0;nack<='0';error<='0';rx_r<=(others=>'0');timeout<=0;timer<=LOW_CYCLES-1;state<=ST_FREE;
     end if;
     when ST_FREE => if timeout=TIMEOUT_CYCLES-1 then error<='1';state<=ST_ABORT;
      else
       timeout<=timeout+1;
       if scl_sync(1)='1' and sda_sync(1)='1' then
        if timer=0 then seq_sda<='1';timer<=HIGH_CYCLES-1;state<=ST_START;else timer<=timer-1;end if;
       else timer<=LOW_CYCLES-1;end if;
      end if;
     when ST_START => if timer/=0 then timer<=timer-1;
      else seq_scl<='1';timer<=LOW_CYCLES-1;state<=ST_START_LOW;end if;
     when ST_START_LOW => if timer/=0 then timer<=timer-1;else seq_sda<='0';state<=ST_ISSUE;end if;
     when ST_ISSUE => if engine_ready='1' then seq_scl<='0';state<=ST_WAIT;end if;
     when ST_WAIT => if engine_done='1' then
      if engine_lost='1' or engine_timeout='1' then error<='1';state<=ST_ABORT;
      else
       if read_hold='1' and index>=9 and index<=16 then rx_r<=rx_r(6 downto 0) & engine_rx;end if;
       if (index=8 or (index=17 and read_hold='0')) and engine_rx='1' then nack<='1';end if;
       if index=17 or (index=8 and engine_rx='1') then
        seq_scl<='1';seq_sda<='1';timer<=LOW_CYCLES-1;state<=ST_STOP_LOW;
       else index<=index+1;state<=ST_ISSUE;end if;
      end if;
     end if;
     when ST_STOP_LOW => if timer/=0 then timer<=timer-1;
      else seq_scl<='0';timeout<=0;state<=ST_STOP_WAIT;end if;
     when ST_STOP_WAIT => if scl_sync(1)='1' then timer<=HIGH_CYCLES-1;state<=ST_STOP_HIGH;
      elsif timeout=TIMEOUT_CYCLES-1 then error<='1';state<=ST_ABORT;else timeout<=timeout+1;end if;
     when ST_STOP_HIGH => if timer/=0 then timer<=timer-1;
      else seq_sda<='0';timer<=LOW_CYCLES-1;state<=ST_STOP_RELEASE;end if;
     when ST_STOP_RELEASE => if timer/=0 then timer<=timer-1;else done<='1';state<=ST_IDLE;end if;
     when ST_ABORT => seq_scl<='0';seq_sda<='0';done<='1';state<=ST_IDLE;
    end case;
   end if;
  end if;
 end process;
end architecture;
```

## Reference: i2c_byte_slave

```vhdl
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
entity i2c_byte_slave is
 generic(ADDRESS:std_logic_vector(6 downto 0):="1000010");
 port(clk,rst,scl_in,sda_in:in std_logic;tx_data:in std_logic_vector(7 downto 0);
 sda_low,rx_valid:out std_logic;rx_data:out std_logic_vector(7 downto 0));
end entity;
architecture rtl of i2c_byte_slave is
 type state_type is (ST_IDLE,ST_ADDR,ST_ADDR_ACK,ST_RX,ST_RX_ACK,ST_TX,ST_TX_ACK,ST_WAIT_STOP);
 signal state:state_type;signal scl_sync,sda_sync:std_logic_vector(1 downto 0);
 attribute ASYNC_REG:string;
 attribute ASYNC_REG of scl_sync:signal is "TRUE";
 attribute ASYNC_REG of sda_sync:signal is "TRUE";
 signal scl_prev,sda_prev,read_hold,ack_seen,nack_hold:std_logic;
 signal bit_index:natural range 0 to 7;signal shift_r,tx_hold:std_logic_vector(7 downto 0);
 signal rise_scl,fall_scl,start_seen,stop_seen:std_logic;
begin
 rise_scl<=scl_sync(1) and not scl_prev;fall_scl<=not scl_sync(1) and scl_prev;
 start_seen<=scl_sync(1) and scl_prev and sda_prev and not sda_sync(1);
 stop_seen<=scl_sync(1) and scl_prev and not sda_prev and sda_sync(1);
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then scl_sync<="11";sda_sync<="11";
   else scl_sync<=scl_sync(0) & scl_in;sda_sync<=sda_sync(0) & sda_in;end if;
  end if;
 end process;
 process(clk) begin
  if rising_edge(clk) then
   if rst='1' then
    state<=ST_IDLE;scl_prev<='1';sda_prev<='1';read_hold<='0';ack_seen<='0';nack_hold<='0';
    bit_index<=7;shift_r<=(others=>'0');tx_hold<=(others=>'0');sda_low<='0';rx_valid<='0';rx_data<=(others=>'0');
   else
    scl_prev<=scl_sync(1);sda_prev<=sda_sync(1);rx_valid<='0';
    if start_seen='1' then state<=ST_ADDR;bit_index<=7;shift_r<=(others=>'0');sda_low<='0';
    elsif stop_seen='1' then state<=ST_IDLE;sda_low<='0';
    else
     case state is
      when ST_ADDR => if rise_scl='1' then
       shift_r<=shift_r(6 downto 0) & sda_sync(1);
       if bit_index=0 then
        if shift_r(6 downto 0)=ADDRESS then read_hold<=sda_sync(1);tx_hold<=tx_data;ack_seen<='0';state<=ST_ADDR_ACK;
        else state<=ST_WAIT_STOP;end if;
       else bit_index<=bit_index-1;end if;
      end if;
      when ST_ADDR_ACK =>
       if rise_scl='1' then ack_seen<='1';end if;
       if fall_scl='1' then
        if ack_seen='0' then sda_low<='1';
        else
         bit_index<=7;shift_r<=(others=>'0');
         if read_hold='1' then sda_low<=not tx_hold(7);state<=ST_TX;else sda_low<='0';state<=ST_RX;end if;
        end if;
       end if;
      when ST_RX => if rise_scl='1' then
       shift_r<=shift_r(6 downto 0) & sda_sync(1);
       if bit_index=0 then rx_data<=shift_r(6 downto 0) & sda_sync(1);rx_valid<='1';ack_seen<='0';state<=ST_RX_ACK;
       else bit_index<=bit_index-1;end if;
      end if;
      when ST_RX_ACK =>
       if rise_scl='1' then ack_seen<='1';end if;
       if fall_scl='1' then
        if ack_seen='0' then sda_low<='1';else sda_low<='0';bit_index<=7;state<=ST_RX;end if;
       end if;
      when ST_TX =>
       if rise_scl='1' then
        if bit_index=0 then ack_seen<='0';state<=ST_TX_ACK;else bit_index<=bit_index-1;end if;
       end if;
       if fall_scl='1' then sda_low<=not tx_hold(bit_index);end if;
      when ST_TX_ACK =>
       if rise_scl='1' then ack_seen<='1';nack_hold<=sda_sync(1);end if;
       if fall_scl='1' then
        if ack_seen='0' then sda_low<='0';
        elsif nack_hold='1' then sda_low<='0';state<=ST_WAIT_STOP;
        else tx_hold<=tx_data;sda_low<=not tx_data(7);bit_index<=7;state<=ST_TX;end if;
       end if;
      when others => sda_low<='0';
     end case;
    end if;
   end if;
  end if;
 end process;
end architecture;
```

## Specification and validation

[NXP I2C-bus specification, UM10204](https://www.nxp.com/docs/en/user-guide/UM10204.pdf). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
