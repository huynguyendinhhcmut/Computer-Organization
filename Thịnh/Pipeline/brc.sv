module brc (
	input logic     [31:0]      A, B,
	input logic                 sign,           // sign = 1:compare signed, sign = 0: compare unsigned
    input logic     [ 2:0]      i_funct3,
//	output logic                equal,			// equal flag
//	output logic                greater,		// greater flag
//	output logic                less,			// less flag
//	output logic                le,				// less or equal flag
//	output logic                ge,				// greater or equal flag
//	output logic    [31:0]      a, b,
//	output logic                G, S,
//	output logic    [2:0]       GES,
    output logic                o_compare
//	output logic GE, SE
);
// Convert Negative number to Magnitude
logic [31:0]    a, b; 				// a, b is magnitude of A, B
logic [1:0]     co;
logic [31:0]    A_comp2, B_comp2;
logic [ 2:0]    GES;

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

always @(*) begin
    case (i_funct3)
        3'b000:     o_compare   =   GES[1];
        3'b001:     o_compare   =   ~GES[1];
        3'b100:     o_compare   =   GES[0];
        3'b101:     o_compare   =   GES[2] | GES[1];
        3'b110:     o_compare   =   GES[0];
        3'b111:     o_compare   =   GES[2] | GES[1];
        default:    o_compare   =   1'b0;
    endcase
end

endmodule : brc

module cmp4_bit (
	input logic [3:0] a, b,
	output logic G, S
);
logic [3:0] cmp;
logic [3:0] g, s;
// Generate cmp bit for which position need compare
assign cmp[3] = a[3] ^ b[3];
assign cmp[2] = (~cmp[3]) & (a[2] ^ b[2]);
assign cmp[1] = (~cmp[3]) & (~cmp[2]) & (a[1] ^ b[1]);
assign cmp[0] = (~cmp[3]) & (~cmp[2]) & (~cmp[1]) & (a[0] ^ b[0]);
// Compare to generate G (Greater - A>B) or S (Smaller - A<B)
assign g[3] = cmp[3] & a[3] & (~b[3]);
assign g[2] = cmp[2] & a[2] & (~b[2]);
assign g[1] = cmp[1] & a[1] & (~b[1]);
assign g[0] = cmp[0] & a[0] & (~b[0]);

assign s[3] = cmp[3] & (~a[3]) & b[3];
assign s[2] = cmp[2] & (~a[2]) & b[2];
assign s[1] = cmp[1] & (~a[1]) & b[1];
assign s[0] = cmp[0] & (~a[0]) & b[0];

assign G = |g;
assign S = |s;

endmodule : cmp4_bit

module cmp2_bit (
	input logic [1:0] a, b,
	output logic G, S
);
logic [1:0] cmp;
logic [1:0] g, s;

assign cmp[1] = a[1] ^ b[1];
assign cmp[0] = (~cmp[1]) & (a[0] ^ b[0]);

assign g[1] = cmp[1] & a[1] & (~b[1]);
assign g[0] = cmp[0] & a[0]& (~b[0]);

assign s[1] = cmp[1] & (~a[1]) & b[1];
assign s[0] = cmp[0] & (~a[0]) & b[0];

assign G = g[1] | g[0];
assign S = s[1] | s[0];

endmodule : cmp2_bit
