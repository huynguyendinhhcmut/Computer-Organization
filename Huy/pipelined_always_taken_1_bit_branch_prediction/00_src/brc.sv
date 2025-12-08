module brc (
	input logic [31:0] i_rs1_data,	// Data from the first register.
	input logic [31:0] i_rs2_data,	// Data from the second register.
	input logic i_br_un,					// Comparison mode (1 if signed, 0 if unsigned).
	input logic [2:0] i_br_sel,

	output logic o_pc_sel
);

logic br_equal, br_less;

comparator32b_signed cmp_signed (.a(i_rs1_data), .b(i_rs2_data), .signed_mode(i_br_un), .Eq(br_equal), .Lt(br_less));

assign o_pc_sel = (~i_br_sel[2] & ~i_br_sel[1] &  i_br_sel[0] &  br_equal) |
		  (~i_br_sel[2] &  i_br_sel[1] & ~i_br_sel[0] & ~br_equal) |
		  (~i_br_sel[2] &  i_br_sel[1] &  i_br_sel[0] &  br_less)  |
		  ( i_br_sel[2] & ~i_br_sel[1] & ~i_br_sel[0] & ~br_less)  |
		  ( i_br_sel[2] & ~i_br_sel[1] &  i_br_sel[0] &  br_less)  |
		  ( i_br_sel[2] &  i_br_sel[1] & ~i_br_sel[0] & ~br_less);

endmodule
