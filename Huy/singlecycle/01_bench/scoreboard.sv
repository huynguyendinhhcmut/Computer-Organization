module scoreboard(
  input  logic         i_clk     ,
  input  logic         i_reset   ,
  input  logic [31:0]  i_io_sw   ,
  input  logic [31:0]  o_io_ledr ,
  input  logic [31:0]  o_io_ledg ,
  input  logic [ 6:0]  o_io_hex0 ,
  input  logic [ 6:0]  o_io_hex1 ,
  input  logic [ 6:0]  o_io_hex2 ,
  input  logic [ 6:0]  o_io_hex3 ,
  input  logic [ 6:0]  o_io_hex4 ,
  input  logic [ 6:0]  o_io_hex5 ,
  input  logic [ 6:0]  o_io_hex6 ,
  input  logic [ 6:0]  o_io_hex7 ,
  input  logic [31:0]  o_io_lcd  ,
  input  logic [31:0]  o_pc_debug,
  input  logic         o_insn_vld
);

// Display test name
initial begin
  $display("\nSINGLE CYCLE - ISA test\n");
end


always @(negedge i_clk) begin
  if (o_pc_debug == 32'h18) begin
      $write("%s", o_io_ledr[7:0]);
  end

  if (o_pc_debug == 32'h1c) begin
      $display("\nEND of ISA test\n");
      $finish;
  end
end



endmodule : scoreboard
