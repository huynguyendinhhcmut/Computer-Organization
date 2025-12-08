`define RESET_PERIOD 51
`define CLOCK_PERIOD 2
`define TIMEOUT      50_000

module tbench;

  // Clock and reset generator
  logic clk;
  logic rstn;

  initial tsk_clock_gen(clk , `CLOCK_PERIOD);
  initial tsk_reset    (rstn, `RESET_PERIOD);
  initial tsk_timeout  (`TIMEOUT);

  // Wave dumping
  initial begin: proc_dump_shm
      $shm_open("wave.shm");
      $shm_probe(dut, "AS");
  end

  logic [31:0]  pc_debug;
  logic [31:0]  io_sw  ;
  logic [31:0]  io_lcd ;
  logic [31:0]  io_ledr;
  logic [31:0]  io_ledg;
  logic [ 6:0]  io_hex0;
  logic [ 6:0]  io_hex1;
  logic [ 6:0]  io_hex2;
  logic [ 6:0]  io_hex3;
  logic [ 6:0]  io_hex4;
  logic [ 6:0]  io_hex5;
  logic [ 6:0]  io_hex6;
  logic [ 6:0]  io_hex7;
  logic         ctrl    ;
  logic         mispred ;
  logic         insn_vld;

  pipelined dut (
    .i_clk     (clk      ),
    .i_reset   (rstn     ),
    // Input peripherals
    .i_io_sw   (io_sw    ),
    // Output peripherals
    .o_io_lcd  (io_lcd   ),
    .o_io_ledr (io_ledr  ),
    .o_io_ledg (io_ledg  ),
    .o_io_hex0 (io_hex0  ),
    .o_io_hex1 (io_hex1  ),
    .o_io_hex2 (io_hex2  ),
    .o_io_hex3 (io_hex3  ),
    .o_io_hex4 (io_hex4  ),
    .o_io_hex5 (io_hex5  ),
    .o_io_hex6 (io_hex6  ),
    .o_io_hex7 (io_hex7  ),
    // Debug
    .o_ctrl    (ctrl     ),
    .o_mispred (mispred  ),
    .o_pc_debug(pc_debug ),
    .o_insn_vld(insn_vld )
  );

  driver driver (
    .i_clk  (clk   ),
    .i_reset(rstn  ),
    .i_io_sw(io_sw )
  );

  scoreboard  scoreboard(
    .i_clk     (clk      ),
    .i_reset   (rstn     ),
    // Input peripherals
    .i_io_sw   (io_sw    ),
    // Output peripherals
    .o_io_lcd  (io_lcd   ),
    .o_io_ledr (io_ledr  ),
    .o_io_ledg (io_ledg  ),
    .o_io_hex0 (io_hex0  ),
    .o_io_hex1 (io_hex1  ),
    .o_io_hex2 (io_hex2  ),
    .o_io_hex3 (io_hex3  ),
    .o_io_hex4 (io_hex4  ),
    .o_io_hex5 (io_hex5  ),
    .o_io_hex6 (io_hex6  ),
    .o_io_hex7 (io_hex7  ),
    // Debug
    .o_ctrl    (ctrl     ),
    .o_mispred (mispred  ),
    .o_pc_debug(pc_debug ),
    .o_insn_vld(insn_vld )
  );


endmodule
