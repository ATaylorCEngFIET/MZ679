# Local AI RTL results

Final RTL and saved verification results for seven model configurations, six tasks and two languages: **84 implementations**. Sources were generated on 21 September 2026 and verified in batch 20260922-161336 on 22 September 2026.

- [VHDL results](verification/results_vhdl.md)
- [SystemVerilog results](verification/results_verilog.md)
- [HTML report](verification/results.html) — clone/download and open locally
- [Model summary](model_summary.csv) and [per-design results](design_results.csv)
- [Full result records and recorded methodology](results.json)
- [Questa permissive-flag results](verification/flag_probe_20260927/README.md)

The dated directories contain the 84 final RTL files. The verification directories contain saved compiler, simulation and Blue Pearl diagnostics. Reports link directly to the RTL and lint results. Generation drafts, skills, scripts and testbenches are not distributed in this repository. References in historical diagnostics describe the original execution environment.

| Language | Designs | Behavioral passes | Checked request passes | Lint errors | Lint warnings |
|---|---:|---:|---:|---:|---:|
| VHDL | 42 | 16 | 11 | 204 | 61 |
| SystemVerilog | 42 | 17 | 15 | 159 | 150 |

Results cover the recorded checks; they are not exhaustive correctness proofs. The separate permissive-flag experiment did not rerun behavioral tests or change these scores. No HDL tools were rerun while packaging this repository.

`FILES_SHA256.json` records the delivered files. Original RTL bytes and all per-design result records are preserved.
