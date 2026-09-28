# Protocol reference validation — 28 September 2026

These results apply to the original RTL code blocks in the twelve added protocol guides. They
are separate from model-generated benchmark results in run one and run two. No new model run
using these twelve guides has been evaluated yet.

QuestaSim Base Edition 2025.3 compiled VHDL with `vcom -2008` and SystemVerilog with `vlog -sv`,
then ran shared, self-checking SystemVerilog benches, one simulation at a time. There were no
RTL compilation failures. All 20 suite/configuration runs passed, totalling 6,274 checks.

Blue Pearl Visual Verification Suite 2026.4.68770 ran RTL-only analysis on all eighteen module
roots under the same project lint policy, with no per-module waivers. All analyses completed:
**0 errors, 3 warnings**. The I2C master analysis also included its bit-engine dependency.

## Simulation results

| Suite/configuration | VHDL checks | SystemVerilog checks | Result |
|---|---:|---:|---|
| axis_fifo2 | 1472 | 1472 | PASS / PASS |
| axif_burst_cursor | 1224 | 1224 | PASS / PASS |
| apb_regs | 289 | 289 | PASS / PASS |
| ahb_regs | 17 | 17 | PASS / PASS |
| spi mode 0 | 25 | 25 | PASS / PASS |
| spi mode 1 | 25 | 25 | PASS / PASS |
| spi mode 2 | 25 | 25 | PASS / PASS |
| spi mode 3 | 25 | 25 | PASS / PASS |
| i2c | 26 | 26 | PASS / PASS |
| i2c_bit_engine | 9 | 9 | PASS / PASS |

Checks are individual scoreboard/assertion evaluations, not independent proof obligations or a
coverage percentage. Paired master/slave tests are supplemented by independent serial drivers
and monitors. Coverage includes:

- AXI4-Stream: queue ordering, stalls, simultaneous traffic, KEEP/LAST/USER, drain and reset.
- AXI4 burst cursor: accepted address/ID/LAST sequencing, stalls, FIXED/INCR/WRAP, maximum INCR length and invalid-command rejection, including 4-KiB crossing.
- APB: wait states, all strobe masks, readback and address errors without write side effects.
- AHB-Lite: overlapping address/data phases, global waits, selection changes, saved address, inactive transfers and two-cycle ERROR.
- SPI: four modes, exact edge counts, TX capture, independent receive/transmit data, MISO release, continuous-CS slave transfers and partial-frame abort.
- I2C: addressed reads/writes, unmatched-address NACK, TX capture, stretching, bus-busy timeout and reset recovery; independent-driver slave multi-byte transfers and repeated START; isolated bit-engine arbitration loss and stretch timeout.

## Blue Pearl results

Each cell is errors / warnings. Counts are native message-ID summary counts.

| Module root | VHDL | SystemVerilog |
|---|---:|---:|
| ahb_regs | 0 / 1 | 0 / 1 |
| apb_regs | 0 / 0 | 0 / 0 |
| axif_burst_cursor | 0 / 0 | 0 / 0 |
| axis_fifo2 | 0 / 0 | 0 / 0 |
| i2c_bit_engine | 0 / 0 | 0 / 0 |
| i2c_byte_master | 0 / 0 | 0 / 1 |
| i2c_byte_slave | 0 / 0 | 0 / 0 |
| spi_byte_master | 0 / 0 | 0 / 0 |
| spi_byte_slave | 0 / 0 | 0 / 0 |

Remaining warnings were reviewed and retained:

- `BPS-0534`, `ahb_regs`, once per language: `HTRANS[0]` is unused. This word-register subordinate uses `HTRANS[1]` to accept NONSEQ/SEQ and reject IDLE/BUSY; it does not need to distinguish NONSEQ from SEQ.
- `VERI-1209`, SystemVerilog `i2c_byte_master`: increment expression truncated into the five-bit transaction index. The state machine initializes at zero and stops at 17, before overflow; indices into each byte are explicitly three bits and guarded by the corresponding phase range.

Questa reported one VHDL `NUMERIC_STD.TO_INTEGER` metavalue warning at time zero in the burst
cursor, before the mixed-language testbench inputs settled. The subsequent reset and functional
checks passed. The batch launcher also emits an `onerror`-outside-macro command warning; the
runner independently checks process return codes and the explicit check/failure summary.
These messages are disclosed separately from the Blue Pearl counts.

## Scope and evidence

This is functional regression plus lint, not formal protocol certification, synthesis/implementation
sign-off or proof of physical pad timing. Small I2C timing defaults are sequencing examples;
select counts from the real clock and bus specification. SPI/I2C slave oversampling limits must
be enforced. Unsupported features and required extensions are listed in each guide. In particular,
repeated START was tested on the I2C slave, not implemented by the one-byte master; the AXI4 cursor
was tested, not a complete AXI4 endpoint.

[Machine-readable results](protocol_validation.json) identify the exact guide/code hashes, simulation
outcomes, lint diagnostics and lint-policy hash. Every published HDL code block was compared with
the tested source. Local testbenches, scripts and full tool outputs are retained under
`verification/protocol_expansion_20260928` in the working project; those executable harnesses/tool
databases are not included in this results repository.
