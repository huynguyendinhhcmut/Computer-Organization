module Comparator (
	input logic [31:0] A, B,
	input logic sign,				// sign = 1:compare signed, sign = 0: compare unsigned
//	output logic equal,			// equal flag
//	output logic greater,		// greater flag
//	output logic less,			// less flag
//	output logic le,				// less or equal flag
//	output logic ge,				// greater or equal flag
//	output logic [31:0] a, b,
//	output logic G, S,
	output logic [2:0] GES
//	output logic GE, SE
);
// Convert Negative number to Magnitude
logic [31:0] a, b; 				// a, b is magnitude of A, B
logic [1:0] co;
logic [31:0] A_comp2, B_comp2;

FA32 duta (.a(~A), .b(32'b1), .cin(1'b0), .s(A_comp2), .cout(co[0]));
FA32 dutb (.a(~B), .b(32'b1), .cin(1'b0), .s(B_comp2), .cout(co[1]));

assign a = ((sign & A[31]) == 1) ? (A_comp2) : A;
assign b = ((sign & B[31]) == 1) ? (B_comp2) : B;

// Output signals in the First stage
logic [7:0] g1, s1;
cmp4_bit cmp0_3 	(.a(a[3:0]), .b(b[3:0]), .G(g1[0]), .S(s1[0]));
cmp4_bit cmp4_7 	(.a(a[7:4]), .b(b[7:4]), .G(g1[1]), .S(s1[1]));
cmp4_bit cmp8_11 	(.a(a[11:8]), .b(b[11:8]), .G(g1[2]), .S(s1[2]));
cmp4_bit cmp12_15 (.a(a[15:12]), .b(b[15:12]), .G(g1[3]), .S(s1[3]));
cmp4_bit cmp16_19 (.a(a[19:16]), .b(b[19:16]), .G(g1[4]), .S(s1[4]));
cmp4_bit cmp20_23 (.a(a[23:20]), .b(b[23:20]), .G(g1[5]), .S(s1[5]));
cmp4_bit cmp24_27 (.a(a[27:24]), .b(b[27:24]), .G(g1[6]), .S(s1[6]));
cmp4_bit cmp28_31 (.a(a[31:28]), .b(b[31:28]), .G(g1[7]), .S(s1[7]));

// Output signals in the Second stage
logic [1:0] g2, s2;
cmp4_bit cmp2_0 (.a(g1[3:0]), .b(s1[3:0]), .G(g2[0]), .S(s2[0]));
cmp4_bit cmp2_1 (.a(g1[7:4]), .b(s1[7:4]), .G(g2[1]), .S(s2[1]));

// Output signals in the Third stage
logic g, s, equal;				// g (Greater) & s (Smaller) & equal result of Magnitude
logic G, S;							// G (Greater) & S(Smaller) final result of both signed and un-signed
cmp2_bit final_stage (.a(g2), .b(s2), .G(g), .S(s));

always_comb begin
	case ({sign, A[31], B[31]})
		3'b000:	begin
						// A and B positive, unsigned
						G = g;
						S = s;
					end
					
		3'b001:	begin
						// A positive & B negative, unsigned
						G = g;
						S = s;
					end
					
		3'b010:	begin
						// A negative & B positive, unsigned
						G = g;
						S = s;
					end
					
		3'b011:	begin
						// A and B negative, unsigned
						G = g;
						S = s;
					end
		
		3'b100:	begin
						// A and B positive, signed
						G = g;
						S = s;
					end
					
		3'b101:	begin
						// A positive & B negative, signed
						G = 1'b1;
						S = 1'b0;
					end
					
		3'b110:	begin
						// A negative & B positive, signed
						G = 1'b0;
						S = 1'b1;
					end
					
		3'b111:	begin
						// A and B negative, signed
						G = ~g;
						S = ~s;
					end
	endcase
end

assign equal =  (~G) & (~S);

//assign GE = ~S;
//assign SE = ~G;

assign GES = {G, equal, S};

endmodule : Comparator