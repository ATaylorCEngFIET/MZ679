# Local AI RTL results

- [Run one](run%20one/README.md): the previously published RTL and verification snapshot, generated on 21 September 2026.
- [Run two — AMD-Halo](run%20two/README.md): 84 new AMD-Halo implementations generated on 28 September 2026 using the updated protocol skills, with saved simulation and Blue Pearl results.
- [Protocol guide index](skills/README.md): AXI4-Stream, AXI4 Full, APB, AHB-Lite, and SPI/I2C master and slave guides in both languages, with reference validation results.
- [VHDL skills](skills/vhdl/vhdl_skill.md) and [protocol examples](skills/vhdl/vhdl_protocols.md).
- [SystemVerilog skills](skills/verilog/verilog_skill.md) and [protocol examples](skills/verilog/verilog_protocols.md).

Each run covers the same seven selected blog model configurations, six tasks and two HDL languages. Run two contains AMD-Halo only; no new Spark or Atlas data is included. Simulations and lint ran centrally on Windows, rather than on the generation machine.

The skills folder is the current version, including the corrected AXI-Lite reference examples. Both protocol-file hashes match the AMD-Halo run-two manifests. The accompanying coding-rule files are the current local versions; generation metadata retains the exact hashes used during generation.

Original RTL and saved result records are preserved. Articles, generation drafts, testbenches, verification scripts and tool databases are not included. Historical logs can reference the original local execution paths. Run one's README describes its original publication scope; skills are now supplied separately at the repository root.
