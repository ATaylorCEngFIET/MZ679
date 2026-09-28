# Questa permissive-option experiment

Executed 27 September 2026 with installed QuestaSim Base Edition-64 2025.3. Selected only the seven retained model configurations. Original RTL and benchmark verdicts were not changed.

Recompiled all 21 source-compilation failures using `vcom -2008 -permissive` or `vlog -sv -permissive`: none became successful compiles. Recompiled the four SystemVerilog elaboration failures and optimized their generated benches using `vopt -permissive work.tb -o tb_relaxed`: all four optimized successfully. Behavioral simulations were not rerun as part of this probe.

The local `verror -kind vopt 7033` help confirms that the language requires a variable written by always_comb/always_latch/always_ff not be written by another process, and that -permissive downgrades this diagnostic to a warning. Accepting these designs does not repair the multiple-driver violation or establish functional/synthesis correctness.

| Language | Model | Task | Baseline | Permissive compile | Permissive optimization |
|---|---|---|---|---|---|
| vhdl | bluepearl-rtl | cdc_sync | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | gemma4-fpga | cdc_sync | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | gemma4-fpga | fifo | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | gemma4-fpga | uart_tx | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen-fpga | axi_lite | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen-fpga | cdc_sync | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen-fpga | fifo | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3-coder_30b | axi_lite | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3-coder_30b | fifo | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3.5_4b | axi_lite | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3.5_4b | cdc_sync | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3.5_4b | fifo | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3.5_4b | uart_tx | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3.8_27b | axi_lite | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3.8_27b | cdc_sync | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3.8_27b | fifo | COMPILE_FAIL | FAIL | NOT RUN |
| verilog | qwen-fpga | axi_lite | ELABORATION_FAIL | PASS | PASS |
| verilog | qwen-fpga | bugfix | ELABORATION_FAIL | PASS | PASS |
| verilog | qwen-fpga | fifo | COMPILE_FAIL | FAIL | NOT RUN |
| verilog | qwen3-coder_30b | fifo | ELABORATION_FAIL | PASS | PASS |
| verilog | qwen3.5_4b | axi_lite | COMPILE_FAIL | FAIL | NOT RUN |
| verilog | qwen3.5_4b | bugfix | ELABORATION_FAIL | PASS | PASS |
| verilog | qwen3.5_4b | fifo | COMPILE_FAIL | FAIL | NOT RUN |
| verilog | qwen3.5_4b | uart_tx | COMPILE_FAIL | FAIL | NOT RUN |
| vhdl | qwen3.8-flash-next | fifo | COMPILE_FAIL | FAIL | NOT RUN |

Commands, return codes and diagnostics: [results.json](results.json).

Recommendation: keep the original benchmark as the standards-conformance result, and use permissive elaboration only as a separately labelled diagnostic run. Retain warnings. `-warning 7033` is a narrower diagnostic downgrade supported by local help; this experiment used `-permissive`.