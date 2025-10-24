module wrapper_singlecycle (
	input logic CLOCK_50,
	input logic [0:0] KEY,
	input logic [9:0] SW,
	
	output logic [31:0] o_pc_debug,	// Debug program counter.
	output logic        o_insn_vld,	// Instruction valid.
	output logic [31:0] o_io_ledr,	// Output for driving red LEDs.
	output logic [31:0] o_io_ledg, 	// Output for driving green LEDs.
	output logic [6:0]  o_io_hex0, 	// Output for driving 7-segment LED0 displays.
	output logic [6:0]  o_io_hex1, 	// Output for driving 7-segment LED1 displays.
	output logic [6:0]  o_io_hex2, 	// Output for driving 7-segment LED2 displays.
	output logic [6:0]  o_io_hex3, 	// Output for driving 7-segment LED3 displays.
	output logic [6:0]  o_io_hex4, 	// Output for driving 7-segment LED4 displays.
	output logic [6:0]  o_io_hex5, 	// Output for driving 7-segment LED5 displays.
	output logic [6:0]  o_io_hex6, 	// Output for driving 7-segment LED6 displays.
	output logic [6:0]  o_io_hex7, 	// Output for driving 7-segment LED7 displays.
	output logic [31:0] o_io_lcd	   // Output for driving the LCD register. 
);

logic clk;

clock_25M clk25M (.clk50(CLOCK_50), .i_rst_n(KEY[0]), .i_clk(clk));  

singlecycle singlecycle1(.i_clk(clk), .i_rst_n(KEY[0]), .i_io_sw(SW[9:0]),
								 .o_pc_debug(o_pc_debug), .o_insn_vld(o_insn_vld), .o_io_ledr(o_io_ledr), .o_io_ledg(o_io_ledg),
								 .o_io_hex0(o_io_hex0), .o_io_hex1(o_io_hex1), .o_io_hex2(o_io_hex2), .o_io_hex3(o_io_hex3),
								 .o_io_hex4(o_io_hex4), .o_io_hex5(o_io_hex5), .o_io_hex6(o_io_hex6), .o_io_hex7(o_io_hex7), 
								 .o_io_lcd(o_io_lcd));

endmodule