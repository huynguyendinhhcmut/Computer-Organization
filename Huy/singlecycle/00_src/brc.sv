module brc (
	input logic [31:0] i_rs1_data,	// Data from the first register.
	input logic [31:0] i_rs2_data,	// Data from the second register.
	input logic i_br_un,					// Comparison mode (1 if signed, 0 if unsigned).
	
	output logic o_br_less, 			// Output is 1 if rs1 < rs2
	output logic o_br_equal				// Output is 1 if rs1 = rs2
);

comparator32b_signed cmp_signed (.a(i_rs1_data), .b(i_rs2_data), .signed_mode(i_br_un), .Eq(o_br_equal), .Lt(o_br_less));

endmodule
