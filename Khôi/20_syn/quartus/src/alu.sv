/*
==================================================================================================
					  _      _       _   _  
					 / \    | |     | | | | 
					/ _ \   | |     | | | | 
				  / ___ \  | |___  | |_| | 
				 /_/   \_\ |_____|  \___/  	
				 
==================================================================================================
*/
module alu
(
	input	[31:0]	i_operand_a, 
	input [31:0]	i_operand_b,
	input [3:0]		i_alu_op,
	
	output [31:0]	o_alu_data

);
/*
			|--------------------|-----------|-----------|-----------|-----------|
			|	 OPERATING MODE	|		S3		|		S2		|		S1		|		S0		|
			|--------------------|-----------|-----------|-----------|-----------|
			|			 ADD			|		0		|		0		|		0		|		0		|
			|--------------------|-----------|-----------|-----------|-----------|
			|			 SUB			|		0		|		0		|		0		|		1		|
			|--------------------|-----------|-----------|-----------|-----------|
			|			 AND			|		0		|		0		|		1		|		0		|
			|--------------------|-----------|-----------|-----------|-----------|
			|			 OR			|		0		|		0		|		1		|		1		|
			|--------------------|-----------|-----------|-----------|-----------|
			|			 SLTU			|		0		|		1		|		0		|		0		|
			|--------------------|-----------|-----------|-----------|-----------|
			|			 SLT			|		0		|		1		|		0		|		1		|
			|--------------------|-----------|-----------|-----------|-----------|
			|	 		 NULL			|		0		|		1		|		1		|		0		|
			|--------------------|-----------|-----------|-----------|-----------|
			|	 		 XOR			|		0		|		1		|		1		|		1		|
			|--------------------|-----------|-----------|-----------|-----------|
			|	 		 SRL			|		1		|		0		|		0		|		1		|
			|--------------------|-----------|-----------|-----------|-----------|
			|	 		 SAR			|		1		|		0		|		1		|		1		|
			|--------------------|-----------|-----------|-----------|-----------|			
			|	 		 SLL			|		1		|		1		|		0		|		1		|
			|--------------------|-----------|-----------|-----------|-----------|
			
						
	-NOte that, i_alu_op[0] is use to control ADDER (0) and SUBTRATOR (1)
						
*/
logic CF;
logic ZF;
logic SF;
logic OF;
logic [1:0] sel_shift;
logic Pre_SLT_out, AS, s_sub, shift_ins, sltu_ins, zero, one;
logic [31:0] AND_out, OR_out, XOR_out, SLT_out, SLTU_out, SHIFT_out, ADD_out;
logic Cout;

// SUB
logic [31:0] AB, ni_operand_b;
assign ni_operand_b = ~i_operand_b;

	MUX_2x1_32Bits					SUBTRATOR (
	.s(s_sub), 
	.I0(i_operand_b[31:0]), 
	.I1(ni_operand_b[31:0]), 
	.Y(AB[31:0])
	);

// ADD
	ADDER_32bits					ADDER_32bits_ALU (
	.A(i_operand_a[31:0]), 
	.B(AB[31:0]), 
	.Cin(s_sub), 
	.Sum(ADD_out[31:0]), 
	.Cout(Cout)
	);

// LOGIC
assign AND_out = i_operand_a & i_operand_b;
assign OR_out	= i_operand_a | i_operand_b;
assign XOR_out = i_operand_a ^ i_operand_b;

// Shifter
assign sel_shift = i_alu_op[2:1];

	SHIFTER_32bits					Barrel_shifter (
	.A(i_operand_a[31:0]), 
	.B(i_operand_b[4:0]), 
	.Sel(sel_shift[1:0]), 
	.Y(SHIFT_out[31:0])
	);

// SLT
assign Pre_SLT_out = OF ^ ADD_out[31];
assign SLT_out = {31'b0,Pre_SLT_out};		// Zero_Ext

// SLTU
assign sltu_ins = ~i_alu_op[3] & i_alu_op[2] & ~i_alu_op[1] & ~i_alu_op[0];	// i_alu_op = 0100
assign s_sub = i_alu_op[0] | sltu_ins;  													// SUB, SLTU, SLT all use subtraction
assign SLTU_out = {31'b0, ~Cout};															// Zero_Ext

// EFLAGS
/*

					CF ; Carry Flag
					ZF : Zero Flag
					SF ; Sign Flag
					OF : Overflow Flag

*/
assign zero = 1'b0;
assign shift_ins = i_alu_op[3] & ~i_alu_op[2] & i_alu_op[1] & i_alu_op[0];		// i_alu_op = 1011

	MUX_2x1							selectCtrl2 (
	.s(shift_ins), 
	.I0(i_alu_op[1]), 
	.I1(zero), 
	.Y(AS)
	);

	assign CF = ~AS & Cout;
	assign ZF = &(~o_alu_data); 
	assign SF = o_alu_data[31];
	assign OF = ~(i_operand_a[31] ^ i_operand_b[31] ^ s_sub) & (i_operand_a[31] ^ ADD_out[31]) & ~AS;

	// ALU_MUX
	ALU_MUX							ALU_MUX_1 (
	.i_alu_op(i_alu_op[3:0]), 
	.I0(ADD_out[31:0]), 
	.I1(ADD_out[31:0]), 
	.I2(AND_out[31:0]), 
	.I3(OR_out[31:0]), 
	.I4(SLTU_out[31:0]),
	.I5(SLT_out[31:0]), 
	.I6(XOR_out[31:0]), 
	.I7(SHIFT_out[31:0]), 
	.I8(SHIFT_out[31:0]), 
	.I9(SHIFT_out[31:0]), 
	.o_alu_data(o_alu_data[31:0])
	);


endmodule 

/*
==================================================================================================
			  _    _    _   _    __  __ _   ___  __
			 / \  | |  | | | |  |  \/  | | | \ \/ /
			/ _ \ | |  | | | |  | |\/| | | | |\  / 
		  / ___ \| |__| |_| |  | |  | | |_| |/  \ 
		 /_/   \_\_____\___/   |_|  |_|\___//_/\_\
                                          
==================================================================================================
*/
module ALU_MUX
(
	input [3:0] i_alu_op,
	input [31:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9,
	output logic [31:0] o_alu_data
);

    always @(*) begin
        case (i_alu_op)
            4'b0000: o_alu_data = I0;  // ADD
            4'b0001: o_alu_data = I1;  // SUB
            4'b0010: o_alu_data = I2;  // AND
				4'b0011: o_alu_data = I3;  // OR
				4'b0100: o_alu_data = I4;  // SLTU (Set if Less Than, Unsigned)
				4'b0101: o_alu_data = I5;  // SLT  (Set if Less Than)
				4'b0111: o_alu_data = I6;  // XOR
				4'b1001: o_alu_data = I7;  // SRL
				4'b1011: o_alu_data = I8;  // SAR
				4'b1101: o_alu_data = I9;  // SLL
            default: o_alu_data = 32'b0; // Default (invalid case)
        endcase
    end	
endmodule

/*
==================================================================================================
		 __  __ _   ___  __  ____           _ 
		|  \/  | | | \ \/ / |___ \  __  __ / |
		| |\/| | | | |\  /    __) | \ \/ / | |
		| |  | | |_| |/  \   / __/   >  <  | |
		|_|  |_|\___//_/\_\ |_____| /_/\_\ |_|
                                       
==================================================================================================
*/

module MUX_2x1
(
	input s,
	input I0, I1,
	output Y
);			

    always @(*) begin
        case (s)
            1'b0: Y = I0;  
            1'b1: Y = I1;   
            default: Y = 1'd0; 
        endcase
    end	
				
endmodule 