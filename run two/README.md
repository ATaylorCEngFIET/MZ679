# Run two: AMD-Halo with updated protocol skills

84 final RTL implementations: seven selected blog models, six tasks and two languages. Source archive: `sweep-20260928-140038-amd-halo.tgz`. The four dated source directories include the main model runs and separate Flash-Next runs; Spark and Atlas sources are excluded.

- [VHDL results](verification/results_vhdl.md)
- [SystemVerilog results](verification/results_verilog.md)
- [HTML report](verification/results.html) — download or clone and open locally
- [Full result records](results.json)
- [Generation provenance and skill hashes](generation_metadata.json)
- [Current skills](../skills/)

| Language | Designs | Behavioral passes | Checked request passes | Blue Pearl errors | Warnings |
|---|---:|---:|---:|---:|---:|
| VHDL | 42 | 36 | 29 | 25 | 94 |
| SystemVerilog | 42 | 35 | 35 | 0 | 89 |

AXI-Lite passes: 5/7 VHDL and 4/7 SystemVerilog. All nine passing AXI implementations also passed the supplemental protocol checks; their saved logs/results are in each design's `axi_extended` directory.

Verification used Questa 2025.3 and Blue Pearl 2026.4.68770 nightly on the central Windows installation. Original RTL was not repaired during verification. Lint counts are diagnostic occurrences, not unique defect counts. A simulation pass is not exhaustive correctness proof; checked request compliance is reported separately.

AMD-Halo's original task-file hashes differ from the supplied common suite; the original task-file bytes were unavailable and the difference was described as minor. That limitation is retained in the recorded methodology. Run one is the original September 21 publication, not the September 28 pre-update Halo baseline, so these two repository folders do not form a controlled skills-only comparison.

This folder contains RTL and saved results. Executable testbenches, verification scripts and simulator databases are omitted. `FILES_SHA256.json` records the delivered file bytes.
