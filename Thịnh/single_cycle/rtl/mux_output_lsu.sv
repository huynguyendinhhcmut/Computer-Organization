module mux_output_lsu (
	input logic 	[31:0]	input_buffer, output_buffer, out_datamem,
	input logic		[1:0]		sel_output_lsu,
	output logic 	[31:0]	o_mux_output_lsu
);	

// Output Mux
always @(*) begin
	case (sel_output_lsu)
		2'b00:	o_mux_output_lsu = input_buffer	;
		2'b01:	o_mux_output_lsu = output_buffer	;
		2'b10:	o_mux_output_lsu = out_datamem	;
		default:	o_mux_output_lsu = 32'h0000_0000	;
	endcase
end



endmodule : mux_output_lsu