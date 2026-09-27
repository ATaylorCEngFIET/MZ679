# Verilog / SystemVerilog model verification
Generated 2026-09-27T14:02:34+01:00.
Behavioral pass, request compliance and Blue Pearl findings are separate measures. PASS_TESTED covers the checks documented below.
| Model | Behavioral pass / 6 | Request pass / 6 | Compile failures | Lint errors | Lint warnings | Lint incomplete |
|---|---:|---:|---:|---:|---:|---:|
| bluepearl-rtl | 4 | 4 | 0 | 0 | 13 | 0 |
| gemma4-fpga | 4 | 3 | 0 | 0 | 10 | 0 |
| qwen-fpga | 1 | 1 | 1 | 75 | 17 | 0 |
| qwen3-coder:30b | 2 | 2 | 0 | 3 | 84 | 0 |
| qwen3.5:4b | 0 | 0 | 3 | 78 | 8 | 0 |
| qwen3.8-flash-next | 3 | 3 | 0 | 3 | 11 | 0 |
| qwen3.8:27b | 3 | 2 | 0 | 0 | 7 | 0 |

## Per-design results

| Model | Request | Simulation | Against request | Blue Pearl errors / warnings | Evidence |
|---|---|---|---|---:|---|
| bluepearl-rtl | counter | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/counter.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/counter/bps_final/bluepearl.log) |
| bluepearl-rtl | cdc_sync | PASS | PASS_TESTED | 0 / 5 | [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/cdc_sync.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/cdc_sync/bps_final/bluepearl.log) |
| bluepearl-rtl | axi_lite | FAIL | FAIL | 0 / 5 | [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/axi_lite.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/axi_lite/bps_final/bluepearl.log) |
| bluepearl-rtl | uart_tx | FAIL | FAIL | 0 / 3 | [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/uart_tx.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/uart_tx/bps_final/bluepearl.log) |
| bluepearl-rtl | fifo | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/fifo.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/fifo/bps_final/bluepearl.log) |
| bluepearl-rtl | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/bugfix.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/bugfix/bps_final/bluepearl.log) |
| gemma4-fpga | counter | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/gemma4-fpga/counter.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/counter/bps_final/bluepearl.log) |
| gemma4-fpga | cdc_sync | PASS | REQUEST_MISMATCH | 0 / 2 | [RTL](../20260921-051654-verilog-skill/gemma4-fpga/cdc_sync.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/cdc_sync/bps_final/bluepearl.log) |
| gemma4-fpga | axi_lite | FAIL | FAIL | 0 / 6 | [RTL](../20260921-051654-verilog-skill/gemma4-fpga/axi_lite.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/axi_lite/bps_final/bluepearl.log) |
| gemma4-fpga | uart_tx | PASS | PASS_TESTED | 0 / 1 | [RTL](../20260921-051654-verilog-skill/gemma4-fpga/uart_tx.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/uart_tx/bps_final/bluepearl.log) |
| gemma4-fpga | fifo | FAIL | FAIL | 0 / 1 | [RTL](../20260921-051654-verilog-skill/gemma4-fpga/fifo.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/fifo/bps_final/bluepearl.log) |
| gemma4-fpga | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/gemma4-fpga/bugfix.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/bugfix/bps_final/bluepearl.log) |
| qwen-fpga | counter | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/qwen-fpga/counter.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/counter/bps_final/bluepearl.log) |
| qwen-fpga | cdc_sync | FAIL | FAIL | 0 / 4 | [RTL](../20260921-051654-verilog-skill/qwen-fpga/cdc_sync.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/cdc_sync/bps_final/bluepearl.log) |
| qwen-fpga | axi_lite | ELABORATION_FAIL | ELABORATION_FAIL | 65 / 5 | [RTL](../20260921-051654-verilog-skill/qwen-fpga/axi_lite.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/axi_lite/bps_final/bluepearl.log) |
| qwen-fpga | uart_tx | FAIL | FAIL | 0 / 6 | [RTL](../20260921-051654-verilog-skill/qwen-fpga/uart_tx.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/uart_tx/bps_final/bluepearl.log) |
| qwen-fpga | fifo | COMPILE_FAIL | COMPILE_FAIL | 7 / 0 | [RTL](../20260921-051654-verilog-skill/qwen-fpga/fifo.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/fifo/bps_final/bluepearl.log) |
| qwen-fpga | bugfix | ELABORATION_FAIL | ELABORATION_FAIL | 3 / 2 | [RTL](../20260921-051654-verilog-skill/qwen-fpga/bugfix.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/bugfix/bps_final/bluepearl.log) |
| qwen3-coder:30b | counter | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/counter.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/counter/bps_final/bluepearl.log) |
| qwen3-coder:30b | cdc_sync | FAIL | FAIL | 0 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/cdc_sync.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/cdc_sync/bps_final/bluepearl.log) |
| qwen3-coder:30b | axi_lite | FAIL | FAIL | 0 / 48 | [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/axi_lite.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/axi_lite/bps_final/bluepearl.log) |
| qwen3-coder:30b | uart_tx | FAIL | FAIL | 0 / 3 | [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/uart_tx.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/uart_tx/bps_final/bluepearl.log) |
| qwen3-coder:30b | fifo | ELABORATION_FAIL | ELABORATION_FAIL | 3 / 33 | [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/fifo.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/fifo/bps_final/bluepearl.log) |
| qwen3-coder:30b | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/bugfix.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/bugfix/bps_final/bluepearl.log) |
| qwen3.5:4b | counter | FAIL | FAIL | 0 / 2 | [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/counter.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/counter/bps_final/bluepearl.log) |
| qwen3.5:4b | cdc_sync | INTERFACE_FAIL | INTERFACE_FAIL | 4 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/cdc_sync.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/cdc_sync/bps_final/bluepearl.log) |
| qwen3.5:4b | axi_lite | COMPILE_FAIL | COMPILE_FAIL | 10 / 4 | [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/axi_lite.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/axi_lite/bps_final/bluepearl.log) |
| qwen3.5:4b | uart_tx | COMPILE_FAIL | COMPILE_FAIL | 55 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/uart_tx.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/uart_tx/bps_final/bluepearl.log) |
| qwen3.5:4b | fifo | COMPILE_FAIL | COMPILE_FAIL | 6 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/fifo.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/fifo/bps_final/bluepearl.log) |
| qwen3.5:4b | bugfix | ELABORATION_FAIL | ELABORATION_FAIL | 3 / 2 | [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/bugfix.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/bugfix/bps_final/bluepearl.log) |
| qwen3.8-flash-next | counter | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/counter.sv) / [lint](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/counter/bps_final/bluepearl.log) |
| qwen3.8-flash-next | cdc_sync | FAIL | FAIL | 0 / 1 | [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/cdc_sync.sv) / [lint](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/cdc_sync/bps_final/bluepearl.log) |
| qwen3.8-flash-next | axi_lite | INTERFACE_FAIL | INTERFACE_FAIL | 3 / 10 | [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/axi_lite.sv) / [lint](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/axi_lite/bps_final/bluepearl.log) |
| qwen3.8-flash-next | uart_tx | FAIL | FAIL | 0 / 0 | [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/uart_tx.sv) / [lint](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/uart_tx/bps_final/bluepearl.log) |
| qwen3.8-flash-next | fifo | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/fifo.sv) / [lint](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/fifo/bps_final/bluepearl.log) |
| qwen3.8-flash-next | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/bugfix.sv) / [lint](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/bugfix/bps_final/bluepearl.log) |
| qwen3.8:27b | counter | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/counter.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/counter/bps_final/bluepearl.log) |
| qwen3.8:27b | cdc_sync | PASS | REQUEST_MISMATCH | 0 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/cdc_sync.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/cdc_sync/bps_final/bluepearl.log) |
| qwen3.8:27b | axi_lite | FAIL | FAIL | 0 / 6 | [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/axi_lite.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/axi_lite/bps_final/bluepearl.log) |
| qwen3.8:27b | uart_tx | FAIL | FAIL | 0 / 1 | [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/uart_tx.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/uart_tx/bps_final/bluepearl.log) |
| qwen3.8:27b | fifo | FAIL | FAIL | 0 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/fifo.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/fifo/bps_final/bluepearl.log) |
| qwen3.8:27b | bugfix | PASS | PASS_TESTED | 0 / 0 | [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/bugfix.sv) / [lint](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/bugfix/bps_final/bluepearl.log) |

### bluepearl-rtl — counter

**Request:** Write a SystemVerilog module 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit output). Count increments when en is high and wraps at 15.

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/counter/compile.log) · [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/counter.sv)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/counter/sim_default.log)

### bluepearl-rtl — cdc_sync

**Request:** Write a parameterised two-flop clock-domain-crossing synchroniser module 'cdc_sync' for a single-bit signal in SystemVerilog. Add the Xilinx ASYNC_REG attribute on the flops and a parameter STAGES defaulting to 2.

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. BPS-0054 warning x2, BPS-0453 warning x2, BPS-0534 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/cdc_sync/compile.log) · [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/cdc_sync.sv)
- default: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/cdc_sync/sim_stages3.log)

### bluepearl-rtl — axi_lite

**Request:** Write a minimal AXI4-Lite slave module 'axil_regs' in SystemVerilog with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper valid/ready handshakes and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 150 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- exposed register 0
- exposed register 1
- exposed register 2
- exposed register 3
- readback register 0 expected 12345678 actual 00000000
- readback register 1 expected 03254769 actual 00000000
- readback register 2 expected 3016745a actual 00000000
- readback register 3 expected 2107654b actual 00000000
- BVALID independent of BREADY
- readback register 1 expected cafe9876 actual 00000000
- readback register 2 expected 87654321 actual 00000000
- readback register 0 expected 12bb56dd actual 00000000

**Blue Pearl:** COMPLETE. BPS-0112 warning x1, BPS-0534 warning x4.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/axi_lite/compile.log) · [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/axi_lite.sv)
- default: FAIL; 150 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/axi_lite/sim_default.log)

### bluepearl-rtl — uart_tx

**Request:** Write a SystemVerilog UART transmitter module 'uart_tx' with parameters CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data[7:0], data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- 8N1 bit=1 cycle=0 payload=55
- 8N1 bit=1 cycle=1 payload=55
- 8N1 bit=1 cycle=2 payload=55
- 8N1 bit=1 cycle=3 payload=55
- 8N1 bit=1 cycle=4 payload=55
- 8N1 bit=1 cycle=5 payload=55
- 8N1 bit=1 cycle=6 payload=55
- 8N1 bit=1 cycle=7 payload=55
- 8N1 bit=3 cycle=0 payload=55
- 8N1 bit=3 cycle=1 payload=55
- 8N1 bit=3 cycle=2 payload=55
- 8N1 bit=3 cycle=3 payload=55

**Blue Pearl:** COMPLETE. VERI-1190 warning x1, VERI-9001 warning x2.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/uart_tx/compile.log) · [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/uart_tx.sv)
- default: FAIL; 624 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/uart_tx/sim_default.log)
- divisor13: FAIL; 1004 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/uart_tx/sim_divisor13.log)

### bluepearl-rtl — fifo

**Request:** Write a synchronous FIFO module 'sync_fifo' in SystemVerilog with parameters WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/fifo/compile.log) · [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/fifo.sv)
- default: PASS; 3455 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/fifo/sim_width16_depth4.log)

### bluepearl-rtl — bugfix

**Request:** The following SystemVerilog has at least two problems (an inferred latch and an asynchronous reset where a synchronous one was required). Return a corrected, synthesisable version of the whole module and nothing else.

module mux_reg(input logic clk, rst, sel, input logic [7:0] a, b, output logic [7:0] q);
  logic [7:0] r;
  always_comb begin
    if (sel == 1'b1) r = a;
    else if (sel == 1'b0) r = b;
  end
  always_ff @(posedge clk or posedge rst) begin
    if (rst) q <= 8'h00;
    else q <= r;
  end
endmodule

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/bugfix/compile.log) · [RTL](../20260921-051654-verilog-skill/bluepearl-rtl/bugfix.sv)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/bluepearl-rtl/bugfix/sim_default.log)

### gemma4-fpga — counter

**Request:** Write a SystemVerilog module 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit output). Count increments when en is high and wraps at 15.

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/counter/compile.log) · [RTL](../20260921-051654-verilog-skill/gemma4-fpga/counter.sv)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/counter/sim_default.log)

### gemma4-fpga — cdc_sync

**Request:** Write a parameterised two-flop clock-domain-crossing synchroniser module 'cdc_sync' for a single-bit signal in SystemVerilog. Add the Xilinx ASYNC_REG attribute on the flops and a parameter STAGES defaulting to 2.

**Source run:** 20260921-051654-verilog-skill

**Result:** REQUEST_MISMATCH; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- The output uses sync_pipeline. Only its first-stage process is annotated; the remaining synchronizer stages have no ASYNC_REG attribute. The separately annotated sync_stage_0 does not drive the output.

**Blue Pearl:** COMPLETE. BPS-0534 warning x2.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/cdc_sync/compile.log) · [RTL](../20260921-051654-verilog-skill/gemma4-fpga/cdc_sync.sv)
- default: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/cdc_sync/sim_stages3.log)

### gemma4-fpga — axi_lite

**Request:** Write a minimal AXI4-Lite slave module 'axil_regs' in SystemVerilog with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper valid/ready handshakes and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 72 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- BVALID independent of BREADY
- exposed register 0
- exposed register 1
- exposed register 2
- exposed register 3
- RVALID independent of RREADY

**Blue Pearl:** COMPLETE. BPS-0534 warning x6.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/axi_lite/compile.log) · [RTL](../20260921-051654-verilog-skill/gemma4-fpga/axi_lite.sv)
- default: FAIL; 72 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/axi_lite/sim_default.log)

### gemma4-fpga — uart_tx

**Request:** Write a SystemVerilog UART transmitter module 'uart_tx' with parameters CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data[7:0], data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. VERI-1209 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/uart_tx/compile.log) · [RTL](../20260921-051654-verilog-skill/gemma4-fpga/uart_tx.sv)
- default: PASS; 624 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/uart_tx/sim_default.log)
- divisor13: PASS; 1004 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/uart_tx/sim_divisor13.log)

### gemma4-fpga — fifo

**Request:** Write a synchronous FIFO module 'sync_fifo' in SystemVerilog with parameters WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- Read data is a combinational RAM lookup, rather than a clocked RAM read. This does not implement the requested synchronous block-RAM read structure.
- WIDTH is declared as a 4-bit parameter: default 32 truncates to zero, and tested WIDTH=16 also truncates to zero.
- FIFO ordering / synchronous read

**Blue Pearl:** COMPLETE. VERI-9001 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/fifo/compile.log) · [RTL](../20260921-051654-verilog-skill/gemma4-fpga/fifo.sv)
- default: FAIL; 3455 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/fifo/sim_default.log)
- width16_depth4: FAIL; 3381 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/fifo/sim_width16_depth4.log)

### gemma4-fpga — bugfix

**Request:** The following SystemVerilog has at least two problems (an inferred latch and an asynchronous reset where a synchronous one was required). Return a corrected, synthesisable version of the whole module and nothing else.

module mux_reg(input logic clk, rst, sel, input logic [7:0] a, b, output logic [7:0] q);
  logic [7:0] r;
  always_comb begin
    if (sel == 1'b1) r = a;
    else if (sel == 1'b0) r = b;
  end
  always_ff @(posedge clk or posedge rst) begin
    if (rst) q <= 8'h00;
    else q <= r;
  end
endmodule

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/bugfix/compile.log) · [RTL](../20260921-051654-verilog-skill/gemma4-fpga/bugfix.sv)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/gemma4-fpga/bugfix/sim_default.log)

### qwen-fpga — counter

**Request:** Write a SystemVerilog module 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit output). Count increments when en is high and wraps at 15.

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/counter/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen-fpga/counter.sv)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/counter/sim_default.log)

### qwen-fpga — cdc_sync

**Request:** Write a parameterised two-flop clock-domain-crossing synchroniser module 'cdc_sync' for a single-bit signal in SystemVerilog. Add the Xilinx ASYNC_REG attribute on the flops and a parameter STAGES defaulting to 2.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- Required ASYNC_REG attribute missing from code.
- STAGES destination-edge latency

**Blue Pearl:** COMPLETE. BPS-0054 warning x2, BPS-0453 warning x2.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/cdc_sync/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen-fpga/cdc_sync.sv)
- default: FAIL; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/cdc_sync/sim_default.log)
- stages3: FAIL; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/cdc_sync/sim_stages3.log)

### qwen-fpga — axi_lite

**Request:** Write a minimal AXI4-Lite slave module 'axil_regs' in SystemVerilog with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper valid/ready handshakes and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-051654-verilog-skill

**Result:** ELABORATION_FAIL; simulation ELABORATION_FAIL; 0 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- Missing requested/AXI port reg0
- Missing requested/AXI port reg1
- Missing requested/AXI port reg2
- Missing requested/AXI port reg3
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\axi_lite.sv(121): (vopt-7033) Variable 'rdata' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\axi_lite.sv(60).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\axi_lite.sv(122): (vopt-7033) Variable 'rresp' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\axi_lite.sv(61).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\axi_lite.sv(124): (vopt-7033) Variable 'rdata' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\axi_lite.sv(60).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\axi_lite.sv(125): (vopt-7033) Variable 'rresp' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\axi_lite.sv(61).
- # ** Error: (vopt-2064) Compiler back-end code generation process terminated due to previous errors with code 12.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, ELAB-1000 error x32, ELAB-1001 error x32, VERI-1924 warning x2, VERI-1971 warning x2, VERI-9015 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/axi_lite/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen-fpga/axi_lite.sv)
- default: ELABORATION_FAIL; 0 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/axi_lite/sim_default.log)

### qwen-fpga — uart_tx

**Request:** Write a SystemVerilog UART transmitter module 'uart_tx' with parameters CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data[7:0], data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- reset idle tx
- 8N1 bit=1 cycle=0 payload=55
- 8N1 bit=1 cycle=1 payload=55
- 8N1 bit=1 cycle=2 payload=55
- busy during start/data
- 8N1 bit=1 cycle=3 payload=55
- 8N1 bit=1 cycle=4 payload=55
- 8N1 bit=1 cycle=5 payload=55
- 8N1 bit=1 cycle=6 payload=55
- 8N1 bit=1 cycle=7 payload=55
- 8N1 bit=3 cycle=0 payload=55
- 8N1 bit=3 cycle=1 payload=55

**Blue Pearl:** COMPLETE. BPS-0054 warning x3, BPS-0453 warning x3.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/uart_tx/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen-fpga/uart_tx.sv)
- default: FAIL; 624 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/uart_tx/sim_default.log)
- divisor13: FAIL; 1004 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/uart_tx/sim_divisor13.log)

### qwen-fpga — fifo

**Request:** Write a synchronous FIFO module 'sync_fifo' in SystemVerilog with parameters WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-051654-verilog-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- Read data is a combinational RAM lookup, rather than a clocked RAM read. This does not implement the requested synchronous block-RAM read structure.
- ** Error: (vlog-13069) C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\fifo.sv(47): near "=": syntax error, unexpected '='.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\fifo.sv(47): (vlog-13205) Syntax error found in the scope following 'full'. Is there a missing '::'?

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VERI-1072 error x1, VERI-1137 error x1, VERI-1281 error x4.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/fifo/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen-fpga/fifo.sv)

### qwen-fpga — bugfix

**Request:** The following SystemVerilog has at least two problems (an inferred latch and an asynchronous reset where a synchronous one was required). Return a corrected, synthesisable version of the whole module and nothing else.

module mux_reg(input logic clk, rst, sel, input logic [7:0] a, b, output logic [7:0] q);
  logic [7:0] r;
  always_comb begin
    if (sel == 1'b1) r = a;
    else if (sel == 1'b0) r = b;
  end
  always_ff @(posedge clk or posedge rst) begin
    if (rst) q <= 8'h00;
    else q <= r;
  end
endmodule

**Source run:** 20260921-051654-verilog-skill

**Result:** ELABORATION_FAIL; simulation ELABORATION_FAIL; 0 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\bugfix.sv(17): (vopt-7033) Variable 'q' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\bugfix.sv(11).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\bugfix.sv(19): (vopt-7033) Variable 'q' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen-fpga\bugfix.sv(11).
- # ** Error: (vopt-2064) Compiler back-end code generation process terminated due to previous errors with code 12.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, ELAB-1000 error x1, ELAB-1001 error x1, VERI-1924 warning x1, VERI-1971 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/bugfix/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen-fpga/bugfix.sv)
- default: ELABORATION_FAIL; 0 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen-fpga/bugfix/sim_default.log)

### qwen3-coder:30b — counter

**Request:** Write a SystemVerilog module 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit output). Count increments when en is high and wraps at 15.

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/counter/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/counter.sv)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/counter/sim_default.log)

### qwen3-coder:30b — cdc_sync

**Request:** Write a parameterised two-flop clock-domain-crossing synchroniser module 'cdc_sync' for a single-bit signal in SystemVerilog. Add the Xilinx ASYNC_REG attribute on the flops and a parameter STAGES defaulting to 2.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- ASYNC_REG is placed on a procedural assignment, rather than the synchronizer register declaration. The final destination-clock dout register is unannotated.
- STAGES destination-edge latency

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/cdc_sync/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/cdc_sync.sv)
- default: FAIL; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/cdc_sync/sim_default.log)
- stages3: FAIL; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/cdc_sync/sim_stages3.log)

### qwen3-coder:30b — axi_lite

**Request:** Write a minimal AXI4-Lite slave module 'axil_regs' in SystemVerilog with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper valid/ready handshakes and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 40 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- Missing requested/AXI port reg0
- Missing requested/AXI port reg1
- Missing requested/AXI port reg2
- Missing requested/AXI port reg3
- BVALID independent of BREADY
- AW/W accepted independently and bounded completion
- AR handshake
- RVALID independent of RREADY

**Blue Pearl:** COMPLETE. BPS-0054 warning x11, BPS-0453 warning x11, BPS-0530 warning x5, BPS-0534 warning x3, BPS-0551 warning x1, BPS-0801 warning x1, BPS-0802 warning x1, BPS-0948 warning x5, VERI-1899 warning x5, VERI-2580 warning x5.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/axi_lite/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/axi_lite.sv)
- default: FAIL; 40 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/axi_lite/sim_default.log)

### qwen3-coder:30b — uart_tx

**Request:** Write a SystemVerilog UART transmitter module 'uart_tx' with parameters CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data[7:0], data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 28 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- start bit begins

**Blue Pearl:** COMPLETE. BPS-0532 warning x1, BPS-0534 warning x1, VERI-1209 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/uart_tx/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/uart_tx.sv)
- default: FAIL; 14 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/uart_tx/sim_default.log)
- divisor13: FAIL; 14 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/uart_tx/sim_divisor13.log)

### qwen3-coder:30b — fifo

**Request:** Write a synchronous FIFO module 'sync_fifo' in SystemVerilog with parameters WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-051654-verilog-skill

**Result:** ELABORATION_FAIL; simulation ELABORATION_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- Read/write addresses and wrap flags are assigned by both always_comb and always_ff blocks. The RAM write address includes the wrap bit, allowing indices outside the RAM depth.
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(61): (vopt-7033) Variable 'wr_addr' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(41).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(62): (vopt-7033) Variable 'rd_addr' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(42).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(63): (vopt-7033) Variable 'wr_wrap' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(43).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(64): (vopt-7033) Variable 'rd_wrap' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(44).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(66): (vopt-7033) Variable 'wr_addr' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(41).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(67): (vopt-7033) Variable 'rd_addr' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(42).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(68): (vopt-7033) Variable 'wr_wrap' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(43).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(69): (vopt-7033) Variable 'rd_wrap' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3-coder_30b\fifo.sv(44).

**Blue Pearl:** ANALYSIS_ERROR. BPS-0530 warning x2, BPS-0752 error x1, ELAB-1000 error x1, ELAB-1001 error x1, VERI-1209 warning x2, VERI-1899 warning x10, VERI-1924 warning x4, VERI-1971 warning x4, VERI-2580 warning x10, VERI-9015 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/fifo/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/fifo.sv)
- default: ELABORATION_FAIL; 0 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/fifo/sim_default.log)
- width16_depth4: ELABORATION_FAIL; 0 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/fifo/sim_width16_depth4.log)

### qwen3-coder:30b — bugfix

**Request:** The following SystemVerilog has at least two problems (an inferred latch and an asynchronous reset where a synchronous one was required). Return a corrected, synthesisable version of the whole module and nothing else.

module mux_reg(input logic clk, rst, sel, input logic [7:0] a, b, output logic [7:0] q);
  logic [7:0] r;
  always_comb begin
    if (sel == 1'b1) r = a;
    else if (sel == 1'b0) r = b;
  end
  always_ff @(posedge clk or posedge rst) begin
    if (rst) q <= 8'h00;
    else q <= r;
  end
endmodule

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/bugfix/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3-coder_30b/bugfix.sv)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3-coder_30b/bugfix/sim_default.log)

### qwen3.5:4b — counter

**Request:** Write a SystemVerilog module 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit output). Count increments when en is high and wraps at 15.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- Required active-high rst port missing (reset adapted for behavioral testing)
- reset clears counter
- increment/hold/wrap/reset priority
- synchronous reset/clocked output

**Blue Pearl:** COMPLETE. BPS-0054 warning x1, BPS-0453 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/counter/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/counter.sv)
- default: FAIL; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/counter/sim_default.log)

### qwen3.5:4b — cdc_sync

**Request:** Write a parameterised two-flop clock-domain-crossing synchroniser module 'cdc_sync' for a single-bit signal in SystemVerilog. Add the Xilinx ASYNC_REG attribute on the flops and a parameter STAGES defaulting to 2.

**Source run:** 20260921-051654-verilog-skill

**Result:** INTERFACE_FAIL; simulation INTERFACE_FAIL; 0 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- Missing required generic/parameter STAGES
- Required ASYNC_REG attribute missing from code.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VERI-1072 error x1, VERI-1348 error x2.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/cdc_sync/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/cdc_sync.sv)

### qwen3.5:4b — axi_lite

**Request:** Write a minimal AXI4-Lite slave module 'axil_regs' in SystemVerilog with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper valid/ready handshakes and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-051654-verilog-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- Missing requested/AXI port reg0
- Missing requested/AXI port reg1
- Missing requested/AXI port reg2
- Missing requested/AXI port reg3
- Wrong port direction rvalid
- Wrong port direction rdata
- Wrong port direction bready
- Wrong port direction rready
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\axi_lite.sv(34): (vlog-13003) Enum member 'R_PENDING' has value that is outside the representable range of the enum.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\axi_lite.sv(156): (vlog-2110) Illegal reference to net "bresp".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\axi_lite.sv(197): (vlog-2110) Illegal reference to net "bresp".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\axi_lite.sv(264): (vlog-2110) Illegal reference to net "bresp".
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\axi_lite.sv(307): (vlog-2110) Illegal reference to net "bresp".

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VERI-1072 error x1, VERI-1100 error x8, VERI-1214 warning x4.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/axi_lite/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/axi_lite.sv)

### qwen3.5:4b — uart_tx

**Request:** Write a SystemVerilog UART transmitter module 'uart_tx' with parameters CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data[7:0], data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-051654-verilog-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- Required active-high rst port missing (reset adapted for behavioral testing)
- Missing required generic/parameter CLK_HZ
- Missing required generic/parameter BAUD
- ** Error: (vlog-13069) C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\uart_tx.sv(30): near "logic": syntax error, unexpected "SystemVerilog keyword 'logic'", expecting IDENTIFIER or TYPE_IDENTIFIER or NETTYPE_IDENTIFIER or '='.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\uart_tx.sv(38): (vlog-2730) Undefined variable: 'baud_counter'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\uart_tx.sv(42): (vlog-2730) Undefined variable: 'state_reg'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\uart_tx.sv(43): (vlog-2730) Undefined variable: 'data_valid_reg'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\uart_tx.sv(44): (vlog-2730) Undefined variable: 'data_reg'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\uart_tx.sv(45): (vlog-2730) Undefined variable: 'busy_reg'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\uart_tx.sv(46): (vlog-2730) Undefined variable: 'tx_reg'.
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\uart_tx.sv(138): (vlog-2730) Undefined variable: 'tx_reg'.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VERI-1072 error x1, VERI-1128 error x51, VERI-1137 error x1, VERI-2344 error x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/uart_tx/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/uart_tx.sv)

### qwen3.5:4b — fifo

**Request:** Write a synchronous FIFO module 'sync_fifo' in SystemVerilog with parameters WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-051654-verilog-skill

**Result:** COMPILE_FAIL; simulation COMPILE_FAIL; 0 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- Missing required port rd_data
- Missing required generic/parameter WIDTH
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\fifo.sv(5): (vlog-2730) Undefined variable: 'WIDTH'.
- ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\fifo.sv(5): (vlog-2388) 'wr_data' already declared in this scope (sync_fifo) at C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\fifo.sv(5).
- ** Error: C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\fifo.sv(5): (vlog-13294) Identifier must be declared with a port mode: wr_data.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, VERI-1072 error x1, VERI-1128 error x2, VERI-1952 error x2.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/fifo/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/fifo.sv)

### qwen3.5:4b — bugfix

**Request:** The following SystemVerilog has at least two problems (an inferred latch and an asynchronous reset where a synchronous one was required). Return a corrected, synthesisable version of the whole module and nothing else.

module mux_reg(input logic clk, rst, sel, input logic [7:0] a, b, output logic [7:0] q);
  logic [7:0] r;
  always_comb begin
    if (sel == 1'b1) r = a;
    else if (sel == 1'b0) r = b;
  end
  always_ff @(posedge clk or posedge rst) begin
    if (rst) q <= 8'h00;
    else q <= r;
  end
endmodule

**Source run:** 20260921-051654-verilog-skill

**Result:** ELABORATION_FAIL; simulation ELABORATION_FAIL; 0 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\bugfix.sv(20): (vopt-7033) Variable 'q' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\bugfix.sv(13).
- # ** Error (suppressible): C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\bugfix.sv(22): (vopt-7033) Variable 'q' driven in a combinational block, may not be driven by any other process. See C:\hdl_projects\ai_on_prem\20260921-051654-verilog-skill\qwen3.5_4b\bugfix.sv(13).
- # ** Error: (vopt-2064) Compiler back-end code generation process terminated due to previous errors with code 12.

**Blue Pearl:** ANALYSIS_ERROR. BPS-0752 error x1, ELAB-1000 error x1, ELAB-1001 error x1, VERI-1924 warning x1, VERI-1971 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/bugfix/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.5_4b/bugfix.sv)
- default: ELABORATION_FAIL; 0 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.5_4b/bugfix/sim_default.log)

### qwen3.8-flash-next — counter

**Request:** Write a SystemVerilog module 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit output). Count increments when en is high and wraps at 15.

**Source run:** 20260921-062620-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/counter/compile.log) · [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/counter.sv)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/counter/sim_default.log)

### qwen3.8-flash-next — cdc_sync

**Request:** Write a parameterised two-flop clock-domain-crossing synchroniser module 'cdc_sync' for a single-bit signal in SystemVerilog. Add the Xilinx ASYNC_REG attribute on the flops and a parameter STAGES defaulting to 2.

**Source run:** 20260921-062620-verilog-skill

**Result:** FAIL; simulation FAIL; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- The output selects a separate fixed two-flop chain for every STAGES value. The parameterized sync_reg chain is unused and unannotated.
- STAGES destination-edge latency

**Blue Pearl:** COMPLETE. BPS-0534 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/cdc_sync/compile.log) · [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/cdc_sync.sv)
- default: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/cdc_sync/sim_default.log)
- stages3: FAIL; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/cdc_sync/sim_stages3.log)

### qwen3.8-flash-next — axi_lite

**Request:** Write a minimal AXI4-Lite slave module 'axil_regs' in SystemVerilog with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper valid/ready handshakes and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-062620-verilog-skill

**Result:** INTERFACE_FAIL; simulation INTERFACE_FAIL; 0 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- Missing required port rready

**Blue Pearl:** ANALYSIS_ERROR. BPS-0112 warning x4, BPS-0752 error x1, ELAB-1000 error x1, ELAB-1001 error x1, VERI-1899 warning x2, VERI-1924 warning x1, VERI-1971 warning x1, VERI-2580 warning x2.

[Full lint log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/axi_lite/compile.log) · [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/axi_lite.sv)

### qwen3.8-flash-next — uart_tx

**Request:** Write a SystemVerilog UART transmitter module 'uart_tx' with parameters CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data[7:0], data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-062620-verilog-skill

**Result:** FAIL; simulation FAIL; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- 8N1 bit=0 cycle=7 payload=55
- 8N1 bit=1 cycle=7 payload=55
- 8N1 bit=2 cycle=7 payload=55
- 8N1 bit=3 cycle=7 payload=55
- 8N1 bit=4 cycle=7 payload=55
- 8N1 bit=5 cycle=7 payload=55
- 8N1 bit=6 cycle=7 payload=55
- 8N1 bit=7 cycle=7 payload=55
- 8N1 bit=8 cycle=7 payload=55
- 8N1 bit=1 cycle=7 payload=a6
- 8N1 bit=3 cycle=7 payload=a6
- 8N1 bit=5 cycle=7 payload=a6

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/uart_tx/compile.log) · [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/uart_tx.sv)
- default: FAIL; 624 checks; [simulation log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/uart_tx/sim_default.log)
- divisor13: FAIL; 1004 checks; [simulation log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/uart_tx/sim_divisor13.log)

### qwen3.8-flash-next — fifo

**Request:** Write a synchronous FIFO module 'sync_fifo' in SystemVerilog with parameters WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-062620-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/fifo/compile.log) · [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/fifo.sv)
- default: PASS; 3455 checks; [simulation log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/fifo/sim_default.log)
- width16_depth4: PASS; 3381 checks; [simulation log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/fifo/sim_width16_depth4.log)

### qwen3.8-flash-next — bugfix

**Request:** The following SystemVerilog has at least two problems (an inferred latch and an asynchronous reset where a synchronous one was required). Return a corrected, synthesisable version of the whole module and nothing else.

module mux_reg(input logic clk, rst, sel, input logic [7:0] a, b, output logic [7:0] q);
  logic [7:0] r;
  always_comb begin
    if (sel == 1'b1) r = a;
    else if (sel == 1'b0) r = b;
  end
  always_ff @(posedge clk or posedge rst) begin
    if (rst) q <= 8'h00;
    else q <= r;
  end
endmodule

**Source run:** 20260921-062620-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/bugfix/compile.log) · [RTL](../20260921-062620-verilog-skill/qwen3.8-flash-next/bugfix.sv)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-062620-verilog-skill/qwen3.8-flash-next/bugfix/sim_default.log)

### qwen3.8:27b — counter

**Request:** Write a SystemVerilog module 'counter4' with ports clk, rst (active-high synchronous), en, and count (4-bit output). Count increments when en is high and wraps at 15.

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 321 evaluated assertions.

**Coverage:** 160 enable/reset cycles; hold, reset priority, off-edge reset, multiple modulo-16 wraps.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/counter/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/counter/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/counter.sv)
- default: PASS; 321 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/counter/sim_default.log)

### qwen3.8:27b — cdc_sync

**Request:** Write a parameterised two-flop clock-domain-crossing synchroniser module 'cdc_sync' for a single-bit signal in SystemVerilog. Add the Xilinx ASYNC_REG attribute on the flops and a parameter STAGES defaulting to 2.

**Source run:** 20260921-051654-verilog-skill

**Result:** REQUEST_MISMATCH; simulation PASS; 800 evaluated assertions.

**Coverage:** 200 input changes per configuration; no feedthrough; destination-edge latency at STAGES=2 and 3; independent source clock when exposed.

- Required ASYNC_REG attribute missing from code.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/cdc_sync/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/cdc_sync/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/cdc_sync.sv)
- default: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/cdc_sync/sim_default.log)
- stages3: PASS; 400 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/cdc_sync/sim_stages3.log)

### qwen3.8:27b — axi_lite

**Request:** Write a minimal AXI4-Lite slave module 'axil_regs' in SystemVerilog with four 32-bit read/write registers at byte offsets 0x0,0x4,0x8,0xC. Implement the AW, W, B, AR and R channels with proper valid/ready handshakes and return the register values on read. Expose the four registers as outputs reg0..reg3.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 160 evaluated assertions.

**Coverage:** All four offsets; exposed register outputs; simultaneous AW/W; AW-before-W and W-before-AW; payload changes after acceptance; B/R backpressure; repeated accesses; partial and zero byte strobes when exposed.

- R data/valid stable while stalled

**Blue Pearl:** COMPLETE. BPS-0112 warning x4, BPS-0534 warning x2.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/axi_lite/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/axi_lite/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/axi_lite.sv)
- default: FAIL; 160 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/axi_lite/sim_default.log)

### qwen3.8:27b — uart_tx

**Request:** Write a SystemVerilog UART transmitter module 'uart_tx' with parameters CLK_HZ and BAUD. Ports: clk, rst (sync, active-high), data[7:0], data_valid, tx, busy. 8N1 framing, LSB first, one start and one stop bit.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 1628 evaluated assertions.

**Coverage:** 8N1 at divisors 8 and 13; bytes 55/A6/00/FF; every bit cycle, LSB-first order, busy, idle, data capture, synchronous reset during a frame.

- 8N1 bit=1 cycle=0 payload=55
- 8N1 bit=1 cycle=1 payload=55
- 8N1 bit=1 cycle=2 payload=55
- 8N1 bit=1 cycle=3 payload=55
- 8N1 bit=1 cycle=4 payload=55
- 8N1 bit=1 cycle=5 payload=55
- 8N1 bit=1 cycle=6 payload=55
- 8N1 bit=1 cycle=7 payload=55
- 8N1 bit=2 cycle=0 payload=55
- 8N1 bit=2 cycle=1 payload=55
- 8N1 bit=2 cycle=2 payload=55
- 8N1 bit=2 cycle=3 payload=55

**Blue Pearl:** COMPLETE. BPS-0534 warning x1.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/uart_tx/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/uart_tx/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/uart_tx.sv)
- default: FAIL; 624 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/uart_tx/sim_default.log)
- divisor13: FAIL; 1004 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/uart_tx/sim_divisor13.log)

### qwen3.8:27b — fifo

**Request:** Write a synchronous FIFO module 'sync_fifo' in SystemVerilog with parameters WIDTH and DEPTH (power of two). Ports: clk, rst, wr_en, wr_data, rd_en, rd_data, full, empty. Use a single-clock inferred block RAM and binary pointers with an extra wrap bit for full/empty detection.

**Source run:** 20260921-051654-verilog-skill

**Result:** FAIL; simulation FAIL; 6836 evaluated assertions.

**Coverage:** WIDTH/DEPTH=8/8 and 16/4; exact capacity, overflow/underflow rejection, fill/drain, wraps, simultaneous operations away from full/empty, 600 deterministic mixed operations, data scoreboard.

- Read data is a combinational RAM lookup, rather than a clocked RAM read. This does not implement the requested synchronous block-RAM read structure.
- FIFO ordering / synchronous read

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/fifo/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/fifo/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/fifo.sv)
- default: FAIL; 3455 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/fifo/sim_default.log)
- width16_depth4: FAIL; 3381 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/fifo/sim_width16_depth4.log)

### qwen3.8:27b — bugfix

**Request:** The following SystemVerilog has at least two problems (an inferred latch and an asynchronous reset where a synchronous one was required). Return a corrected, synthesisable version of the whole module and nothing else.

module mux_reg(input logic clk, rst, sel, input logic [7:0] a, b, output logic [7:0] q);
  logic [7:0] r;
  always_comb begin
    if (sel == 1'b1) r = a;
    else if (sel == 1'b0) r = b;
  end
  always_ff @(posedge clk or posedge rst) begin
    if (rst) q <= 8'h00;
    else q <= r;
  end
endmodule

**Source run:** 20260921-051654-verilog-skill

**Result:** PASS_TESTED; simulation PASS; 513 evaluated assertions.

**Coverage:** 256 registered mux samples; both inputs; output holds between clock edges; synchronous reset. Unknown select is informational; latch inference is assessed by lint/source review.

- No mismatch found in the executed behavioral and checked structural requirements.

**Blue Pearl:** COMPLETE. No errors or warnings.

[Full lint log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/bugfix/bps_final/bluepearl.log) · [Compiler log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/bugfix/compile.log) · [RTL](../20260921-051654-verilog-skill/qwen3.8_27b/bugfix.sv)
- default: PASS; 513 checks; [simulation log](batches/20260922-161336/runs/20260921-051654-verilog-skill/qwen3.8_27b/bugfix/sim_default.log)

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