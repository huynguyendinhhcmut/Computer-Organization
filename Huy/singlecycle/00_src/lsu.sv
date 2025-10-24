module lsu (
	input logic         i_clk, 												 // Global clock, active on the rising edge
	input logic         i_reset, 												 // Global active reset
	input logic  [31:0] i_lsu_addr, 											 // Address for data read/write
	input logic  [31:0] i_st_data, 											 // Data to be stored
	input logic         i_lsu_wren, 											 // Write enable signal (1 if writing)
	input logic  [31:0] i_io_sw, 												 // Input for switches
	input logic  [2:0]  i_st, 											       // check store type
	
	output logic [31:0] o_ld_data, 											 // Data read from memory
	output logic [31:0] o_io_ledr, 											 // Output for red LEDs
	output logic [31:0] o_io_ledg, 											 // Output for green LEDs
	output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, // Output for 7-segment displays
	output logic [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7, // Output for 7-segment displays
	output logic [31:0] o_io_lcd 												 // Output for the LCD register.
);

logic [9:0] addr_even_1, addr_even_2, addr_odd_1, addr_odd_2;
logic [7:0] data_even_1, data_even_2, data_odd_1, data_odd_2;
logic we_even_1, we_even_2, we_odd_1, we_odd_2;

decodelsu decodelsu1 (.i_lsu_addr(i_lsu_addr), .i_st_data(i_st_data), .i_lsu_wren(i_lsu_wren), .i_st(i_st), 
							 .o_addr_even_1(addr_even_1), .o_addr_even_2(addr_even_2), .o_addr_odd_1(addr_odd_1), .o_addr_odd_2(addr_odd_2),
							 .o_data_even_1(data_even_1), .o_data_even_2(data_even_2), .o_data_odd_1(data_odd_1), .o_data_odd_2(data_odd_2),
							 .o_we_even_1(we_even_1),     .o_we_even_2(we_even_2),     .o_we_odd_1(we_odd_1),     .o_we_odd_2(we_odd_2));
							 
memory mem (.i_clk(i_clk), .i_addr_even_1(addr_even_1), .i_addr_even_2(addr_even_2), .i_addr_odd_1(addr_odd_1), .i_addr_odd_2(addr_odd_2),
							      .i_data_even_1(data_even_1), .i_data_even_2(data_even_2), .i_data_odd_1(data_odd_1), .i_data_odd_2(data_odd_2),
							      .i_we_even_1(we_even_1),     .i_we_even_2(we_even_2),     .i_we_odd_1(we_odd_1),     .i_we_odd_2(we_odd_2),
				.o_data(o_ld_data));						  

endmodule
