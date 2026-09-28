module axil_regs (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [31:0] s_axi_awaddr,
  input  logic        s_axi_awvalid,
  output logic        s_axi_awready,
  input  logic [31:0] s_axi_wdata,
  input  logic [3:0]  s_axi_wstrb,
  input  logic        s_axi_wvalid,
  output logic        s_axi_wready,
  output logic [1:0]  s_axi_bresp,
  output logic        s_axi_bvalid,
  input  logic        s_axi_bready,
  input  logic [31:0] s_axi_araddr,
  input  logic        s_axi_arvalid,
  output logic        s_axi_arready,
  output logic [31:0] s_axi_rdata,
  output logic [1:0]  s_axi_rresp,
  output logic        s_axi_rvalid,
  input  logic        s_axi_rready
);

  // Register definitions
  logic [31:0] reg0;
  logic [31:0] reg1;
  logic [31:0] reg2;
  logic [31:0] reg3;
  
  // AW channel registers
  logic [31:0] aw_addr_reg;
  logic        aw_valid_reg;
  
  // W channel registers
  logic [31:0] w_data_reg;
  logic [3:0]  w_strb_reg;
  logic        w_valid_reg;
  
  // B channel registers
  logic        b_valid_reg;
  logic [1:0]  b_resp_reg;
  
  // AR channel registers
  logic [31:0] ar_addr_reg;
  logic        ar_valid_reg;
  
  // R channel registers
  logic        r_valid_reg;
  logic [31:0] r_data_reg;
  logic [1:0]  r_resp_reg;
  
  // State machine for write and read operations
  typedef enum logic [2:0] { IDLE, WRITE_ADDR, WRITE_DATA, READ_ADDR, READ_DATA } state_t;
  state_t current_state, next_state;
  
  // Write address channel
  always_comb begin
    s_axi_awready = 1'b0;
    aw_valid_reg  = aw_valid_reg;
    
    case (current_state)
      IDLE: begin
        if (s_axi_awvalid) begin
          s_axi_awready = 1'b1;
          aw_valid_reg  = 1'b1;
        end
      end
      WRITE_ADDR: begin
        if (s_axi_awvalid && s_axi_awready) begin
          aw_valid_reg = 1'b0;
        end
      end
    endcase
  end
  
  // Write data channel
  always_comb begin
    s_axi_wready = 1'b0;
    w_valid_reg  = w_valid_reg;
    
    case (current_state)
      IDLE: begin
        if (s_axi_wvalid) begin
          s_axi_wready = 1'b1;
          w_valid_reg  = 1'b1;
        end
      end
      WRITE_DATA: begin
        if (s_axi_wvalid && s_axi_wready) begin
          w_valid_reg = 1'b0;
        end
      end
    endcase
  end
  
  // B channel
  always_comb begin
    s_axi_bvalid = 1'b0;
    b_valid_reg  = b_valid_reg;
    
    case (current_state)
      IDLE: begin
        if (w_valid_reg && s_axi_wready) begin
          s_axi_bvalid = 1'b1;
          b_valid_reg  = 1'b1;
        end
      end
      WRITE_DATA: begin
        if (s_axi_bready && s_axi_bvalid) begin
          b_valid_reg = 1'b0;
        end
      end
    endcase
  end
  
  // Read address channel
  always_comb begin
    s_axi_arready = 1'b0;
    ar_valid_reg  = ar_valid_reg;
    
    case (current_state)
      IDLE: begin
        if (s_axi_arvalid) begin
          s_axi_arready = 1'b1;
          ar_valid_reg  = 1'b1;
        end
      end
      READ_ADDR: begin
        if (s_axi_arvalid && s_axi_arready) begin
          ar_valid_reg = 1'b0;
        end
      end
    endcase
  end
  
  // R channel
  always_comb begin
    s_axi_rvalid = 1'b0;
    r_valid_reg  = r_valid_reg;
    
    case (current_state)
      IDLE: begin
        if (ar_valid_reg && s_axi_arready) begin
          s_axi_rvalid = 1'b1;
          r_valid_reg  = 1'b1;
        end
      end
      READ_DATA: begin
        if (s_axi_rready && s_axi_rvalid) begin
          r_valid_reg = 1'b0;
        end
      end
    endcase
  end
  
  // State machine logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end
  
  always_comb begin
    next_state = current_state;
    
    case (current_state)
      IDLE: begin
        if (s_axi_awvalid && s_axi_awready) begin
          next_state = WRITE_ADDR;
        end else if (s_axi_arvalid && s_axi_arready) begin
          next_state = READ_ADDR;
        end
      end
      
      WRITE_ADDR: begin
        if (s_axi_wvalid && s_axi_wready) begin
          next_state = WRITE_DATA;
        end
      end
      
      WRITE_DATA: begin
        if (s_axi_bready && s_axi_bvalid) begin
          next_state = IDLE;
        end
      end
      
      READ_ADDR: begin
        if (s_axi_rready && s_axi_rvalid) begin
          next_state = READ_DATA;
        end
      end
      
      READ_DATA: begin
        if (s_axi_rready && s_axi_rvalid) begin
          next_state = IDLE;
        end
      end
    endcase
  end
  
  // Register write logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      aw_addr_reg <= '0;
      w_data_reg  <= '0;
      w_strb_reg  <= '0;
      reg0        <= '0;
      reg1        <= '0;
      reg2        <= '0;
      reg3        <= '0;
    end else begin
      if (s_axi_awvalid && s_axi_awready) begin
        aw_addr_reg <= s_axi_awaddr;
      end
      
      if (s_axi_wvalid && s_axi_wready) begin
        w_data_reg <= s_axi_wdata;
        w_strb_reg <= s_axi_wstrb;
      end
      
      // Write to registers based on address and strobe
      if (w_valid_reg && s_axi_wready) begin
        case (aw_addr_reg[3:2])
          2'b00: begin
            if (w_strb_reg[0]) reg0[7:0]   <= w_data_reg[7:0];
            if (w_strb_reg[1]) reg0[15:8]  <= w_data_reg[15:8];
            if (w_strb_reg[2]) reg0[23:16] <= w_data_reg[23:16];
            if (w_strb_reg[3]) reg0[31:24] <= w_data_reg[31:24];
          end
          
          2'b01: begin
            if (w_strb_reg[0]) reg1[7:0]   <= w_data_reg[7:0];
            if (w_strb_reg[1]) reg1[15:8]  <= w_data_reg[15:8];
            if (w_strb_reg[2]) reg1[23:16] <= w_data_reg[23:16];
            if (w_strb_reg[3]) reg1[31:24] <= w_data_reg[31:24];
          end
          
          2'b10: begin
            if (w_strb_reg[0]) reg2[7:0]   <= w_data_reg[7:0];
            if (w_strb_reg[1]) reg2[15:8]  <= w_data_reg[15:8];
            if (w_strb_reg[2]) reg2[23:16] <= w_data_reg[23:16];
            if (w_strb_reg[3]) reg2[31:24] <= w_data_reg[31:24];
          end
          
          2'b11: begin
            if (w_strb_reg[0]) reg3[7:0]   <= w_data_reg[7:0];
            if (w_strb_reg[1]) reg3[15:8]  <= w_data_reg[15:8];
            if (w_strb_reg[2]) reg3[23:16] <= w_data_reg[23:16];
            if (w_strb_reg[3]) reg3[31:24] <= w_data_reg[31:24];
          end
        endcase
      end
    end
  end
  
  // Register read logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ar_addr_reg <= '0;
      r_data_reg  <= '0;
      r_resp_reg  <= '0;
    end else begin
      if (s_axi_arvalid && s_axi_arready) begin
        ar_addr_reg <= s_axi_araddr;
      end
      
      if (ar_valid_reg && s_axi_arready) begin
        case (ar_addr_reg[3:2])
          2'b00: r_data_reg <= reg0;
          2'b01: r_data_reg <= reg1;
          2'b10: r_data_reg <= reg2;
          2'b11: r_data_reg <= reg3;
        endcase
        r_resp_reg <= 2'b00; // OKAY response
      end
    end
  end
  
  // Output assignments
  assign s_axi_bresp = b_resp_reg;
  assign s_axi_rdata = r_data_reg;
  assign s_axi_rresp = r_resp_reg;

endmodule
