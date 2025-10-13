module output_buffer (
	input logic 				i_clk, i_rst,
	input logic 				i_en,
	input logic		[31:0]	i_outbuff,
	output logic 	[31:0]	o_output_buffer
);

// Output Buffer
reg_32bit output_buffer (
	.clk		(		i_clk				),
	.rst_n	(		i_rst				),
	.en		(		i_en				),
	.d			(		i_outbuff		),
	.q			(	o_output_buffer	)
);

endmodule : output_buffer