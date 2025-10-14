module alu(
	input logic [31:0] i_operand_a, i_operand_b,
	input logic [3:0] i_alu_op,
	output logic [31:0] o_alu_data
);
// Internal signals
logic [31:0] add_sub;
logic [2:0] ges;
logic [31:0] o_compare;
logic [1:0] shift_sel;
logic [31:0] o_shifter;

localparam ADD	= 4'b0000,
SUB	= 4'b0001,
SLT	= 4'b0010,
SLTU	= 4'b0011,
XOR	= 4'b0100,
OR		= 4'b0101,
AND	= 4'b0110,
SLL	= 4'b0111,
SRL	= 4'b1000,
SRA	= 4'b1001;

 
always_comb begin
	case (i_alu_op)
		ADD	:	o_alu_data = add_sub;
		SUB	: 	o_alu_data = add_sub;
		SLT	: 	o_alu_data = o_compare;
		SLTU	:	o_alu_data = o_compare;
		XOR	: 	o_alu_data = i_operand_a ^ i_operand_b;
		OR		: 	o_alu_data = i_operand_a | i_operand_b;
		AND	: 	o_alu_data = i_operand_a & i_operand_b;
		SLL	: 	o_alu_data = o_shifter;
		SRL	: 	o_alu_data = o_shifter;
		SRA	: 	o_alu_data = o_shifter;
		default:	o_alu_data = 32'h0000_0000;
	endcase
end

// ADD-SUB
KSA_top dut_add_sub (
	.a(in_operand_a),
	.b(in_operand_b),
	.cin(i_alu_op[0]),
	.sum(add_sub)
);

// Comparator
Comparator dut_compare (
	.A(in_operand_a),
	.B(in_operand_b),
	.sign(i_alu_op[0]),
	.GES(ges)
);

assign o_compare = ges[0] ? 1:0;

// Barrel Shifter
always_comb begin
	case(i_alu_op)
		SLL:		shift_sel = 2'b10;
		SRL:		shift_sel = 2'b00;
		SRA:		shift_sel = 2'b01;
		default:	shift_sel = 2'b00;
	endcase
end

Barrel_shifter dut_shifter (
	.in(i_operand_a),
	.sel(shift_sel),
	.B(i_operand_b[4:0]),
	.out(o_shifter)
);

endmodule : alu