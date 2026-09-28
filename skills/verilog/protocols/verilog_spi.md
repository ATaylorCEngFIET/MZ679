# SPI master and slave protocol guidance (SystemVerilog)

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
Use SystemVerilog with explicit widths, nonblocking clocked assignments and one driver per
register. Do not declare a dynamic address as a localparam, initialize a static local variable
from a live signal, or split one state register across multiple always_ff blocks.

## Reference: spi_byte_master

```systemverilog
module spi_byte_master #(parameter int MODE=0, HALF_CYCLES=4)(
 input logic clk,rst,start,input logic [7:0] tx_data,input logic miso,
 output logic busy,done,cs_n,sclk,mosi,output logic [7:0] rx_data);
 localparam bit CPOL=(MODE>=2), CPHA=(MODE%2!=0);
 typedef enum logic [1:0] {ST_IDLE,ST_SHIFT,ST_HOLD} state_t;
 state_t state;
 integer timer;logic [3:0] edge_index;logic [7:0] tx_shift,rx_shift;
 assign busy=(state!=ST_IDLE);
 always_ff @(posedge clk) begin
  if(rst) begin
   state<=ST_IDLE;timer<=0;edge_index<=0;tx_shift<=0;rx_shift<=0;
   done<=0;cs_n<=1;sclk<=CPOL;mosi<=0;rx_data<=0;
  end else begin
   done<=0;
   case(state)
    ST_IDLE: if(start) begin
     tx_shift<=tx_data;rx_shift<=0;edge_index<=0;timer<=HALF_CYCLES-1;
     cs_n<=0;sclk<=CPOL;mosi<=CPHA ? 1'b0 : tx_data[7];state<=ST_SHIFT;
    end
    ST_SHIFT: if(timer!=0) timer<=timer-1;
     else begin
      timer<=HALF_CYCLES-1;sclk<=!sclk;
      if(edge_index[0]==CPHA) rx_shift<={rx_shift[6:0],miso};
      else if(CPHA) begin mosi<=tx_shift[7];tx_shift<={tx_shift[6:0],1'b0};end
      else if(edge_index!=15) begin tx_shift<={tx_shift[6:0],1'b0};mosi<=tx_shift[6];end
      if(edge_index==15) state<=ST_HOLD;else edge_index<=edge_index+1'b1;
     end
    ST_HOLD: if(timer!=0) timer<=timer-1;
     else begin cs_n<=1;rx_data<=rx_shift;done<=1;state<=ST_IDLE;end
    default: state<=ST_IDLE;
   endcase
  end
 end
endmodule
```

## Reference: spi_byte_slave

```systemverilog
module spi_byte_slave #(parameter int MODE=0)(
 input logic clk,rst,cs_n,sclk,mosi,input logic [7:0] tx_data,
 output logic miso,miso_oe,rx_valid,output logic [7:0] rx_data);
 localparam bit CPOL=(MODE>=2),CPHA=(MODE%2!=0);
 (* ASYNC_REG="TRUE" *) logic [1:0] cs_sync,sck_sync,mosi_sync;
 logic cs_prev,sck_prev,selected,reload;
 logic [2:0] bit_count;logic [7:0] tx_shift,rx_shift;
 logic leading,trailing,sample_edge,launch_edge;
 assign miso_oe=!cs_n; // Pad wrapper must tri-state MISO immediately when deselected.
 assign leading=(sck_sync[1]!=sck_prev && sck_sync[1]!=CPOL);
 assign trailing=(sck_sync[1]!=sck_prev && sck_sync[1]==CPOL);
 assign sample_edge=CPHA ? trailing : leading;
 assign launch_edge=CPHA ? leading : trailing;
 always_ff @(posedge clk) begin
  if(rst) begin cs_sync<=2'b11;sck_sync<={2{CPOL}};mosi_sync<=0;end
  else begin cs_sync<={cs_sync[0],cs_n};sck_sync<={sck_sync[0],sclk};mosi_sync<={mosi_sync[0],mosi};end
 end
 always_ff @(posedge clk) begin
  if(rst) begin
   cs_prev<=1;sck_prev<=CPOL;selected<=0;reload<=0;bit_count<=0;
   tx_shift<=0;rx_shift<=0;rx_data<=0;rx_valid<=0;miso<=0;
  end else begin
   cs_prev<=cs_sync[1];sck_prev<=sck_sync[1];rx_valid<=0;
   if(cs_sync[1]) begin selected<=0;bit_count<=0;reload<=0;end
   else if(cs_prev) begin
    selected<=1;bit_count<=0;reload<=0;tx_shift<=tx_data;rx_shift<=0;
    miso<=CPHA ? 1'b0 : tx_data[7];
   end else if(selected) begin
    if(sample_edge) begin
     rx_shift<={rx_shift[6:0],mosi_sync[1]};bit_count<=bit_count+1'b1;
     if(bit_count==7) begin rx_data<={rx_shift[6:0],mosi_sync[1]};rx_valid<=1;reload<=1;end
    end
    if(launch_edge) begin
     if(reload) begin
      miso<=tx_data[7];tx_shift<=CPHA ? {tx_data[6:0],1'b0} : tx_data;reload<=0;
     end else if(CPHA) begin miso<=tx_shift[7];tx_shift<={tx_shift[6:0],1'b0};end
     else begin miso<=tx_shift[6];tx_shift<={tx_shift[6:0],1'b0};end
    end
   end
  end
 end
endmodule
```

## Specification and validation

[Microchip SPI introduction and device timing documentation](https://developerhelp.microchip.com/xwiki/bin/view/applications/SPI/). These examples are original teaching implementations, not vendor IP.
See [the validation record](../../PROTOCOL_VALIDATION.md) for tested configurations and limits.
