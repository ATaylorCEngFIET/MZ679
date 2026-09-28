# VHDL model verification
Generated 2026-09-28T20:28:25+01:00.
Behavioral pass, request compliance and Blue Pearl findings are separate measures. PASS_TESTED covers the checks documented below.
| Model | Behavioral pass / 6 | Request pass / 6 | Compile failures | Lint errors | Lint warnings | Lint incomplete |
|---|---:|---:|---:|---:|---:|---:|
| bluepearl-rtl | 6 | 5 | 0 | 0 | 13 | 0 |
| gemma4-fpga | 5 | 4 | 0 | 0 | 13 | 0 |
| qwen-fpga | 5 | 4 | 0 | 0 | 17 | 0 |
| qwen3-coder:30b | 4 | 3 | 0 | 0 | 18 | 0 |
| qwen3.5:4b | 4 | 3 | 1 | 25 | 9 | 0 |
| qwen3.8-flash-next | 6 | 5 | 0 | 0 | 12 | 0 |
| qwen3.8:27b | 6 | 5 | 0 | 0 | 12 | 0 |

## Per-design results

| Model | Request | Simulation | Against request | Blue Pearl errors / warnings | Evidence |
|---|---|---|---|---:|---|
| bluepearl-rtl | counter | PASS | REQUEST_MISMATCH | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/counter/bps/bluepearl.log) |
| bluepearl-rtl | cdc_sync | PASS | PASS_TESTED | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/cdc_sync/bps/bluepearl.log) |
| bluepearl-rtl | axi_lite | PASS | PASS_TESTED | 0 / 5 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/axi_lite/bps/bluepearl.log) |
| bluepearl-rtl | uart_tx | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/uart_tx/bps/bluepearl.log) |
| bluepearl-rtl | fifo | PASS | PASS_TESTED | 0 / 2 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/fifo/bps/bluepearl.log) |
| bluepearl-rtl | bugfix | PASS | PASS_TESTED | 0 / 0 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/bugfix/bps/bluepearl.log) |
| gemma4-fpga | counter | PASS | REQUEST_MISMATCH | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/counter/bps/bluepearl.log) |
| gemma4-fpga | cdc_sync | PASS | PASS_TESTED | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/cdc_sync/bps/bluepearl.log) |
| gemma4-fpga | axi_lite | PASS | PASS_TESTED | 0 / 5 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/axi_lite/bps/bluepearl.log) |
| gemma4-fpga | uart_tx | FAIL | FAIL | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/uart_tx/bps/bluepearl.log) |
| gemma4-fpga | fifo | PASS | PASS_TESTED | 0 / 2 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/fifo/bps/bluepearl.log) |
| gemma4-fpga | bugfix | PASS | PASS_TESTED | 0 / 0 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/bugfix/bps/bluepearl.log) |
| qwen-fpga | counter | PASS | PASS_TESTED | 0 / 0 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/counter/bps/bluepearl.log) |
| qwen-fpga | cdc_sync | PASS | PASS_TESTED | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/cdc_sync/bps/bluepearl.log) |
| qwen-fpga | axi_lite | FAIL | FAIL | 0 / 5 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/axi_lite/bps/bluepearl.log) |
| qwen-fpga | uart_tx | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/uart_tx/bps/bluepearl.log) |
| qwen-fpga | fifo | PASS | PASS_TESTED | 0 / 2 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/fifo/bps/bluepearl.log) |
| qwen-fpga | bugfix | PASS | REQUEST_MISMATCH | 0 / 5 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/bugfix/bps/bluepearl.log) |
| qwen3-coder:30b | counter | PASS | REQUEST_MISMATCH | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/counter/bps/bluepearl.log) |
| qwen3-coder:30b | cdc_sync | FAIL | FAIL | 0 / 3 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/cdc_sync/bps/bluepearl.log) |
| qwen3-coder:30b | axi_lite | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/axi_lite/bps/bluepearl.log) |
| qwen3-coder:30b | uart_tx | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/uart_tx/bps/bluepearl.log) |
| qwen3-coder:30b | fifo | PASS | PASS_TESTED | 0 / 2 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/fifo/bps/bluepearl.log) |
| qwen3-coder:30b | bugfix | FAIL | FAIL | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/bugfix/bps/bluepearl.log) |
| qwen3.5:4b | counter | PASS | REQUEST_MISMATCH | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/counter/bps/bluepearl.log) |
| qwen3.5:4b | cdc_sync | FAIL | FAIL | 4 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/cdc_sync/bps/bluepearl.log) |
| qwen3.5:4b | axi_lite | COMPILE_FAIL | COMPILE_FAIL | 21 / 0 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/axi_lite/bps/bluepearl.log) |
| qwen3.5:4b | uart_tx | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/uart_tx/bps/bluepearl.log) |
| qwen3.5:4b | fifo | PASS | PASS_TESTED | 0 / 2 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/fifo/bps/bluepearl.log) |
| qwen3.5:4b | bugfix | PASS | PASS_TESTED | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/bugfix/bps/bluepearl.log) |
| qwen3.8-flash-next | counter | PASS | REQUEST_MISMATCH | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/counter/bps/bluepearl.log) |
| qwen3.8-flash-next | cdc_sync | PASS | PASS_TESTED | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/cdc_sync/bps/bluepearl.log) |
| qwen3.8-flash-next | axi_lite | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/axi_lite/bps/bluepearl.log) |
| qwen3.8-flash-next | uart_tx | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/uart_tx/bps/bluepearl.log) |
| qwen3.8-flash-next | fifo | PASS | PASS_TESTED | 0 / 2 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/fifo/bps/bluepearl.log) |
| qwen3.8-flash-next | bugfix | PASS | PASS_TESTED | 0 / 0 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/bugfix/bps/bluepearl.log) |
| qwen3.8:27b | counter | PASS | REQUEST_MISMATCH | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/counter/bps/bluepearl.log) |
| qwen3.8:27b | cdc_sync | PASS | PASS_TESTED | 0 / 1 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/cdc_sync/bps/bluepearl.log) |
| qwen3.8:27b | axi_lite | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/axi_lite/bps/bluepearl.log) |
| qwen3.8:27b | uart_tx | PASS | PASS_TESTED | 0 / 4 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/uart_tx/bps/bluepearl.log) |
| qwen3.8:27b | fifo | PASS | PASS_TESTED | 0 / 2 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/fifo/bps/bluepearl.log) |
| qwen3.8:27b | bugfix | PASS | PASS_TESTED | 0 / 0 | testbench (local evaluation) / [lint](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/bugfix/bps/bluepearl.log) |

### bluepearl-rtl — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/counter/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/counter/compile.log) · testbench (local evaluation)
- default: PASS; 321 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/counter/sim_default.log)

### bluepearl-rtl — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/cdc_sync/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/cdc_sync/compile.log) · testbench (local evaluation)
- default: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/cdc_sync/sim_stages3.log)

### bluepearl-rtl — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 154 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x1, BPS-0534 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/axi_lite/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/axi_lite/compile.log) · testbench (local evaluation)
- default: PASS; 154 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/axi_lite/sim_default.log)

### bluepearl-rtl — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/uart_tx/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/uart_tx/compile.log) · testbench (local evaluation)
- default: PASS; 624 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/uart_tx/sim_default.log)
- divisor13: PASS; 1004 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/uart_tx/sim_divisor13.log)

### bluepearl-rtl — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/fifo/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/fifo/compile.log) · testbench (local evaluation)
- default: PASS; 3455 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/fifo/sim_width16_depth4.log)

### bluepearl-rtl — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/bugfix/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/bugfix/compile.log) · testbench (local evaluation)
- default: PASS; 513 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/bluepearl-rtl/bugfix/sim_default.log)

### gemma4-fpga — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/counter/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/counter/compile.log) · testbench (local evaluation)
- default: PASS; 321 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/counter/sim_default.log)

### gemma4-fpga — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/cdc_sync/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/cdc_sync/compile.log) · testbench (local evaluation)
- default: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/cdc_sync/sim_stages3.log)

### gemma4-fpga — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 154 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0534 warning x5.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/axi_lite/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/axi_lite/compile.log) · testbench (local evaluation)
- default: PASS; 154 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/axi_lite/sim_default.log)

### gemma4-fpga — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** FAIL; simulation FAIL; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- 8N1 bit=3 cycle=0 payload=55
- 8N1 bit=3 cycle=1 payload=55
- 8N1 bit=3 cycle=2 payload=55
- 8N1 bit=3 cycle=3 payload=55
- 8N1 bit=3 cycle=4 payload=55
- 8N1 bit=3 cycle=5 payload=55
- 8N1 bit=3 cycle=6 payload=55
- 8N1 bit=3 cycle=7 payload=55
- 8N1 bit=5 cycle=0 payload=55
- 8N1 bit=5 cycle=1 payload=55
- 8N1 bit=5 cycle=2 payload=55
- 8N1 bit=5 cycle=3 payload=55

**Blue Pearl:** COMPLETE. BPS-0272 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/uart_tx/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/uart_tx/compile.log) · testbench (local evaluation)
- default: FAIL; 624 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/uart_tx/sim_default.log)
- divisor13: FAIL; 1004 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/uart_tx/sim_divisor13.log)

### gemma4-fpga — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/fifo/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/fifo/compile.log) · testbench (local evaluation)
- default: PASS; 3455 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/fifo/sim_width16_depth4.log)

### gemma4-fpga — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/bugfix/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/bugfix/compile.log) · testbench (local evaluation)
- default: PASS; 513 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/gemma4-fpga/bugfix/sim_default.log)

### qwen-fpga — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/counter/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/counter/compile.log) · testbench (local evaluation)
- default: PASS; 321 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/counter/sim_default.log)

### qwen-fpga — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/cdc_sync/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/cdc_sync/compile.log) · testbench (local evaluation)
- default: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/cdc_sync/sim_stages3.log)

### qwen-fpga — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** FAIL; simulation FAIL; 106 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- RVALID independent of RREADY
- AR handshake

**Blue Pearl:** COMPLETE. BPS-0272 warning x1, BPS-0534 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/axi_lite/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/axi_lite/compile.log) · testbench (local evaluation)
- default: FAIL; 106 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/axi_lite/sim_default.log)

### qwen-fpga — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/uart_tx/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/uart_tx/compile.log) · testbench (local evaluation)
- default: PASS; 624 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/uart_tx/sim_default.log)
- divisor13: PASS; 1004 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/uart_tx/sim_divisor13.log)

### qwen-fpga — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/fifo/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/fifo/compile.log) · testbench (local evaluation)
- default: PASS; 3455 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/fifo/sim_width16_depth4.log)

### qwen-fpga — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** REQUEST_MISMATCH; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- Reset is outside rising_edge(clk) although rst is absent from the sensitivity list; reset can act on a falling clock edge and simulation/synthesis reset behaviour can differ.

**Blue Pearl:** COMPLETE. BPS-0054 warning x1, BPS-0272 warning x1, BPS-0453 warning x1, VHDL-1251 warning x1, VHDL-1613 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/bugfix/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/bugfix/compile.log) · testbench (local evaluation)
- default: PASS; 513 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen-fpga/bugfix/sim_default.log)

### qwen3-coder:30b — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/counter/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/counter/compile.log) · testbench (local evaluation)
- default: PASS; 321 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/counter/sim_default.log)

### qwen3-coder:30b — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** FAIL; simulation FAIL; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- The STAGES chain is clocked by clk_src; clk_dst is unused. This is not a destination-clock synchronizer.
- STAGES destination-edge latency
- no combinational CDC feedthrough

**Blue Pearl:** COMPLETE. BPS-0272 warning x1, BPS-0534 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/cdc_sync/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/cdc_sync/compile.log) · testbench (local evaluation)
- default: FAIL; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/cdc_sync/sim_default.log)
- stages3: FAIL; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/cdc_sync/sim_stages3.log)

### qwen3-coder:30b — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 154 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0534 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/axi_lite/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/axi_lite/compile.log) · testbench (local evaluation)
- default: PASS; 154 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/axi_lite/sim_default.log)

### qwen3-coder:30b — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/uart_tx/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/uart_tx/compile.log) · testbench (local evaluation)
- default: PASS; 624 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/uart_tx/sim_default.log)
- divisor13: PASS; 1004 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/uart_tx/sim_divisor13.log)

### qwen3-coder:30b — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/fifo/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/fifo/compile.log) · testbench (local evaluation)
- default: PASS; 3455 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/fifo/sim_width16_depth4.log)

### qwen3-coder:30b — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** FAIL; simulation FAIL; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- Direct asynchronous reset remains without deassertion synchronization; the common repair test assumes synchronous reset.
- registered mux both paths
- output and reset synchronous

**Blue Pearl:** COMPLETE. BPS-0054 warning x2, BPS-0453 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/bugfix/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/bugfix/compile.log) · testbench (local evaluation)
- default: FAIL; 513 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3-coder_30b/bugfix/sim_default.log)

### qwen3.5:4b — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/counter/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/counter/compile.log) · testbench (local evaluation)
- default: PASS; 321 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/counter/sim_default.log)

### qwen3.5:4b — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** FAIL; simulation FAIL; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- The chain shifts on clk_i and sync_out is driven both concurrently and on clk_o. This is not a valid STAGES-flop destination-clock synchronizer.
- STAGES destination-edge latency
- no combinational CDC feedthrough

**Blue Pearl:** ANALYSIS_ERROR. BPS-0272 warning x1, BPS-0723 error x1, BPS-0752 error x1, ELAB-1000 error x1, ELAB-1001 error x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/cdc_sync/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/cdc_sync/compile.log) · testbench (local evaluation)
- default: FAIL; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/cdc_sync/sim_default.log)
- stages3: FAIL; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/cdc_sync/sim_stages3.log)

### qwen3.5:4b — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- ** Error: C:\hdl_projects\ai_on_prem\results\comparison-20260928-updated-skills\amd-halo\20260928-140039-vhdl-skill-amd-halo\qwen3.5_4b\axi_lite.vhd(47): near "signal": syntax error
- ** Error: C:\hdl_projects\ai_on_prem\results\comparison-20260928-updated-skills\amd-halo\20260928-140039-vhdl-skill-amd-halo\qwen3.5_4b\axi_lite.vhd(55): Illegal target for signal assignment.
- ** Error: C:\hdl_projects\ai_on_prem\results\comparison-20260928-updated-skills\amd-halo\20260928-140039-vhdl-skill-amd-halo\qwen3.5_4b\axi_lite.vhd(55): (vcom-1136) Unknown identifier "aw_fire".
- ** Error: C:\hdl_projects\ai_on_prem\results\comparison-20260928-updated-skills\amd-halo\20260928-140039-vhdl-skill-amd-halo\qwen3.5_4b\axi_lite.vhd(56): Illegal target for signal assignment.
- ** Error: C:\hdl_projects\ai_on_prem\results\comparison-20260928-updated-skills\amd-halo\20260928-140039-vhdl-skill-amd-halo\qwen3.5_4b\axi_lite.vhd(56): (vcom-1136) Unknown identifier "w_fire".
- ** Error: C:\hdl_projects\ai_on_prem\results\comparison-20260928-updated-skills\amd-halo\20260928-140039-vhdl-skill-amd-halo\qwen3.5_4b\axi_lite.vhd(57): Illegal target for signal assignment.
- ** Error: C:\hdl_projects\ai_on_prem\results\comparison-20260928-updated-skills\amd-halo\20260928-140039-vhdl-skill-amd-halo\qwen3.5_4b\axi_lite.vhd(57): (vcom-1136) Unknown identifier "ar_fire".
- ** Error: C:\hdl_projects\ai_on_prem\results\comparison-20260928-updated-skills\amd-halo\20260928-140039-vhdl-skill-amd-halo\qwen3.5_4b\axi_lite.vhd(70): (vcom-1136) Unknown identifier "aw_fire".

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VHDL-1155 error x1, VHDL-1236 error x3, VHDL-1241 error x2, VHDL-1261 error x3, VHDL-1272 error x3, VHDL-1275 error x1, VHDL-1284 error x1, VHDL-1312 error x6.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/axi_lite/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/axi_lite/compile.log) · testbench (local evaluation)

### qwen3.5:4b — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/uart_tx/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/uart_tx/compile.log) · testbench (local evaluation)
- default: PASS; 624 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/uart_tx/sim_default.log)
- divisor13: PASS; 1004 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/uart_tx/sim_divisor13.log)

### qwen3.5:4b — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/fifo/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/fifo/compile.log) · testbench (local evaluation)
- default: PASS; 3455 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/fifo/sim_width16_depth4.log)

### qwen3.5:4b — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/bugfix/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/bugfix/compile.log) · testbench (local evaluation)
- default: PASS; 513 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.5_4b/bugfix/sim_default.log)

### qwen3.8-flash-next — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260928-150924-vhdl-skill-amd-halo

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/counter/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/counter/compile.log) · testbench (local evaluation)
- default: PASS; 321 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/counter/sim_default.log)

### qwen3.8-flash-next — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260928-150924-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/cdc_sync/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/cdc_sync/compile.log) · testbench (local evaluation)
- default: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/cdc_sync/sim_stages3.log)

### qwen3.8-flash-next — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260928-150924-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 154 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0534 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/axi_lite/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/axi_lite/compile.log) · testbench (local evaluation)
- default: PASS; 154 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/axi_lite/sim_default.log)

### qwen3.8-flash-next — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260928-150924-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/uart_tx/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/uart_tx/compile.log) · testbench (local evaluation)
- default: PASS; 624 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/uart_tx/sim_default.log)
- divisor13: PASS; 1004 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/uart_tx/sim_divisor13.log)

### qwen3.8-flash-next — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260928-150924-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/fifo/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/fifo/compile.log) · testbench (local evaluation)
- default: PASS; 3455 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/fifo/sim_width16_depth4.log)

### qwen3.8-flash-next — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260928-150924-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/bugfix/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/bugfix/compile.log) · testbench (local evaluation)
- default: PASS; 513 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-150924-vhdl-skill-amd-halo/qwen3.8-flash-next/bugfix/sim_default.log)

### qwen3.8:27b — counter

**Request:** Write a VHDL-2008 entity 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit unsigned output). Count increments when en='1' and wraps at 15.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** REQUEST_MISMATCH; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- count output is not declared unsigned; JSON requests unsigned output

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/counter/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/counter/compile.log) · testbench (local evaluation)
- default: PASS; 321 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/counter/sim_default.log)

### qwen3.8:27b — cdc_sync

**Request:** Write a generic two-flop clock-domain-crossing synchroniser 'cdc_sync' for a single-bit signal in VHDL-2008. Add the Xilinx ASYNC_REG attribute on the flops and a generic STAGES defaulting to 2.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x1.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/cdc_sync/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/cdc_sync/compile.log) · testbench (local evaluation)
- default: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/cdc_sync/sim_stages3.log)

### qwen3.8:27b — axi_lite

**Request:** Write a minimal AXI4-Lite slave 'axil_regs' in VHDL-2008 with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper handshake (valid/ready) and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 154 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0534 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/axi_lite/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/axi_lite/compile.log) · testbench (local evaluation)
- default: PASS; 154 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/axi_lite/sim_default.log)

### qwen3.8:27b — uart_tx

**Request:** Write a VHDL-2008 UART transmitter 'uart_tx' with generics CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data(7 downto 0), data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x4.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/uart_tx/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/uart_tx/compile.log) · testbench (local evaluation)
- default: PASS; 624 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/uart_tx/sim_default.log)
- divisor13: PASS; 1004 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/uart_tx/sim_divisor13.log)

### qwen3.8:27b — fifo

**Request:** Write a synchronous FIFO 'sync_fifo' in VHDL-2008 with generics WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0272 warning x2.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/fifo/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/fifo/compile.log) · testbench (local evaluation)
- default: PASS; 3455 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/fifo/sim_width16_depth4.log)

### qwen3.8:27b — bugfix

**Request:** The following VHDL has at least two problems (an inferred latch and an unsafe reset). Return a corrected, synthesisable VHDL-2008 version of the whole module and nothing else.

library ieee; use ieee.std_logic_1164.all;
entity mux_reg is port(clk, rst, sel : in std_logic; a, b : in std_logic_vector(7 downto 0); q : out std_logic_vector(7 downto 0)); end;
architecture rtl of mux_reg is signal r : std_logic_vector(7 downto 0); begin
process(sel, a, b) begin if sel = '1' then r <= a; elsif sel = '0' then r <= b; end if; end process;
process(clk, rst) begin if rst = '1' then q <= (others => '0'); elsif rising_edge(clk) then q <= r; end if; end process;
end;

**Source run:** 20260928-140039-vhdl-skill-amd-halo

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/bugfix/bps/bluepearl.log) · [Compiler log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/bugfix/compile.log) · testbench (local evaluation)
- default: PASS; 513 checks; [simulation log](batches/20260928-updated-skills/runs/20260928-140039-vhdl-skill-amd-halo/qwen3.8_27b/bugfix/sim_default.log)

## Method and limits

These sources were generated on amd-halo and verified centrally on the same Windows Questa/Blue Pearl installation. Only the seven selected model configurations are included. AMD-Halo original task-file hashes differ from the supplied definitions; the user described the differences as minor, and all machines are evaluated against the supplied common requirements. Distinct clocks named clk_in/clk_a/clk_i are driven independently from clk_out/clk_b where both are exposed.

Updated protocol-skill generation run, compared against archived prior results. The protocol hashes match the corrected local skill files. The test stimulus and lint policy are unchanged; the adapter additionally recognises the new clk_i/clk_o source/destination clock pair.

Final RTL files, six designs per model per language. The .first files are excluded. Source files were not edited. Testbench stimulus is shared across models; generated per-design benches adapt port and generic names (including i_/o_/g_ prefixes), optional reset polarity and VHDL port widths. Naming aliases are accepted for this evaluation; literal identifier conformance is not scored. Required active-high resets remain a request requirement. All benches are SystemVerilog; Questa compiles VHDL DUTs as VHDL-2008 in mixed-language simulation. Each DUT has an isolated work library. A reference AXI slave validates the AXI checker and is excluded from rankings.

PASS_TESTED means the behavioral tests passed and no checked request/structural mismatch was found; it is not an exhaustive proof. Behavioral PASS is reported separately from request compliance and lint. An unsigned VHDL output requested as unsigned is a mismatch when declared std_logic_vector, even if its numerical behavior passes. The VHDL bugfix request's unsafe-reset repair is tested as synchronous reset, consistent with the explicit Verilog request; source review also identifies implementations retaining direct asynchronous reset without deassertion synchronization.

FIFO read data is checked after the accepting rising edge, consistent with the requested single-clock block RAM. Full/empty boundary simultaneous read+write policy is unspecified, so it is not scored. Overflow/underflow attempts are expected to be rejected. CDC physical metastability/MTBF and placement are not simulated. The tests exercise STAGES=2 and 3; STAGES=1 legality was unspecified and is not scored. UART tests use exact integer baud ratios; invalid parameter combinations and non-integer baud accuracy are not scored. AXI tests use valid aligned addresses, an 80-cycle progress bound, and one transaction at a time; no maximum-throughput claim is made. Unspecified AXI register reset values are not scored: exposed outputs are compared only after that register has been explicitly initialized by a write.

Blue Pearl analyzes DUT-only source at its declared default parameters with one shared lint policy and no waivers or SDC constraints. VHDL_2008 and SYS_VERILOG are assigned explicitly per input file. Automatic clock detection is used; these are lint findings, not CDC signoff. The installed nightly build's -write_sarif option was found to suppress native diagnostics, so the final runs omit it. Native logs and reports are the evidence. Lint counts below are the official Message ID Summary counts (including parser/elaborator diagnostics), excluding later command-wrapper repetitions. Error-aborted analysis is not a clean lint pass. If a tool run terminates without its diagnostic summary, emitted counts are marked partial and the run is marked TOOL_INCOMPLETE.

No FPGA target or synthesis constraints were supplied. FIFO RAM coding style was reviewed, but actual block RAM mapping, timing closure and hardware operation were not verified. No original implementation is repaired in this evaluation.

## Coverage

- **counter:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.
- **cdc_sync:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.
- **axi_lite:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.
- **uart_tx:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.
- **fifo:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.
- **bugfix:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.