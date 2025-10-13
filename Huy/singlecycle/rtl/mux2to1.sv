module mux2to1 (
	input logic [31:0] i_data_0, i_data_1,
	input logic i_sel,
	output logic [31:0] o_data
);

always @(*) begin
	case (i_sel)
		1'b0: o_data = i_data_0;
		1'b1: o_data = i_data_1;
	endcase
end

endmodule
