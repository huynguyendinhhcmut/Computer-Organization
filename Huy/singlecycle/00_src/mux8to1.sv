module mux8to1 (
	input logic [31:0] i_data_0, i_data_1, i_data_2, i_data_3, i_data_4, i_data_5, i_data_6, i_data_7,
	input logic [2:0] i_sel,
	output logic [31:0] o_data
);

always_comb begin
	case (i_sel)
		3'b000: o_data = i_data_0;
		3'b001: o_data = i_data_1;
		3'b010: o_data = i_data_2;
		3'b011: o_data = i_data_3;
		3'b100: o_data = i_data_4;
		3'b101: o_data = i_data_5;
		3'b110: o_data = i_data_6;
		3'b111: o_data = i_data_7;
	endcase
end

endmodule
