module FA1 (
	input logic a, b, cin,
	output logic s, cout
);

assign s = a ^ b ^ cin;
assign cout = ((a ^ b) & cin) | (a & b);

endmodule : FA1