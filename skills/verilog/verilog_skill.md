# SystemVerilog coding rules (IEEE 1800-2012, must pass `iverilog -g2012`)

Output only SystemVerilog. One module per answer, compilable as given.

## Module structure
- ANSI ports, explicit direction and width: `input logic clk, input logic [7:0] data, output logic tx`.
- `logic` for everything — never `wire`/`reg`. Every signal, output ports included, is driven from exactly one `always_ff`, one `always_comb`, or one `assign` — never two, and never `assign` plus a clocked write.
- `parameter` / `localparam` scalars only: `localparam int CYCLES = CLK_HZ / BAUD;`. No unpacked-array localparams (`localparam X [3:0] = '{...}` does not compile). Hex literals are `32'h0000_000C`, never `0x`.

## Registers, resets
- `always_ff @(posedge clk)` with synchronous active-high reset checked first, unless the prompt says otherwise. Non-blocking `<=` only.
- Reset every register; use `'0`.

## Combinational logic
- `always_comb`, blocking `=` only, every output given a default at the top, `case` has `default`.

## State machines (most common compile error)
- `typedef enum logic [1:0] {ST_IDLE, ST_START, ST_DATA, ST_STOP} state_t;` — the width must hold every member (4 members → 2 bits, 5–8 → 3 bits). Prefix states `ST_` so they never clash with ports like `data`.
- Refer to states by bare name: `state <= ST_IDLE;` `case (state) ST_IDLE: ...` — never `state_t::ST_IDLE`.
- Assign enums only from enum literals or another enum of the same type; never from an integer/expression without a cast `state_t'(x)`.

## Generate, loops, arrays
- Prefer vectors to generate blocks: a shift chain is `logic [STAGES-1:0] sync; always_ff @(posedge clk) sync <= {sync[STAGES-2:0], din};` and the output is `sync[STAGES-1]`.
- If `generate` is used: no nesting, and never reference `blk[i].sig` from outside the generate with a loop variable.
- `for` loops inside `always_ff`/`always_comb` use `int i` and constant bounds.

## Attributes (e.g. ASYNC_REG, KEEP, MARK_DEBUG)
Attribute goes immediately before the declaration it applies to — nowhere else (not in the always block, not on the assignment):
```systemverilog
(* ASYNC_REG = "TRUE" *) logic [STAGES-1:0] sync;
(* KEEP = "TRUE" *)      logic              dbg_pulse;
```

## Shift registers
One statement, concatenation, in the always_ff — no loops, no per-bit assignments:
```systemverilog
sr <= {sr[N-2:0], din};   // shift left: new bit enters at 0, oldest is sr[N-1]  (CDC synchroniser)
sr <= {1'b0, sr[7:1]};    // shift right: LSB falls off first  (UART TX, tx <= sr[0])
```

## Reference — this compiles; copy its structure
```systemverilog
module sync_count #(parameter int STAGES = 2, parameter int WIDTH = 4) (
  input  logic             clk, rst, en,
  input  logic             async_in,
  output logic             sync_out,
  output logic [WIDTH-1:0] count);

  logic [WIDTH-1:0] cnt;
  (* ASYNC_REG = "TRUE" *) logic [STAGES-1:0] sync;   // attribute directly before its declaration

  assign count    = cnt;                               // pure wiring only in assign
  assign sync_out = sync[STAGES-1];

  always_ff @(posedge clk) sync <= {sync[STAGES-2:0], async_in};   // synchroniser: no reset, no logic between stages

  always_ff @(posedge clk) begin                       // cnt is written here and nowhere else
    if (rst)     cnt <= '0;
    else if (en) cnt <= cnt + 1'b1;                    // wraps at 2**WIDTH-1
  end
endmodule
```
