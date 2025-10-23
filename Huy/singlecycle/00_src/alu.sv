module alu (
	input logic [31:0] i_operand_a,	// First operand for ALU operations.
	input logic [31:0] i_operand_b,	// Second operand for ALU operations.
	input logic [3:0] i_alu_op,		// The operation to be performed.
	
	output logic [31:0] o_alu_data	// Result of the ALU operation.
);

logic [31:0] sum, shifted;
logic less;

fullAdder32b fa1 (.a(i_operand_a), .b(i_operand_b), .cin(i_alu_op[0]), .sum(sum));
comparator32b_signed comp_signed (.a(i_operand_a), .b(i_operand_b), .signed_mode(~i_alu_op[0]), .Lt(less));
shift shift (.data_in(i_operand_a), .rightleft(i_alu_op[2]), .arith(i_alu_op[0] & i_alu_op[3]), .shift_amount(i_operand_b[4:0]), .data_out(shifted));

always_comb begin
	case (i_alu_op)
		4'b0000: o_alu_data = sum;									// ADD
		4'b0001:	o_alu_data = sum;									// SUB
		4'b0010: o_alu_data = {31'b0, less};					// SLT
		4'b0011: o_alu_data = {31'b0, less};					// SLTU
		4'b0100: o_alu_data = i_operand_a ^ i_operand_b;	// XOR
		4'b0101: o_alu_data = i_operand_a | i_operand_b;	// OR
		4'b0110: o_alu_data = i_operand_a & i_operand_b;	// AND
		4'b0111: o_alu_data = shifted;							// SLL
		4'b1000: o_alu_data = shifted;							// SRL
		4'b1001: o_alu_data = shifted;							// SRA
		4'b1010: o_alu_data = i_operand_b;						// LUI
		default: o_alu_data = 32'b0;
	endcase
end

endmodule