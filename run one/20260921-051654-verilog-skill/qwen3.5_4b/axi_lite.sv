module axil_regs (
    input logic clk,
    input logic rst_n,
    
    // AXI4-Lite Slave Ports
    input logic [31:0] awaddr,
    input logic awvalid,
    output logic awready,
    input logic [31:0] wdata,
    input logic [2:0] wstrb,
    input logic wvalid,
    output logic wready,
    input logic [1:0] bresp,
    output logic bvalid,
    output logic bready,
    
    input logic [31:0] araddr,
    input logic arvalid,
    output logic arready,
    input logic rdata,
    input logic rvalid,
    output logic rready,
    output logic rresp
);

    localparam ADDR_WIDTH = 5; 
    localparam REG_COUNT = 4;
    
    typedef enum logic [1:0] {
        IDLE,
        AW_PENDING,
        W_PENDING,
        AR_PENDING,
        R_PENDING
    } state_t;

    // Register storage (4 x 32-bit)
    logic [31:0] reg0, reg1, reg2, reg3;

    // State machine for handshake processing
    state_t current_state = IDLE;
    state_t next_state;

    // Channel flags to track pending transactions
    logic aw_pending = 1'b0;
    logic w_pending = 1'b0;
    logic ar_pending = 1'b0;
    logic r_pending = 1'b0;

    // Output registers for AXI4-Lite slave (must be registered)
    logic [31:0] reg_out_0, reg_out_1, reg_out_2, reg_out_3;

    // ============================================================================
    // Sequential Logic (Always FF)
    // ============================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg0 <= 32'd0;
            reg1 <= 32'd0;
            reg2 <= 32'd0;
            reg3 <= 32'd0;
            
            current_state <= IDLE;
            aw_pending <= 1'b0;
            w_pending <= 1'b0;
            ar_pending <= 1'b0;
            r_pending <= 1'b0;
            
            reg_out_0 <= 32'd0;
            reg_out_1 <= 32'd0;
            reg_out_2 <= 32'd0;
            reg_out_3 <= 32'd0;
        end else begin
            // Update registers based on R channel data
            if (r_pending) begin
                case (araddr [ADDR_WIDTH-1:2])
                    4'd0: reg0 <= rdata;
                    4'd1: reg1 <= rdata;
                    4'd2: reg2 <= rdata;
                    4'd3: reg3 <= rdata;
                    default: reg_out_0 <= 32'd0; // Unmapped address behavior
                endcase
            end

            // Update output registers for read channel
            if (r_pending) begin
                case (araddr [ADDR_WIDTH-1:2])
                    4'd0: reg_out_0 <= rdata;
                    4'd1: reg_out_1 <= rdata;
                    4'd2: reg_out_2 <= rdata;
                    4'd3: reg_out_3 <= rdata;
                    default: reg_out_0 <= 32'd0;
                endcase
            end

            // Update state and pending flags based on handshake completion
            case (current_state)
                IDLE: begin
                    if (awvalid && awready) begin
                        current_state <= AW_PENDING;
                        aw_pending <= 1'b1;
                    end else if (wvalid && wready) begin
                        current_state <= W_PENDING;
                        w_pending <= 1'b1;
                    end else if (arvalid && arready) begin
                        current_state <= AR_PENDING;
                        ar_pending <= 1'b1;
                    end else if (rvalid && rready) begin
                        current_state <= R_PENDING;
                        r_pending <= 1'b1;
                    end
                end

                AW_PENDING: begin
                    if (awready && awvalid) begin // Handshake complete for AW
                        current_state <= IDLE;
                        aw_pending <= 1'b0;
                    end else if (wvalid && wready) begin
                        current_state <= W_PENDING;
                        w_pending <= 1'b1;
                    end
                end

                W_PENDING: begin
                    // Apply write data to registers based on address and strobe
                    logic [31:0] temp_reg;
                    if (awaddr [ADDR_WIDTH-1:2] == 4'd0) temp_reg = reg0;
                    else if (awaddr [ADDR_WIDTH-1:2] == 4'd1) temp_reg = reg1;
                    else if (awaddr [ADDR_WIDTH-1:2] == 4'd2) temp_reg = reg2;
                    else if (awaddr [ADDR_WIDTH-1:2] == 4'd3) temp_reg = reg3;
                    else temp_reg = 32'd0;

                    // Apply wstrb byte enable logic
                    for (integer i = 0; i < 4; i++) begin
                        if (wstrb[i]) begin
                            temp_reg [8*i +: 8] <= wdata [8*i +: 8];
                        end
                    end

                    // Update register and complete handshake
                    case (awaddr [ADDR_WIDTH-1:2])
                        4'd0: reg0 <= temp_reg;
                        4'd1: reg1 <= temp_reg;
                        4'd2: reg2 <= temp_reg;
                        4'd3: reg3 <= temp_reg;
                        default: begin // Unimplemented address
                            // Still complete handshake as per prompt requirement
                            current_state <= IDLE;
                            w_pending <= 1'b0;
                        end
                    endcase

                    // Assert bvalid with OKAY response (2'b00) until bready
                    if (!bready) begin
                        bvalid <= 1'b1;
                        bresp <= 2'b00;
                    end else begin
                        bvalid <= 1'b0;
                    end

                end

                AR_PENDING: begin
                    if (arready && arvalid) begin
                        current_state <= IDLE;
                        ar_pending <= 1'b0;
                    end else if (rvalid && rready) begin
                        current_state <= R_PENDING;
                        r_pending <= 1'b1;
                    end
                end

                R_PENDING: begin
                    // Update register with read data
                    logic [31:0] temp_reg;
                    if (araddr [ADDR_WIDTH-1:2] == 4'd0) temp_reg = reg0;
                    else if (araddr [ADDR_WIDTH-1:2] == 4'd1) temp_reg = reg1;
                    else if (araddr [ADDR_WIDTH-1:2] == 4'd2) temp_reg = reg2;
                    else if (araddr [ADDR_WIDTH-1:2] == 4'd3) temp_reg = reg3;
                    else temp_reg = 32'd0;

                    // Update register value
                    case (araddr [ADDR_WIDTH-1:2])
                        4'd0: reg0 <= temp_reg;
                        4'd1: reg1 <= temp_reg;
                        4'd2: reg2 <= temp_reg;
                        4'd3: reg3 <= temp_reg;
                        default: begin // Unimplemented address
                            current_state <= IDLE;
                            r_pending <= 1'b0;
                        end
                    endcase

                    // Assert bvalid with OKAY response (2'b00) until bready
                    if (!bready) begin
                        bvalid <= 1'b1;
                        bresp <= 2'b00;
                    end else begin
                        bvalid <= 1'b0;
                    end

                end

                default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end

    // ============================================================================
    // Combinational Logic (Always Comb)
    // ============================================================================
    always_comb begin
        // Reset outputs to 0 if no pending transaction or invalid handshake
        reg_out_0 = 32'd0;
        reg_out_1 = 32'd0;
        reg_out_2 = 32'd0;
        reg_out_3 = 32'd0;

        // Handle AW channel ready logic
        if (aw_pending) begin
            if (awvalid && awready) begin
                current_state <= IDLE;
                aw_pending <= 1'b0;
            end else if (wvalid && wready) begin
                current_state <= W_PENDING;
                w_pending <= 1'b1;
            end
        end

        // Handle W channel ready logic
        if (w_pending) begin
            // Apply write data to registers based on address and strobe
            logic [31:0] temp_reg;
            if (awaddr [ADDR_WIDTH-1:2] == 4'd0) temp_reg = reg0;
            else if (awaddr [ADDR_WIDTH-1:2] == 4'd1) temp_reg = reg1;
            else if (awaddr [ADDR_WIDTH-1:2] == 4'd2) temp_reg = reg2;
            else if (awaddr [ADDR_WIDTH-1:2] == 4'd3) temp_reg = reg3;
            else temp_reg = 32'd0;

            // Apply wstrb byte enable logic
            for (integer i = 0; i < 4; i++) begin
                if (wstrb[i]) begin
                    temp_reg [8*i +: 8] <= wdata [8*i +: 8];
                end
            end

            // Update register and complete handshake
            case (awaddr [ADDR_WIDTH-1:2])
                4'd0: reg0 <= temp_reg;
                4'd1: reg1 <= temp_reg;
                4'd2: reg2 <= temp_reg;
                4'd3: reg3 <= temp_reg;
                default: begin // Unimplemented address
                    current_state <= IDLE;
                    w_pending <= 1'b0;
                end
            endcase

            // Assert bvalid with OKAY response (2'b00) until bready
            if (!bready) begin
                bvalid <= 1'b1;
                bresp <= 2'b00;
            end else begin
                bvalid <= 1'b0;
            end

        end

        // Handle AR channel ready logic
        if (ar_pending) begin
            if (arready && arvalid) begin
                current_state <= IDLE;
                ar_pending <= 1'b0;
            end else if (rvalid && rready) begin
                current_state <= R_PENDING;
                r_pending <= 1'b1;
            end
        end

        // Handle R channel ready logic
        if (r_pending) begin
            // Update register with read data
            logic [31:0] temp_reg;
            if (araddr [ADDR_WIDTH-1:2] == 4'd0) temp_reg = reg0;
            else if (araddr [ADDR_WIDTH-1:2] == 4'd1) temp_reg = reg1;
            else if (araddr [ADDR_WIDTH-1:2] == 4'd2) temp_reg = reg2;
            else if (araddr [ADDR_WIDTH-1:2] == 4'd3) temp_reg = reg3;
            else temp_reg = 32'd0;

            // Update register value
            case (araddr [ADDR_WIDTH-1:2])
                4'd0: reg0 <= temp_reg;
                4'd1: reg1 <= temp_reg;
                4'd2: reg2 <= temp_reg;
                4'd3: reg3 <= temp_reg;
                default: begin // Unimplemented address
                    current_state <= IDLE;
                    r_pending <= 1'b0;
                end
            endcase

            // Assert bvalid with OKAY response (2'b00) until bready
            if (!bready) begin
                bvalid <= 1'b1;
                bresp <= 2'b00;
            end else begin
                bvalid <= 1'b0;
            end

        end
    end

endmodule
