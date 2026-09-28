# I2C master and slave protocol guidance (SystemVerilog)

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
Use SystemVerilog with explicit widths, nonblocking clocked assignments and one driver per
register. Do not declare a dynamic address as a localparam, initialize a static local variable
from a live signal, or split one state register across multiple always_ff blocks.

## Reference: i2c_bit_engine

```systemverilog
module i2c_bit_engine #(parameter int LOW_CYCLES=8,HIGH_CYCLES=8,TIMEOUT_CYCLES=1024)(
 input logic clk,rst,cmd_valid,output logic cmd_ready,
 input logic tx_bit,arbitration_check,input logic scl_in,sda_in,
 output logic scl_low,sda_low,done,rx_bit,arbitration_lost,timed_out);
 // *_low=1 drives zero; *_low=0 releases the open-drain pad.
 typedef enum logic [1:0] {ST_IDLE,ST_LOW,ST_WAIT_HIGH,ST_HIGH} state_t;
 state_t state;
 (* ASYNC_REG="TRUE" *) logic [1:0] scl_sync,sda_sync;
 logic tx_hold,check_hold;integer timer,stretch_timer;
 assign cmd_ready=(state==ST_IDLE);
 always_ff @(posedge clk) begin
  if(rst) begin scl_sync<=2'b11;sda_sync<=2'b11;end
  else begin scl_sync<={scl_sync[0],scl_in};sda_sync<={sda_sync[0],sda_in};end
 end
 always_ff @(posedge clk) begin
  if(rst) begin
   state<=ST_IDLE;scl_low<=0;sda_low<=0;done<=0;rx_bit<=1;
   arbitration_lost<=0;timed_out<=0;tx_hold<=1;check_hold<=0;timer<=0;stretch_timer<=0;
  end else begin
   done<=0;
   case(state)
    ST_IDLE: if(cmd_valid) begin
     scl_low<=1;sda_low<=!tx_bit;tx_hold<=tx_bit;check_hold<=arbitration_check;
     arbitration_lost<=0;timed_out<=0;timer<=LOW_CYCLES-1;state<=ST_LOW;
    end
    ST_LOW: if(timer!=0) timer<=timer-1;
     else begin scl_low<=0;stretch_timer<=0;state<=ST_WAIT_HIGH;end
    ST_WAIT_HIGH: if(scl_sync[1]) begin timer<=HIGH_CYCLES-1;state<=ST_HIGH;end
     else if(stretch_timer==TIMEOUT_CYCLES-1) begin
      scl_low<=0;sda_low<=0;timed_out<=1;done<=1;state<=ST_IDLE;
     end else stretch_timer<=stretch_timer+1;
    ST_HIGH: if(timer!=0) timer<=timer-1;
     else begin
      rx_bit<=sda_sync[1];done<=1;state<=ST_IDLE;
      if(check_hold && tx_hold && !sda_sync[1]) begin
       arbitration_lost<=1;scl_low<=0;sda_low<=0;
      end else scl_low<=1;
     end
    default: state<=ST_IDLE;
   endcase
  end
 end
endmodule
```

## Reference: i2c_byte_master

```systemverilog
module i2c_byte_master #(parameter int LOW_CYCLES=8,HIGH_CYCLES=8,TIMEOUT_CYCLES=1024)(
 input logic clk,rst,start,read_transfer,input logic [6:0] address,input logic [7:0] tx_data,
 input logic scl_in,sda_in,
 output logic scl_low,sda_low,busy,done,nack,error,output logic [7:0] rx_data);
 typedef enum logic [3:0] {ST_IDLE,ST_FREE,ST_START,ST_START_LOW,ST_ISSUE,ST_WAIT,
 ST_STOP_LOW,ST_STOP_WAIT,ST_STOP_HIGH,ST_STOP_RELEASE,ST_ABORT} state_t;
 state_t state;
 logic seq_scl,seq_sda,engine_reset,engine_cmd,engine_ready,engine_scl,engine_sda;
 logic engine_done,engine_rx,engine_lost,engine_timeout,send_bit,check_bit;
 logic [7:0] addr_hold,data_hold;logic read_hold;logic [4:0] index;integer timer,timeout;
 (* ASYNC_REG="TRUE" *) logic [1:0] scl_sync,sda_sync;
 assign busy=(state!=ST_IDLE);assign scl_low=seq_scl || engine_scl;assign sda_low=seq_sda || engine_sda;
 assign engine_reset=rst || state==ST_IDLE || state==ST_STOP_LOW || state==ST_ABORT;
 assign engine_cmd=(state==ST_ISSUE);
 always_comb begin
  send_bit=1;check_bit=0;
  if(index<8) begin send_bit=addr_hold[3'(7-index)];check_bit=1;end
  else if(index>=9 && index<=16 && !read_hold) begin send_bit=data_hold[3'(16-index)];check_bit=1;end
 end
 i2c_bit_engine #(.LOW_CYCLES(LOW_CYCLES),.HIGH_CYCLES(HIGH_CYCLES),.TIMEOUT_CYCLES(TIMEOUT_CYCLES)) bit_engine(
 .clk(clk),.rst(engine_reset),.cmd_valid(engine_cmd),.cmd_ready(engine_ready),.tx_bit(send_bit),.arbitration_check(check_bit),
 .scl_in(scl_in),.sda_in(sda_in),.scl_low(engine_scl),.sda_low(engine_sda),.done(engine_done),.rx_bit(engine_rx),.arbitration_lost(engine_lost),.timed_out(engine_timeout));
 always_ff @(posedge clk) begin
  if(rst) begin scl_sync<=3;sda_sync<=3;end
  else begin scl_sync<={scl_sync[0],scl_in};sda_sync<={sda_sync[0],sda_in};end
 end
 always_ff @(posedge clk) begin
  if(rst) begin
   state<=ST_IDLE;seq_scl<=0;seq_sda<=0;addr_hold<=0;data_hold<=0;read_hold<=0;
   index<=0;timer<=0;timeout<=0;done<=0;nack<=0;error<=0;rx_data<=0;
  end else begin
   done<=0;
   case(state)
    ST_IDLE: if(start) begin
     addr_hold<={address,read_transfer};data_hold<=tx_data;read_hold<=read_transfer;
     index<=0;nack<=0;error<=0;rx_data<=0;timeout<=0;timer<=LOW_CYCLES-1;state<=ST_FREE;
    end
    ST_FREE: if(timeout==TIMEOUT_CYCLES-1) begin error<=1;state<=ST_ABORT;end
     else begin
      timeout<=timeout+1;
      if(scl_sync[1] && sda_sync[1]) begin
       if(timer==0) begin seq_sda<=1;timer<=HIGH_CYCLES-1;state<=ST_START;end else timer<=timer-1;
      end else timer<=LOW_CYCLES-1;
     end
    ST_START: if(timer!=0) timer<=timer-1;
     else begin seq_scl<=1;timer<=LOW_CYCLES-1;state<=ST_START_LOW;end
    ST_START_LOW: if(timer!=0) timer<=timer-1;else begin seq_sda<=0;state<=ST_ISSUE;end
    ST_ISSUE: if(engine_ready) begin seq_scl<=0;state<=ST_WAIT;end
    ST_WAIT: if(engine_done) begin
     if(engine_lost || engine_timeout) begin error<=1;state<=ST_ABORT;end
     else begin
      if(read_hold && index>=9 && index<=16) rx_data<={rx_data[6:0],engine_rx};
      if((index==8 || (index==17 && !read_hold)) && engine_rx) nack<=1;
      if(index==17 || (index==8 && engine_rx)) begin
       seq_scl<=1;seq_sda<=1;timer<=LOW_CYCLES-1;state<=ST_STOP_LOW;
      end else begin index<=index+1;state<=ST_ISSUE;end
     end
    end
    ST_STOP_LOW: if(timer!=0) timer<=timer-1;
     else begin seq_scl<=0;timeout<=0;state<=ST_STOP_WAIT;end
    ST_STOP_WAIT: if(scl_sync[1]) begin timer<=HIGH_CYCLES-1;state<=ST_STOP_HIGH;end
     else if(timeout==TIMEOUT_CYCLES-1) begin error<=1;state<=ST_ABORT;end else timeout<=timeout+1;
    ST_STOP_HIGH: if(timer!=0) timer<=timer-1;
     else begin seq_sda<=0;timer<=LOW_CYCLES-1;state<=ST_STOP_RELEASE;end
    ST_STOP_RELEASE: if(timer!=0) timer<=timer-1;else begin done<=1;state<=ST_IDLE;end
    ST_ABORT: begin seq_scl<=0;seq_sda<=0;done<=1;state<=ST_IDLE;end
    default: state<=ST_ABORT;
   endcase
  end
 end
endmodule
```

## Reference: i2c_byte_slave

```systemverilog
module i2c_byte_slave #(parameter logic [6:0] ADDRESS=7'h42)(
 input logic clk,rst,scl_in,sda_in,input logic [7:0] tx_data,
 output logic sda_low,rx_valid,output logic [7:0] rx_data);
 // Addressed byte target: no clock stretching; tx_data must already be available.
 typedef enum logic [3:0] {ST_IDLE,ST_ADDR,ST_ADDR_ACK,ST_RX,ST_RX_ACK,ST_TX,ST_TX_ACK,ST_WAIT_STOP} state_t;
 state_t state;
 (* ASYNC_REG="TRUE" *) logic [1:0] scl_sync,sda_sync;
 logic scl_prev,sda_prev,read_hold,ack_seen,nack_hold;
 logic [2:0] bit_index;logic [7:0] shift_r,tx_hold;
 logic rise_scl,fall_scl,start_seen,stop_seen;
 assign rise_scl=scl_sync[1] && !scl_prev;assign fall_scl=!scl_sync[1] && scl_prev;
 assign start_seen=scl_sync[1] && scl_prev && sda_prev && !sda_sync[1];
 assign stop_seen=scl_sync[1] && scl_prev && !sda_prev && sda_sync[1];
 always_ff @(posedge clk) begin
  if(rst) begin scl_sync<=3;sda_sync<=3;end
  else begin scl_sync<={scl_sync[0],scl_in};sda_sync<={sda_sync[0],sda_in};end
 end
 always_ff @(posedge clk) begin
  if(rst) begin
   state<=ST_IDLE;scl_prev<=1;sda_prev<=1;read_hold<=0;ack_seen<=0;nack_hold<=0;
   bit_index<=7;shift_r<=0;tx_hold<=0;sda_low<=0;rx_valid<=0;rx_data<=0;
  end else begin
   scl_prev<=scl_sync[1];sda_prev<=sda_sync[1];rx_valid<=0;
   if(start_seen) begin state<=ST_ADDR;bit_index<=7;shift_r<=0;sda_low<=0;end
   else if(stop_seen) begin state<=ST_IDLE;sda_low<=0;end
   else case(state)
    ST_ADDR: if(rise_scl) begin
     shift_r<={shift_r[6:0],sda_sync[1]};
     if(bit_index==0) begin
      if(shift_r[6:0]==ADDRESS) begin read_hold<=sda_sync[1];tx_hold<=tx_data;ack_seen<=0;state<=ST_ADDR_ACK;end
      else state<=ST_WAIT_STOP;
     end else bit_index<=bit_index-1'b1;
    end
    ST_ADDR_ACK: begin
     if(rise_scl) ack_seen<=1;
     if(fall_scl) begin
      if(!ack_seen) sda_low<=1;
      else begin
       bit_index<=7;shift_r<=0;sda_low<=read_hold ? !tx_hold[7] : 1'b0;
       state<=read_hold ? ST_TX : ST_RX;
      end
     end
    end
    ST_RX: if(rise_scl) begin
     shift_r<={shift_r[6:0],sda_sync[1]};
     if(bit_index==0) begin rx_data<={shift_r[6:0],sda_sync[1]};rx_valid<=1;ack_seen<=0;state<=ST_RX_ACK;end
     else bit_index<=bit_index-1'b1;
    end
    ST_RX_ACK: begin
     if(rise_scl) ack_seen<=1;
     if(fall_scl) begin
      if(!ack_seen) sda_low<=1;
      else begin sda_low<=0;bit_index<=7;state<=ST_RX;end
     end
    end
    ST_TX: begin
     if(rise_scl) begin
      if(bit_index==0) begin ack_seen<=0;state<=ST_TX_ACK;end else bit_index<=bit_index-1'b1;
     end
     if(fall_scl) sda_low<=!tx_hold[bit_index];
    end
    ST_TX_ACK: begin
     if(rise_scl) begin ack_seen<=1;nack_hold<=sda_sync[1];end
     if(fall_scl) begin
      if(!ack_seen) sda_low<=0;
      else if(nack_hold) begin sda_low<=0;state<=ST_WAIT_STOP;end
      else begin tx_hold<=tx_data;sda_low<=!tx_data[7];bit_index<=7;state<=ST_TX;end
     end
    end
    default: sda_low<=0;
   endcase
  end
 end
endmodule
```

## Specification and validation

[NXP I2C-bus specification, UM10204](https://www.nxp.com/docs/en/user-guide/UM10204.pdf). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
