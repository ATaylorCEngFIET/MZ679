--------------------------------------------------------------------------------
-- mux_reg : 8-bit multiplexer followed by a synchronous register.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_reg IS
  PORT (
    i_clk : IN  std_ulogic;                     -- system clock
    i_rst : IN  std_ulogic;                     -- synchronous reset, active high
    i_sel : IN  std_ulogic;                     -- select signal
    i_a   : IN  std_ulogic_vector(7 DOWNTO 0);  -- input a
    i_b   : IN  std_ulogic_vector(7 DOWNTO 0);  -- input b
    o_q   : OUT std_ulogic_vector(7 DOWNTO 0)   -- registered output
  );
END ENTITY mux_reg;

ARCHITECTURE rtl OF mux_reg IS
  SIGNAL s_mux_out : std_ulogic_vector(7 DOWNTO 0);
BEGIN

  -- Combinational multiplexer logic
  mux_proc : PROCESS (i_sel, i_a, i_b)
  BEGIN
    IF i_sel = '1' THEN
      s_mux_out <= i_a;
    ELSE
      s_mux_out <= i_b;
    END IF;
  END PROCESS mux_proc;

  -- Synchronous output register
  reg_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        o_q <= (OTHERS => '0');
      ELSE
        o_q <= s_mux_out;
      END IF;
    END IF;
  END PROCESS reg_proc;

END ARCHITECTURE rtl;
