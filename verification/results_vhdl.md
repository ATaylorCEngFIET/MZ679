# VHDL model verification
Generated 2026-09-27T14:02:34+01:00.
Behavioral pass, request compliance and Blue Pearl findings are separate measures. PASS_TESTED covers the checks documented below.
| Model | Behavioral pass / 6 | Request pass / 6 | Compile failures | Lint errors | Lint warnings | Lint incomplete |
|---|---:|---:|---:|---:|---:|---:|
| bluepearl-rtl | 3 | 3 | 1 | 6 | 9 | 0 |
| gemma4-fpga | 2 | 1 | 3 | 37 | 6 | 0 |
| qwen-fpga | 1 | 1 | 3 | 39 | 5 | 0 |
| qwen3-coder:30b | 3 | 2 | 2 | 13 | 1 | 0 |
| qwen3.5:4b | 2 | 1 | 4 | 82 | 13 | 0 |
| qwen3.8-flash-next | 3 | 2 | 1 | 7 | 27 | 0 |
| qwen3.8:27b | 2 | 1 | 3 | 20 | 0 | 0 |

## Per-design results

| Model | Request | Simulation | Against request | Blue Pearl errors / warnings | Evidence |
|---|---|---|---|---:|---|
| bluepearl-rtl | counter | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/counter.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/counter/bps_final/bluepearl.log) |
| bluepearl-rtl | cdc_sync | COMPILE_FAIL | COMPILE_FAIL | 6 / 0 | [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/cdc_sync.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/cdc_sync/bps_final/bluepearl.log) |
| bluepearl-rtl | axi_lite | FAIL | FAIL | 0 / 1 | [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/axi_lite.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/axi_lite/bps_final/bluepearl.log) |
| bluepearl-rtl | uart_tx | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/uart_tx.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/uart_tx/bps_final/bluepearl.log) |
| bluepearl-rtl | fifo | FAIL | FAIL | 0 / 8 | [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/fifo.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/fifo/bps_final/bluepearl.log) |
| bluepearl-rtl | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/bugfix.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/bugfix/bps_final/bluepearl.log) |
| gemma4-fpga | counter | PASS | REQUEST_MISMATCH | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/counter.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/counter/bps_final/bluepearl.log) |
| gemma4-fpga | cdc_sync | COMPILE_FAIL | COMPILE_FAIL | 12 / 0 | [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/cdc_sync.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/cdc_sync/bps_final/bluepearl.log) |
| gemma4-fpga | axi_lite | FAIL | FAIL | 0 / 6 | [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/axi_lite.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/axi_lite/bps_final/bluepearl.log) |
| gemma4-fpga | uart_tx | COMPILE_FAIL | COMPILE_FAIL | 20 / 0 | [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/uart_tx.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/uart_tx/bps_final/bluepearl.log) |
| gemma4-fpga | fifo | COMPILE_FAIL | COMPILE_FAIL | 5 / 0 | [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/fifo.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/fifo/bps_final/bluepearl.log) |
| gemma4-fpga | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/bugfix.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/bugfix/bps_final/bluepearl.log) |
| qwen-fpga | counter | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen-fpga/counter.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/counter/bps_final/bluepearl.log) |
| qwen-fpga | cdc_sync | COMPILE_FAIL | COMPILE_FAIL | 25 / 1 | [RTL](../20260921-035335-vhdl-skill/qwen-fpga/cdc_sync.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/cdc_sync/bps_final/bluepearl.log) |
| qwen-fpga | axi_lite | COMPILE_FAIL | COMPILE_FAIL | 7 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen-fpga/axi_lite.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/axi_lite/bps_final/bluepearl.log) |
| qwen-fpga | uart_tx | INTERFACE_FAIL | INTERFACE_FAIL | 0 / 4 | [RTL](../20260921-035335-vhdl-skill/qwen-fpga/uart_tx.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/uart_tx/bps_final/bluepearl.log) |
| qwen-fpga | fifo | COMPILE_FAIL | COMPILE_FAIL | 3 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen-fpga/fifo.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/fifo/bps_final/bluepearl.log) |
| qwen-fpga | bugfix | FAIL | FAIL | 4 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen-fpga/bugfix.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/bugfix/bps_final/bluepearl.log) |
| qwen3-coder:30b | counter | PASS | REQUEST_MISMATCH | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/counter.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/counter/bps_final/bluepearl.log) |
| qwen3-coder:30b | cdc_sync | PASS | PASS_TESTED | 0 / 1 | [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/cdc_sync.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/cdc_sync/bps_final/bluepearl.log) |
| qwen3-coder:30b | axi_lite | COMPILE_FAIL | COMPILE_FAIL | 5 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/axi_lite.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/axi_lite/bps_final/bluepearl.log) |
| qwen3-coder:30b | uart_tx | FAIL | FAIL | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/uart_tx.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/uart_tx/bps_final/bluepearl.log) |
| qwen3-coder:30b | fifo | COMPILE_FAIL | COMPILE_FAIL | 8 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/fifo.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/fifo/bps_final/bluepearl.log) |
| qwen3-coder:30b | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/bugfix.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/bugfix/bps_final/bluepearl.log) |
| qwen3.5:4b | counter | PASS | REQUEST_MISMATCH | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/counter.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/counter/bps_final/bluepearl.log) |
| qwen3.5:4b | cdc_sync | COMPILE_FAIL | COMPILE_FAIL | 16 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/cdc_sync.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/cdc_sync/bps_final/bluepearl.log) |
| qwen3.5:4b | axi_lite | COMPILE_FAIL | COMPILE_FAIL | 42 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/axi_lite.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/axi_lite/bps_final/bluepearl.log) |
| qwen3.5:4b | uart_tx | COMPILE_FAIL | COMPILE_FAIL | 17 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/uart_tx.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/uart_tx/bps_final/bluepearl.log) |
| qwen3.5:4b | fifo | COMPILE_FAIL | COMPILE_FAIL | 7 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/fifo.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/fifo/bps_final/bluepearl.log) |
| qwen3.5:4b | bugfix | PASS | PASS_TESTED | 0 / 13 | [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/bugfix.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/bugfix/bps_final/bluepearl.log) |
| qwen3.8-flash-next | counter | PASS | REQUEST_MISMATCH | 0 / 0 | [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/counter.vhd) / [lint](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/counter/bps_final/bluepearl.log) |
| qwen3.8-flash-next | cdc_sync | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/cdc_sync.vhd) / [lint](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/cdc_sync/bps_final/bluepearl.log) |
| qwen3.8-flash-next | axi_lite | FAIL | FAIL | 0 / 19 | [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/axi_lite.vhd) / [lint](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/axi_lite/bps_final/bluepearl.log) |
| qwen3.8-flash-next | uart_tx | FAIL | FAIL | 0 / 8 | [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/uart_tx.vhd) / [lint](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/uart_tx/bps_final/bluepearl.log) |
| qwen3.8-flash-next | fifo | COMPILE_FAIL | COMPILE_FAIL | 7 / 0 | [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/fifo.vhd) / [lint](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/fifo/bps_final/bluepearl.log) |
| qwen3.8-flash-next | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/bugfix.vhd) / [lint](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/bugfix/bps_final/bluepearl.log) |
| qwen3.8:27b | counter | PASS | REQUEST_MISMATCH | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/counter.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/counter/bps_final/bluepearl.log) |
| qwen3.8:27b | cdc_sync | COMPILE_FAIL | COMPILE_FAIL | 5 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/cdc_sync.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/cdc_sync/bps_final/bluepearl.log) |
| qwen3.8:27b | axi_lite | COMPILE_FAIL | COMPILE_FAIL | 4 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/axi_lite.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/axi_lite/bps_final/bluepearl.log) |
| qwen3.8:27b | uart_tx | FAIL | FAIL | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/uart_tx.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/uart_tx/bps_final/bluepearl.log) |
| qwen3.8:27b | fifo | COMPILE_FAIL | COMPILE_FAIL | 11 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/fifo.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/fifo/bps_final/bluepearl.log) |
| qwen3.8:27b | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/bugfix.vhd) / [lint](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/bugfix/bps_final/bluepearl.log) |

### bluepearl-rtl — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/counter/compile.log) · [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/counter.vhd)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/counter/sim_default.log)

### bluepearl-rtl — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- The array is indexed 0 through g_stages, creating g_stages+1 flops. The attribute specification is also in the architecture statement region; see compiler errors.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\bluepearl-rtl\cdc_sync.vhd(33): near "ATTRIBUTE": syntax error

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1223 error x1, VHDL-1261 error x1, VHDL-1275 error x1, VHDL-1276 error x1, VHDL-1284 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/cdc_sync/compile.log) · [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/cdc_sync.vhd)

### bluepearl-rtl — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-035335-vhdl-skill

**Result:** FAIL; simulation FAIL; 150 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- BVALID independent of BREADY
- exposed register 1
- readback register 1 expected cafe9876 actual 03254769
- exposed register 2
- readback register 2 expected 87654321 actual 3016745a

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/axi_lite/compile.log) · [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/axi_lite.vhd)
- default: FAIL; 150 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/axi_lite/sim_default.log)

### bluepearl-rtl — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/uart_tx/compile.log) · [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/uart_tx.vhd)
- default: PASS; 624 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/uart_tx/sim_default.log)
- divisor13: PASS; 1004 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/uart_tx/sim_divisor13.log)

### bluepearl-rtl — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-035335-vhdl-skill

**Result:** FAIL; simulation FAIL; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- Read data is a concurrent RAM lookup, rather than a clocked RAM read. This does not implement the requested synchronous block-RAM read structure.
- FIFO ordering / synchronous read

**Blue Pearl:** COMPLETE. BPS-0272 warning x6, BPS-0552 warning x1, VHDL-1794 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/fifo/compile.log) · [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/fifo.vhd)
- default: FAIL; 3455 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/fifo/sim_default.log)
- width16_depth4: FAIL; 3381 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/fifo/sim_width16_depth4.log)

### bluepearl-rtl — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/bugfix/compile.log) · [RTL](../20260921-035335-vhdl-skill/bluepearl-rtl/bugfix.vhd)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/bluepearl-rtl/bugfix/sim_default.log)

### gemma4-fpga — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260921-035335-vhdl-skill

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/counter/compile.log) · [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/counter.vhd)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/counter/sim_default.log)

### gemma4-fpga — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- Required ASYNC_REG attribute missing from code.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\gemma4-fpga\cdc_sync.vhd(10): near "map": (vcom-1576) expecting '('.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1059 error x1, VHDL-1241 error x9, VHDL-1261 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/cdc_sync/compile.log) · [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/cdc_sync.vhd)

### gemma4-fpga — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-035335-vhdl-skill

**Result:** FAIL; simulation FAIL; 118 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- Missing requested/AXI port reg0
- Missing requested/AXI port reg1
- Missing requested/AXI port reg2
- Missing requested/AXI port reg3
- B stable while stalled
- readback register 0 expected 12345678 actual 21524111
- R data/valid stable while stalled
- readback register 1 expected 03254769 actual 21524111
- readback register 2 expected 3016745a actual 21524111
- readback register 3 expected 2107654b actual 21524111
- BVALID independent of BREADY
- readback register 1 expected cafe9876 actual 21524111
- readback register 2 expected 87654321 actual 21524111
- readback register 0 expected 12bb56dd actual 21524111

**Blue Pearl:** COMPLETE. BPS-0534 warning x6.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/axi_lite/compile.log) · [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/axi_lite.vhd)
- default: FAIL; 118 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/axi_lite/sim_default.log)

### gemma4-fpga — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\gemma4-fpga\uart_tx.vhd(29): near "ENUM": syntax error

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1036 error x2, VHDL-1241 error x12, VHDL-1261 error x2, VHDL-1284 error x1, VHDL-1432 error x1, VHDL-1520 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/uart_tx/compile.log) · [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/uart_tx.vhd)

### gemma4-fpga — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\gemma4-fpga\fifo.vhd(6): near "map": (vcom-1576) expecting '('.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1059 error x1, VHDL-1241 error x1, VHDL-1261 error x1, VHDL-1283 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/fifo/compile.log) · [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/fifo.vhd)

### gemma4-fpga — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/bugfix/compile.log) · [RTL](../20260921-035335-vhdl-skill/gemma4-fpga/bugfix.vhd)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/gemma4-fpga/bugfix/sim_default.log)

### qwen-fpga — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/counter/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen-fpga/counter.vhd)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/counter/sim_default.log)

### qwen-fpga — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- ASYNC_REG is declared but no attribute specification attaches it to the synchronizer signals.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\cdc_sync.vhd(57): near "TYPE": syntax error
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\cdc_sync.vhd(70): (vcom-1136) Unknown identifier "s".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\cdc_sync.vhd(70): Prefix of attribute "range" must be appropriate for an array object or must denote an array subtype.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\cdc_sync.vhd(70): (vcom-1489) Range of a parameter specification must be of a discrete type.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\cdc_sync.vhd(71): (vcom-1136) Unknown identifier "s".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\cdc_sync.vhd(71): (vcom-1581) No feasible entries for infix operator '='.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\cdc_sync.vhd(71): Type error resolving infix expression "=" as type std.STANDARD.BOOLEAN.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\cdc_sync.vhd(72): Illegal target for signal assignment.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, BPS-1005 warning x1, VHDL-1149 error x5, VHDL-1223 error x1, VHDL-1236 error x5, VHDL-1241 error x7, VHDL-1261 error x3, VHDL-1272 error x1, VHDL-1284 error x1, VHDL-1312 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/cdc_sync/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen-fpga/cdc_sync.vhd)

### qwen-fpga — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- Missing requested/AXI port reg0
- Missing requested/AXI port reg1
- Missing requested/AXI port reg2
- Missing requested/AXI port reg3
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\axi_lite.vhd(119): near "?": (vcom-1576) expecting ')'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\axi_lite.vhd(125): (vcom-1581) No feasible entries for prefix operator '??'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\axi_lite.vhd(125): Type error resolving prefix expression "??" as type std.STANDARD.BOOLEAN.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\axi_lite.vhd(125): near "IN": (vcom-1576) expecting ';'.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1052 error x1, VHDL-1261 error x4, VHDL-1284 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/axi_lite/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen-fpga/axi_lite.vhd)

### qwen-fpga — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-035335-vhdl-skill

**Result:** INTERFACE_FAIL; simulation INTERFACE_FAIL; 0 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- Missing required generic/parameter BAUD

**Blue Pearl:** COMPLETE. BPS-0272 warning x4.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/uart_tx/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen-fpga/uart_tx.vhd)

### qwen-fpga — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- Missing required generic/parameter DEPTH
- DEPTH is absent and no RAM or read-data assignment is implemented. Both pointers increment on every clock without enable gating.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen-fpga\fifo.vhd(25): (vcom-1136) Unknown identifier "CEIL_LOG2_REAL".

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1241 error x1, VHDL-1284 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/fifo/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen-fpga/fifo.vhd)

### qwen-fpga — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260921-035335-vhdl-skill

**Result:** FAIL; simulation FAIL; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- output and reset synchronous
- registered mux both paths

**Blue Pearl:** ANALYSIS_ERROR. BPS-0723 error x1, BPS-0752 error x1, ELAB-1000 error x1, ELAB-1001 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/bugfix/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen-fpga/bugfix.vhd)
- default: FAIL; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen-fpga/bugfix/sim_default.log)

### qwen3-coder:30b — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260921-035335-vhdl-skill

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/counter/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/counter.vhd)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/counter/sim_default.log)

### qwen3-coder:30b — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0534 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/cdc_sync/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/cdc_sync.vhd)
- default: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/cdc_sync/sim_stages3.log)

### qwen3-coder:30b — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3-coder_30b\axi_lite.vhd(21): Nonresolved signal 'o_bresp' has multiple sources.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3-coder_30b\axi_lite.vhd(28): Nonresolved signal 'o_rresp' has multiple sources.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, ELAB-1000 error x2, ELAB-1001 error x2.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/axi_lite/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/axi_lite.vhd)

### qwen3-coder:30b — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-035335-vhdl-skill

**Result:** FAIL; simulation FAIL; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- busy during start/data
- 8N1 bit=1 cycle=6 payload=a6
- 8N1 bit=1 cycle=7 payload=a6
- 8N1 bit=3 cycle=6 payload=a6
- 8N1 bit=3 cycle=7 payload=a6
- 8N1 bit=5 cycle=6 payload=a6
- 8N1 bit=5 cycle=7 payload=a6
- 8N1 bit=6 cycle=6 payload=a6
- 8N1 bit=6 cycle=7 payload=a6
- 8N1 bit=7 cycle=6 payload=a6
- 8N1 bit=7 cycle=7 payload=a6
- 8N1 bit=8 cycle=5 payload=00

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/uart_tx/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/uart_tx.vhd)
- default: FAIL; 624 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/uart_tx/sim_default.log)
- divisor13: FAIL; 1004 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/uart_tx/sim_divisor13.log)

### qwen3-coder:30b — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- Read data is a concurrent RAM lookup, rather than a clocked RAM read. This does not implement the requested synchronous block-RAM read structure.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3-coder_30b\fifo.vhd(31): (vcom-1600) No feasible entries for subprogram "LOG2".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3-coder_30b\fifo.vhd(72): (vcom-1581) No feasible entries for infix operator 'and'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3-coder_30b\fifo.vhd(72): Type error resolving infix expression "and" as type ieee.std_logic_1164.STD_ULOGIC.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3-coder_30b\fifo.vhd(74): (vcom-1581) No feasible entries for infix operator 'and'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3-coder_30b\fifo.vhd(74): Type error resolving infix expression "and" as type ieee.std_logic_1164.STD_ULOGIC.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1052 error x4, VHDL-1272 error x1, VHDL-1284 error x1, VHDL-1773 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/fifo/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/fifo.vhd)

### qwen3-coder:30b — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/bugfix/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3-coder_30b/bugfix.vhd)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3-coder_30b/bugfix/sim_default.log)

### qwen3.5:4b — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260921-035335-vhdl-skill

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/counter/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/counter.vhd)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/counter/sim_default.log)

### qwen3.5:4b — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- Required ASYNC_REG attribute missing from code.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\cdc_sync.vhd(14): (vcom-1136) Unknown identifier "i_clk_dst".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\cdc_sync.vhd(14): Bad resolution function (STD_ULOGIC) for type (error).
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\cdc_sync.vhd(14): near ":": (vcom-1576) expecting ';' or ')'.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1059 error x1, VHDL-1241 error x7, VHDL-1261 error x7.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/cdc_sync/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/cdc_sync.vhd)

### qwen3.5:4b — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- Missing requested/AXI port reg0
- Missing requested/AXI port reg1
- Missing requested/AXI port reg2
- Missing requested/AXI port reg3
- Missing requested/AXI port bresp
- Missing required port bvalid
- Missing required port bready
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\axi_lite.vhd(98): near "v_idx": (vcom-1576) expecting == or '+' or '-' or '&'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\axi_lite.vhd(118): near "v_byte_offset": (vcom-1576) expecting == or '+' or '-' or '&'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\axi_lite.vhd(121): (vcom-1136) Unknown identifier "s_wstrb".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\axi_lite.vhd(121): Type error resolving infix expression "=" as type std.STANDARD.BOOLEAN.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\axi_lite.vhd(122): (vcom-1136) Unknown identifier "v_byte_offset".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\axi_lite.vhd(122): (vcom-1591) Bad expression in left bound of range expression.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\axi_lite.vhd(122): (vcom-1136) Unknown identifier "v_byte_offset".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\axi_lite.vhd(122): Target type ieee.NUMERIC_STD.UNRESOLVED_UNSIGNED in signal assignment is different from expression type ieee.std_logic_1164.STD_ULOGIC_VECTOR.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1120 error x4, VHDL-1241 error x12, VHDL-1261 error x5, VHDL-1272 error x4, VHDL-1284 error x1, VHDL-1312 error x10, VHDL-1352 error x5.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/axi_lite/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/axi_lite.vhd)

### qwen3.5:4b — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- Missing required generic/parameter BAUD
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\uart_tx.vhd(11): (vcom-1136) Unknown identifier "i_rst".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\uart_tx.vhd(11): Bad resolution function (STD_ULOGIC) for type (error).
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\uart_tx.vhd(11): near ":": (vcom-1576) expecting ';' or ')'.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1059 error x1, VHDL-1241 error x13, VHDL-1261 error x1, VHDL-1445 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/uart_tx/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/uart_tx.vhd)

### qwen3.5:4b — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.5_4b\fifo.vhd(15): near ";": (vcom-1576) expecting IDENTIFIER.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1261 error x5, VHDL-1284 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/fifo/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/fifo.vhd)

### qwen3.5:4b — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0527 warning x1, BPS-0530 warning x1, BPS-0534 warning x1, BPS-0538 warning x1, BPS-0948 warning x1, VHDL-1840 warning x8.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/bugfix/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.5_4b/bugfix.vhd)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.5_4b/bugfix/sim_default.log)

### qwen3.8-flash-next — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260921-062307-vhdl-skill

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/counter/compile.log) · [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/counter.vhd)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/counter/sim_default.log)

### qwen3.8-flash-next — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260921-062307-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/cdc_sync/compile.log) · [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/cdc_sync.vhd)
- default: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/cdc_sync/sim_stages3.log)

### qwen3.8-flash-next — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-062307-vhdl-skill

**Result:** FAIL; simulation FAIL; 160 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- readback register 0 expected 12345678 actual 00000000
- exposed register 1
- exposed register 2
- readback register 2 expected 87654321 actual 3016745a

**Blue Pearl:** COMPLETE. BPS-0272 warning x14, VHDL-1251 warning x4, VHDL-1613 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/axi_lite/compile.log) · [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/axi_lite.vhd)
- default: FAIL; 160 checks; [simulation log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/axi_lite/sim_default.log)

### qwen3.8-flash-next — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-062307-vhdl-skill

**Result:** FAIL; simulation FAIL; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- 8N1 bit=1 cycle=0 payload=55
- 8N1 bit=2 cycle=0 payload=55
- 8N1 bit=2 cycle=1 payload=55
- 8N1 bit=2 cycle=2 payload=55
- 8N1 bit=2 cycle=3 payload=55
- 8N1 bit=2 cycle=4 payload=55
- 8N1 bit=2 cycle=5 payload=55
- 8N1 bit=2 cycle=6 payload=55
- 8N1 bit=2 cycle=7 payload=55
- 8N1 bit=4 cycle=0 payload=55
- 8N1 bit=4 cycle=1 payload=55
- 8N1 bit=4 cycle=2 payload=55

**Blue Pearl:** COMPLETE. BPS-0272 warning x7, BPS-0534 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/uart_tx/compile.log) · [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/uart_tx.vhd)
- default: FAIL; 624 checks; [simulation log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/uart_tx/sim_default.log)
- divisor13: FAIL; 1004 checks; [simulation log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/uart_tx/sim_divisor13.log)

### qwen3.8-flash-next — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-062307-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- ** Error: C:\hdl_projects\ai_on_prem\20260921-062307-vhdl-skill\qwen3.8-flash-next\fifo.vhd(116): Type error resolving infix expression "=" as type ieee.std_logic_1164.STD_ULOGIC.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-062307-vhdl-skill\qwen3.8-flash-next\fifo.vhd(118): Type error resolving infix expression "and" as type ieee.std_logic_1164.STD_ULOGIC.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1052 error x5, VHDL-1284 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/fifo/compile.log) · [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/fifo.vhd)

### qwen3.8-flash-next — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260921-062307-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/bugfix/compile.log) · [RTL](../20260921-062307-vhdl-skill/qwen3.8-flash-next/bugfix.vhd)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-062307-vhdl-skill/qwen3.8-flash-next/bugfix/sim_default.log)

### qwen3.8:27b — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260921-035335-vhdl-skill

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/counter/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/counter.vhd)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/counter/sim_default.log)

### qwen3.8:27b — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\cdc_sync.vhd(24): near "ATTRIBUTE": syntax error

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1223 error x1, VHDL-1261 error x1, VHDL-1276 error x1, VHDL-1284 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/cdc_sync/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/cdc_sync.vhd)

### qwen3.8:27b — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\axi_lite.vhd(49): Nonresolved signal 's_reg0' has multiple sources.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\axi_lite.vhd(50): Nonresolved signal 's_reg1' has multiple sources.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\axi_lite.vhd(51): Nonresolved signal 's_reg2' has multiple sources.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\axi_lite.vhd(52): Nonresolved signal 's_reg3' has multiple sources.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0723 error x1, BPS-0752 error x1, ELAB-1000 error x1, ELAB-1001 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/axi_lite/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/axi_lite.vhd)

### qwen3.8:27b — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-035335-vhdl-skill

**Result:** FAIL; simulation FAIL; 28 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- start bit begins

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/uart_tx/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/uart_tx.vhd)
- default: FAIL; 14 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/uart_tx/sim_default.log)
- divisor13: FAIL; 14 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/uart_tx/sim_divisor13.log)

### qwen3.8:27b — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-035335-vhdl-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\fifo.vhd(26): near "'": (vcom-1576) expecting ';'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\fifo.vhd(31): (vcom-1136) Unknown identifier "c_addr_width".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\fifo.vhd(31): (vcom-1591) Bad expression in left bound of range expression.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\fifo.vhd(31): Type error in range expression.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\fifo.vhd(32): (vcom-1136) Unknown identifier "c_addr_width".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\fifo.vhd(32): (vcom-1591) Bad expression in left bound of range expression.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\fifo.vhd(32): Type error in range expression.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-035335-vhdl-skill\qwen3.8_27b\fifo.vhd(64): (vcom-1136) Unknown identifier "c_addr_width".

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1241 error x8, VHDL-1261 error x1, VHDL-1284 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/fifo/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/fifo.vhd)

### qwen3.8:27b — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260921-035335-vhdl-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/bugfix/compile.log) · [RTL](../20260921-035335-vhdl-skill/qwen3.8_27b/bugfix.vhd)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-035335-vhdl-skill/qwen3.8_27b/bugfix/sim_default.log)

## Method and limits

Final RTL files, six designs per model per language. The .first files are excluded. Source files were not edited. Testbench stimulus is shared across models; generated per-design benches adapt port and generic names (including i_/o_/g_ prefixes), optional reset polarity and VHDL port widths. Naming aliases are accepted for this evaluation; literal identifier conformance is not scored. Required active-high resets remain a request requirement. All benches are SystemVerilog; Questa compiles VHDL DUTs as VHDL-2008 in mixed-language simulation. Each DUT has an isolated work library. A reference AXI slave validates the AXI checker and is excluded from rankings.

PASS_TESTED means the behavioral tests passed and no checked request/structural mismatch was found; it is not an exhaustive proof. Behavioral PASS is reported separately from request compliance and lint. An unsigned VHDL output requested as unsigned is a mismatch when declared std_logic_vector, even if its numerical behavior passes. The VHDL bugfix request's unsafe-reset repair is tested as synchronous reset, consistent with the explicit Verilog request; source review also identifies implementations retaining direct asynchronous reset without deassertion synchronization.

FIFO read data is checked after the accepting rising edge, consistent with the requested single-clock block RAM. Full/empty boundary simultaneous read+write policy is unspecified, so it is not scored. Overflow/underflow attempts are expected to be rejected. CDC physical metastability/MTBF and placement are not simulated. The tests exercise STAGES=2 and 3; STAGES=1 legality was unspecified and is not scored. UART tests use exact integer baud ratios; invalid parameter combinations and non-integer baud accuracy are not scored. AXI tests use valid aligned addresses, an 80-cycle progress bound, and one transaction at a time; no maximum-throughput claim is made.

Blue Pearl analyzes DUT-only source at its declared default parameters with one shared lint policy and no waivers or SDC constraints. VHDL_2008 and SYS_VERILOG are assigned explicitly per input file. Automatic clock detection is used; these are lint findings, not CDC signoff. The installed nightly build's -write_sarif option was found to suppress native diagnostics, so the final runs omit it. Native logs and reports are the evidence. Lint counts below are the official Message ID Summary counts (including parser/elaborator diagnostics), excluding later command-wrapper repetitions. Error-aborted analysis is not a clean lint pass. If a tool run terminates without its diagnostic summary, emitted counts are marked partial and the run is marked TOOL_INCOMPLETE.

No FPGA target or synthesis constraints were supplied. FIFO RAM coding style was reviewed, but actual block RAM mapping, timing closure and hardware operation were not verified. No original implementation is repaired in this evaluation.

## Coverage

- **counter:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.
- **cdc_sync:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.
- **axi_lite:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.
- **uart_tx:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.
- **fifo:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.
- **bugfix:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.