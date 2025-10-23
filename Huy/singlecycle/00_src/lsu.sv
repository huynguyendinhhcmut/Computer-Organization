module lsu (
	input logic         i_clk, 												 // Global clock, active on the rising edge
	input logic         i_rst, 												 // Global active reset
	input logic  [31:0] i_lsu_addr, 											 // Address for data read/write
	input logic  [31:0] i_st_data, 											 // Data to be stored
	input logic         i_lsu_wren, 											 // Write enable signal (1 if writing)
	input logic  [31:0] i_io_sw, 												 // Input for switches
	input logic  [3:0]  i_io_btn, 											 // Input for buttons
	input logic  [2:0]  i_funct3, 											 // Input function3 to select between sh, sw, sb
	
	output logic [31:0] o_ld_data, 											 // Data read from memory
	output logic [31:0] o_io_ledr, 											 // Output for red LEDs
	output logic [31:0] o_io_ledg, 											 // Output for green LEDs
	output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, // Output for 7-segment displays
	output logic [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7, // Output for 7-segment displays
	output logic [31:0] o_io_lcd 												 // Output for the LCD register.
);

endmodule
