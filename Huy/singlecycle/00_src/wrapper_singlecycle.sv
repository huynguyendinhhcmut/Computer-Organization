module wrapper_singlecycle (
	input logic CLOCK_50,
	input logic [3:0] KEY,
	input logic [9:0] SW,
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output logic [9:0] LEDR,
	
	output logic [31:0] o_pc_debug,	// Debug program counter.
	output logic        o_insn_vld,	// Instruction valid.
	output logic [31:0] o_io_ledg, 	// Output for driving green LEDs.
	output logic [6:0]  o_io_hex6, 	// Output for driving 7-segment LED6 displays.
	output logic [6:0]  o_io_hex7, 	// Output for driving 7-segment LED7 displays.
	output logic [31:0] o_io_lcd	   // Output for driving the LCD register. 
);

logic clk;

clock_25M clk25M (.clk50(CLOCK_50), .i_reset(KEY[3]), .o_clk(clk));  

single_cycle singlecycle1 (.i_clk(clk), .i_reset(KEY[3]), .i_io_sw({22'b0, SW[9:0]}), .i_io_key({29'b0, KEY[2:0]}),
								 .o_pc_debug(o_pc_debug), .o_insn_vld(o_insn_vld), .o_io_ledr(LEDR), .o_io_ledg(o_io_ledg),
								 .o_io_hex0(HEX0), .o_io_hex1(HEX1), .o_io_hex2(HEX2), .o_io_hex3(HEX3),
								 .o_io_hex4(HEX4), .o_io_hex5(HEX5), .o_io_hex6(o_io_hex6), .o_io_hex7(o_io_hex7), 
								 .o_io_lcd(o_io_lcd));

endmodule