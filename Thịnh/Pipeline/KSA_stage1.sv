// Computing Generate and Propagate signals
module KSA_stage1 (
	input logic [31:0] a,
	input logic [31:0] b,
	output logic [31:0] g,
	output logic [31:0] p
);

assign g[31:0] = a[31:0] & b[31:0];
assign p[31:0] = a[31:0] ^ b[31:0];

endmodule : KSA_stage1