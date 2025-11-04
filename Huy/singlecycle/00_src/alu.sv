module alu (
	input logic [31:0] i_operand_a,	// First operand for ALU operations.
	input logic [31:0] i_operand_b,	// Second operand for ALU operations.
	input logic [4:0] i_alu_op,		// The operation to be performed.
	
	output logic [31:0] o_alu_data	// Result of the ALU operation.
);

logic [31:0] sum, shifted;
logic less;
logic [63:0] mul;
logic [31:0] quotient, remainder;

fullAdder32b fa1 (.a(i_operand_a), .b(i_operand_b), .cin(i_alu_op[0]), .sum(sum));
comparator32b_signed comp_signed (.a(i_operand_a), .b(i_operand_b), .signed_mode(~i_alu_op[0]), .Lt(less));
shift shift (.data_in(i_operand_a), .rightleft(i_alu_op[2]), .arith(i_alu_op[0] & i_alu_op[3]), .shift_amount(i_operand_b[4:0]), .data_out(shifted));
multiplication mul1 (.i_a(i_operand_a), .i_b(i_operand_b), .i_sign_a(~i_alu_op[1]), .i_sign_b(~(i_alu_op[1] ^ i_alu_op[0])), .o_mul(mul));
big_divider div (.i_dividend(i_operand_a), .i_divisor(i_operand_b), .i_signed(i_alu_op[0]), .o_quotient(quotient), .o_remainder(remainder));

always_comb begin
	case (i_alu_op)
		5'b00000: o_alu_data = sum;								// ADD
		5'b00001: o_alu_data = sum;								// SUB
		5'b00010: o_alu_data = {31'b0, less};					// SLT
		5'b00011: o_alu_data = {31'b0, less};					// SLTU
		5'b00100: o_alu_data = i_operand_a ^ i_operand_b;	// XOR
		5'b00101: o_alu_data = i_operand_a | i_operand_b;	// OR
		5'b00110: o_alu_data = i_operand_a & i_operand_b;	// AND
		5'b00111: o_alu_data = shifted;							// SLL
		5'b01000: o_alu_data = shifted;							// SRL
		5'b01001: o_alu_data = shifted;							// SRA
		5'b01010: o_alu_data = i_operand_b;						// LUI
		5'b01011: o_alu_data = mul[31:0];						// MUL
		5'b01100: o_alu_data = mul[63:32];						// MULH 	 (signed signed)
		5'b01101: o_alu_data = mul[63:32];						// MULHsu (signed unsigned)
		5'b01110: o_alu_data = mul[63:32];						// MULHU  (unsigned unsigned)
		5'b01111: o_alu_data = quotient;							// DIV    (signed)
		5'b10000: o_alu_data = quotient;							// DIVU   (unsigned)
		5'b10001: o_alu_data = remainder;						// REM    (signed)
		5'b10010: o_alu_data = remainder;						// REMU   (unsigned)
		default:  o_alu_data = 32'b0;							
	endcase
end

endmodule