/*
==================================================================================================
		 ____            _____ _ _      
		|  _ \ ___  __ _|  ___(_) | ___ 
		| |_) / _ \/ _` | |_  | | |/ _ \
		|  _ <  __/ (_| |  _| | | |  __/
		|_| \_\___|\__, |_|   |_|_|\___|
					  |___/                
==================================================================================================
*/
module regfile 
(
	input i_clk, 
	input i_rst_n,
	input [4:0] i_rs1_addr, 
	input [4:0] i_rs2_addr, 
	input [4:0] i_rd_addr,		
	input [31:0] i_rd_data,								
	input i_rd_wren,	
	
	output [31:0] o_rs1_data,
	output [31:0] o_rs2_data		
);




	logic [31:0] 	R0,  R1,  R2,  R3,  R4,  R5,  R6,  R7,
						R8,  R9,  R10, R11, R12, R13, R14, R15,
						R16, R17, R18, R19, R20, R21, R22, R23,
						R24, R25, R26, R27, R28, R29, R30, R31;
	logic [31:1] WE;
	logic [31:0] decoder_output;

	// Select which REGISTER is taked value
	logic [31:0] REG1, REG2, REG_S;

	// Decode to know which REGISTER is selected
	DECODER_5_to_32 DECODER_5_to_32_REG1 (i_rs1_addr, REG1);
	DECODER_5_to_32 DECODER_5_to_32_REG2 (i_rs2_addr, REG2);

	DECODER_5_to_32 DECODER_5_to_32_REGD (i_rd_addr, decoder_output);
												
	// Register ARRAY 0 to 31
	// Specially, R0 == 0 <=> ZeroREG				 
	assign R0 = 32'b0;			
	assign REG_S = decoder_output & ~32'b1;  			// Always disable R0 selection

	assign WE[31:1] = REG_S[31:1] & {31{i_rd_wren}};		// Write enable for writen REGISTER
	
//									  R   			   Rin_en  		   i_clk  			i_nrst    			Q	
REG_32bits	REG_32bits_R1  (.R(i_rd_data), .Rin_en(WE[1]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R1));
REG_32bits	REG_32bits_R2  (.R(i_rd_data), .Rin_en(WE[2]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R2));
REG_32bits 	REG_32bits_R3  (.R(i_rd_data), .Rin_en(WE[3]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R3));
REG_32bits 	REG_32bits_R4  (.R(i_rd_data), .Rin_en(WE[4]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R4));
REG_32bits 	REG_32bits_R5  (.R(i_rd_data), .Rin_en(WE[5]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R5));
REG_32bits 	REG_32bits_R6  (.R(i_rd_data), .Rin_en(WE[6]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R6));
REG_32bits	REG_32bits_R7  (.R(i_rd_data), .Rin_en(WE[7]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R7));
REG_32bits 	REG_32bits_R8  (.R(i_rd_data), .Rin_en(WE[8]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R8));
REG_32bits 	REG_32bits_R9  (.R(i_rd_data), .Rin_en(WE[9]), .i_clk(i_clk), .i_nrst(i_rst_n), .Q(R9));
REG_32bits 	REG_32bits_R10 (.R(i_rd_data), .Rin_en(WE[10]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R10));
REG_32bits 	REG_32bits_R11 (.R(i_rd_data), .Rin_en(WE[11]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R11));
REG_32bits 	REG_32bits_R12 (.R(i_rd_data), .Rin_en(WE[12]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R12));
REG_32bits 	REG_32bits_R13 (.R(i_rd_data), .Rin_en(WE[13]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R13));
REG_32bits 	REG_32bits_R14 (.R(i_rd_data), .Rin_en(WE[14]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R14));
REG_32bits 	REG_32bits_R15 (.R(i_rd_data), .Rin_en(WE[15]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R15));
REG_32bits 	REG_32bits_R16 (.R(i_rd_data), .Rin_en(WE[16]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R16));
REG_32bits 	REG_32bits_R17 (.R(i_rd_data), .Rin_en(WE[17]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R17));
REG_32bits 	REG_32bits_R18 (.R(i_rd_data), .Rin_en(WE[18]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R18));
REG_32bits 	REG_32bits_R19 (.R(i_rd_data), .Rin_en(WE[19]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R19));
REG_32bits 	REG_32bits_R20 (.R(i_rd_data), .Rin_en(WE[20]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R20));
REG_32bits 	REG_32bits_R21 (.R(i_rd_data), .Rin_en(WE[21]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R21));
REG_32bits 	REG_32bits_R22 (.R(i_rd_data), .Rin_en(WE[22]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R22));
REG_32bits 	REG_32bits_R23 (.R(i_rd_data), .Rin_en(WE[23]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R23));
REG_32bits 	REG_32bits_R24 (.R(i_rd_data), .Rin_en(WE[24]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R24));
REG_32bits 	REG_32bits_R25 (.R(i_rd_data), .Rin_en(WE[25]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R25));
REG_32bits 	REG_32bits_R26 (.R(i_rd_data), .Rin_en(WE[26]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R26));
REG_32bits 	REG_32bits_R27 (.R(i_rd_data), .Rin_en(WE[27]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R27));
REG_32bits 	REG_32bits_R28 (.R(i_rd_data), .Rin_en(WE[28]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R28));
REG_32bits 	REG_32bits_R29 (.R(i_rd_data), .Rin_en(WE[29]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R29));
REG_32bits 	REG_32bits_R30 (.R(i_rd_data), .Rin_en(WE[30]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R30));
REG_32bits 	REG_32bits_R31 (.R(i_rd_data), .Rin_en(WE[31]),.i_clk(i_clk), .i_nrst(i_rst_n), .Q(R31));



// Get data from selected REGISTER
MULT_32X1 MULT_32X1_REG1 (REG1, 	R0,  R1,  R2,  R3,  R4,  R5,  R6,  R7,
											R8,  R9,  R10, R11, R12, R13, R14, R15,
											R16, R17, R18, R19, R20, R21, R22, R23,
											R24, R25, R26, R27, R28, R29, R30, R31, o_rs1_data);
											
MULT_32X1 MULT_32X1_REG2 (REG2, 	R0,  R1,  R2,  R3,  R4,  R5,  R6,  R7,
											R8,  R9,  R10, R11, R12, R13, R14, R15,
											R16, R17, R18, R19, R20, R21, R22, R23,
											R24, R25, R26, R27, R28, R29, R30, R31, o_rs2_data);


endmodule 

//--------------------------------DECODER 5 to 32------------------------------------

module DECODER_5_to_32 (
    input  [4:0] A,  // 5-bit input
    output [31:0] Y  // 32-bit output
); 

    // Inverted signals
    wire A0_n, A1_n, A2_n, A3_n, A4_n;

    not (A0_n, A[0]);
    not (A1_n, A[1]);
    not (A2_n, A[2]);
    not (A3_n, A[3]);
    not (A4_n, A[4]);

    // Each output bit is a 5-input AND gate
    and (Y[0],  A4_n, A3_n, A2_n, A1_n, A0_n);
    and (Y[1],  A4_n, A3_n, A2_n, A1_n, A[0]);
    and (Y[2],  A4_n, A3_n, A2_n, A[1], A0_n);
    and (Y[3],  A4_n, A3_n, A2_n, A[1], A[0]);
    and (Y[4],  A4_n, A3_n, A[2], A1_n, A0_n);
    and (Y[5],  A4_n, A3_n, A[2], A1_n, A[0]);
    and (Y[6],  A4_n, A3_n, A[2], A[1], A0_n);
    and (Y[7],  A4_n, A3_n, A[2], A[1], A[0]);
    and (Y[8],  A4_n, A[3], A2_n, A1_n, A0_n);
    and (Y[9],  A4_n, A[3], A2_n, A1_n, A[0]);
    and (Y[10], A4_n, A[3], A2_n, A[1], A0_n);
    and (Y[11], A4_n, A[3], A2_n, A[1], A[0]);
    and (Y[12], A4_n, A[3], A[2], A1_n, A0_n);
    and (Y[13], A4_n, A[3], A[2], A1_n, A[0]);
    and (Y[14], A4_n, A[3], A[2], A[1], A0_n);
    and (Y[15], A4_n, A[3], A[2], A[1], A[0]);
    and (Y[16], A[4], A3_n, A2_n, A1_n, A0_n);
    and (Y[17], A[4], A3_n, A2_n, A1_n, A[0]);
    and (Y[18], A[4], A3_n, A2_n, A[1], A0_n);
    and (Y[19], A[4], A3_n, A2_n, A[1], A[0]);
    and (Y[20], A[4], A3_n, A[2], A1_n, A0_n);
    and (Y[21], A[4], A3_n, A[2], A1_n, A[0]);
    and (Y[22], A[4], A3_n, A[2], A[1], A0_n);
    and (Y[23], A[4], A3_n, A[2], A[1], A[0]);
    and (Y[24], A[4], A[3], A2_n, A1_n, A0_n);
    and (Y[25], A[4], A[3], A2_n, A1_n, A[0]);
    and (Y[26], A[4], A[3], A2_n, A[1], A0_n);
    and (Y[27], A[4], A[3], A2_n, A[1], A[0]);
    and (Y[28], A[4], A[3], A[2], A1_n, A0_n);
    and (Y[29], A[4], A[3], A[2], A1_n, A[0]);
    and (Y[30], A[4], A[3], A[2], A[1], A0_n);
    and (Y[31], A[4], A[3], A[2], A[1], A[0]);

endmodule  

//--------------------------------Multiplexer------------------------------------

module MULT_32X1 
(
input [31:0] sel,
input [31:0] R0,  R1,  R2,  R3,  R4,  R5,  R6,  R7,
             R8,  R9,  R10, R11, R12, R13, R14, R15,
             R16, R17, R18, R19, R20, R21, R22, R23,
             R24, R25, R26, R27, R28, R29, R30, R31,
output [31:0] bus		// Value of Register  	
);

// Declare masked wires
logic [31:0] masked_R0,  masked_R1,  masked_R2,  masked_R3;
logic [31:0] masked_R4,  masked_R5,  masked_R6,  masked_R7;
logic [31:0] masked_R8,  masked_R9,  masked_R10, masked_R11;
logic [31:0] masked_R12, masked_R13, masked_R14, masked_R15;
logic [31:0] masked_R16, masked_R17, masked_R18, masked_R19;
logic [31:0] masked_R20, masked_R21, masked_R22, masked_R23;
logic [31:0] masked_R24, masked_R25, masked_R26, masked_R27;
logic [31:0] masked_R28, masked_R29, masked_R30, masked_R31;



// Assign each masked register using logic gates
assign masked_R0  = {32{sel[0]}}  & R0;
assign masked_R1  = {32{sel[1]}}  & R1;
assign masked_R2  = {32{sel[2]}}  & R2;
assign masked_R3  = {32{sel[3]}}  & R3;
assign masked_R4  = {32{sel[4]}}  & R4;
assign masked_R5  = {32{sel[5]}}  & R5;
assign masked_R6  = {32{sel[6]}}  & R6;
assign masked_R7  = {32{sel[7]}}  & R7;
assign masked_R8  = {32{sel[8]}}  & R8;
assign masked_R9  = {32{sel[9]}}  & R9;
assign masked_R10 = {32{sel[10]}} & R10;
assign masked_R11 = {32{sel[11]}} & R11;
assign masked_R12 = {32{sel[12]}} & R12;
assign masked_R13 = {32{sel[13]}} & R13;
assign masked_R14 = {32{sel[14]}} & R14;
assign masked_R15 = {32{sel[15]}} & R15;
assign masked_R16 = {32{sel[16]}} & R16;
assign masked_R17 = {32{sel[17]}} & R17;
assign masked_R18 = {32{sel[18]}} & R18;
assign masked_R19 = {32{sel[19]}} & R19;
assign masked_R20 = {32{sel[20]}} & R20;
assign masked_R21 = {32{sel[21]}} & R21;
assign masked_R22 = {32{sel[22]}} & R22;
assign masked_R23 = {32{sel[23]}} & R23;
assign masked_R24 = {32{sel[24]}} & R24;
assign masked_R25 = {32{sel[25]}} & R25;
assign masked_R26 = {32{sel[26]}} & R26;
assign masked_R27 = {32{sel[27]}} & R27;
assign masked_R28 = {32{sel[28]}} & R28;
assign masked_R29 = {32{sel[29]}} & R29;
assign masked_R30 = {32{sel[30]}} & R30;
assign masked_R31 = {32{sel[31]}} & R31;



// OR all masked outputs together to get final bus
assign bus = masked_R0  | masked_R1  | masked_R2  | masked_R3  |
             masked_R4  | masked_R5  | masked_R6  | masked_R7  |
             masked_R8  | masked_R9  | masked_R10 | masked_R11 |
             masked_R12 | masked_R13 | masked_R14 | masked_R15 |
             masked_R16 | masked_R17 | masked_R18 | masked_R19 |
             masked_R20 | masked_R21 | masked_R22 | masked_R23 |
             masked_R24 | masked_R25 | masked_R26 | masked_R27 |
             masked_R28 | masked_R29 | masked_R30 | masked_R31;
endmodule

/*
==================================================================================================
		 ____              _________  ____  _ _       
		|  _ \ ___  __ _  |___ /___ \| __ )(_) |_ ___ 
		| |_) / _ \/ _` |   |_ \ __) |  _ \| | __/ __|
		|  _ <  __/ (_| |  ___) / __/| |_) | | |_\__ \
		|_| \_\___|\__, | |____/_____|____/|_|\__|___/
					  |___/                              				 
==================================================================================================
*/

module REG_32bits 
(
	input [31:0] R,					
	input Rin_en, clk, nrst,
	output reg [31:0] Q			
);

always @(negedge clk or negedge nrst) begin
	if (!nrst) begin							
			Q <= {32'b0};
		end
		else 
	if (Rin_en == 1'b1) begin						
			Q <= R;								
	end
end

endmodule








