// ----- Black cell -----
module black_cell (
	input logic Gik,
	input logic Gkj,
	input logic Pik,
	input logic Pkj,
	output logic G,
	output logic P
);

assign G = Gik | (Pik & Gkj);
assign P = Pik & Pkj;

endmodule : black_cell