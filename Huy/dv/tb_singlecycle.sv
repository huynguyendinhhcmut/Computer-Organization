//=============================================================
// Testbench for Single-Cycle CPU (GTKWave version)
//=============================================================
`timescale 1ns/1ps

module tb_singlecycle;

  //==== DUT I/O ====
  logic clk, rst_n;
  logic [31:0] io_sw;
  logic [3:0] io_btn;
  logic [31:0] pc_debug;
  logic insn_vld;
  logic [31:0] io_ledr, io_ledg;
  logic [6:0] io_hex0, io_hex1, io_hex2, io_hex3;
  logic [6:0] io_hex4, io_hex5, io_hex6, io_hex7;
  logic [31:0] io_lcd;

  //==== Instantiate DUT ====
  singlecycle uut (
    .i_clk(clk),
    .i_rst_n(rst_n),
    .i_io_sw(io_sw),
    .i_io_btn(io_btn),
    .o_pc_debug(pc_debug),
    .o_insn_vld(insn_vld),
    .o_io_ledr(io_ledr),
    .o_io_ledg(io_ledg),
    .o_io_hex0(io_hex0),
    .o_io_hex1(io_hex1),
    .o_io_hex2(io_hex2),
    .o_io_hex3(io_hex3),
    .o_io_hex4(io_hex4),
    .o_io_hex5(io_hex5),
    .o_io_hex6(io_hex6),
    .o_io_hex7(io_hex7),
    .o_io_lcd(io_lcd)
  );

  //==== Clock generation: 2ns period (1ns high, 1ns low) ====
  initial begin
    clk = 0;
    forever #1 clk = ~clk;  // Toggle every 1ns → 2ns full period
  end

  //==== Test sequence ====
  initial begin
    // Dump waveform for GTKWave
    $dumpfile("singlecycle_wave.vcd");
    $dumpvars(0, tb_singlecycle);

    // Initialize inputs
    rst_n  = 0;
    io_sw  = 32'h0;
    io_btn = 4'h0;

    // Hold reset low for a few ns
    #2;
    rst_n = 1;

    // Run simulation for a while to observe behavior
    #1000;

    $finish;
  end

endmodule
