module lsu (
	input logic 				i_clk, i_rst,
	input logic 	[31:0] 	i_lsu_addr,
	input logic 	[31:0] 	i_st_data,
	input logic 				i_lsu_wren,
	input logic 	[31:0] 	i_io_sw,
	input logic 	[3:0] 	i_io_btn,
	input logic 	[2:0]		i_funct3,
	output logic 	[31:0] 	o_ld_data,
	output logic 	[31:0] 	o_io_ledr, o_io_ledg,
	//Extra signals
/*	output logic 	[3:0] 	wbe,
	output logic	[31:0]	waddr, raddr,
	output logic	[31:0]	wdata,
	output logic	[1:0]		sel_output_lsu,
	output logic	[2:0]		sel_wren,
	output logic	[31:0]	in_buf, out_buf, dmem
*/
	output logic 	[6:0] 	o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
	output logic 	[31:0] 	o_io_lcd
);
logic [31:0] 	waddr, raddr;
logic [31:0]	wdata;
logic [3:0]		wbe;
logic [31:0]	sw_buff, btn_buff;
logic [31:0]	o_input_buffer, o_output_buffer, o_datamem;
logic [1:0]		sel_output_lsu;
logic [2:0]		sel_wren;
logic	[31:0]	in_buf, out_buf, dmem;

// DUT Data Memory
data_mem dut_dmem (
	.i_clk		(	i_clk			),
	.i_wdata		(	wdata			),
	.i_waddr		(	waddr			),
	.i_raddr		(	raddr			),
	.i_wren		(	sel_wren[2]	),
	.i_wbe		(	wbe			),
	.o_rd_data	(	o_datamem	)
);

// DUT Input Bưffer
input_buffer dut_inbuff (
	.i_clk					(			i_clk				),
	.i_rst					(			i_rst				),
	.i_en						(			sel_wren[0]		),
	.i_io_sw					(			i_io_sw			),
	.o_input_buffer		(		o_input_buffer		)
);

// DUT Output Buffer
output_buffer dut_outbuff 	(
	.i_clk						(			i_clk				),
	.i_rst						(			i_rst				),
	.i_en							(			sel_wren[1]		),
	.i_outbuff					(			wdata				),
	.o_output_buffer			(		o_output_buffer	)
);

// Decoder Input
decoder_input_lsu dut_decoder_input (
	.i_lsu_addr								(	i_lsu_addr		),
	.i_st_data								(	i_st_data		),
	.i_lsu_wren								(	i_lsu_wren		),
	.i_funct3								(	i_funct3			),
	.sel_output_lsu						(	sel_output_lsu	),
	.sel_wren								(	sel_wren			),
	.wbe										(	wbe				),
	.waddr									(	waddr				),
	.raddr									(	raddr				),
	.o_wdata									(	wdata				)
);

// Mux Output
mux_output_lsu	dut_mux_output	(
	.input_buffer					(	o_input_buffer		),
	.output_buffer					(	o_output_buffer	),
	.out_datamem					(	o_datamem			),
	.sel_output_lsu				(	sel_output_lsu		),
	.o_mux_output_lsu				(	o_ld_data			)
);

assign o_io_ledr = o_ld_data;
assign o_io_ledg = o_ld_data;

assign in_buf 	= o_input_buffer;
assign out_buf	= o_output_buffer;
assign dmem		= o_datamem;

endmodule : lsu