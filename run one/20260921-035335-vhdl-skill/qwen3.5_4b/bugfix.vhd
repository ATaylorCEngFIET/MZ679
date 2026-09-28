--------------------------------------------------------------------------------
-- mux_reg : 8-bit multiplexer with register and reset.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_reg IS
  PORT (
    i_clk   : IN  std_ulogic;                     -- system clock
    i_rst   : IN  std_ulogic;                     -- reset, active high
    i_sel   : IN  std_ulogic;                     -- select line
    i_a     : IN  std_logic_vector(7 DOWNTO 0);  -- input a
    i_b     : IN  std_logic_vector(7 DOWNTO 0);  -- input b
    o_q     : OUT std_logic_vector(7 DOWNTO 0)   -- output q
  );
END ENTITY mux_reg;

ARCHITECTURE rtl OF mux_reg IS
  SIGNAL s_muxed_data : std_logic_vector(7 DOWNTO 0);
BEGIN
  -- Combinational logic: multiplexes inputs based on select.
  mux_proc : PROCESS (i_sel, i_a, i_b)
  BEGIN
    IF i_sel = '1' THEN
      s_muxed_data <= i_a;
    ELSIF i_sel = '0' THEN
      s_muxed_data <= i_b;
    END IF;
  END PROCESS mux_proc;

  -- Sequential logic: registers output on clock edge, clears on reset.
  reg_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      IF i_rst = '1' THEN
        o_q <= (OTHERS => '0');
      ELSIF i_sel = '1' THEN
        o_q <= i_a;
      ELSIF i_sel = '0' THEN
        o_q <= i_b;
      END IF;
    END IF;
  END PROCESS reg_proc;

END ARCHITECTURE rtl;
