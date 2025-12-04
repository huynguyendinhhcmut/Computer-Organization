module decode_hex (
	input logic [3:0] in,
	output logic [6:0] out
);

always @(*) begin
	case (in)
		4'h0:	out = 7'b100_0000;
		4'h1:	out = 7'b111_1001;
		4'h2:	out = 7'b010_0100;
		4'h3:	out = 7'b011_0000;
		4'h4:	out = 7'b001_1001;
		4'h5:	out = 7'b001_0010;
		4'h6:	out = 7'b000_0010;
		4'h7:	out = 7'b111_1000;
		4'h8:	out = 7'b000_0000;
		4'h9:	out = 7'b001_0000;
		4'hA:	out = 7'b000_1000;
		4'hB:	out = 7'b000_0011;
		4'hC:	out = 7'b100_0110;
		4'hD:	out = 7'b010_0001;
		4'hE:	out = 7'b000_0110;
		4'hF:	out = 7'b000_1110;
	endcase
end

endmodule