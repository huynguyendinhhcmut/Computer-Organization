//	Barrel Shifter:
// + Logical shift right & left
// + Arithmetic shift right

module Barrel_shifter (
	input logic [31:0] in,
	input logic [1:0] sel,	// sel[1]: 1=left or 0=right; sel[0]: 1=arithmetic or 0=logical
	input logic [4:0] B,		// number of shifted bits
	output logic [31:0] out
);

logic [31:0] shift_out;

logic [31:0] out1, out2, out4, out8, out16;	// Output of srlx module
logic [31:0] out_mux0, out_mux1, out_mux2, out_mux3, out_mux4;	// Output of mux
logic [31:0] out_reverse;

reverse reversal_in (.in(in[31:0]), .left(sel[1]), .out(out_reverse[31:0]));

sr1 shift1 (.in(out_reverse), .left(sel[1]), .arith(sel[0]), .B0(B[0]), .out(out1));
mux2_1 mux0 (.in0(out_reverse), .in1(out1), .sel(B[0]), .out(out_mux0));

sr2 shift2 (.in(out_mux0), .left(sel[1]), .arith(sel[0]), .B1(B[1]), .out(out2));
mux2_1 mux1 (.in0(out_mux0), .in1(out2), .sel(B[1]), .out(out_mux1));

sr4 shift4 (.in(out_mux1), .left(sel[1]), .arith(sel[0]), .B2(B[2]), .out(out4));
mux2_1 mux2 (.in0(out_mux1), .in1(out4), .sel(B[2]), .out(out_mux2));

sr8 shift8 (.in(out_mux2), .left(sel[1]), .arith(sel[0]), .B3(B[3]), .out(out8));
mux2_1 mux3 (.in0(out_mux2), .in1(out8), .sel(B[3]), .out(out_mux3));

sr16 shift16 (.in(out_mux3), .left(sel[1]), .arith(sel[0]), .B4(B[4]), .out(out16));
mux2_1 mux4 (.in0(out_mux3), .in1(out16), .sel(B[4]), .out(out_mux4));

reverse reversal_out (.in(out_mux4), .left(sel[1]), .out(shift_out));

assign out = shift_out;

endmodule : Barrel_shifter

// sr1 module is a Shift Right (>>1)
module sr1 (
	input logic [31:0] in,
	input logic left,
	input logic arith,
	input logic B0,
	output logic [31:0] out
);

always @(*) begin
	case (B0)
		1'b0:	out = in;
		1'b1:	out = {((~left) & arith & in[31]), in[31:1]};
	endcase
end

endmodule : sr1

// sr2 module is a Shift Right (>>2)
module sr2 (
	input logic [31:0] in,
	input logic left,
	input logic arith,
	input logic B1,
	output logic [31:0] out
);

always @(*) begin
	case (B1)
		1'b0:	out = in;
		1'b1:	out = {{2{((~left) & arith & in[31])}}, in[31:2]};
	endcase
end

endmodule : sr2

// sr4 module is a Shift Right (>>4)
module sr4 (
	input logic [31:0] in,
	input logic left,
	input logic arith,
	input logic B2,
	output logic [31:0] out
);

always @(*) begin
	case (B2)
		1'b0:	out = in;
		1'b1:	out = {{4{((~left) & arith & in[31])}}, in[31:4]};
	endcase
end

endmodule : sr4

// sr8 module is Shift Right (>>8))
module sr8 (
	input logic [31:0] in,
	input logic left,
	input logic arith,
	input logic B3,
	output logic [31:0] out	
);

always @(*) begin
	case (B3)
		1'b0:	out = in;
		1'b1:	out = {{8{((~left) & arith & in[31])}}, in[31:8]};
	endcase
end

endmodule : sr8

// sr16 module is Shift Right (>>16)
module sr16 (
	input logic [31:0] in,
	input logic left,
	input logic arith,
	input logic B4,
	output logic [31:0] out
);

always @(*) begin
	case (B4)
		1'b0:	out = in;
		1'b1:	out = {{16{((~left) & arith & in[31])}}, in[31:16]};
	endcase
end

endmodule : sr16

// Reverse module - use to reverse 32-bits to shift left Arithmetic or Logical
module reverse (
	input logic [31:0] in,
	input logic left,			// left = 1: reverse, left = 0 no reverse
	output logic [31:0] out
);

always @(*) begin
	case (left)
		1'b0:	out = in;
		1'b1: out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15],
						 in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31]};
	endcase
end

endmodule : reverse