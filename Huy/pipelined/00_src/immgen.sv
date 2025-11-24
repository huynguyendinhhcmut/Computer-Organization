module immgen (
	input logic [31:7] i_instr,
	input logic [2:0] i_imm_sel,
	output logic [31:0] o_immext
);

always_comb begin
    case (i_imm_sel)
		3'b000: o_immext = {{20{i_instr[31]}}, i_instr[31:20]};													// I Type
		3'b001: o_immext = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]};								// S Type
		3'b010: o_immext = {{20{i_instr[31]}}, i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0};		// B Type
		3'b011: o_immext = {{12{i_instr[31]}}, i_instr[19:12], i_instr[20], i_instr[30:21], 1'b0};	// J Type
		3'b100: o_immext = {i_instr[31:12], 12'b0};																	// U Type
		default: o_immext = 32'b0;
	endcase
end

endmodule
