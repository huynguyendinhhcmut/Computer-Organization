module lsu (
	input logic 		i_clk, i_rst,
	input logic 	[31:0] 	i_lsu_addr,
	input logic 	[31:0] 	i_st_data,
	input logic 		i_lsu_wren,
	input logic 	[31:0] 	i_io_sw,
	input logic 	[3:0] 	i_io_btn,
	input logic 	[2:0]		i_funct3,
	output logic 	[31:0] 	o_ld_data,
	output logic 	[31:0] 	o_io_ledr, o_io_ledg,
	output logic 	[6:0] 	o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
	output logic 	[31:0] 	o_io_lcd
);

endmodule
