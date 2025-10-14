/*
==================================================================================================
		 ____                       _        ____                                       _   _       _ _   
		| __ ) _ __ __ _ _ __   ___| |__    / ___|___  _ __ ___  _ __   __ _ _ __ ___  | | | |_ __ (_) |_ 
		|  _ \| '__/ _` | '_ \ / __| '_ \  | |   / _ \| '_ ` _ \| '_ \ / _` | '__/ _ \ | | | | '_ \| | __|
		| |_) | | | (_| | | | | (__| | | | | |__| (_) | | | | | | |_) | (_| | | |  __/ | |_| | | | | | |_ 
		|____/|_|  \__,_|_| |_|\___|_| |_|  \____\___/|_| |_| |_| .__/ \__,_|_|  \___|  \___/|_| |_|_|\__|
																				  |_|                                       
==================================================================================================
*/
module brc
( 
	input [31:0] i_rs1_data, 
	input [31:0] i_rs2_data,	
	input 		 i_br_un,
	
	output 		 o_br_less,
	output 		 o_br_equal
);
	logic LT_U, GT_U; 
	
	// Calculate condition
	comparator
	(
	  .operand_a	(i_rs1_data), 
	  .operand_b	(i_rs2_data),
	  .o_eq			(o_br_equal), 
	  .o_lt			(LT_U), 
	  .o_gt			(GT_U)
	);
	
	logic sel, null0, AxB, SG, SL;
	assign AxB = i_rs1_data[31] ^ i_rs2_data[31];		// A[31] xor B[31] if A==B = 0
														//							 							 A~=B = 1
	assign SG = (~i_rs1_data[31] & i_rs2_data[31]);		// (A positive, B negative) => A > B
	assign SL = (i_rs1_data[31] & ~i_rs2_data[31]);		// (A negative, B positive) => A < B										  
/*



																 AxB	0  
																_|____|_
																\ 0  1 /__ i_br_un ( 0: Signed, 1: UnSigned )
																 \____/
																	|
																   |
								GT_U  SG		  LT_U  SL		|
								_|____|_			_|____|_		|
								\ 0  1 /_______\ 0  1 /__ sel
								 \____/			 \____/
									 |				 	|
									GT					LT

*/
	
	MUX_2x1	MUX_SEL1	(i_br_un, AxB, 1'b0, sel); 
	MUX_2x1	MUX_LT1	(sel, LT_U, SL, o_br_less);
	MUX_2x1	MUX_GT1	(sel, GT_U, SG, null0);
		
endmodule

/* 
==================================================================================================
		  ____                                      _             
		 / ___|___  _ __ ___  _ __   __ _ _ __ __ _| |_ ___  _ __ 
		| |   / _ \| '_ ` _ \| '_ \ / _` | '__/ _` | __/ _ \| '__|
		| |__| (_) | | | | | | |_) | (_| | | | (_| | || (_) | |   
		 \____\___/|_| |_| |_| .__/ \__,_|_|  \__,_|\__\___/|_|   
									|_|                                  
==================================================================================================
*/

module comparator
(
  input  logic [31:0] operand_a, 
  input  logic [31:0] operand_b,
  output logic        o_eq, 
  output logic        o_lt, 
  output logic        o_gt
);

logic Ehigh, Lhigh;
logic Elow, Llow;

com16bit	com16bit_high	(.A(operand_a[31:16]), .B(operand_b[31:16]), .EQ(Ehigh), .LT(Lhigh));
com16bit	com16bit_low	(.A(operand_a[15:0]), .B(operand_b[15:0]), .EQ(Elow), .LT(Llow));

assign o_eq = Ehigh & Elow;
assign o_lt = (Ehigh & Llow) | Lhigh;
assign o_gt = ~(o_eq | o_lt);
endmodule

// ==================================================
//		1 bit
// ==================================================

module com1bit
(
  input  logic A, B,
  output logic EQ, LT
);

assign EQ = ~( A ^ B );
assign LT = ~A & B;

endmodule 

// ==================================================
// 	2 bit
// ==================================================

module com2bit
(
  input  logic [1:0] A, B,
  output logic EQ, LT
);

logic Ehigh, Lhigh;
logic Elow, Llow;

com1bit	com1bit_high	(.A(A[1]), .B(B[1]), .EQ(Ehigh), .LT(Lhigh));
com1bit	com1bit_low		(.A(A[0]), .B(B[0]), .EQ(Elow), .LT(Llow));

assign EQ = Ehigh & Elow;
assign LT = (Ehigh & Llow) | Lhigh;

endmodule

// ==================================================
//		4 bit
// ==================================================

module com4bit
(
  input  logic [3:0] A, B,
  output logic EQ, LT
);

logic Ehigh, Lhigh;
logic Elow, Llow;

com2bit	com2bit_high	(.A(A[3:2]), .B(B[3:2]), .EQ(Ehigh), .LT(Lhigh));
com2bit	com2bit_low		(.A(A[1:0]), .B(B[1:0]), .EQ(Elow), .LT(Llow));

assign EQ = Ehigh & Elow;
assign LT = (Ehigh & Llow) | Lhigh;

endmodule

// ==================================================
//		8 bit
// ==================================================

module com8bit
(
  input  logic [7:0] A, B,
  output logic EQ, LT
);

logic Ehigh, Lhigh;
logic Elow, Llow;

com4bit	com4bit_high	(.A(A[7:4]), .B(B[7:4]), .EQ(Ehigh), .LT(Lhigh));
com4bit	com4bit_low		(.A(A[3:0]), .B(B[3:0]), .EQ(Elow), .LT(Llow));

assign EQ = Ehigh & Elow;
assign LT = (Ehigh & Llow) | Lhigh;

endmodule

// ==================================================
//		16 bit
// ==================================================

module com16bit
(
  input  logic [15:0] A, B,
  output logic EQ, LT
);

logic Ehigh, Lhigh;
logic Elow, Llow;

com8bit	com8bit_high	(.A(A[15:8]), .B(B[15:8]), .EQ(Ehigh), .LT(Lhigh));
com8bit	com8bit_low		(.A(A[7:0]), .B(B[7:0]), .EQ(Elow), .LT(Llow));

assign EQ = Ehigh & Elow;
assign LT = (Ehigh & Llow) | Lhigh;

endmodule 



