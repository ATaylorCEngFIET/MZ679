--------------------------------------------------------------------------------
-- axil_regs : Minimal AXI4-Lite slave with 4x32-bit registers.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY axil_regs IS
  GENERIC (
    g_clk_freq : INTEGER := 100000000 -- System clock frequency in Hz
  );
  PORT (
    i_clk   : IN  std_ulogic;                      -- System clock
    i_rst   : IN  std_ulogic;                      -- Reset, active high
    
    -- AXI4-Lite Write Channel
    i_awvalid : IN  std_ulogic;                     -- AW channel valid
    i_awready : OUT std_ulogic;                    -- AW channel ready
    i_awaddr : IN  unsigned(31 DOWNTO 0);          -- AW address
    i_awlen  : IN  unsigned(7 DOWNTO 0);           -- AW length (ignored for minimal)
    
    i_wvalid : IN  std_ulogic;                     -- W channel valid
    i_wready : OUT std_ulogic;                    -- W channel ready
    i_wdata : IN  std_logic_vector(31 DOWNTO 0);   -- W data
    i_wstrb  : IN  std_logic_vector(3 DOWNTO 0);   -- W strobe
    
    -- AXI4-Lite Read Channel
    i_arvalid : IN  std_ulogic;                    -- AR channel valid
    i_arready : OUT std_ulogic;                    -- AR channel ready
    i_araddr : IN  unsigned(31 DOWNTO 0);          -- AR address
    
    i_rvalid : OUT std_ulogic;                     -- R channel valid
    i_rready : IN  std_ulogic;                     -- R channel ready
    o_rdata  : OUT std_logic_vector(31 DOWNTO 0);  -- R data
    o_rresp  : OUT std_logic_vector(1 DOWNTO 0)    -- R response
    
  );
END ENTITY axil_regs;

ARCHITECTURE rtl OF axil_regs IS
  -- Constants
  CONSTANT c_reg_count : INTEGER := 4;              -- Number of registers
  CONSTANT c_reg_width : INTEGER := 32;             -- Register width in bits
  CONSTANT c_byte_offset : INTEGER := 4;             -- Byte offset between registers
  
  -- State types for FSMs
  TYPE state_type IS (IDLE, WAIT_ACK);
  
  -- Signals
  SIGNAL s_awvalid_reg   : std_ulogic;              -- AW valid registered
  SIGNAL s_awready_reg   : std_ulogic;              -- AW ready registered
  SIGNAL s_awaddr_reg    : unsigned(31 DOWNTO 0);  -- AW address registered
  
  SIGNAL s_wvalid_reg    : std_ulogic;              -- W valid registered
  SIGNAL s_wready_reg    : std_ulogic;              -- W ready registered
  SIGNAL s_wdata_reg     : std_logic_vector(31 DOWNTO 0); -- W data registered
  SIGNAL s_wstrb_reg     : std_logic_vector(3 DOWNTO 0); -- W strobe registered
  
  SIGNAL s_arvalid_reg   : std_ulogic;              -- AR valid registered
  SIGNAL s_arready_reg   : std_ulogic;              -- AR ready registered
  SIGNAL s_araddr_reg    : unsigned(31 DOWNTO 0);  -- AR address registered
  
  SIGNAL s_rvalid_reg    : std_ulogic;              -- R valid registered
  SIGNAL s_rdata_reg     : std_logic_vector(31 DOWNTO 0); -- R data registered
  SIGNAL s_rresp_reg     : std_logic_vector(1 DOWNTO 0); -- R response registered
  
  SIGNAL s_reg_state     : state_type;               -- Write FSM state
  SIGNAL s_reg_next      : state_type;              -- Write FSM next state
  
  SIGNAL s_reg_data      : unsigned(31 DOWNTO 0);   -- Internal register storage
  
  -- Register array for data storage (4 registers)
  TYPE reg_array_type IS RECORD
    r0 : UNSIGNED(31 DOWNTO 0);
    r1 : UNSIGNED(31 DOWNTO 0);
    r2 : UNSIGNED(31 DOWNTO 0);
    r3 : UNSIGNED(31 DOWNTO 0);
  END RECORD;
  
  SIGNAL s_regs          : reg_array_type;           -- Register storage
  
BEGIN
  -- AXI4-Lite Write Channel Logic
  write_channel_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      -- Register inputs
      s_awvalid_reg <= i_awvalid;
      s_wvalid_reg  <= i_wvalid;
      
      -- Register outputs (ready signals)
      s_awready_reg <= '0';
      s_wready_reg  <= '0';
      
      -- Decode address to register index
      -- Assuming word-aligned access for simplicity in this minimal design.
      -- Register index calculation: (addr / 4) % 4
      VAR v_idx : INTEGER := TO_INTEGER(s_awaddr_reg);
      VAR v_offset : INTEGER := (v_idx MOD c_reg_count) * c_byte_offset;
      
      -- Write FSM Logic
      CASE s_reg_state IS
        WHEN IDLE =>
          IF s_awvalid_reg = '1' THEN
            s_reg_next <= WAIT_ACK;
          ELSIF s_wvalid_reg = '1' THEN
            s_reg_next <= WAIT_ACK;
          END IF;
          
        WHEN WAIT_ACK =>
          -- Wait for AW or W ready
          IF s_awready_reg = '1' AND s_awvalid_reg = '1' THEN
            -- Accept AW, update address
            s_regs.r0 <= (OTHERS => '0'); -- Reset on new transaction start if needed
            s_reg_state <= IDLE;
          ELSIF s_wready_reg = '1' AND s_wvalid_reg = '1' THEN
            -- Accept W data
            VAR v_byte_offset : INTEGER := TO_INTEGER(s_awaddr_reg) MOD 4 * c_byte_offset;
            
            -- Apply wstrb per byte lane
            IF s_wstrb(0) = '1' THEN
              s_regs.r0(v_byte_offset + 7 DOWNTO v_byte_offset) <= s_wdata_reg(7 DOWNTO 0);
            END IF;
            IF s_wstrb(1) = '1' THEN
              s_regs.r1(v_byte_offset + 7 DOWNTO v_byte_offset) <= s_wdata_reg(7 DOWNTO 0);
            END IF;
            IF s_wstrb(2) = '1' THEN
              s_regs.r2(v_byte_offset + 7 DOWNTO v_byte_offset) <= s_wdata_reg(7 DOWNTO 0);
            END IF;
            IF s_wstrb(3) = '1' THEN
              s_regs.r3(v_byte_offset + 7 DOWNTO v_byte_offset) <= s_wdata_reg(7 DOWNTO 0);
            END IF;
            
            -- Assert B response
            o_rresp <= "00"; -- OKAY
            
            s_reg_state <= IDLE;
          END IF;
          
      END CASE;
      
      -- Update ready signals based on state and handshake
      IF s_reg_state = WAIT_ACK THEN
        IF s_awvalid_reg = '1' AND s_awready_reg = '0' THEN
          s_awready_reg <= '1';
        ELSIF s_wvalid_reg = '1' AND s_wready_reg = '0' THEN
          s_wready_reg <= '1';
        END IF;
      ELSE
        -- IDLE state: ready is low unless handshake completes
        IF s_awvalid_reg = '1' THEN
          s_awready_reg <= '0';
        ELSIF s_wvalid_reg = '1' THEN
          s_wready_reg <= '0';
        END IF;
      END IF;
      
    END IF;
  END PROCESS write_channel_proc;
  
  -- AXI4-Lite Read Channel Logic
  read_channel_proc : PROCESS (i_clk)
  BEGIN
    IF rising_edge(i_clk) THEN
      -- Register inputs
      s_arvalid_reg <= i_arvalid;
      
      -- Register outputs
      s_arready_reg <= '0';
      s_rvalid_reg  <= '0';
      o_rdata       <= (OTHERS => '0');
      o_rresp       <= "11"; -- DECERR default
      
      -- Decode address to register index
      VAR v_idx : INTEGER := TO_INTEGER(s_araddr_reg);
      VAR v_offset : INTEGER := (v_idx MOD c_reg_count) * c_byte_offset;
      
      -- Read FSM Logic
      CASE s_reg_state IS
        WHEN IDLE =>
          IF s_arvalid_reg = '1' THEN
            s_reg_next <= WAIT_ACK;
          END IF;
          
        WHEN WAIT_ACK =>
          IF s_arready_reg = '1' AND s_arvalid_reg = '1' THEN
            -- Accept AR, assert R valid immediately for minimal slave
            s_rvalid_reg <= '1';
            o_rdata      <= std_logic_vector(s_regs.r0); -- Return r0 as example read
            o_rresp      <= "00"; -- OKAY
            
            s_reg_state <= IDLE;
          END IF;
          
      END CASE;
      
      -- Update ready signals
      IF s_reg_state = WAIT_ACK THEN
        IF s_arvalid_reg = '1' AND s_arready_reg = '0' THEN
          s_arready_reg <= '1';
        END IF;
      ELSE
        IF s_arvalid_reg = '1' THEN
          s_arready_reg <= '0';
        END IF;
      END IF;
      
    END IF;
  END PROCESS read_channel_proc;
  
  -- Register Output Mapping
  o_reg0 <= std_logic_vector(s_regs.r0);
  o_reg1 <= std_logic_vector(s_regs.r1);
  o_reg2 <= std_logic_vector(s_regs.r2);
  o_reg3 <= std_logic_vector(s_regs.r3);
  
END ARCHITECTURE rtl;
