--------------------------------------------------------------------------------
-- mux_reg : 8-bit multiplexer with registered output.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_reg IS
  PORT (
    i_clk : IN  std_ulogic;                     -- system clock
    i_rst : IN  std_ulogic;                     -- reset, active high
    i_sel : IN  std_ulogic;                     -- select input
    i_a   : IN  std_ulogic_vector(7 DOWNTO 0);  -- input A
    i_b   : IN  std_ulogic_vector(7 DOWNTO 0);  -- input B
    o_q   : OUT std_ulogic_vector(7 DOWNTO 0)   -- output
  );
END ENTITY mux_reg;

ARCHITECTURE rtl OF mux_reg IS
  SIGNAL s_r : std_ulogic_vector(7 DOWNTO 0);
BEGIN
  -- Mux select: choose between i_a and i_b based on i_sel.
  mux_proc : PROCESS (i_sel, i_a, i_b)
  BEGIN
    IF i_sel = '1' THEN
      s_r <= i_a;
    ELSE
      s_r <= i_b;
    END IF;
  END PROCESS mux_proc;

  -- Output register: synchronous reset, captures mux output on clock edge.
  reg_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        o_q <= (OTHERS => '0');
      ELSE
        o_q <= s_r;
      END IF;
    END IF;
  END PROCESS reg_proc;
END ARCHITECTURE rtl;
