# RTL protocol skills

Use a language coding guide plus the protocol guide relevant to the task. Each new guide gives
protocol invariants, implementation structure, original reference RTL, test scenarios and explicit
limits. The requested interface and features take priority over example defaults.

## Existing guides

- [VHDL coding rules](vhdl/vhdl_skill.md) and [existing protocol examples, including corrected AXI-Lite](vhdl/vhdl_protocols.md).
- [SystemVerilog coding rules](verilog/verilog_skill.md) and [existing protocol examples, including corrected AXI-Lite](verilog/verilog_protocols.md).

These four files retain their previous contents and hashes. The added files below were not used
in the published run-one or run-two model generations.

## Added protocol guides

| Protocol | VHDL-2008 | SystemVerilog |
|---|---|---|
| AXI4-Stream | [VHDL](vhdl/protocols/vhdl_axi_stream.md) | [SystemVerilog](verilog/protocols/verilog_axi_stream.md) |
| AXI4 Full | [VHDL](vhdl/protocols/vhdl_axi_full.md) | [SystemVerilog](verilog/protocols/verilog_axi_full.md) |
| APB | [VHDL](vhdl/protocols/vhdl_apb.md) | [SystemVerilog](verilog/protocols/verilog_apb.md) |
| AHB / AHB-Lite | [VHDL](vhdl/protocols/vhdl_ahb.md) | [SystemVerilog](verilog/protocols/verilog_ahb.md) |
| SPI master and slave | [VHDL](vhdl/protocols/vhdl_spi.md) | [SystemVerilog](verilog/protocols/verilog_spi.md) |
| I2C master and slave | [VHDL](vhdl/protocols/vhdl_i2c.md) | [SystemVerilog](verilog/protocols/verilog_i2c.md) |

SPI includes separate master and slave implementations, all four clock modes, continuous-CS
slave operation and partial-frame recovery. I2C includes a bit engine, a one-byte master and a
multi-byte slave supporting repeated START. The I2C master needs a message sequencer extension
for repeated-START combined transactions; the slave does not stretch SCL.

The AXI4 Full reference is a burst-address building block, not a complete five-channel endpoint.
Its guide explains the additional channel buffers, ordering and response logic required. The
AHB reference implements an AHB-Lite register subordinate, not classic AHB arbitration or AHB5.
All guides state their other supported features and timing assumptions.

## Select guides for local generation

The current `ai_bench/bench_models.py` loader accepts multiple paths with `--skill`. Directory
loading reads only top-level Markdown/text files in the selected language directory. It does
not recursively load the new `protocols` subdirectory. Existing `--skill skills` behavior is
therefore unchanged; select a new guide explicitly for a new protocol task.

From the local `ai_bench` directory, with your own task files defining the requested interfaces:

```powershell
python bench_models.py --lang vhdl --tasks my_spi_tasks.json --skill skills/vhdl/vhdl_skill.md skills/vhdl/protocols/vhdl_spi.md
python bench_models.py --lang verilog --tasks my_i2c_tasks.json --skill skills/verilog/verilog_skill.md skills/verilog/protocols/verilog_i2c.md
```

The task filenames above are examples to replace with your actual task files. The generation
runner is part of the local benchmark package and is not distributed in this results repository.
Select a single language when passing explicit language-specific guide paths. To use an existing
reference as well, add its file path to the same `--skill` list. Keep unrelated protocol guides out
of the prompt, especially when the model has limited context capacity.

State the role, supported features, clock/reset behavior, port list, timing and error policy in
each task. Require self-checking tests for the guide's corner cases. A reference passing tests
does not establish that a model adapted it correctly: compile, simulate and lint each new output.

## Validation

[Reference validation record](PROTOCOL_VALIDATION.md) and [machine-readable results and hashes](protocol_validation.json).
