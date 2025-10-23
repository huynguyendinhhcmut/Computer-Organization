module mux4to1 (
	input logic [31:0] i_data_0, i_data_1, i_data_2, i_data_3,
	input logic [1:0] i_sel,
	output logic [31:0] o_data
);

always_comb begin
	case (i_sel)
		2'b00: o_data = i_data_0;
		2'b01: o_data = i_data_1;
		2'b10: o_data = i_data_2;
		2'b11: o_data = i_data_3;
	endcase
end

endmodule
