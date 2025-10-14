module input_buffer (
	input logic 				i_clk, i_rst,
	input logic					i_en,
	input logic		[31:0]	i_io_sw,
	output logic 	[31:0]	o_input_buffer
);

// IO Switch
reg_32bit input_buffer (
	.clk		(		i_clk			),
	.rst_n	(		i_rst			),
	.en		(		i_en			),
	.d			(		i_io_sw		),
	.q			(	o_input_buffer	)
);

endmodule : input_buffer