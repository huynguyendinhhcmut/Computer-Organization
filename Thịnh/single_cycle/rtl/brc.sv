module brc (
	input logic [31:0] i_rs1_data, i_rs2_data,
	input logic i_br_un,
	output logic o_br_less, o_br_equal
);
logic [2:0] ges;
Comparator dut_brc (
	.A(i_rs1_data),
	.B(i_rs2_data),
	.sign(i_br_un),
	.GES(ges)
);
assign o_br_less = ges[0];
assign o_br_equal = ges[1];

endmodule : brc