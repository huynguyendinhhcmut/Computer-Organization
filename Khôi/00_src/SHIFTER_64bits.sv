/*
==================================================================================================
		 ____           _    ____ _   _  __ _           
		| __ )  __ _ _ __ _ __ ___| |  / ___|| |__ (_)/ _| |_ ___ _ __ 
		| _ \ / _` | '__| '__/ _ \ |  \___ \| '_ \| | |_| __/ _ \ '__|
		| |_) | (_| | |  | | |  __/ |  ___) | | | | | _| ||  __/ |   
		|____/ \__,_|_|  |_|  \___|_| |____/|_| |_|_|_|  \__\___|_|   
                                                                   
==================================================================================================
*/
module SHIFTER_64bits
(
	input [63:0] A,		// 64-bit Input
	input [5:0] B,			// Shift n bits (0 to 63)
	input [1:0] Sel,		// Select mode Shift
	output [63:0] Y		// 64-bit Output
);
/*
							|--------------------|-----------|--------------|
							|	 OPERATING MODE	|	 Left		|	Arithmetic	|
							|--------------------|-----------|--------------|
							|		SHIFT RIGHT		|		0		|		  0		|
							|--------------------|-----------|--------------|
							|			 ASR			|		0		|		  1		|
							|--------------------|-----------|--------------|
							|		SHIFT LEFT		|		1		|		  0		|
							|--------------------|-----------|--------------|
							|			 ASL			|		1		|		  1		|
							|--------------------|-----------|--------------|
*/

logic zero;
assign zero = 1'b0;

// Intermediate signals for 6 stages of the barrel shifter, plus input/output
// A6: Input reversal result (A shifted left/right)
// A5: After 32-bit shift (B[5])
// A4: After 16-bit shift (B[4])
// A3: After 8-bit shift (B[3])
// A2: After 4-bit shift (B[2])
// A1: After 2-bit shift (B[1])
// A0: After 1-bit shift (B[0])
logic [63:0] A6, A5, A4, A3, A2, A1, A0;

// =======================================================================
// ARITHMETIC/LOGICAL FILL BIT (AoL)
// AoL = 1'b0 for Logical Shift (Sel[0]=0) or Left Shift (Sel[1]=1)
// AoL = A[63] for Arithmetic Right Shift (ASR) (Sel[0]=1, Sel[1]=0)
// =======================================================================
logic AoL,AoL1;
// AoL1 is A[63] only if Sel[0]=1 (Arithmetic mode)
MUX_2x1 MUX_2x1_AoL1 (Sel[0], zero, A[63], AoL1);
// AoL is AoL1 only if Sel[1]=0 (Right shift mode, which is when filling is needed)
MUX_2x1 MUX_2x1_AoL (Sel[1], AoL1, zero, AoL);

// =======================================================================
// 1. DATA REVERSAL (Input A to A6) - 64 MUXes
// A6 = A (Right Shift/ASR: Sel[1]=0)
// A6 = A reversed (Left Shift/ASL: Sel[1]=1)
// =======================================================================
	MUX_2x1 MUX_2x1_DIR_1 (Sel[1], A[0], A[63], A6[0]);
	MUX_2x1 MUX_2x1_DIR_2 (Sel[1], A[1], A[62], A6[1]);
	MUX_2x1 MUX_2x1_DIR_3 (Sel[1], A[2], A[61], A6[2]);
	MUX_2x1 MUX_2x1_DIR_4 (Sel[1], A[3], A[60], A6[3]);
	MUX_2x1 MUX_2x1_DIR_5 (Sel[1], A[4], A[59], A6[4]);
	MUX_2x1 MUX_2x1_DIR_6 (Sel[1], A[5], A[58], A6[5]);
	MUX_2x1 MUX_2x1_DIR_7 (Sel[1], A[6], A[57], A6[6]);
	MUX_2x1 MUX_2x1_DIR_8 (Sel[1], A[7], A[56], A6[7]);
	MUX_2x1 MUX_2x1_DIR_9 (Sel[1], A[8], A[55], A6[8]);
	MUX_2x1 MUX_2x1_DIR_10 (Sel[1], A[9], A[54], A6[9]);
	MUX_2x1 MUX_2x1_DIR_11 (Sel[1], A[10], A[53], A6[10]);
	MUX_2x1 MUX_2x1_DIR_12 (Sel[1], A[11], A[52], A6[11]);
	MUX_2x1 MUX_2x1_DIR_13 (Sel[1], A[12], A[51], A6[12]);
	MUX_2x1 MUX_2x1_DIR_14 (Sel[1], A[13], A[50], A6[13]);
	MUX_2x1 MUX_2x1_DIR_15 (Sel[1], A[14], A[49], A6[14]);
	MUX_2x1 MUX_2x1_DIR_16 (Sel[1], A[15], A[48], A6[15]);
	MUX_2x1 MUX_2x1_DIR_17 (Sel[1], A[16], A[47], A6[16]);
	MUX_2x1 MUX_2x1_DIR_18 (Sel[1], A[17], A[46], A6[17]);
	MUX_2x1 MUX_2x1_DIR_19 (Sel[1], A[18], A[45], A6[18]);
	MUX_2x1 MUX_2x1_DIR_20 (Sel[1], A[19], A[44], A6[19]);
	MUX_2x1 MUX_2x1_DIR_21 (Sel[1], A[20], A[43], A6[20]);
	MUX_2x1 MUX_2x1_DIR_22 (Sel[1], A[21], A[42], A6[21]);
	MUX_2x1 MUX_2x1_DIR_23 (Sel[1], A[22], A[41], A6[22]);
	MUX_2x1 MUX_2x1_DIR_24 (Sel[1], A[23], A[40], A6[23]);
	MUX_2x1 MUX_2x1_DIR_25 (Sel[1], A[24], A[39], A6[24]);
	MUX_2x1 MUX_2x1_DIR_26 (Sel[1], A[25], A[38], A6[25]);
	MUX_2x1 MUX_2x1_DIR_27 (Sel[1], A[26], A[37], A6[26]);
	MUX_2x1 MUX_2x1_DIR_28 (Sel[1], A[27], A[36], A6[27]);
	MUX_2x1 MUX_2x1_DIR_29 (Sel[1], A[28], A[35], A6[28]);
	MUX_2x1 MUX_2x1_DIR_30 (Sel[1], A[29], A[34], A6[29]);
	MUX_2x1 MUX_2x1_DIR_31 (Sel[1], A[30], A[33], A6[30]);
	MUX_2x1 MUX_2x1_DIR_32 (Sel[1], A[31], A[32], A6[31]);
	MUX_2x1 MUX_2x1_DIR_33 (Sel[1], A[32], A[31], A6[32]);
	MUX_2x1 MUX_2x1_DIR_34 (Sel[1], A[33], A[30], A6[33]);
	MUX_2x1 MUX_2x1_DIR_35 (Sel[1], A[34], A[29], A6[34]);
	MUX_2x1 MUX_2x1_DIR_36 (Sel[1], A[35], A[28], A6[35]);
	MUX_2x1 MUX_2x1_DIR_37 (Sel[1], A[36], A[27], A6[36]);
	MUX_2x1 MUX_2x1_DIR_38 (Sel[1], A[37], A[26], A6[37]);
	MUX_2x1 MUX_2x1_DIR_39 (Sel[1], A[38], A[25], A6[38]);
	MUX_2x1 MUX_2x1_DIR_40 (Sel[1], A[39], A[24], A6[39]);
	MUX_2x1 MUX_2x1_DIR_41 (Sel[1], A[40], A[23], A6[40]);
	MUX_2x1 MUX_2x1_DIR_42 (Sel[1], A[41], A[22], A6[41]);
	MUX_2x1 MUX_2x1_DIR_43 (Sel[1], A[42], A[21], A6[42]);
	MUX_2x1 MUX_2x1_DIR_44 (Sel[1], A[43], A[20], A6[43]);
	MUX_2x1 MUX_2x1_DIR_45 (Sel[1], A[44], A[19], A6[44]);
	MUX_2x1 MUX_2x1_DIR_46 (Sel[1], A[45], A[18], A6[45]);
	MUX_2x1 MUX_2x1_DIR_47 (Sel[1], A[46], A[17], A6[46]);
	MUX_2x1 MUX_2x1_DIR_48 (Sel[1], A[47], A[16], A6[47]);
	MUX_2x1 MUX_2x1_DIR_49 (Sel[1], A[48], A[15], A6[48]);
	MUX_2x1 MUX_2x1_DIR_50 (Sel[1], A[49], A[14], A6[49]);
	MUX_2x1 MUX_2x1_DIR_51 (Sel[1], A[50], A[13], A6[50]);
	MUX_2x1 MUX_2x1_DIR_52 (Sel[1], A[51], A[12], A6[51]);
	MUX_2x1 MUX_2x1_DIR_53 (Sel[1], A[52], A[11], A6[52]);
	MUX_2x1 MUX_2x1_DIR_54 (Sel[1], A[53], A[10], A6[53]);
	MUX_2x1 MUX_2x1_DIR_55 (Sel[1], A[54], A[9], A6[54]);
	MUX_2x1 MUX_2x1_DIR_56 (Sel[1], A[55], A[8], A6[55]);
	MUX_2x1 MUX_2x1_DIR_57 (Sel[1], A[56], A[7], A6[56]);
	MUX_2x1 MUX_2x1_DIR_58 (Sel[1], A[57], A[6], A6[57]);
	MUX_2x1 MUX_2x1_DIR_59 (Sel[1], A[58], A[5], A6[58]);
	MUX_2x1 MUX_2x1_DIR_60 (Sel[1], A[59], A[4], A6[59]);
	MUX_2x1 MUX_2x1_DIR_61 (Sel[1], A[60], A[3], A6[60]);
	MUX_2x1 MUX_2x1_DIR_62 (Sel[1], A[61], A[2], A6[61]);
	MUX_2x1 MUX_2x1_DIR_63 (Sel[1], A[62], A[1], A6[62]);
	MUX_2x1 MUX_2x1_DIR_64 (Sel[1], A[63], A[0], A6[63]);

// =======================================================================
// 2. BARREL SHIFTER STAGE 5 (32-bit shift, B[5]) : A6 -> A5 - 64 MUXes
// =======================================================================
// Bits 0-31 are shifted from A6[32-63]
	MUX_2x1 MUX_2x1_B5_1 (B[5], A6[0], A6[32], A5[0]);
	MUX_2x1 MUX_2x1_B5_2 (B[5], A6[1], A6[33], A5[1]);
	MUX_2x1 MUX_2x1_B5_3 (B[5], A6[2], A6[34], A5[2]);
	MUX_2x1 MUX_2x1_B5_4 (B[5], A6[3], A6[35], A5[3]);
	MUX_2x1 MUX_2x1_B5_5 (B[5], A6[4], A6[36], A5[4]);
	MUX_2x1 MUX_2x1_B5_6 (B[5], A6[5], A6[37], A5[5]);
	MUX_2x1 MUX_2x1_B5_7 (B[5], A6[6], A6[38], A5[6]);
	MUX_2x1 MUX_2x1_B5_8 (B[5], A6[7], A6[39], A5[7]);
	MUX_2x1 MUX_2x1_B5_9 (B[5], A6[8], A6[40], A5[8]);
	MUX_2x1 MUX_2x1_B5_10 (B[5], A6[9], A6[41], A5[9]);
	MUX_2x1 MUX_2x1_B5_11 (B[5], A6[10], A6[42], A5[10]);
	MUX_2x1 MUX_2x1_B5_12 (B[5], A6[11], A6[43], A5[11]);
	MUX_2x1 MUX_2x1_B5_13 (B[5], A6[12], A6[44], A5[12]);
	MUX_2x1 MUX_2x1_B5_14 (B[5], A6[13], A6[45], A5[13]);
	MUX_2x1 MUX_2x1_B5_15 (B[5], A6[14], A6[46], A5[14]);
	MUX_2x1 MUX_2x1_B5_16 (B[5], A6[15], A6[47], A5[15]);
	MUX_2x1 MUX_2x1_B5_17 (B[5], A6[16], A6[48], A5[16]);
	MUX_2x1 MUX_2x1_B5_18 (B[5], A6[17], A6[49], A5[17]);
	MUX_2x1 MUX_2x1_B5_19 (B[5], A6[18], A6[50], A5[18]);
	MUX_2x1 MUX_2x1_B5_20 (B[5], A6[19], A6[51], A5[19]);
	MUX_2x1 MUX_2x1_B5_21 (B[5], A6[20], A6[52], A5[20]);
	MUX_2x1 MUX_2x1_B5_22 (B[5], A6[21], A6[53], A5[21]);
	MUX_2x1 MUX_2x1_B5_23 (B[5], A6[22], A6[54], A5[22]);
	MUX_2x1 MUX_2x1_B5_24 (B[5], A6[23], A6[55], A5[23]);
	MUX_2x1 MUX_2x1_B5_25 (B[5], A6[24], A6[56], A5[24]);
	MUX_2x1 MUX_2x1_B5_26 (B[5], A6[25], A6[57], A5[25]);
	MUX_2x1 MUX_2x1_B5_27 (B[5], A6[26], A6[58], A5[26]);
	MUX_2x1 MUX_2x1_B5_28 (B[5], A6[27], A6[59], A5[27]);
	MUX_2x1 MUX_2x1_B5_29 (B[5], A6[28], A6[60], A5[28]);
	MUX_2x1 MUX_2x1_B5_30 (B[5], A6[29], A6[61], A5[29]);
	MUX_2x1 MUX_2x1_B5_31 (B[5], A6[30], A6[62], A5[30]);
	MUX_2x1 MUX_2x1_B5_32 (B[5], A6[31], A6[63], A5[31]);
// Bits 32-63 are filled with AoL if B[5]=1
	MUX_2x1 MUX_2x1_B5_33 (B[5], A6[32], AoL, A5[32]);
	MUX_2x1 MUX_2x1_B5_34 (B[5], A6[33], AoL, A5[33]);
	MUX_2x1 MUX_2x1_B5_35 (B[5], A6[34], AoL, A5[34]);
	MUX_2x1 MUX_2x1_B5_36 (B[5], A6[35], AoL, A5[35]);
	MUX_2x1 MUX_2x1_B5_37 (B[5], A6[36], AoL, A5[36]);
	MUX_2x1 MUX_2x1_B5_38 (B[5], A6[37], AoL, A5[37]);
	MUX_2x1 MUX_2x1_B5_39 (B[5], A6[38], AoL, A5[38]);
	MUX_2x1 MUX_2x1_B5_40 (B[5], A6[39], AoL, A5[39]);
	MUX_2x1 MUX_2x1_B5_41 (B[5], A6[40], AoL, A5[40]);
	MUX_2x1 MUX_2x1_B5_42 (B[5], A6[41], AoL, A5[41]);
	MUX_2x1 MUX_2x1_B5_43 (B[5], A6[42], AoL, A5[42]);
	MUX_2x1 MUX_2x1_B5_44 (B[5], A6[43], AoL, A5[43]);
	MUX_2x1 MUX_2x1_B5_45 (B[5], A6[44], AoL, A5[44]);
	MUX_2x1 MUX_2x1_B5_46 (B[5], A6[45], AoL, A5[45]);
	MUX_2x1 MUX_2x1_B5_47 (B[5], A6[46], AoL, A5[46]);
	MUX_2x1 MUX_2x1_B5_48 (B[5], A6[47], AoL, A5[47]);
	MUX_2x1 MUX_2x1_B5_49 (B[5], A6[48], AoL, A5[48]);
	MUX_2x1 MUX_2x1_B5_50 (B[5], A6[49], AoL, A5[49]);
	MUX_2x1 MUX_2x1_B5_51 (B[5], A6[50], AoL, A5[50]);
	MUX_2x1 MUX_2x1_B5_52 (B[5], A6[51], AoL, A5[51]);
	MUX_2x1 MUX_2x1_B5_53 (B[5], A6[52], AoL, A5[52]);
	MUX_2x1 MUX_2x1_B5_54 (B[5], A6[53], AoL, A5[53]);
	MUX_2x1 MUX_2x1_B5_55 (B[5], A6[54], AoL, A5[54]);
	MUX_2x1 MUX_2x1_B5_56 (B[5], A6[55], AoL, A5[55]);
	MUX_2x1 MUX_2x1_B5_57 (B[5], A6[56], AoL, A5[56]);
	MUX_2x1 MUX_2x1_B5_58 (B[5], A6[57], AoL, A5[57]);
	MUX_2x1 MUX_2x1_B5_59 (B[5], A6[58], AoL, A5[58]);
	MUX_2x1 MUX_2x1_B5_60 (B[5], A6[59], AoL, A5[59]);
	MUX_2x1 MUX_2x1_B5_61 (B[5], A6[60], AoL, A5[60]);
	MUX_2x1 MUX_2x1_B5_62 (B[5], A6[61], AoL, A5[61]);
	MUX_2x1 MUX_2x1_B5_63 (B[5], A6[62], AoL, A5[62]);
	MUX_2x1 MUX_2x1_B5_64 (B[5], A6[63], AoL, A5[63]);

// =======================================================================
// 3. BARREL SHIFTER STAGE 4 (16-bit shift, B[4]) : A5 -> A4 - 64 MUXes
// =======================================================================
// Bits 0-47 are shifted from A5[16-63]
	MUX_2x1 MUX_2x1_B4_1 (B[4], A5[0], A5[16], A4[0]);
	MUX_2x1 MUX_2x1_B4_2 (B[4], A5[1], A5[17], A4[1]);
	MUX_2x1 MUX_2x1_B4_3 (B[4], A5[2], A5[18], A4[2]);
	MUX_2x1 MUX_2x1_B4_4 (B[4], A5[3], A5[19], A4[3]);
	MUX_2x1 MUX_2x1_B4_5 (B[4], A5[4], A5[20], A4[4]);
	MUX_2x1 MUX_2x1_B4_6 (B[4], A5[5], A5[21], A4[5]);
	MUX_2x1 MUX_2x1_B4_7 (B[4], A5[6], A5[22], A4[6]);
	MUX_2x1 MUX_2x1_B4_8 (B[4], A5[7], A5[23], A4[7]);
	MUX_2x1 MUX_2x1_B4_9 (B[4], A5[8], A5[24], A4[8]);
	MUX_2x1 MUX_2x1_B4_10 (B[4], A5[9], A5[25], A4[9]);
	MUX_2x1 MUX_2x1_B4_11 (B[4], A5[10], A5[26], A4[10]);
	MUX_2x1 MUX_2x1_B4_12 (B[4], A5[11], A5[27], A4[11]);
	MUX_2x1 MUX_2x1_B4_13 (B[4], A5[12], A5[28], A4[12]);
	MUX_2x1 MUX_2x1_B4_14 (B[4], A5[13], A5[29], A4[13]);
	MUX_2x1 MUX_2x1_B4_15 (B[4], A5[14], A5[30], A4[14]);
	MUX_2x1 MUX_2x1_B4_16 (B[4], A5[15], A5[31], A4[15]);
	MUX_2x1 MUX_2x1_B4_17 (B[4], A5[16], A5[32], A4[16]);
	MUX_2x1 MUX_2x1_B4_18 (B[4], A5[17], A5[33], A4[17]);
	MUX_2x1 MUX_2x1_B4_19 (B[4], A5[18], A5[34], A4[18]);
	MUX_2x1 MUX_2x1_B4_20 (B[4], A5[19], A5[35], A4[19]);
	MUX_2x1 MUX_2x1_B4_21 (B[4], A5[20], A5[36], A4[20]);
	MUX_2x1 MUX_2x1_B4_22 (B[4], A5[21], A5[37], A4[21]);
	MUX_2x1 MUX_2x1_B4_23 (B[4], A5[22], A5[38], A4[22]);
	MUX_2x1 MUX_2x1_B4_24 (B[4], A5[23], A5[39], A4[23]);
	MUX_2x1 MUX_2x1_B4_25 (B[4], A5[24], A5[40], A4[24]);
	MUX_2x1 MUX_2x1_B4_26 (B[4], A5[25], A5[41], A4[25]);
	MUX_2x1 MUX_2x1_B4_27 (B[4], A5[26], A5[42], A4[26]);
	MUX_2x1 MUX_2x1_B4_28 (B[4], A5[27], A5[43], A4[27]);
	MUX_2x1 MUX_2x1_B4_29 (B[4], A5[28], A5[44], A4[28]);
	MUX_2x1 MUX_2x1_B4_30 (B[4], A5[29], A5[45], A4[29]);
	MUX_2x1 MUX_2x1_B4_31 (B[4], A5[30], A5[46], A4[30]);
	MUX_2x1 MUX_2x1_B4_32 (B[4], A5[31], A5[47], A4[31]);
	MUX_2x1 MUX_2x1_B4_33 (B[4], A5[32], A5[48], A4[32]);
	MUX_2x1 MUX_2x1_B4_34 (B[4], A5[33], A5[49], A4[33]);
	MUX_2x1 MUX_2x1_B4_35 (B[4], A5[34], A5[50], A4[34]);
	MUX_2x1 MUX_2x1_B4_36 (B[4], A5[35], A5[51], A4[35]);
	MUX_2x1 MUX_2x1_B4_37 (B[4], A5[36], A5[52], A4[36]);
	MUX_2x1 MUX_2x1_B4_38 (B[4], A5[37], A5[53], A4[37]);
	MUX_2x1 MUX_2x1_B4_39 (B[4], A5[38], A5[54], A4[38]);
	MUX_2x1 MUX_2x1_B4_40 (B[4], A5[39], A5[55], A4[39]);
	MUX_2x1 MUX_2x1_B4_41 (B[4], A5[40], A5[56], A4[40]);
	MUX_2x1 MUX_2x1_B4_42 (B[4], A5[41], A5[57], A4[41]);
	MUX_2x1 MUX_2x1_B4_43 (B[4], A5[42], A5[58], A4[42]);
	MUX_2x1 MUX_2x1_B4_44 (B[4], A5[43], A5[59], A4[43]);
	MUX_2x1 MUX_2x1_B4_45 (B[4], A5[44], A5[60], A4[44]);
	MUX_2x1 MUX_2x1_B4_46 (B[4], A5[45], A5[61], A4[45]);
	MUX_2x1 MUX_2x1_B4_47 (B[4], A5[46], A5[62], A4[46]);
	MUX_2x1 MUX_2x1_B4_48 (B[4], A5[47], A5[63], A4[47]);
// Bits 48-63 are filled with AoL if B[4]=1
	MUX_2x1 MUX_2x1_B4_49 (B[4], A5[48], AoL, A4[48]);
	MUX_2x1 MUX_2x1_B4_50 (B[4], A5[49], AoL, A4[49]);
	MUX_2x1 MUX_2x1_B4_51 (B[4], A5[50], AoL, A4[50]);
	MUX_2x1 MUX_2x1_B4_52 (B[4], A5[51], AoL, A4[51]);
	MUX_2x1 MUX_2x1_B4_53 (B[4], A5[52], AoL, A4[52]);
	MUX_2x1 MUX_2x1_B4_54 (B[4], A5[53], AoL, A4[53]);
	MUX_2x1 MUX_2x1_B4_55 (B[4], A5[54], AoL, A4[54]);
	MUX_2x1 MUX_2x1_B4_56 (B[4], A5[55], AoL, A4[55]);
	MUX_2x1 MUX_2x1_B4_57 (B[4], A5[56], AoL, A4[56]);
	MUX_2x1 MUX_2x1_B4_58 (B[4], A5[57], AoL, A4[57]);
	MUX_2x1 MUX_2x1_B4_59 (B[4], A5[58], AoL, A4[58]);
	MUX_2x1 MUX_2x1_B4_60 (B[4], A5[59], AoL, A4[59]);
	MUX_2x1 MUX_2x1_B4_61 (B[4], A5[60], AoL, A4[60]);
	MUX_2x1 MUX_2x1_B4_62 (B[4], A5[61], AoL, A4[61]);
	MUX_2x1 MUX_2x1_B4_63 (B[4], A5[62], AoL, A4[62]);
	MUX_2x1 MUX_2x1_B4_64 (B[4], A5[63], AoL, A4[63]);

// =======================================================================
// 4. BARREL SHIFTER STAGE 3 (8-bit shift, B[3]) : A4 -> A3 - 64 MUXes
// =======================================================================
// Bits 0-55 are shifted from A4[8-63]
	MUX_2x1 MUX_2x1_B3_1 (B[3], A4[0], A4[8], A3[0]);
	MUX_2x1 MUX_2x1_B3_2 (B[3], A4[1], A4[9], A3[1]);
	MUX_2x1 MUX_2x1_B3_3 (B[3], A4[2], A4[10], A3[2]);
	MUX_2x1 MUX_2x1_B3_4 (B[3], A4[3], A4[11], A3[3]);
	MUX_2x1 MUX_2x1_B3_5 (B[3], A4[4], A4[12], A3[4]);
	MUX_2x1 MUX_2x1_B3_6 (B[3], A4[5], A4[13], A3[5]);
	MUX_2x1 MUX_2x1_B3_7 (B[3], A4[6], A4[14], A3[6]);
	MUX_2x1 MUX_2x1_B3_8 (B[3], A4[7], A4[15], A3[7]);
	MUX_2x1 MUX_2x1_B3_9 (B[3], A4[8], A4[16], A3[8]);
	MUX_2x1 MUX_2x1_B3_10 (B[3], A4[9], A4[17], A3[9]);
	MUX_2x1 MUX_2x1_B3_11 (B[3], A4[10], A4[18], A3[10]);
	MUX_2x1 MUX_2x1_B3_12 (B[3], A4[11], A4[19], A3[11]);
	MUX_2x1 MUX_2x1_B3_13 (B[3], A4[12], A4[20], A3[12]);
	MUX_2x1 MUX_2x1_B3_14 (B[3], A4[13], A4[21], A3[13]);
	MUX_2x1 MUX_2x1_B3_15 (B[3], A4[14], A4[22], A3[14]);
	MUX_2x1 MUX_2x1_B3_16 (B[3], A4[15], A4[23], A3[15]);
	MUX_2x1 MUX_2x1_B3_17 (B[3], A4[16], A4[24], A3[16]);
	MUX_2x1 MUX_2x1_B3_18 (B[3], A4[17], A4[25], A3[17]);
	MUX_2x1 MUX_2x1_B3_19 (B[3], A4[18], A4[26], A3[18]);
	MUX_2x1 MUX_2x1_B3_20 (B[3], A4[19], A4[27], A3[19]);
	MUX_2x1 MUX_2x1_B3_21 (B[3], A4[20], A4[28], A3[20]);
	MUX_2x1 MUX_2x1_B3_22 (B[3], A4[21], A4[29], A3[21]);
	MUX_2x1 MUX_2x1_B3_23 (B[3], A4[22], A4[30], A3[22]);
	MUX_2x1 MUX_2x1_B3_24 (B[3], A4[23], A4[31], A3[23]);
	MUX_2x1 MUX_2x1_B3_25 (B[3], A4[24], A4[32], A3[24]);
	MUX_2x1 MUX_2x1_B3_26 (B[3], A4[25], A4[33], A3[25]);
	MUX_2x1 MUX_2x1_B3_27 (B[3], A4[26], A4[34], A3[26]);
	MUX_2x1 MUX_2x1_B3_28 (B[3], A4[27], A4[35], A3[27]);
	MUX_2x1 MUX_2x1_B3_29 (B[3], A4[28], A4[36], A3[28]);
	MUX_2x1 MUX_2x1_B3_30 (B[3], A4[29], A4[37], A3[29]);
	MUX_2x1 MUX_2x1_B3_31 (B[3], A4[30], A4[38], A3[30]);
	MUX_2x1 MUX_2x1_B3_32 (B[3], A4[31], A4[39], A3[31]);
	MUX_2x1 MUX_2x1_B3_33 (B[3], A4[32], A4[40], A3[32]);
	MUX_2x1 MUX_2x1_B3_34 (B[3], A4[33], A4[41], A3[33]);
	MUX_2x1 MUX_2x1_B3_35 (B[3], A4[34], A4[42], A3[34]);
	MUX_2x1 MUX_2x1_B3_36 (B[3], A4[35], A4[43], A3[35]);
	MUX_2x1 MUX_2x1_B3_37 (B[3], A4[36], A4[44], A3[36]);
	MUX_2x1 MUX_2x1_B3_38 (B[3], A4[37], A4[45], A3[37]);
	MUX_2x1 MUX_2x1_B3_39 (B[3], A4[38], A4[46], A3[38]);
	MUX_2x1 MUX_2x1_B3_40 (B[3], A4[39], A4[47], A3[39]);
	MUX_2x1 MUX_2x1_B3_41 (B[3], A4[40], A4[48], A3[40]);
	MUX_2x1 MUX_2x1_B3_42 (B[3], A4[41], A4[49], A3[41]);
	MUX_2x1 MUX_2x1_B3_43 (B[3], A4[42], A4[50], A3[42]);
	MUX_2x1 MUX_2x1_B3_44 (B[3], A4[43], A4[51], A3[43]);
	MUX_2x1 MUX_2x1_B3_45 (B[3], A4[44], A4[52], A3[44]);
	MUX_2x1 MUX_2x1_B3_46 (B[3], A4[45], A4[53], A3[45]);
	MUX_2x1 MUX_2x1_B3_47 (B[3], A4[46], A4[54], A3[46]);
	MUX_2x1 MUX_2x1_B3_48 (B[3], A4[47], A4[55], A3[47]);
	MUX_2x1 MUX_2x1_B3_49 (B[3], A4[48], A4[56], A3[48]);
	MUX_2x1 MUX_2x1_B3_50 (B[3], A4[49], A4[57], A3[49]);
	MUX_2x1 MUX_2x1_B3_51 (B[3], A4[50], A4[58], A3[50]);
	MUX_2x1 MUX_2x1_B3_52 (B[3], A4[51], A4[59], A3[51]);
	MUX_2x1 MUX_2x1_B3_53 (B[3], A4[52], A4[60], A3[52]);
	MUX_2x1 MUX_2x1_B3_54 (B[3], A4[53], A4[61], A3[53]);
	MUX_2x1 MUX_2x1_B3_55 (B[3], A4[54], A4[62], A3[54]);
	MUX_2x1 MUX_2x1_B3_56 (B[3], A4[55], A4[63], A3[55]);
// Bits 56-63 are filled with AoL if B[3]=1
	MUX_2x1 MUX_2x1_B3_57 (B[3], A4[56], AoL, A3[56]);
	MUX_2x1 MUX_2x1_B3_58 (B[3], A4[57], AoL, A3[57]);
	MUX_2x1 MUX_2x1_B3_59 (B[3], A4[58], AoL, A3[58]);
	MUX_2x1 MUX_2x1_B3_60 (B[3], A4[59], AoL, A3[59]);
	MUX_2x1 MUX_2x1_B3_61 (B[3], A4[60], AoL, A3[60]);
	MUX_2x1 MUX_2x1_B3_62 (B[3], A4[61], AoL, A3[61]);
	MUX_2x1 MUX_2x1_B3_63 (B[3], A4[62], AoL, A3[62]);
	MUX_2x1 MUX_2x1_B3_64 (B[3], A4[63], AoL, A3[63]);

// =======================================================================
// 5. BARREL SHIFTER STAGE 2 (4-bit shift, B[2]) : A3 -> A2 - 64 MUXes
// =======================================================================
// Bits 0-59 are shifted from A3[4-63]
	MUX_2x1 MUX_2x1_B2_1 (B[2], A3[0], A3[4], A2[0]);
	MUX_2x1 MUX_2x1_B2_2 (B[2], A3[1], A3[5], A2[1]);
	MUX_2x1 MUX_2x1_B2_3 (B[2], A3[2], A3[6], A2[2]);
	MUX_2x1 MUX_2x1_B2_4 (B[2], A3[3], A3[7], A2[3]);
	MUX_2x1 MUX_2x1_B2_5 (B[2], A3[4], A3[8], A2[4]);
	MUX_2x1 MUX_2x1_B2_6 (B[2], A3[5], A3[9], A2[5]);
	MUX_2x1 MUX_2x1_B2_7 (B[2], A3[6], A3[10], A2[6]);
	MUX_2x1 MUX_2x1_B2_8 (B[2], A3[7], A3[11], A2[7]);
	MUX_2x1 MUX_2x1_B2_9 (B[2], A3[8], A3[12], A2[8]);
	MUX_2x1 MUX_2x1_B2_10 (B[2], A3[9], A3[13], A2[9]);
	MUX_2x1 MUX_2x1_B2_11 (B[2], A3[10], A3[14], A2[10]);
	MUX_2x1 MUX_2x1_B2_12 (B[2], A3[11], A3[15], A2[11]);
	MUX_2x1 MUX_2x1_B2_13 (B[2], A3[12], A3[16], A2[12]);
	MUX_2x1 MUX_2x1_B2_14 (B[2], A3[13], A3[17], A2[13]);
	MUX_2x1 MUX_2x1_B2_15 (B[2], A3[14], A3[18], A2[14]);
	MUX_2x1 MUX_2x1_B2_16 (B[2], A3[15], A3[19], A2[15]);
	MUX_2x1 MUX_2x1_B2_17 (B[2], A3[16], A3[20], A2[16]);
	MUX_2x1 MUX_2x1_B2_18 (B[2], A3[17], A3[21], A2[17]);
	MUX_2x1 MUX_2x1_B2_19 (B[2], A3[18], A3[22], A2[18]);
	MUX_2x1 MUX_2x1_B2_20 (B[2], A3[19], A3[23], A2[19]);
	MUX_2x1 MUX_2x1_B2_21 (B[2], A3[20], A3[24], A2[20]);
	MUX_2x1 MUX_2x1_B2_22 (B[2], A3[21], A3[25], A2[21]);
	MUX_2x1 MUX_2x1_B2_23 (B[2], A3[22], A3[26], A2[22]);
	MUX_2x1 MUX_2x1_B2_24 (B[2], A3[23], A3[27], A2[23]);
	MUX_2x1 MUX_2x1_B2_25 (B[2], A3[24], A3[28], A2[24]);
	MUX_2x1 MUX_2x1_B2_26 (B[2], A3[25], A3[29], A2[25]);
	MUX_2x1 MUX_2x1_B2_27 (B[2], A3[26], A3[30], A2[26]);
	MUX_2x1 MUX_2x1_B2_28 (B[2], A3[27], A3[31], A2[27]);
	MUX_2x1 MUX_2x1_B2_29 (B[2], A3[28], A3[32], A2[28]);
	MUX_2x1 MUX_2x1_B2_30 (B[2], A3[29], A3[33], A2[29]);
	MUX_2x1 MUX_2x1_B2_31 (B[2], A3[30], A3[34], A2[30]);
	MUX_2x1 MUX_2x1_B2_32 (B[2], A3[31], A3[35], A2[31]);
	MUX_2x1 MUX_2x1_B2_33 (B[2], A3[32], A3[36], A2[32]);
	MUX_2x1 MUX_2x1_B2_34 (B[2], A3[33], A3[37], A2[33]);
	MUX_2x1 MUX_2x1_B2_35 (B[2], A3[34], A3[38], A2[34]);
	MUX_2x1 MUX_2x1_B2_36 (B[2], A3[35], A3[39], A2[35]);
	MUX_2x1 MUX_2x1_B2_37 (B[2], A3[36], A3[40], A2[36]);
	MUX_2x1 MUX_2x1_B2_38 (B[2], A3[37], A3[41], A2[37]);
	MUX_2x1 MUX_2x1_B2_39 (B[2], A3[38], A3[42], A2[38]);
	MUX_2x1 MUX_2x1_B2_40 (B[2], A3[39], A3[43], A2[39]);
	MUX_2x1 MUX_2x1_B2_41 (B[2], A3[40], A3[44], A2[40]);
	MUX_2x1 MUX_2x1_B2_42 (B[2], A3[41], A3[45], A2[41]);
	MUX_2x1 MUX_2x1_B2_43 (B[2], A3[42], A3[46], A2[42]);
	MUX_2x1 MUX_2x1_B2_44 (B[2], A3[43], A3[47], A2[43]);
	MUX_2x1 MUX_2x1_B2_45 (B[2], A3[44], A3[48], A2[44]);
	MUX_2x1 MUX_2x1_B2_46 (B[2], A3[45], A3[49], A2[45]);
	MUX_2x1 MUX_2x1_B2_47 (B[2], A3[46], A3[50], A2[46]);
	MUX_2x1 MUX_2x1_B2_48 (B[2], A3[47], A3[51], A2[47]);
	MUX_2x1 MUX_2x1_B2_49 (B[2], A3[48], A3[52], A2[48]);
	MUX_2x1 MUX_2x1_B2_50 (B[2], A3[49], A3[53], A2[49]);
	MUX_2x1 MUX_2x1_B2_51 (B[2], A3[50], A3[54], A2[50]);
	MUX_2x1 MUX_2x1_B2_52 (B[2], A3[51], A3[55], A2[51]);
	MUX_2x1 MUX_2x1_B2_53 (B[2], A3[52], A3[56], A2[52]);
	MUX_2x1 MUX_2x1_B2_54 (B[2], A3[53], A3[57], A2[53]);
	MUX_2x1 MUX_2x1_B2_55 (B[2], A3[54], A3[58], A2[54]);
	MUX_2x1 MUX_2x1_B2_56 (B[2], A3[55], A3[59], A2[55]);
	MUX_2x1 MUX_2x1_B2_57 (B[2], A3[56], A3[60], A2[56]);
	MUX_2x1 MUX_2x1_B2_58 (B[2], A3[57], A3[61], A2[57]);
	MUX_2x1 MUX_2x1_B2_59 (B[2], A3[58], A3[62], A2[58]);
	MUX_2x1 MUX_2x1_B2_60 (B[2], A3[59], A3[63], A2[59]);
// Bits 60-63 are filled with AoL if B[2]=1
	MUX_2x1 MUX_2x1_B2_61 (B[2], A3[60], AoL, A2[60]);
	MUX_2x1 MUX_2x1_B2_62 (B[2], A3[61], AoL, A2[61]);
	MUX_2x1 MUX_2x1_B2_63 (B[2], A3[62], AoL, A2[62]);
	MUX_2x1 MUX_2x1_B2_64 (B[2], A3[63], AoL, A2[63]);

// =======================================================================
// 6. BARREL SHIFTER STAGE 1 (2-bit shift, B[1]) : A2 -> A1 - 64 MUXes
// =======================================================================
// Bits 0-61 are shifted from A2[2-63]
	MUX_2x1 MUX_2x1_B1_1 (B[1], A2[0], A2[2], A1[0]);
	MUX_2x1 MUX_2x1_B1_2 (B[1], A2[1], A2[3], A1[1]);
	MUX_2x1 MUX_2x1_B1_3 (B[1], A2[2], A2[4], A1[2]);
	MUX_2x1 MUX_2x1_B1_4 (B[1], A2[3], A2[5], A1[3]);
	MUX_2x1 MUX_2x1_B1_5 (B[1], A2[4], A2[6], A1[4]);
	MUX_2x1 MUX_2x1_B1_6 (B[1], A2[5], A2[7], A1[5]);
	MUX_2x1 MUX_2x1_B1_7 (B[1], A2[6], A2[8], A1[6]);
	MUX_2x1 MUX_2x1_B1_8 (B[1], A2[7], A2[9], A1[7]);
	MUX_2x1 MUX_2x1_B1_9 (B[1], A2[8], A2[10], A1[8]);
	MUX_2x1 MUX_2x1_B1_10 (B[1], A2[9], A2[11], A1[9]);
	MUX_2x1 MUX_2x1_B1_11 (B[1], A2[10], A2[12], A1[10]);
	MUX_2x1 MUX_2x1_B1_12 (B[1], A2[11], A2[13], A1[11]);
	MUX_2x1 MUX_2x1_B1_13 (B[1], A2[12], A2[14], A1[12]);
	MUX_2x1 MUX_2x1_B1_14 (B[1], A2[13], A2[15], A1[13]);
	MUX_2x1 MUX_2x1_B1_15 (B[1], A2[14], A2[16], A1[14]);
	MUX_2x1 MUX_2x1_B1_16 (B[1], A2[15], A2[17], A1[15]);
	MUX_2x1 MUX_2x1_B1_17 (B[1], A2[16], A2[18], A1[16]);
	MUX_2x1 MUX_2x1_B1_18 (B[1], A2[17], A2[19], A1[17]);
	MUX_2x1 MUX_2x1_B1_19 (B[1], A2[18], A2[20], A1[18]);
	MUX_2x1 MUX_2x1_B1_20 (B[1], A2[19], A2[21], A1[19]);
	MUX_2x1 MUX_2x1_B1_21 (B[1], A2[20], A2[22], A1[20]);
	MUX_2x1 MUX_2x1_B1_22 (B[1], A2[21], A2[23], A1[21]);
	MUX_2x1 MUX_2x1_B1_23 (B[1], A2[22], A2[24], A1[22]);
	MUX_2x1 MUX_2x1_B1_24 (B[1], A2[23], A2[25], A1[23]);
	MUX_2x1 MUX_2x1_B1_25 (B[1], A2[24], A2[26], A1[24]);
	MUX_2x1 MUX_2x1_B1_26 (B[1], A2[25], A2[27], A1[25]);
	MUX_2x1 MUX_2x1_B1_27 (B[1], A2[26], A2[28], A1[26]);
	MUX_2x1 MUX_2x1_B1_28 (B[1], A2[27], A2[29], A1[27]);
	MUX_2x1 MUX_2x1_B1_29 (B[1], A2[28], A2[30], A1[28]);
	MUX_2x1 MUX_2x1_B1_30 (B[1], A2[29], A2[31], A1[29]);
	MUX_2x1 MUX_2x1_B1_31 (B[1], A2[30], A2[32], A1[30]);
	MUX_2x1 MUX_2x1_B1_32 (B[1], A2[31], A2[33], A1[31]);
	MUX_2x1 MUX_2x1_B1_33 (B[1], A2[32], A2[34], A1[32]);
	MUX_2x1 MUX_2x1_B1_34 (B[1], A2[33], A2[35], A1[33]);
	MUX_2x1 MUX_2x1_B1_35 (B[1], A2[34], A2[36], A1[34]);
	MUX_2x1 MUX_2x1_B1_36 (B[1], A2[35], A2[37], A1[35]);
	MUX_2x1 MUX_2x1_B1_37 (B[1], A2[36], A2[38], A1[36]);
	MUX_2x1 MUX_2x1_B1_38 (B[1], A2[37], A2[39], A1[37]);
	MUX_2x1 MUX_2x1_B1_39 (B[1], A2[38], A2[40], A1[38]);
	MUX_2x1 MUX_2x1_B1_40 (B[1], A2[39], A2[41], A1[39]);
	MUX_2x1 MUX_2x1_B1_41 (B[1], A2[40], A2[42], A1[40]);
	MUX_2x1 MUX_2x1_B1_42 (B[1], A2[41], A2[43], A1[41]);
	MUX_2x1 MUX_2x1_B1_43 (B[1], A2[42], A2[44], A1[42]);
	MUX_2x1 MUX_2x1_B1_44 (B[1], A2[43], A2[45], A1[43]);
	MUX_2x1 MUX_2x1_B1_45 (B[1], A2[44], A2[46], A1[44]);
	MUX_2x1 MUX_2x1_B1_46 (B[1], A2[45], A2[47], A1[45]);
	MUX_2x1 MUX_2x1_B1_47 (B[1], A2[46], A2[48], A1[46]);
	MUX_2x1 MUX_2x1_B1_48 (B[1], A2[47], A2[49], A1[47]);
	MUX_2x1 MUX_2x1_B1_49 (B[1], A2[48], A2[50], A1[48]);
	MUX_2x1 MUX_2x1_B1_50 (B[1], A2[49], A2[51], A1[49]);
	MUX_2x1 MUX_2x1_B1_51 (B[1], A2[50], A2[52], A1[50]);
	MUX_2x1 MUX_2x1_B1_52 (B[1], A2[51], A2[53], A1[51]);
	MUX_2x1 MUX_2x1_B1_53 (B[1], A2[52], A2[54], A1[52]);
	MUX_2x1 MUX_2x1_B1_54 (B[1], A2[53], A2[55], A1[53]);
	MUX_2x1 MUX_2x1_B1_55 (B[1], A2[54], A2[56], A1[54]);
	MUX_2x1 MUX_2x1_B1_56 (B[1], A2[55], A2[57], A1[55]);
	MUX_2x1 MUX_2x1_B1_57 (B[1], A2[56], A2[58], A1[56]);
	MUX_2x1 MUX_2x1_B1_58 (B[1], A2[57], A2[59], A1[57]);
	MUX_2x1 MUX_2x1_B1_59 (B[1], A2[58], A2[60], A1[58]);
	MUX_2x1 MUX_2x1_B1_60 (B[1], A2[59], A2[61], A1[59]);
	MUX_2x1 MUX_2x1_B1_61 (B[1], A2[60], A2[62], A1[60]);
	MUX_2x1 MUX_2x1_B1_62 (B[1], A2[61], A2[63], A1[61]);
// Bits 62-63 are filled with AoL if B[1]=1
	MUX_2x1 MUX_2x1_B1_63 (B[1], A2[62], AoL, A1[62]);
	MUX_2x1 MUX_2x1_B1_64 (B[1], A2[63], AoL, A1[63]);

// =======================================================================
// 7. BARREL SHIFTER STAGE 0 (1-bit shift, B[0]) : A1 -> A0 - 64 MUXes
// =======================================================================
// Bits 0-62 are shifted from A1[1-63]
	MUX_2x1 MUX_2x1_B0_1 (B[0], A1[0], A1[1], A0[0]);
	MUX_2x1 MUX_2x1_B0_2 (B[0], A1[1], A1[2], A0[1]);
	MUX_2x1 MUX_2x1_B0_3 (B[0], A1[2], A1[3], A0[2]);
	MUX_2x1 MUX_2x1_B0_4 (B[0], A1[3], A1[4], A0[3]);
	MUX_2x1 MUX_2x1_B0_5 (B[0], A1[4], A1[5], A0[4]);
	MUX_2x1 MUX_2x1_B0_6 (B[0], A1[5], A1[6], A0[5]);
	MUX_2x1 MUX_2x1_B0_7 (B[0], A1[6], A1[7], A0[6]);
	MUX_2x1 MUX_2x1_B0_8 (B[0], A1[7], A1[8], A0[7]);
	MUX_2x1 MUX_2x1_B0_9 (B[0], A1[8], A1[9], A0[8]);
	MUX_2x1 MUX_2x1_B0_10 (B[0], A1[9], A1[10], A0[9]);
	MUX_2x1 MUX_2x1_B0_11 (B[0], A1[10], A1[11], A0[10]);
	MUX_2x1 MUX_2x1_B0_12 (B[0], A1[11], A1[12], A0[11]);
	MUX_2x1 MUX_2x1_B0_13 (B[0], A1[12], A1[13], A0[12]);
	MUX_2x1 MUX_2x1_B0_14 (B[0], A1[13], A1[14], A0[13]);
	MUX_2x1 MUX_2x1_B0_15 (B[0], A1[14], A1[15], A0[14]);
	MUX_2x1 MUX_2x1_B0_16 (B[0], A1[15], A1[16], A0[15]);
	MUX_2x1 MUX_2x1_B0_17 (B[0], A1[16], A1[17], A0[16]);
	MUX_2x1 MUX_2x1_B0_18 (B[0], A1[17], A1[18], A0[17]);
	MUX_2x1 MUX_2x1_B0_19 (B[0], A1[18], A1[19], A0[18]);
	MUX_2x1 MUX_2x1_B0_20 (B[0], A1[19], A1[20], A0[19]);
	MUX_2x1 MUX_2x1_B0_21 (B[0], A1[20], A1[21], A0[20]);
	MUX_2x1 MUX_2x1_B0_22 (B[0], A1[21], A1[22], A0[21]);
	MUX_2x1 MUX_2x1_B0_23 (B[0], A1[22], A1[23], A0[22]);
	MUX_2x1 MUX_2x1_B0_24 (B[0], A1[23], A1[24], A0[23]);
	MUX_2x1 MUX_2x1_B0_25 (B[0], A1[24], A1[25], A0[24]);
	MUX_2x1 MUX_2x1_B0_26 (B[0], A1[25], A1[26], A0[25]);
	MUX_2x1 MUX_2x1_B0_27 (B[0], A1[26], A1[27], A0[26]);
	MUX_2x1 MUX_2x1_B0_28 (B[0], A1[27], A1[28], A0[27]);
	MUX_2x1 MUX_2x1_B0_29 (B[0], A1[28], A1[29], A0[28]);
	MUX_2x1 MUX_2x1_B0_30 (B[0], A1[29], A1[30], A0[29]);
	MUX_2x1 MUX_2x1_B0_31 (B[0], A1[30], A1[31], A0[30]);
	MUX_2x1 MUX_2x1_B0_32 (B[0], A1[31], A1[32], A0[31]);
	MUX_2x1 MUX_2x1_B0_33 (B[0], A1[32], A1[33], A0[32]);
	MUX_2x1 MUX_2x1_B0_34 (B[0], A1[33], A1[34], A0[33]);
	MUX_2x1 MUX_2x1_B0_35 (B[0], A1[34], A1[35], A0[34]);
	MUX_2x1 MUX_2x1_B0_36 (B[0], A1[35], A1[36], A0[35]);
	MUX_2x1 MUX_2x1_B0_37 (B[0], A1[36], A1[37], A0[36]);
	MUX_2x1 MUX_2x1_B0_38 (B[0], A1[37], A1[38], A0[37]);
	MUX_2x1 MUX_2x1_B0_39 (B[0], A1[38], A1[39], A0[38]);
	MUX_2x1 MUX_2x1_B0_40 (B[0], A1[39], A1[40], A0[39]);
	MUX_2x1 MUX_2x1_B0_41 (B[0], A1[40], A1[41], A0[40]);
	MUX_2x1 MUX_2x1_B0_42 (B[0], A1[41], A1[42], A0[41]);
	MUX_2x1 MUX_2x1_B0_43 (B[0], A1[42], A1[43], A0[42]);
	MUX_2x1 MUX_2x1_B0_44 (B[0], A1[43], A1[44], A0[43]);
	MUX_2x1 MUX_2x1_B0_45 (B[0], A1[44], A1[45], A0[44]);
	MUX_2x1 MUX_2x1_B0_46 (B[0], A1[45], A1[46], A0[45]);
	MUX_2x1 MUX_2x1_B0_47 (B[0], A1[46], A1[47], A0[46]);
	MUX_2x1 MUX_2x1_B0_48 (B[0], A1[47], A1[48], A0[47]);
	MUX_2x1 MUX_2x1_B0_49 (B[0], A1[48], A1[49], A0[48]);
	MUX_2x1 MUX_2x1_B0_50 (B[0], A1[49], A1[50], A0[49]);
	MUX_2x1 MUX_2x1_B0_51 (B[0], A1[50], A1[51], A0[50]);
	MUX_2x1 MUX_2x1_B0_52 (B[0], A1[51], A1[52], A0[51]);
	MUX_2x1 MUX_2x1_B0_53 (B[0], A1[52], A1[53], A0[52]);
	MUX_2x1 MUX_2x1_B0_54 (B[0], A1[53], A1[54], A0[53]);
	MUX_2x1 MUX_2x1_B0_55 (B[0], A1[54], A1[55], A0[54]);
	MUX_2x1 MUX_2x1_B0_56 (B[0], A1[55], A1[56], A0[55]);
	MUX_2x1 MUX_2x1_B0_57 (B[0], A1[56], A1[57], A0[56]);
	MUX_2x1 MUX_2x1_B0_58 (B[0], A1[57], A1[58], A0[57]);
	MUX_2x1 MUX_2x1_B0_59 (B[0], A1[58], A1[59], A0[58]);
	MUX_2x1 MUX_2x1_B0_60 (B[0], A1[59], A1[60], A0[59]);
	MUX_2x1 MUX_2x1_B0_61 (B[0], A1[60], A1[61], A0[60]);
	MUX_2x1 MUX_2x1_B0_62 (B[0], A1[61], A1[62], A0[61]);
	MUX_2x1 MUX_2x1_B0_63 (B[0], A1[62], A1[63], A0[62]);
// Bit 63 is filled with AoL if B[0]=1
	MUX_2x1 MUX_2x1_B0_64 (B[0], A1[63], AoL, A0[63]);


// =======================================================================
// 8. DATA REVERSAL (Output A0 to Y) - 64 MUXes
// Y = A0 (Right Shift/ASR: Sel[1]=0)
// Y = A0 reversed (Left Shift/ASL: Sel[1]=1)
// =======================================================================
	MUX_2x1 MUX_2x1_OUT_1 (Sel[1], A0[0], A0[63], Y[0]);
	MUX_2x1 MUX_2x1_OUT_2 (Sel[1], A0[1], A0[62], Y[1]);
	MUX_2x1 MUX_2x1_OUT_3 (Sel[1], A0[2], A0[61], Y[2]);
	MUX_2x1 MUX_2x1_OUT_4 (Sel[1], A0[3], A0[60], Y[3]);
	MUX_2x1 MUX_2x1_OUT_5 (Sel[1], A0[4], A0[59], Y[4]);
	MUX_2x1 MUX_2x1_OUT_6 (Sel[1], A0[5], A0[58], Y[5]);
	MUX_2x1 MUX_2x1_OUT_7 (Sel[1], A0[6], A0[57], Y[6]);
	MUX_2x1 MUX_2x1_OUT_8 (Sel[1], A0[7], A0[56], Y[7]);
	MUX_2x1 MUX_2x1_OUT_9 (Sel[1], A0[8], A0[55], Y[8]);
	MUX_2x1 MUX_2x1_OUT_10 (Sel[1], A0[9], A0[54], Y[9]);
	MUX_2x1 MUX_2x1_OUT_11 (Sel[1], A0[10], A0[53], Y[10]);
	MUX_2x1 MUX_2x1_OUT_12 (Sel[1], A0[11], A0[52], Y[11]);
	MUX_2x1 MUX_2x1_OUT_13 (Sel[1], A0[12], A0[51], Y[12]);
	MUX_2x1 MUX_2x1_OUT_14 (Sel[1], A0[13], A0[50], Y[13]);
	MUX_2x1 MUX_2x1_OUT_15 (Sel[1], A0[14], A0[49], Y[14]);
	MUX_2x1 MUX_2x1_OUT_16 (Sel[1], A0[15], A0[48], Y[15]);
	MUX_2x1 MUX_2x1_OUT_17 (Sel[1], A0[16], A0[47], Y[16]);
	MUX_2x1 MUX_2x1_OUT_18 (Sel[1], A0[17], A0[46], Y[17]);
	MUX_2x1 MUX_2x1_OUT_19 (Sel[1], A0[18], A0[45], Y[18]);
	MUX_2x1 MUX_2x1_OUT_20 (Sel[1], A0[19], A0[44], Y[19]);
	MUX_2x1 MUX_2x1_OUT_21 (Sel[1], A0[20], A0[43], Y[20]);
	MUX_2x1 MUX_2x1_OUT_22 (Sel[1], A0[21], A0[42], Y[21]);
	MUX_2x1 MUX_2x1_OUT_23 (Sel[1], A0[22], A0[41], Y[22]);
	MUX_2x1 MUX_2x1_OUT_24 (Sel[1], A0[23], A0[40], Y[23]);
	MUX_2x1 MUX_2x1_OUT_25 (Sel[1], A0[24], A0[39], Y[24]);
	MUX_2x1 MUX_2x1_OUT_26 (Sel[1], A0[25], A0[38], Y[25]);
	MUX_2x1 MUX_2x1_OUT_27 (Sel[1], A0[26], A0[37], Y[26]);
	MUX_2x1 MUX_2x1_OUT_28 (Sel[1], A0[27], A0[36], Y[27]);
	MUX_2x1 MUX_2x1_OUT_29 (Sel[1], A0[28], A0[35], Y[28]);
	MUX_2x1 MUX_2x1_OUT_30 (Sel[1], A0[29], A0[34], Y[29]);
	MUX_2x1 MUX_2x1_OUT_31 (Sel[1], A0[30], A0[33], Y[30]);
	MUX_2x1 MUX_2x1_OUT_32 (Sel[1], A0[31], A0[32], Y[31]);
	MUX_2x1 MUX_2x1_OUT_33 (Sel[1], A0[32], A0[31], Y[32]);
	MUX_2x1 MUX_2x1_OUT_34 (Sel[1], A0[33], A0[30], Y[33]);
	MUX_2x1 MUX_2x1_OUT_35 (Sel[1], A0[34], A0[29], Y[34]);
	MUX_2x1 MUX_2x1_OUT_36 (Sel[1], A0[35], A0[28], Y[35]);
	MUX_2x1 MUX_2x1_OUT_37 (Sel[1], A0[36], A0[27], Y[36]);
	MUX_2x1 MUX_2x1_OUT_38 (Sel[1], A0[37], A0[26], Y[37]);
	MUX_2x1 MUX_2x1_OUT_39 (Sel[1], A0[38], A0[25], Y[38]);
	MUX_2x1 MUX_2x1_OUT_40 (Sel[1], A0[39], A0[24], Y[39]);
	MUX_2x1 MUX_2x1_OUT_41 (Sel[1], A0[40], A0[23], Y[40]);
	MUX_2x1 MUX_2x1_OUT_42 (Sel[1], A0[41], A0[22], Y[41]);
	MUX_2x1 MUX_2x1_OUT_43 (Sel[1], A0[42], A0[21], Y[42]);
	MUX_2x1 MUX_2x1_OUT_44 (Sel[1], A0[43], A0[20], Y[43]);
	MUX_2x1 MUX_2x1_OUT_45 (Sel[1], A0[44], A0[19], Y[44]);
	MUX_2x1 MUX_2x1_OUT_46 (Sel[1], A0[45], A0[18], Y[45]);
	MUX_2x1 MUX_2x1_OUT_47 (Sel[1], A0[46], A0[17], Y[46]);
	MUX_2x1 MUX_2x1_OUT_48 (Sel[1], A0[47], A0[16], Y[47]);
	MUX_2x1 MUX_2x1_OUT_49 (Sel[1], A0[48], A0[15], Y[48]);
	MUX_2x1 MUX_2x1_OUT_50 (Sel[1], A0[49], A0[14], Y[49]);
	MUX_2x1 MUX_2x1_OUT_51 (Sel[1], A0[50], A0[13], Y[50]);
	MUX_2x1 MUX_2x1_OUT_52 (Sel[1], A0[51], A0[12], Y[51]);
	MUX_2x1 MUX_2x1_OUT_53 (Sel[1], A0[52], A0[11], Y[52]);
	MUX_2x1 MUX_2x1_OUT_54 (Sel[1], A0[53], A0[10], Y[53]);
	MUX_2x1 MUX_2x1_OUT_55 (Sel[1], A0[54], A0[9], Y[54]);
	MUX_2x1 MUX_2x1_OUT_56 (Sel[1], A0[55], A0[8], Y[55]);
	MUX_2x1 MUX_2x1_OUT_57 (Sel[1], A0[56], A0[7], Y[56]);
	MUX_2x1 MUX_2x1_OUT_58 (Sel[1], A0[57], A0[6], Y[57]);
	MUX_2x1 MUX_2x1_OUT_59 (Sel[1], A0[58], A0[5], Y[58]);
	MUX_2x1 MUX_2x1_OUT_60 (Sel[1], A0[59], A0[4], Y[59]);
	MUX_2x1 MUX_2x1_OUT_61 (Sel[1], A0[60], A0[3], Y[60]);
	MUX_2x1 MUX_2x1_OUT_62 (Sel[1], A0[61], A0[2], Y[61]);
	MUX_2x1 MUX_2x1_OUT_63 (Sel[1], A0[62], A0[1], Y[62]);
	MUX_2x1 MUX_2x1_OUT_64 (Sel[1], A0[63], A0[0], Y[63]);

endmodule
