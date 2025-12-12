// ----- Grey cell -----
module grey_cell (
	input logic Gik,
	input logic Gkj,
	input logic Pik,
	output logic G
);

assign G = Gik | (Pik & Gkj);

endmodule : grey_cell