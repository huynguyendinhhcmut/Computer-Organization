`timescale 1ns / 1ps

module lsu_tb;

    // ==============================================
    // 1. Testbench Signals (Inputs to LSU)
    // ==============================================
    logic i_clk;
    logic i_rst;
    logic [31:0] i_lsu_addr;
    logic [31:0] i_st_data;
    logic i_lsu_wren;
    logic [3:0] i_sl_sel;

    // ==============================================
    // 2. LSU Outputs (Wire/Logic from LSU)
    // ==============================================
    logic [31:0] o_ld_data;
    
    // Memory-Mapped I/O Outputs (just need to monitor them)
    logic [31:0] o_io_ledr;
    logic [31:0] o_io_ledg;
    logic [ 7:0] o_io_hex_0, o_io_hex_1, o_io_hex_2, o_io_hex_3;
    logic [ 7:0] o_io_hex_4, o_io_hex_5, o_io_hex_6, o_io_hex_7;
 //   logic [31:0] o_io_lcd;

    // ==============================================
    // 3. I/O Peripheral Inputs (Inputs to LSU)
    // ==============================================
    // These signals are connected to the LSU's input ports
    logic [31:0] i_io_sw; 
    logic [ 3:0] i_io_btn;

    // ==============================================
    // 4. Parameter Definitions for RISC-V Load/Store Types
    // ==============================================
    // sl_sel = {op5, funct3}
    localparam LB  = 4'b0000; // Load Byte (signed)
    localparam LH  = 4'b0001; // Load Halfword (signed)
    localparam LW  = 4'b0010; // Load Word
    localparam LBU = 4'b0100; // Load Byte Unsigned
    localparam LHU = 4'b0110; // Load Halfword Unsigned
    localparam SB  = 4'b1000; // Store Byte
    localparam SH  = 4'b1001; // Store Halfword
    localparam SW  = 4'b1010; // Store Word

    // ==============================================
    // 5. Instantiate the Unit Under Test (UUT)
    // ==============================================
    lsu uut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_lsu_addr(i_lsu_addr),
        .i_st_data(i_st_data),
        .i_lsu_wren(i_lsu_wren),
        .i_sl_sel(i_sl_sel),
        .o_ld_data(o_ld_data),

        // Mapped I/O Outputs
        .o_io_ledr(o_io_ledr),
        .o_io_ledg(o_io_ledg),
        .o_io_hex_0(o_io_hex_0),
        .o_io_hex_1(o_io_hex_1),
        .o_io_hex_2(o_io_hex_2),
        .o_io_hex_3(o_io_hex_3),
        .o_io_hex_4(o_io_hex_4),
        .o_io_hex_5(o_io_hex_5),
        .o_io_hex_6(o_io_hex_6),
        .o_io_hex_7(o_io_hex_7),
//        .o_io_lcd(o_io_lcd),

        // Mapped I/O Inputs
        .i_io_sw(i_io_sw),
        .i_io_btn(i_io_btn)
    );

    // ==============================================
    // 6. Clock Generation
    // ==============================================
    localparam CLK_PERIOD = 10; // 10ns period (100 MHz)
    always # (CLK_PERIOD / 2) i_clk = ~i_clk;

    // ==============================================
    // 7. Initial Setup and Test Sequence
    // ==============================================
    initial begin
        // Initialize all signals
        i_clk        = 1'b0;
        i_rst        = 1'b1; // Assert reset
        i_lsu_addr   = 32'h0;
        i_st_data    = 32'h0;
        i_lsu_wren   = 1'b0;
        i_sl_sel     = LW; // Default to Load Word
        
        i_io_sw      = 32'hFEEDF00D; // Constant input from switches
        i_io_btn     = 4'b1011;      // Constant input from buttons

        $display("-----------------------------------------");
        $display("Starting LSU Testbench Simulation");
        $display("-----------------------------------------");

        // Release Reset
        # (CLK_PERIOD * 2); 
        i_rst = 1'b0;
        $display("Time %0t: Reset released.", $time);

        // --- Test 1: Data Memory Write (Store Word) ---
        @(posedge i_clk);
        i_lsu_addr = 32'h2000; // DM base address
        i_st_data  = 32'hDEADBEEF;
        i_lsu_wren = 1'b1;
        i_sl_sel   = SW;
        $display("Time %0t: WRITE (SW) to 0x2000 with 0x%h", $time, i_st_data);

        // --- Test 2: Data Memory Read (Load Word) ---
        @(posedge i_clk);
        i_lsu_addr = 32'h2000; 
        i_lsu_wren = 1'b0; // Disable write
        i_sl_sel   = LW;
        @(posedge i_clk); // Wait one cycle for the read data to propagate (combinational)
        $display("Time %0t: READ (LW) from 0x2000. Data: 0x%h. Expected: 0xDEADBEEF", $time, o_ld_data);
        assert (o_ld_data === 32'hDEADBEEF) else $error("LW FAILED: Expected 0xDEADBEEF, Got 0x%h", o_ld_data);


        // --- Test 3: Output I/O Write (Red LEDs) ---
        @(posedge i_clk);
        i_lsu_addr = 32'h7000; // Red LEDs address
        i_st_data  = 32'hF00DF00D;
        i_lsu_wren = 1'b1;
        i_sl_sel   = SW; // Store Word is sufficient for full 32-bit register
        @(posedge i_clk);
        $display("Time %0t: WRITE to Red LEDs (0x7000) with 0x%h. LEDs: 0x%h", $time, i_st_data, o_io_ledr);
        assert (o_io_ledr === 32'hF00DF00D) else $error("LED WRITE FAILED: Expected 0xF00DF00D, Got 0x%h", o_io_ledr);


        // --- Test 4: Output I/O Write (Hex Display 0 - Byte Store) ---
        @(posedge i_clk);
        i_lsu_addr = 32'h7020; // Hex Display 0 address
        i_st_data  = 32'h000000AA; // Data to store
        i_lsu_wren = 1'b1;
        i_sl_sel   = SB; // Store Byte
        @(posedge i_clk);
        $display("Time %0t: WRITE to Hex 0 (0x7020) with 0x%h. Hex 0: 0x%h", $time, i_st_data, o_io_hex_0);
        assert (o_io_hex_0 === 8'hAA) else $error("HEX WRITE FAILED: Expected 0xAA, Got 0x%h", o_io_hex_0);


        // --- Test 5: Input I/O Read (Switches) ---
        @(posedge i_clk);
        i_lsu_addr = 32'h7800; // Switches address
        i_lsu_wren = 1'b0;
        i_sl_sel   = LW;
        @(posedge i_clk);
        $display("Time %0t: READ from Switches (0x7800). Data: 0x%h. Expected: 0xFEEDF00D", $time, o_ld_data);
        assert (o_ld_data === 32'hFEEDF00D) else $error("SWITCH READ FAILED: Expected 0xFEEDF00D, Got 0x%h", o_ld_data);


        // --- Test 6: Input I/O Read (Buttons) ---
        @(posedge i_clk);
        i_lsu_addr = 32'h7810; // Buttons address
        i_lsu_wren = 1'b0;
        i_sl_sel   = LW;
        @(posedge i_clk);
        $display("Time %0t: READ from Buttons (0x7810). Data: 0x%h. Expected: 0x0000000B", $time, o_ld_data);
        assert (o_ld_data === 32'h0000000B) else $error("BUTTON READ FAILED: Expected 0x0000000B, Got 0x%h", o_ld_data);


        // --- Test 7: Data Memory Read (Load Byte Signed) ---
        // Address 0x2001 (contains 0xBE)
        @(posedge i_clk);
        i_lsu_addr = 32'h2001; 
        i_lsu_wren = 1'b0;
        i_sl_sel   = LB;
        @(posedge i_clk);
        // 0xBE is signed (-66). Sign-extended: 0xFFFFFFBE
        $display("Time %0t: READ (LB) from 0x2001. Data: 0x%h. Expected: 0xFFFFFFBE", $time, o_ld_data);
        assert (o_ld_data === 32'hFFFF_FFBE) else $error("LB FAILED: Expected 0xFFFFFFBE, Got 0x%h", o_ld_data);


        // --- End Simulation ---
        # (CLK_PERIOD * 2);
        $display("-----------------------------------------");
        $display("Simulation Finished Successfully.");
        $display("-----------------------------------------");
        $stop;
    end

endmodule