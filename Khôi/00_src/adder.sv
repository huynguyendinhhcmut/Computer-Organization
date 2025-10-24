/*
==================================================================================================
		 _  __                        ____  _                        _       _     _           
		| |/ /___   __ _  __ _  ___  / ___|| |_ ___  _ __   ___     / \   __| | __| | ___ _ __ 
		| ' // _ \ / _` |/ _` |/ _ \ \___ \| __/ _ \| '_ \ / _ \   / _ \ / _` |/ _` |/ _ \ '__|
		| . \ (_) | (_| | (_| |  __/  ___) | || (_) | | | |  __/  / ___ \ (_| | (_| |  __/ |   
		|_|\_\___/ \__, |\__, |\___| |____/ \__\___/|_| |_|\___| /_/   \_\__,_|\__,_|\___|_|   
					  |___/ |___/                                                                 
==================================================================================================
*/
//-------------------------------- adder_4bits ---------------------------

module adder_4bits (
    input  [3:0] A, B,
    output [3:0] Sum,
    output       Cout
);

    logic [4:1] G, P;   // Generate & Propagate
    logic [4:1] C;      // Carry

    // Pre-processing
    assign G = A & B;
    assign P = A ^ B;

    // Cin = 0
    assign C[1] = G[1];

    // Level 1
    logic G1_2, P1_2;
    BLACK_CELL BC1_2 (P[1], G[1], P[2], G[2], P1_2, G1_2);
    GRAY_CELL  GC2   (C[1], P1_2, G1_2, C[2]);

    // Level 2
    logic G2_3, P2_3;
    BLACK_CELL BC2_3 (P1_2, G1_2, P[3], G[3], P2_3, G2_3);
    GRAY_CELL  GC3   (C[1], P2_3, G2_3, C[3]);

    logic G3_4, P3_4;
    BLACK_CELL BC2_4 (P2_3, G2_3, P[4], G[4], P3_4, G3_4);
    GRAY_CELL  GC4   (C[1], P3_4, G3_4, C[4]);

    // Post-processing: sum and carry out
    assign Sum[0] = P[1];           // Cin = 0, so Sum[0] = A[0] ^ B[0]
    assign Sum[1] = C[1] ^ P[2];
    assign Sum[2] = C[2] ^ P[3];
    assign Sum[3] = C[3] ^ P[4];
    assign Cout   = C[4];

endmodule

//-------------------------------- adder_8bits ---------------------------

module adder_8bits
(
    input  logic [7:0]  operand_a,
    input  logic [7:0]  operand_b,
    input  logic        cin,

    output logic [7:0]  sum,
    output logic        cout
);

    // Note: keep 1-based indexing like your 32-bit code
    logic [8:1] G, P;     // bit-Generate/Propagate for bits [1]=LSB ... [8]=MSB
    logic [8:1] C;        // carries into bits 1..8

    // Pre-process
    assign G = operand_a & operand_b;
    assign P = operand_a ^ operand_b;

    // Intermediate prefix levels
    logic [8:3]  G1, P1;  // distance-1 combine
    logic [8:5]  G2, P2;  // distance-2 combine

    // ----------------
    // Level 1 (distance 1)
    // ----------------
    assign C[1] = G[1] | (P[1] & cin);
    GRAY_CELL  u_gc_02 (C[1], P[2], G[2], C[2]);

    // black cells: combine (i-1) with i  → G1[i], P1[i] for i=3..8
    BLACK_CELL u_bc_1_03 (P[2], G[2], P[3], G[3], P1[3], G1[3]);
    BLACK_CELL u_bc_1_04 (P[3], G[3], P[4], G[4], P1[4], G1[4]);
    BLACK_CELL u_bc_1_05 (P[4], G[4], P[5], G[5], P1[5], G1[5]);
    BLACK_CELL u_bc_1_06 (P[5], G[5], P[6], G[6], P1[6], G1[6]);
    BLACK_CELL u_bc_1_07 (P[6], G[6], P[7], G[7], P1[7], G1[7]);
    BLACK_CELL u_bc_1_08 (P[7], G[7], P[8], G[8], P1[8], G1[8]);

    // ----------------
    // Level 2 (distance 2)
    // ----------------
    GRAY_CELL  u_gc_03 (C[1], P1[3], G1[3], C[3]);
    GRAY_CELL  u_gc_04 (C[2], P1[4], G1[4], C[4]);

    // combine (i-2) with i → G2[i], P2[i] for i=5..8
    BLACK_CELL u_bc_2_05 (P1[3], G1[3], P1[5], G1[5], P2[5], G2[5]);
    BLACK_CELL u_bc_2_06 (P1[4], G1[4], P1[6], G1[6], P2[6], G2[6]);
    BLACK_CELL u_bc_2_07 (P1[5], G1[5], P1[7], G1[7], P2[7], G2[7]);
    BLACK_CELL u_bc_2_08 (P1[6], G1[6], P1[8], G1[8], P2[8], G2[8]);

    // ----------------
    // Level 3 (distance 4)
    // ----------------
    GRAY_CELL  u_gc_05 (C[1], P2[5], G2[5], C[5]);
    GRAY_CELL  u_gc_06 (C[2], P2[6], G2[6], C[6]);
    GRAY_CELL  u_gc_07 (C[3], P2[7], G2[7], C[7]);
    GRAY_CELL  u_gc_08 (C[4], P2[8], G2[8], C[8]);

    // Post-process: sum/cout
    assign sum[0]   = cin ^ P[1];
    assign sum[7:1] = C[7:1] ^ P[8:2];
    assign cout     = C[8];

endmodule

//-------------------------------- adder_16bits ---------------------------

module adder_16bits
(
    input  logic [15:0] operand_a,
    input  logic [15:0] operand_b,
    input  logic        cin,

    output logic [15:0] sum,
    output logic        cout
);
    // Pre-processing: bitwise Generate/Propagate
    logic [16:1] G, P;    // 1-based to mirror your 32-bit adder
    logic [16:1] C;

    assign G = operand_a & operand_b;
    assign P = operand_a ^ operand_b;

    // -------- Prefix network (4 levels for 16 bits) --------
    // Level 1 spans 1
    logic [16:3] G1, P1;
    // Level 2 spans 2
    logic [16:5] G2, P2;
    // Level 3 spans 4
    logic [16:9] G3, P3;

    // -------- Level 1 --------
    assign C[1] = G[1] | (P[1] & cin);               // gray for bit1 (carry into bit1)

    GRAY_CELL  GRAY_CELL_02 (C[1], P[2], G[2], C[2]);

    // black cells combining (i-1, i) → (P1[i], G1[i]) for i=3..16
    BLACK_CELL BLACK_CELL_1_03 (P[2],  G[2],  P[3],  G[3],  P1[3],  G1[3]);
    BLACK_CELL BLACK_CELL_1_04 (P[3],  G[3],  P[4],  G[4],  P1[4],  G1[4]);
    BLACK_CELL BLACK_CELL_1_05 (P[4],  G[4],  P[5],  G[5],  P1[5],  G1[5]);
    BLACK_CELL BLACK_CELL_1_06 (P[5],  G[5],  P[6],  G[6],  P1[6],  G1[6]);
    BLACK_CELL BLACK_CELL_1_07 (P[6],  G[6],  P[7],  G[7],  P1[7],  G1[7]);
    BLACK_CELL BLACK_CELL_1_08 (P[7],  G[7],  P[8],  G[8],  P1[8],  G1[8]);
    BLACK_CELL BLACK_CELL_1_09 (P[8],  G[8],  P[9],  G[9],  P1[9],  G1[9]);
    BLACK_CELL BLACK_CELL_1_10 (P[9],  G[9],  P[10], G[10], P1[10], G1[10]);
    BLACK_CELL BLACK_CELL_1_11 (P[10], G[10], P[11], G[11], P1[11], G1[11]);
    BLACK_CELL BLACK_CELL_1_12 (P[11], G[11], P[12], G[12], P1[12], G1[12]);
    BLACK_CELL BLACK_CELL_1_13 (P[12], G[12], P[13], G[13], P1[13], G1[13]);
    BLACK_CELL BLACK_CELL_1_14 (P[13], G[13], P[14], G[14], P1[14], G1[14]);
    BLACK_CELL BLACK_CELL_1_15 (P[14], G[14], P[15], G[15], P1[15], G1[15]);
    BLACK_CELL BLACK_CELL_1_16 (P[15], G[15], P[16], G[16], P1[16], G1[16]);

    // -------- Level 2 (span=2) --------
    // gray for C[3], C[4]
    GRAY_CELL GRAY_CELL_03 (C[1], P1[3], G1[3], C[3]);
    GRAY_CELL GRAY_CELL_04 (C[2], P1[4], G1[4], C[4]);

    // black combine (i-2, i) → (P2[i], G2[i]) for i=5..16
    BLACK_CELL BLACK_CELL_2_05 (P1[3],  G1[3],  P1[5],  G1[5],  P2[5],  G2[5]);
    BLACK_CELL BLACK_CELL_2_06 (P1[4],  G1[4],  P1[6],  G1[6],  P2[6],  G2[6]);
    BLACK_CELL BLACK_CELL_2_07 (P1[5],  G1[5],  P1[7],  G1[7],  P2[7],  G2[7]);
    BLACK_CELL BLACK_CELL_2_08 (P1[6],  G1[6],  P1[8],  G1[8],  P2[8],  G2[8]);
    BLACK_CELL BLACK_CELL_2_09 (P1[7],  G1[7],  P1[9],  G1[9],  P2[9],  G2[9]);
    BLACK_CELL BLACK_CELL_2_10 (P1[8],  G1[8],  P1[10], G1[10], P2[10], G2[10]);
    BLACK_CELL BLACK_CELL_2_11 (P1[9],  G1[9],  P1[11], G1[11], P2[11], G2[11]);
    BLACK_CELL BLACK_CELL_2_12 (P1[10], G1[10], P1[12], G1[12], P2[12], G2[12]);
    BLACK_CELL BLACK_CELL_2_13 (P1[11], G1[11], P1[13], G1[13], P2[13], G2[13]);
    BLACK_CELL BLACK_CELL_2_14 (P1[12], G1[12], P1[14], G1[14], P2[14], G2[14]);
    BLACK_CELL BLACK_CELL_2_15 (P1[13], G1[13], P1[15], G1[15], P2[15], G2[15]);
    BLACK_CELL BLACK_CELL_2_16 (P1[14], G1[14], P1[16], G1[16], P2[16], G2[16]);

    // -------- Level 3 (span=4) --------
    // gray for C[5]..C[8]
    GRAY_CELL GRAY_CELL_05 (C[1], P2[5], G2[5], C[5]);
    GRAY_CELL GRAY_CELL_06 (C[2], P2[6], G2[6], C[6]);
    GRAY_CELL GRAY_CELL_07 (C[3], P2[7], G2[7], C[7]);
    GRAY_CELL GRAY_CELL_08 (C[4], P2[8], G2[8], C[8]);

    // black combine (i-4, i) → (P3[i], G3[i]) for i=9..16
    BLACK_CELL BLACK_CELL_3_09 (P2[5],  G2[5],  P2[9],  G2[9],  P3[9],  G3[9]);
    BLACK_CELL BLACK_CELL_3_10 (P2[6],  G2[6],  P2[10], G2[10], P3[10], G3[10]);
    BLACK_CELL BLACK_CELL_3_11 (P2[7],  G2[7],  P2[11], G2[11], P3[11], G3[11]);
    BLACK_CELL BLACK_CELL_3_12 (P2[8],  G2[8],  P2[12], G2[12], P3[12], G3[12]);
    BLACK_CELL BLACK_CELL_3_13 (P2[9],  G2[9],  P2[13], G2[13], P3[13], G3[13]);
    BLACK_CELL BLACK_CELL_3_14 (P2[10], G2[10], P2[14], G2[14], P3[14], G3[14]);
    BLACK_CELL BLACK_CELL_3_15 (P2[11], G2[11], P2[15], G2[15], P3[15], G3[15]);
    BLACK_CELL BLACK_CELL_3_16 (P2[12], G2[12], P2[16], G2[16], P3[16], G3[16]);

    // -------- Level 4 (span=8) --------
    // gray for C[9]..C[16]
    GRAY_CELL GRAY_CELL_09 (C[1], P3[9],  G3[9],  C[9]);
    GRAY_CELL GRAY_CELL_10 (C[2], P3[10], G3[10], C[10]);
    GRAY_CELL GRAY_CELL_11 (C[3], P3[11], G3[11], C[11]);
    GRAY_CELL GRAY_CELL_12 (C[4], P3[12], G3[12], C[12]);
    GRAY_CELL GRAY_CELL_13 (C[5], P3[13], G3[13], C[13]);
    GRAY_CELL GRAY_CELL_14 (C[6], P3[14], G3[14], C[14]);
    GRAY_CELL GRAY_CELL_15 (C[7], P3[15], G3[15], C[15]);
    GRAY_CELL GRAY_CELL_16 (C[8], P3[16], G3[16], C[16]);

    // -------- Post-processing: Sum/Cout --------
    assign sum[0]     = cin ^ P[1];
    assign sum[15:1]  = C[15:1] ^ P[16:2];
    assign cout       = C[16];

endmodule

//-------------------------------- adder_32bits ---------------------------

module adder_32bits 			
(
    input [31:0] operand_a, 
	 input [31:0] operand_b,
    input cin,
	 
    output [31:0] sum,
    output cout
);
    logic [32:1] G,P; 
	 logic [32:1] C;
    
    // Pre-processing stage: Generate & Propagate
    assign G = operand_a & operand_b;    // Generate
    assign P = operand_a ^ operand_b;    // Propagate
    
    // Prefix Computation Stage: (Using Gray & Black Cells)
	 
	 logic [32:3] G1, P1;		// Level 1 - Level 2
	 logic [32:5] G2, P2;		// Level 2 - Level 3
	 logic [32:9] G3, P3;		// Level 3 - Level 4
	 logic [32:17] G4, P4;		// Level 4 - Level 5
	 
	 
	 // Level 1
	 assign C[1] = G[1] | (P[1] & cin);
	 
	 GRAY_CELL 	GRAY_CELL_02	(C[1], P[2], G[2], C[2]);
	 
	 //								 |P_pre-1|G_pre-1|P_cur| G_cur| P_n  |  G_n
    BLACK_CELL BLACK_CELL_1_03  ( P[2],  G[2],  P[3],  G[3],  P1[3],  G1[3]);
    BLACK_CELL BLACK_CELL_1_04  ( P[3],  G[3],  P[4],  G[4],  P1[4],  G1[4]);
	 
    BLACK_CELL BLACK_CELL_1_05  ( P[4],  G[4],  P[5],  G[5],  P1[5],  G1[5]);
    BLACK_CELL BLACK_CELL_1_06  ( P[5],  G[5],  P[6],  G[6],  P1[6],  G1[6]);
    BLACK_CELL BLACK_CELL_1_07  ( P[6],  G[6],  P[7],  G[7],  P1[7],  G1[7]);
    BLACK_CELL BLACK_CELL_1_08  ( P[7],  G[7],  P[8],  G[8],  P1[8],  G1[8]);
	 
    BLACK_CELL BLACK_CELL_1_09  ( P[8],  G[8],  P[9],  G[9],  P1[9],  G1[9]);
    BLACK_CELL BLACK_CELL_1_10  ( P[9],  G[9],  P[10], G[10], P1[10], G1[10]);
    BLACK_CELL BLACK_CELL_1_11  ( P[10], G[10], P[11], G[11], P1[11], G1[11]);
    BLACK_CELL BLACK_CELL_1_12  ( P[11], G[11], P[12], G[12], P1[12], G1[12]);
	 
    BLACK_CELL BLACK_CELL_1_13  ( P[12], G[12], P[13], G[13], P1[13], G1[13]);
    BLACK_CELL BLACK_CELL_1_14  ( P[13], G[13], P[14], G[14], P1[14], G1[14]);
    BLACK_CELL BLACK_CELL_1_15  ( P[14], G[14], P[15], G[15], P1[15], G1[15]);
    BLACK_CELL BLACK_CELL_1_16  ( P[15], G[15], P[16], G[16], P1[16], G1[16]);
	 
    BLACK_CELL BLACK_CELL_1_17  ( P[16], G[16], P[17], G[17], P1[17], G1[17]);
    BLACK_CELL BLACK_CELL_1_18  ( P[17], G[17], P[18], G[18], P1[18], G1[18]);
    BLACK_CELL BLACK_CELL_1_19  ( P[18], G[18], P[19], G[19], P1[19], G1[19]);
    BLACK_CELL BLACK_CELL_1_20  ( P[19], G[19], P[20], G[20], P1[20], G1[20]);
	 
    BLACK_CELL BLACK_CELL_1_21  ( P[20], G[20], P[21], G[21], P1[21], G1[21]);
    BLACK_CELL BLACK_CELL_1_22  ( P[21], G[21], P[22], G[22], P1[22], G1[22]);
    BLACK_CELL BLACK_CELL_1_23  ( P[22], G[22], P[23], G[23], P1[23], G1[23]);
    BLACK_CELL BLACK_CELL_1_24  ( P[23], G[23], P[24], G[24], P1[24], G1[24]);
	 
    BLACK_CELL BLACK_CELL_1_25  ( P[24], G[24], P[25], G[25], P1[25], G1[25]);
    BLACK_CELL BLACK_CELL_1_26  ( P[25], G[25], P[26], G[26], P1[26], G1[26]);
    BLACK_CELL BLACK_CELL_1_27  ( P[26], G[26], P[27], G[27], P1[27], G1[27]);
    BLACK_CELL BLACK_CELL_1_28  ( P[27], G[27], P[28], G[28], P1[28], G1[28]);
	 
    BLACK_CELL BLACK_CELL_1_29  ( P[28], G[28], P[29], G[29], P1[29], G1[29]);
    BLACK_CELL BLACK_CELL_1_30  ( P[29], G[29], P[30], G[30], P1[30], G1[30]);
    BLACK_CELL BLACK_CELL_1_31  ( P[30], G[30], P[31], G[31], P1[31], G1[31]);
	 BLACK_CELL BLACK_CELL_1_32  ( P[31], G[31], P[32], G[32], P1[32], G1[32]);


	 
	 // Level 2
	 GRAY_CELL 	GRAY_CELL_03	(C[1], P1[3], G1[3], C[3]);
	 GRAY_CELL 	GRAY_CELL_04	(C[2], P1[4], G1[4], C[4]);
	 
	 //								  |P_pre-2| G_pre-2|P_cur | G_cur | P_n  |  G_n 
    BLACK_CELL BLACK_CELL_2_05  ( P1[3],  G1[3],  P1[5],  G1[5],  P2[5],  G2[5]);
    BLACK_CELL BLACK_CELL_2_06  ( P1[4],  G1[4],  P1[6],  G1[6],  P2[6],  G2[6]);
    BLACK_CELL BLACK_CELL_2_07  ( P1[5],  G1[5],  P1[7],  G1[7],  P2[7],  G2[7]);
    BLACK_CELL BLACK_CELL_2_08  ( P1[6],  G1[6],  P1[8],  G1[8],  P2[8],  G2[8]);
	 
    BLACK_CELL BLACK_CELL_2_09  ( P1[7], G1[7], P1[9],  G1[9],  P2[9],  G2[9]);
    BLACK_CELL BLACK_CELL_2_10  ( P1[8], G1[8], P1[10], G1[10], P2[10], G2[10]);
    BLACK_CELL BLACK_CELL_2_11  ( P1[9], G1[9], P1[11], G1[11], P2[11], G2[11]);
    BLACK_CELL BLACK_CELL_2_12  ( P1[10], G1[10], P1[12], G1[12], P2[12], G2[12]);
	 
    BLACK_CELL BLACK_CELL_2_13  ( P1[11], G1[11], P1[13], G1[13], P2[13], G2[13]);
    BLACK_CELL BLACK_CELL_2_14  ( P1[12], G1[12], P1[14], G1[14], P2[14], G2[14]);
    BLACK_CELL BLACK_CELL_2_15  ( P1[13], G1[13], P1[15], G1[15], P2[15], G2[15]);
    BLACK_CELL BLACK_CELL_2_16  ( P1[14], G1[14], P1[16], G1[16], P2[16], G2[16]);

    BLACK_CELL BLACK_CELL_2_17  ( P1[15], G1[15], P1[17], G1[17], P2[17], G2[17]);
    BLACK_CELL BLACK_CELL_2_18  ( P1[16], G1[16], P1[18], G1[18], P2[18], G2[18]);
    BLACK_CELL BLACK_CELL_2_19  ( P1[17], G1[17], P1[19], G1[19], P2[19], G2[19]);
    BLACK_CELL BLACK_CELL_2_20  ( P1[18], G1[18], P1[20], G1[20], P2[20], G2[20]);
	 
    BLACK_CELL BLACK_CELL_2_21  ( P1[19], G1[19], P1[21], G1[21], P2[21], G2[21]);
    BLACK_CELL BLACK_CELL_2_22  ( P1[20], G1[20], P1[22], G1[22], P2[22], G2[22]);
    BLACK_CELL BLACK_CELL_2_23  ( P1[21], G1[21], P1[23], G1[23], P2[23], G2[23]);
    BLACK_CELL BLACK_CELL_2_24  ( P1[22], G1[22], P1[24], G1[24], P2[24], G2[24]);
	
    BLACK_CELL BLACK_CELL_2_25  ( P1[23], G1[23], P1[25], G1[25], P2[25], G2[25]);
    BLACK_CELL BLACK_CELL_2_26  ( P1[24], G1[24], P1[26], G1[26], P2[26], G2[26]);
    BLACK_CELL BLACK_CELL_2_27  ( P1[25], G1[25], P1[27], G1[27], P2[27], G2[27]);
    BLACK_CELL BLACK_CELL_2_28  ( P1[26], G1[26], P1[28], G1[28], P2[28], G2[28]);

    BLACK_CELL BLACK_CELL_2_29  ( P1[27], G1[27], P1[29], G1[29], P2[29], G2[29]);
    BLACK_CELL BLACK_CELL_2_30  ( P1[28], G1[28], P1[30], G1[30], P2[30], G2[30]);
    BLACK_CELL BLACK_CELL_2_31  ( P1[29], G1[29], P1[31], G1[31], P2[31], G2[31]);
	 BLACK_CELL BLACK_CELL_2_32  ( P1[30], G1[30], P1[32], G1[32], P2[32], G2[32]);

	 
	 // Level 3 
	 
	 GRAY_CELL 	GRAY_CELL_05	(C[1] , P2[5], G2[5], C[5]);
	 GRAY_CELL 	GRAY_CELL_06	(C[2] , P2[6], G2[6], C[6]);
	 GRAY_CELL 	GRAY_CELL_07	(C[3] , P2[7], G2[7], C[7]);
	 GRAY_CELL 	GRAY_CELL_08	(C[4] , P2[8], G2[8], C[8]);
	 //								 |P_pre-4|G_pre-4|P_cur| G_cur| P_n  |  G_n	 
    BLACK_CELL BLACK_CELL_3_09  ( P2[5], G2[5], P2[9],  G2[9],  P3[9],  G3[9]);
    BLACK_CELL BLACK_CELL_3_10  ( P2[6], G2[6], P2[10], G2[10], P3[10], G3[10]);
    BLACK_CELL BLACK_CELL_3_11  ( P2[7], G2[7], P2[11], G2[11], P3[11], G3[11]);
    BLACK_CELL BLACK_CELL_3_12  ( P2[8], G2[8], P2[12], G2[12], P3[12], G3[12]);
	 
    BLACK_CELL BLACK_CELL_3_13  ( P2[9] , G2[9] , P2[13], G2[13], P3[13], G3[13]);
    BLACK_CELL BLACK_CELL_3_14  ( P2[10], G2[10], P2[14], G2[14], P3[14], G3[14]);
    BLACK_CELL BLACK_CELL_3_15  ( P2[11], G2[11], P2[15], G2[15], P3[15], G3[15]);
    BLACK_CELL BLACK_CELL_3_16  ( P2[12], G2[12], P2[16], G2[16], P3[16], G3[16]);
	
    BLACK_CELL BLACK_CELL_3_17  ( P2[13], G2[13], P2[17], G2[17], P3[17], G3[17]);
    BLACK_CELL BLACK_CELL_3_18  ( P2[14], G2[14], P2[18], G2[18], P3[18], G3[18]);
    BLACK_CELL BLACK_CELL_3_19  ( P2[15], G2[15], P2[19], G2[19], P3[19], G3[19]);
    BLACK_CELL BLACK_CELL_3_20  ( P2[16], G2[16], P2[20], G2[20], P3[20], G3[20]);
	
    BLACK_CELL BLACK_CELL_3_21  ( P2[17], G2[17], P2[21], G2[21], P3[21], G3[21]);
    BLACK_CELL BLACK_CELL_3_22  ( P2[18], G2[18], P2[22], G2[22], P3[22], G3[22]);
    BLACK_CELL BLACK_CELL_3_23  ( P2[19], G2[19], P2[23], G2[23], P3[23], G3[23]);
    BLACK_CELL BLACK_CELL_3_24  ( P2[20], G2[20], P2[24], G2[24], P3[24], G3[24]);
	 
    BLACK_CELL BLACK_CELL_3_25  ( P2[21], G2[21], P2[25], G2[25], P3[25], G3[25]);
    BLACK_CELL BLACK_CELL_3_26  ( P2[22], G2[22], P2[26], G2[26], P3[26], G3[26]);
    BLACK_CELL BLACK_CELL_3_27  ( P2[23], G2[23], P2[27], G2[27], P3[27], G3[27]);
    BLACK_CELL BLACK_CELL_3_28  ( P2[24], G2[24], P2[28], G2[28], P3[28], G3[28]); 
	 
    BLACK_CELL BLACK_CELL_3_29  ( P2[25], G2[25], P2[29], G2[29], P3[29], G3[29]);
    BLACK_CELL BLACK_CELL_3_30  ( P2[26], G2[26], P2[30], G2[30], P3[30], G3[30]);
    BLACK_CELL BLACK_CELL_3_31  ( P2[27], G2[27], P2[31], G2[31], P3[31], G3[31]);
	 BLACK_CELL BLACK_CELL_3_32  ( P2[28], G2[28], P2[32], G2[32], P3[32], G3[32]);

	 
	 // Level 4
	 
    GRAY_CELL 	GRAY_CELL_09	(C[1], P3[9],  G3[9],  C[9]);
    GRAY_CELL 	GRAY_CELL_10	(C[2], P3[10], G3[10], C[10]);
    GRAY_CELL 	GRAY_CELL_11	(C[3], P3[11], G3[11], C[11]);
    GRAY_CELL 	GRAY_CELL_12	(C[4], P3[12], G3[12], C[12]);
    GRAY_CELL 	GRAY_CELL_13	(C[5], P3[13], G3[13], C[13]);
    GRAY_CELL 	GRAY_CELL_14	(C[6], P3[14], G3[14], C[14]);
    GRAY_CELL 	GRAY_CELL_15	(C[7], P3[15], G3[15], C[15]);
    GRAY_CELL 	GRAY_CELL_16	(C[8], P3[16], G3[16], C[16]);
	 //								 |P_pre-8|G_pre-8|P_cur| G_cur| P_n  |  G_n 
    BLACK_CELL BLACK_CELL_4_17  ( P3[9] , G3[9] , P3[17], G3[17], P4[17], G4[17]);
    BLACK_CELL BLACK_CELL_4_18  ( P3[10], G3[10], P3[18], G3[18], P4[18], G4[18]);
    BLACK_CELL BLACK_CELL_4_19  ( P3[11], G3[11], P3[19], G3[19], P4[19], G4[19]);
    BLACK_CELL BLACK_CELL_4_20  ( P3[12], G3[12], P3[20], G3[20], P4[20], G4[20]);
	 
    BLACK_CELL BLACK_CELL_4_21  ( P3[13], G3[13], P3[21], G3[21], P4[21], G4[21]);
    BLACK_CELL BLACK_CELL_4_22  ( P3[14], G3[14], P3[22], G3[22], P4[22], G4[22]);
    BLACK_CELL BLACK_CELL_4_23  ( P3[15], G3[15], P3[23], G3[23], P4[23], G4[23]);
    BLACK_CELL BLACK_CELL_4_24  ( P3[16], G3[16], P3[24], G3[24], P4[24], G4[24]);
	 
    BLACK_CELL BLACK_CELL_4_25  ( P3[17], G3[17], P3[25], G3[25], P4[25], G4[25]);
    BLACK_CELL BLACK_CELL_4_26  ( P3[18], G3[18], P3[26], G3[26], P4[26], G4[26]);
    BLACK_CELL BLACK_CELL_4_27  ( P3[19], G3[19], P3[27], G3[27], P4[27], G4[27]);
    BLACK_CELL BLACK_CELL_4_28  ( P3[20], G3[20], P3[28], G3[28], P4[28], G4[28]);
	 
    BLACK_CELL BLACK_CELL_4_29  ( P3[21], G3[21], P3[29], G3[29], P4[29], G4[29]);
    BLACK_CELL BLACK_CELL_4_30  ( P3[22], G3[22], P3[30], G3[30], P4[30], G4[30]);
    BLACK_CELL BLACK_CELL_4_31  ( P3[23], G3[23], P3[31], G3[31], P4[31], G4[31]);
	 BLACK_CELL BLACK_CELL_4_32  ( P3[24], G3[24], P3[32], G3[32], P4[32], G4[32]);

	 
	 // Level 5
	 //							   |G_pre-16|P_cur| G_cur|  G_n 
	 GRAY_CELL 	GRAY_CELL_17	(C[1],  P4[17], G4[17], C[17]);
    GRAY_CELL 	GRAY_CELL_18	(C[2],  P4[18], G4[18], C[18]);
    GRAY_CELL 	GRAY_CELL_19	(C[3],  P4[19], G4[19], C[19]);
    GRAY_CELL 	GRAY_CELL_20	(C[4],  P4[20], G4[20], C[20]);
	 
    GRAY_CELL 	GRAY_CELL_21	(C[5],  P4[21], G4[21], C[21]);
    GRAY_CELL 	GRAY_CELL_22	(C[6],  P4[22], G4[22], C[22]);
    GRAY_CELL 	GRAY_CELL_23	(C[7],  P4[23], G4[23], C[23]);
    GRAY_CELL 	GRAY_CELL_24	(C[8],  P4[24], G4[24], C[24]);
	 
    GRAY_CELL 	GRAY_CELL_25	(C[9],  P4[25], G4[25], C[25]);
    GRAY_CELL 	GRAY_CELL_26	(C[10], P4[26], G4[26], C[26]);
    GRAY_CELL 	GRAY_CELL_27	(C[11], P4[27], G4[27], C[27]);
    GRAY_CELL 	GRAY_CELL_28	(C[12], P4[28], G4[28], C[28]); 
	
    GRAY_CELL 	GRAY_CELL_29	(C[13], P4[29], G4[29], C[29]);
    GRAY_CELL 	GRAY_CELL_30	(C[14], P4[30], G4[30], C[30]);
    GRAY_CELL 	GRAY_CELL_31	(C[15], P4[31], G4[31], C[31]);
    GRAY_CELL 	GRAY_CELL_32	(C[16], P4[32], G4[32], C[32]);

	 
    // Post-processing stage: Compute Sum
	 
	 // Calculate Sum[31:0]
	 assign sum[0] = cin ^ P[1];
    assign sum[31:1] = C[31:1] ^ P[32:2];
	 
	 // Calculate Cout
	 assign cout = C[32];
	 

endmodule

//-------------------------------- adder_64bits ---------------------------

module adder_64bits (
    input  [63:0] A,
    input  [63:0] B,
    input         Cin,
    output [63:0] Sum,
    output        Cout
);

    // 1-based buses like the 32-bit version
    logic [64:1] G, P;
    logic [64:1] C;

    // Pre-processing: Generate & Propagate (manual assigns for 1-based indices)
    assign G = A & B;    // Generate
    assign P = A ^ B;    // Propagate

    // Intermediate prefix nets
    logic [64:3]   G1, P1;  // span 1
    logic [64:5]   G2, P2;  // span 2
    logic [64:9]   G3, P3;  // span 4
    logic [64:17]  G4, P4;  // span 8
    logic [64:33]  G5, P5;  // span 16

    // ---------------- Level 1 (span = 1) ----------------
    assign C[1] = G[1] | (P[1] & Cin);
    GRAY_CELL GRAY_CELL_02 (C[1], P[2], G[2], C[2]);
    BLACK_CELL BLACK_CELL_1_03 ( P[2], G[2], P[3], G[3], P1[3], G1[3] );
    BLACK_CELL BLACK_CELL_1_04 ( P[3], G[3], P[4], G[4], P1[4], G1[4] );
    BLACK_CELL BLACK_CELL_1_05 ( P[4], G[4], P[5], G[5], P1[5], G1[5] );
    BLACK_CELL BLACK_CELL_1_06 ( P[5], G[5], P[6], G[6], P1[6], G1[6] );
    BLACK_CELL BLACK_CELL_1_07 ( P[6], G[6], P[7], G[7], P1[7], G1[7] );
    BLACK_CELL BLACK_CELL_1_08 ( P[7], G[7], P[8], G[8], P1[8], G1[8] );
    BLACK_CELL BLACK_CELL_1_09 ( P[8], G[8], P[9], G[9], P1[9], G1[9] );
    BLACK_CELL BLACK_CELL_1_10 ( P[9], G[9], P[10], G[10], P1[10], G1[10] );
    BLACK_CELL BLACK_CELL_1_11 ( P[10], G[10], P[11], G[11], P1[11], G1[11] );
    BLACK_CELL BLACK_CELL_1_12 ( P[11], G[11], P[12], G[12], P1[12], G1[12] );
    BLACK_CELL BLACK_CELL_1_13 ( P[12], G[12], P[13], G[13], P1[13], G1[13] );
    BLACK_CELL BLACK_CELL_1_14 ( P[13], G[13], P[14], G[14], P1[14], G1[14] );
    BLACK_CELL BLACK_CELL_1_15 ( P[14], G[14], P[15], G[15], P1[15], G1[15] );
    BLACK_CELL BLACK_CELL_1_16 ( P[15], G[15], P[16], G[16], P1[16], G1[16] );
    BLACK_CELL BLACK_CELL_1_17 ( P[16], G[16], P[17], G[17], P1[17], G1[17] );
    BLACK_CELL BLACK_CELL_1_18 ( P[17], G[17], P[18], G[18], P1[18], G1[18] );
    BLACK_CELL BLACK_CELL_1_19 ( P[18], G[18], P[19], G[19], P1[19], G1[19] );
    BLACK_CELL BLACK_CELL_1_20 ( P[19], G[19], P[20], G[20], P1[20], G1[20] );
    BLACK_CELL BLACK_CELL_1_21 ( P[20], G[20], P[21], G[21], P1[21], G1[21] );
    BLACK_CELL BLACK_CELL_1_22 ( P[21], G[21], P[22], G[22], P1[22], G1[22] );
    BLACK_CELL BLACK_CELL_1_23 ( P[22], G[22], P[23], G[23], P1[23], G1[23] );
    BLACK_CELL BLACK_CELL_1_24 ( P[23], G[23], P[24], G[24], P1[24], G1[24] );
    BLACK_CELL BLACK_CELL_1_25 ( P[24], G[24], P[25], G[25], P1[25], G1[25] );
    BLACK_CELL BLACK_CELL_1_26 ( P[25], G[25], P[26], G[26], P1[26], G1[26] );
    BLACK_CELL BLACK_CELL_1_27 ( P[26], G[26], P[27], G[27], P1[27], G1[27] );
    BLACK_CELL BLACK_CELL_1_28 ( P[27], G[27], P[28], G[28], P1[28], G1[28] );
    BLACK_CELL BLACK_CELL_1_29 ( P[28], G[28], P[29], G[29], P1[29], G1[29] );
    BLACK_CELL BLACK_CELL_1_30 ( P[29], G[29], P[30], G[30], P1[30], G1[30] );
    BLACK_CELL BLACK_CELL_1_31 ( P[30], G[30], P[31], G[31], P1[31], G1[31] );
    BLACK_CELL BLACK_CELL_1_32 ( P[31], G[31], P[32], G[32], P1[32], G1[32] );
    BLACK_CELL BLACK_CELL_1_33 ( P[32], G[32], P[33], G[33], P1[33], G1[33] );
    BLACK_CELL BLACK_CELL_1_34 ( P[33], G[33], P[34], G[34], P1[34], G1[34] );
    BLACK_CELL BLACK_CELL_1_35 ( P[34], G[34], P[35], G[35], P1[35], G1[35] );
    BLACK_CELL BLACK_CELL_1_36 ( P[35], G[35], P[36], G[36], P1[36], G1[36] );
    BLACK_CELL BLACK_CELL_1_37 ( P[36], G[36], P[37], G[37], P1[37], G1[37] );
    BLACK_CELL BLACK_CELL_1_38 ( P[37], G[37], P[38], G[38], P1[38], G1[38] );
    BLACK_CELL BLACK_CELL_1_39 ( P[38], G[38], P[39], G[39], P1[39], G1[39] );
    BLACK_CELL BLACK_CELL_1_40 ( P[39], G[39], P[40], G[40], P1[40], G1[40] );
    BLACK_CELL BLACK_CELL_1_41 ( P[40], G[40], P[41], G[41], P1[41], G1[41] );
    BLACK_CELL BLACK_CELL_1_42 ( P[41], G[41], P[42], G[42], P1[42], G1[42] );
    BLACK_CELL BLACK_CELL_1_43 ( P[42], G[42], P[43], G[43], P1[43], G1[43] );
    BLACK_CELL BLACK_CELL_1_44 ( P[43], G[43], P[44], G[44], P1[44], G1[44] );
    BLACK_CELL BLACK_CELL_1_45 ( P[44], G[44], P[45], G[45], P1[45], G1[45] );
    BLACK_CELL BLACK_CELL_1_46 ( P[45], G[45], P[46], G[46], P1[46], G1[46] );
    BLACK_CELL BLACK_CELL_1_47 ( P[46], G[46], P[47], G[47], P1[47], G1[47] );
    BLACK_CELL BLACK_CELL_1_48 ( P[47], G[47], P[48], G[48], P1[48], G1[48] );
    BLACK_CELL BLACK_CELL_1_49 ( P[48], G[48], P[49], G[49], P1[49], G1[49] );
    BLACK_CELL BLACK_CELL_1_50 ( P[49], G[49], P[50], G[50], P1[50], G1[50] );
    BLACK_CELL BLACK_CELL_1_51 ( P[50], G[50], P[51], G[51], P1[51], G1[51] );
    BLACK_CELL BLACK_CELL_1_52 ( P[51], G[51], P[52], G[52], P1[52], G1[52] );
    BLACK_CELL BLACK_CELL_1_53 ( P[52], G[52], P[53], G[53], P1[53], G1[53] );
    BLACK_CELL BLACK_CELL_1_54 ( P[53], G[53], P[54], G[54], P1[54], G1[54] );
    BLACK_CELL BLACK_CELL_1_55 ( P[54], G[54], P[55], G[55], P1[55], G1[55] );
    BLACK_CELL BLACK_CELL_1_56 ( P[55], G[55], P[56], G[56], P1[56], G1[56] );
    BLACK_CELL BLACK_CELL_1_57 ( P[56], G[56], P[57], G[57], P1[57], G1[57] );
    BLACK_CELL BLACK_CELL_1_58 ( P[57], G[57], P[58], G[58], P1[58], G1[58] );
    BLACK_CELL BLACK_CELL_1_59 ( P[58], G[58], P[59], G[59], P1[59], G1[59] );
    BLACK_CELL BLACK_CELL_1_60 ( P[59], G[59], P[60], G[60], P1[60], G1[60] );
    BLACK_CELL BLACK_CELL_1_61 ( P[60], G[60], P[61], G[61], P1[61], G1[61] );
    BLACK_CELL BLACK_CELL_1_62 ( P[61], G[61], P[62], G[62], P1[62], G1[62] );
    BLACK_CELL BLACK_CELL_1_63 ( P[62], G[62], P[63], G[63], P1[63], G1[63] );
    BLACK_CELL BLACK_CELL_1_64 ( P[63], G[63], P[64], G[64], P1[64], G1[64] );

    // ---------------- Level 2 (span = 2) ----------------
    GRAY_CELL GRAY_CELL_03 (C[1], P1[3], G1[3], C[3]);
    GRAY_CELL GRAY_CELL_04 (C[2], P1[4], G1[4], C[4]);
    BLACK_CELL BLACK_CELL_2_05 ( P1[3], G1[3], P1[5], G1[5], P2[5], G2[5] );
    BLACK_CELL BLACK_CELL_2_06 ( P1[4], G1[4], P1[6], G1[6], P2[6], G2[6] );
    BLACK_CELL BLACK_CELL_2_07 ( P1[5], G1[5], P1[7], G1[7], P2[7], G2[7] );
    BLACK_CELL BLACK_CELL_2_08 ( P1[6], G1[6], P1[8], G1[8], P2[8], G2[8] );
    BLACK_CELL BLACK_CELL_2_09 ( P1[7], G1[7], P1[9], G1[9], P2[9], G2[9] );
    BLACK_CELL BLACK_CELL_2_10 ( P1[8], G1[8], P1[10], G1[10], P2[10], G2[10] );
    BLACK_CELL BLACK_CELL_2_11 ( P1[9], G1[9], P1[11], G1[11], P2[11], G2[11] );
    BLACK_CELL BLACK_CELL_2_12 ( P1[10], G1[10], P1[12], G1[12], P2[12], G2[12] );
    BLACK_CELL BLACK_CELL_2_13 ( P1[11], G1[11], P1[13], G1[13], P2[13], G2[13] );
    BLACK_CELL BLACK_CELL_2_14 ( P1[12], G1[12], P1[14], G1[14], P2[14], G2[14] );
    BLACK_CELL BLACK_CELL_2_15 ( P1[13], G1[13], P1[15], G1[15], P2[15], G2[15] );
    BLACK_CELL BLACK_CELL_2_16 ( P1[14], G1[14], P1[16], G1[16], P2[16], G2[16] );
    BLACK_CELL BLACK_CELL_2_17 ( P1[15], G1[15], P1[17], G1[17], P2[17], G2[17] );
    BLACK_CELL BLACK_CELL_2_18 ( P1[16], G1[16], P1[18], G1[18], P2[18], G2[18] );
    BLACK_CELL BLACK_CELL_2_19 ( P1[17], G1[17], P1[19], G1[19], P2[19], G2[19] );
    BLACK_CELL BLACK_CELL_2_20 ( P1[18], G1[18], P1[20], G1[20], P2[20], G2[20] );
    BLACK_CELL BLACK_CELL_2_21 ( P1[19], G1[19], P1[21], G1[21], P2[21], G2[21] );
    BLACK_CELL BLACK_CELL_2_22 ( P1[20], G1[20], P1[22], G1[22], P2[22], G2[22] );
    BLACK_CELL BLACK_CELL_2_23 ( P1[21], G1[21], P1[23], G1[23], P2[23], G2[23] );
    BLACK_CELL BLACK_CELL_2_24 ( P1[22], G1[22], P1[24], G1[24], P2[24], G2[24] );
    BLACK_CELL BLACK_CELL_2_25 ( P1[23], G1[23], P1[25], G1[25], P2[25], G2[25] );
    BLACK_CELL BLACK_CELL_2_26 ( P1[24], G1[24], P1[26], G1[26], P2[26], G2[26] );
    BLACK_CELL BLACK_CELL_2_27 ( P1[25], G1[25], P1[27], G1[27], P2[27], G2[27] );
    BLACK_CELL BLACK_CELL_2_28 ( P1[26], G1[26], P1[28], G1[28], P2[28], G2[28] );
    BLACK_CELL BLACK_CELL_2_29 ( P1[27], G1[27], P1[29], G1[29], P2[29], G2[29] );
    BLACK_CELL BLACK_CELL_2_30 ( P1[28], G1[28], P1[30], G1[30], P2[30], G2[30] );
    BLACK_CELL BLACK_CELL_2_31 ( P1[29], G1[29], P1[31], G1[31], P2[31], G2[31] );
    BLACK_CELL BLACK_CELL_2_32 ( P1[30], G1[30], P1[32], G1[32], P2[32], G2[32] );
    BLACK_CELL BLACK_CELL_2_33 ( P1[31], G1[31], P1[33], G1[33], P2[33], G2[33] );
    BLACK_CELL BLACK_CELL_2_34 ( P1[32], G1[32], P1[34], G1[34], P2[34], G2[34] );
    BLACK_CELL BLACK_CELL_2_35 ( P1[33], G1[33], P1[35], G1[35], P2[35], G2[35] );
    BLACK_CELL BLACK_CELL_2_36 ( P1[34], G1[34], P1[36], G1[36], P2[36], G2[36] );
    BLACK_CELL BLACK_CELL_2_37 ( P1[35], G1[35], P1[37], G1[37], P2[37], G2[37] );
    BLACK_CELL BLACK_CELL_2_38 ( P1[36], G1[36], P1[38], G1[38], P2[38], G2[38] );
    BLACK_CELL BLACK_CELL_2_39 ( P1[37], G1[37], P1[39], G1[39], P2[39], G2[39] );
    BLACK_CELL BLACK_CELL_2_40 ( P1[38], G1[38], P1[40], G1[40], P2[40], G2[40] );
    BLACK_CELL BLACK_CELL_2_41 ( P1[39], G1[39], P1[41], G1[41], P2[41], G2[41] );
    BLACK_CELL BLACK_CELL_2_42 ( P1[40], G1[40], P1[42], G1[42], P2[42], G2[42] );
    BLACK_CELL BLACK_CELL_2_43 ( P1[41], G1[41], P1[43], G1[43], P2[43], G2[43] );
    BLACK_CELL BLACK_CELL_2_44 ( P1[42], G1[42], P1[44], G1[44], P2[44], G2[44] );
    BLACK_CELL BLACK_CELL_2_45 ( P1[43], G1[43], P1[45], G1[45], P2[45], G2[45] );
    BLACK_CELL BLACK_CELL_2_46 ( P1[44], G1[44], P1[46], G1[46], P2[46], G2[46] );
    BLACK_CELL BLACK_CELL_2_47 ( P1[45], G1[45], P1[47], G1[47], P2[47], G2[47] );
    BLACK_CELL BLACK_CELL_2_48 ( P1[46], G1[46], P1[48], G1[48], P2[48], G2[48] );
    BLACK_CELL BLACK_CELL_2_49 ( P1[47], G1[47], P1[49], G1[49], P2[49], G2[49] );
    BLACK_CELL BLACK_CELL_2_50 ( P1[48], G1[48], P1[50], G1[50], P2[50], G2[50] );
    BLACK_CELL BLACK_CELL_2_51 ( P1[49], G1[49], P1[51], G1[51], P2[51], G2[51] );
    BLACK_CELL BLACK_CELL_2_52 ( P1[50], G1[50], P1[52], G1[52], P2[52], G2[52] );
    BLACK_CELL BLACK_CELL_2_53 ( P1[51], G1[51], P1[53], G1[53], P2[53], G2[53] );
    BLACK_CELL BLACK_CELL_2_54 ( P1[52], G1[52], P1[54], G1[54], P2[54], G2[54] );
    BLACK_CELL BLACK_CELL_2_55 ( P1[53], G1[53], P1[55], G1[55], P2[55], G2[55] );
    BLACK_CELL BLACK_CELL_2_56 ( P1[54], G1[54], P1[56], G1[56], P2[56], G2[56] );
    BLACK_CELL BLACK_CELL_2_57 ( P1[55], G1[55], P1[57], G1[57], P2[57], G2[57] );
    BLACK_CELL BLACK_CELL_2_58 ( P1[56], G1[56], P1[58], G1[58], P2[58], G2[58] );
    BLACK_CELL BLACK_CELL_2_59 ( P1[57], G1[57], P1[59], G1[59], P2[59], G2[59] );
    BLACK_CELL BLACK_CELL_2_60 ( P1[58], G1[58], P1[60], G1[60], P2[60], G2[60] );
    BLACK_CELL BLACK_CELL_2_61 ( P1[59], G1[59], P1[61], G1[61], P2[61], G2[61] );
    BLACK_CELL BLACK_CELL_2_62 ( P1[60], G1[60], P1[62], G1[62], P2[62], G2[62] );
    BLACK_CELL BLACK_CELL_2_63 ( P1[61], G1[61], P1[63], G1[63], P2[63], G2[63] );
    BLACK_CELL BLACK_CELL_2_64 ( P1[62], G1[62], P1[64], G1[64], P2[64], G2[64] );

    // ---------------- Level 3 (span = 4) ----------------
    GRAY_CELL GRAY_CELL_05 (C[1], P2[5], G2[5], C[5]);
    GRAY_CELL GRAY_CELL_06 (C[2], P2[6], G2[6], C[6]);
    GRAY_CELL GRAY_CELL_07 (C[3], P2[7], G2[7], C[7]);
    GRAY_CELL GRAY_CELL_08 (C[4], P2[8], G2[8], C[8]);
    BLACK_CELL BLACK_CELL_3_09 ( P2[5], G2[5], P2[9], G2[9], P3[9], G3[9] );
    BLACK_CELL BLACK_CELL_3_10 ( P2[6], G2[6], P2[10], G2[10], P3[10], G3[10] );
    BLACK_CELL BLACK_CELL_3_11 ( P2[7], G2[7], P2[11], G2[11], P3[11], G3[11] );
    BLACK_CELL BLACK_CELL_3_12 ( P2[8], G2[8], P2[12], G2[12], P3[12], G3[12] );
    BLACK_CELL BLACK_CELL_3_13 ( P2[9], G2[9], P2[13], G2[13], P3[13], G3[13] );
    BLACK_CELL BLACK_CELL_3_14 ( P2[10], G2[10], P2[14], G2[14], P3[14], G3[14] );
    BLACK_CELL BLACK_CELL_3_15 ( P2[11], G2[11], P2[15], G2[15], P3[15], G3[15] );
    BLACK_CELL BLACK_CELL_3_16 ( P2[12], G2[12], P2[16], G2[16], P3[16], G3[16] );
    BLACK_CELL BLACK_CELL_3_17 ( P2[13], G2[13], P2[17], G2[17], P3[17], G3[17] );
    BLACK_CELL BLACK_CELL_3_18 ( P2[14], G2[14], P2[18], G2[18], P3[18], G3[18] );
    BLACK_CELL BLACK_CELL_3_19 ( P2[15], G2[15], P2[19], G2[19], P3[19], G3[19] );
    BLACK_CELL BLACK_CELL_3_20 ( P2[16], G2[16], P2[20], G2[20], P3[20], G3[20] );
    BLACK_CELL BLACK_CELL_3_21 ( P2[17], G2[17], P2[21], G2[21], P3[21], G3[21] );
    BLACK_CELL BLACK_CELL_3_22 ( P2[18], G2[18], P2[22], G2[22], P3[22], G3[22] );
    BLACK_CELL BLACK_CELL_3_23 ( P2[19], G2[19], P2[23], G2[23], P3[23], G3[23] );
    BLACK_CELL BLACK_CELL_3_24 ( P2[20], G2[20], P2[24], G2[24], P3[24], G3[24] );
    BLACK_CELL BLACK_CELL_3_25 ( P2[21], G2[21], P2[25], G2[25], P3[25], G3[25] );
    BLACK_CELL BLACK_CELL_3_26 ( P2[22], G2[22], P2[26], G2[26], P3[26], G3[26] );
    BLACK_CELL BLACK_CELL_3_27 ( P2[23], G2[23], P2[27], G2[27], P3[27], G3[27] );
    BLACK_CELL BLACK_CELL_3_28 ( P2[24], G2[24], P2[28], G2[28], P3[28], G3[28] );
    BLACK_CELL BLACK_CELL_3_29 ( P2[25], G2[25], P2[29], G2[29], P3[29], G3[29] );
    BLACK_CELL BLACK_CELL_3_30 ( P2[26], G2[26], P2[30], G2[30], P3[30], G3[30] );
    BLACK_CELL BLACK_CELL_3_31 ( P2[27], G2[27], P2[31], G2[31], P3[31], G3[31] );
    BLACK_CELL BLACK_CELL_3_32 ( P2[28], G2[28], P2[32], G2[32], P3[32], G3[32] );
    BLACK_CELL BLACK_CELL_3_33 ( P2[29], G2[29], P2[33], G2[33], P3[33], G3[33] );
    BLACK_CELL BLACK_CELL_3_34 ( P2[30], G2[30], P2[34], G2[34], P3[34], G3[34] );
    BLACK_CELL BLACK_CELL_3_35 ( P2[31], G2[31], P2[35], G2[35], P3[35], G3[35] );
    BLACK_CELL BLACK_CELL_3_36 ( P2[32], G2[32], P2[36], G2[36], P3[36], G3[36] );
    BLACK_CELL BLACK_CELL_3_37 ( P2[33], G2[33], P2[37], G2[37], P3[37], G3[37] );
    BLACK_CELL BLACK_CELL_3_38 ( P2[34], G2[34], P2[38], G2[38], P3[38], G3[38] );
    BLACK_CELL BLACK_CELL_3_39 ( P2[35], G2[35], P2[39], G2[39], P3[39], G3[39] );
    BLACK_CELL BLACK_CELL_3_40 ( P2[36], G2[36], P2[40], G2[40], P3[40], G3[40] );
    BLACK_CELL BLACK_CELL_3_41 ( P2[37], G2[37], P2[41], G2[41], P3[41], G3[41] );
    BLACK_CELL BLACK_CELL_3_42 ( P2[38], G2[38], P2[42], G2[42], P3[42], G3[42] );
    BLACK_CELL BLACK_CELL_3_43 ( P2[39], G2[39], P2[43], G2[43], P3[43], G3[43] );
    BLACK_CELL BLACK_CELL_3_44 ( P2[40], G2[40], P2[44], G2[44], P3[44], G3[44] );
    BLACK_CELL BLACK_CELL_3_45 ( P2[41], G2[41], P2[45], G2[45], P3[45], G3[45] );
    BLACK_CELL BLACK_CELL_3_46 ( P2[42], G2[42], P2[46], G2[46], P3[46], G3[46] );
    BLACK_CELL BLACK_CELL_3_47 ( P2[43], G2[43], P2[47], G2[47], P3[47], G3[47] );
    BLACK_CELL BLACK_CELL_3_48 ( P2[44], G2[44], P2[48], G2[48], P3[48], G3[48] );
    BLACK_CELL BLACK_CELL_3_49 ( P2[45], G2[45], P2[49], G2[49], P3[49], G3[49] );
    BLACK_CELL BLACK_CELL_3_50 ( P2[46], G2[46], P2[50], G2[50], P3[50], G3[50] );
    BLACK_CELL BLACK_CELL_3_51 ( P2[47], G2[47], P2[51], G2[51], P3[51], G3[51] );
    BLACK_CELL BLACK_CELL_3_52 ( P2[48], G2[48], P2[52], G2[52], P3[52], G3[52] );
    BLACK_CELL BLACK_CELL_3_53 ( P2[49], G2[49], P2[53], G2[53], P3[53], G3[53] );
    BLACK_CELL BLACK_CELL_3_54 ( P2[50], G2[50], P2[54], G2[54], P3[54], G3[54] );
    BLACK_CELL BLACK_CELL_3_55 ( P2[51], G2[51], P2[55], G2[55], P3[55], G3[55] );
    BLACK_CELL BLACK_CELL_3_56 ( P2[52], G2[52], P2[56], G2[56], P3[56], G3[56] );
    BLACK_CELL BLACK_CELL_3_57 ( P2[53], G2[53], P2[57], G2[57], P3[57], G3[57] );
    BLACK_CELL BLACK_CELL_3_58 ( P2[54], G2[54], P2[58], G2[58], P3[58], G3[58] );
    BLACK_CELL BLACK_CELL_3_59 ( P2[55], G2[55], P2[59], G2[59], P3[59], G3[59] );
    BLACK_CELL BLACK_CELL_3_60 ( P2[56], G2[56], P2[60], G2[60], P3[60], G3[60] );
    BLACK_CELL BLACK_CELL_3_61 ( P2[57], G2[57], P2[61], G2[61], P3[61], G3[61] );
    BLACK_CELL BLACK_CELL_3_62 ( P2[58], G2[58], P2[62], G2[62], P3[62], G3[62] );
    BLACK_CELL BLACK_CELL_3_63 ( P2[59], G2[59], P2[63], G2[63], P3[63], G3[63] );
    BLACK_CELL BLACK_CELL_3_64 ( P2[60], G2[60], P2[64], G2[64], P3[64], G3[64] );

    // ---------------- Level 4 (span = 8) ----------------
    GRAY_CELL GRAY_CELL_13 (C[1], P3[9], G3[9], C[9]);
    GRAY_CELL GRAY_CELL_14 (C[2], P3[10], G3[10], C[10]);
    GRAY_CELL GRAY_CELL_15 (C[3], P3[11], G3[11], C[11]);
    GRAY_CELL GRAY_CELL_16 (C[4], P3[12], G3[12], C[12]);
    GRAY_CELL GRAY_CELL_17 (C[5], P3[13], G3[13], C[13]);
    GRAY_CELL GRAY_CELL_18 (C[6], P3[14], G3[14], C[14]);
    GRAY_CELL GRAY_CELL_19 (C[7], P3[15], G3[15], C[15]);
    GRAY_CELL GRAY_CELL_20 (C[8], P3[16], G3[16], C[16]);
    BLACK_CELL BLACK_CELL_4_17 ( P3[9], G3[9], P3[17], G3[17], P4[17], G4[17] );
    BLACK_CELL BLACK_CELL_4_18 ( P3[10], G3[10], P3[18], G3[18], P4[18], G4[18] );
    BLACK_CELL BLACK_CELL_4_19 ( P3[11], G3[11], P3[19], G3[19], P4[19], G4[19] );
    BLACK_CELL BLACK_CELL_4_20 ( P3[12], G3[12], P3[20], G3[20], P4[20], G4[20] );
    BLACK_CELL BLACK_CELL_4_21 ( P3[13], G3[13], P3[21], G3[21], P4[21], G4[21] );
    BLACK_CELL BLACK_CELL_4_22 ( P3[14], G3[14], P3[22], G3[22], P4[22], G4[22] );
    BLACK_CELL BLACK_CELL_4_23 ( P3[15], G3[15], P3[23], G3[23], P4[23], G4[23] );
    BLACK_CELL BLACK_CELL_4_24 ( P3[16], G3[16], P3[24], G3[24], P4[24], G4[24] );
    BLACK_CELL BLACK_CELL_4_25 ( P3[17], G3[17], P3[25], G3[25], P4[25], G4[25] );
    BLACK_CELL BLACK_CELL_4_26 ( P3[18], G3[18], P3[26], G3[26], P4[26], G4[26] );
    BLACK_CELL BLACK_CELL_4_27 ( P3[19], G3[19], P3[27], G3[27], P4[27], G4[27] );
    BLACK_CELL BLACK_CELL_4_28 ( P3[20], G3[20], P3[28], G3[28], P4[28], G4[28] );
    BLACK_CELL BLACK_CELL_4_29 ( P3[21], G3[21], P3[29], G3[29], P4[29], G4[29] );
    BLACK_CELL BLACK_CELL_4_30 ( P3[22], G3[22], P3[30], G3[30], P4[30], G4[30] );
    BLACK_CELL BLACK_CELL_4_31 ( P3[23], G3[23], P3[31], G3[31], P4[31], G4[31] );
    BLACK_CELL BLACK_CELL_4_32 ( P3[24], G3[24], P3[32], G3[32], P4[32], G4[32] );
    BLACK_CELL BLACK_CELL_4_33 ( P3[25], G3[25], P3[33], G3[33], P4[33], G4[33] );
    BLACK_CELL BLACK_CELL_4_34 ( P3[26], G3[26], P3[34], G3[34], P4[34], G4[34] );
    BLACK_CELL BLACK_CELL_4_35 ( P3[27], G3[27], P3[35], G3[35], P4[35], G4[35] );
    BLACK_CELL BLACK_CELL_4_36 ( P3[28], G3[28], P3[36], G3[36], P4[36], G4[36] );
    BLACK_CELL BLACK_CELL_4_37 ( P3[29], G3[29], P3[37], G3[37], P4[37], G4[37] );
    BLACK_CELL BLACK_CELL_4_38 ( P3[30], G3[30], P3[38], G3[38], P4[38], G4[38] );
    BLACK_CELL BLACK_CELL_4_39 ( P3[31], G3[31], P3[39], G3[39], P4[39], G4[39] );
    BLACK_CELL BLACK_CELL_4_40 ( P3[32], G3[32], P3[40], G3[40], P4[40], G4[40] );
    BLACK_CELL BLACK_CELL_4_41 ( P3[33], G3[33], P3[41], G3[41], P4[41], G4[41] );
    BLACK_CELL BLACK_CELL_4_42 ( P3[34], G3[34], P3[42], G3[42], P4[42], G4[42] );
    BLACK_CELL BLACK_CELL_4_43 ( P3[35], G3[35], P3[43], G3[43], P4[43], G4[43] );
    BLACK_CELL BLACK_CELL_4_44 ( P3[36], G3[36], P3[44], G3[44], P4[44], G4[44] );
    BLACK_CELL BLACK_CELL_4_45 ( P3[37], G3[37], P3[45], G3[45], P4[45], G4[45] );
    BLACK_CELL BLACK_CELL_4_46 ( P3[38], G3[38], P3[46], G3[46], P4[46], G4[46] );
    BLACK_CELL BLACK_CELL_4_47 ( P3[39], G3[39], P3[47], G3[47], P4[47], G4[47] );
    BLACK_CELL BLACK_CELL_4_48 ( P3[40], G3[40], P3[48], G3[48], P4[48], G4[48] );
    BLACK_CELL BLACK_CELL_4_49 ( P3[41], G3[41], P3[49], G3[49], P4[49], G4[49] );
    BLACK_CELL BLACK_CELL_4_50 ( P3[42], G3[42], P3[50], G3[50], P4[50], G4[50] );
    BLACK_CELL BLACK_CELL_4_51 ( P3[43], G3[43], P3[51], G3[51], P4[51], G4[51] );
    BLACK_CELL BLACK_CELL_4_52 ( P3[44], G3[44], P3[52], G3[52], P4[52], G4[52] );
    BLACK_CELL BLACK_CELL_4_53 ( P3[45], G3[45], P3[53], G3[53], P4[53], G4[53] );
    BLACK_CELL BLACK_CELL_4_54 ( P3[46], G3[46], P3[54], G3[54], P4[54], G4[54] );
    BLACK_CELL BLACK_CELL_4_55 ( P3[47], G3[47], P3[55], G3[55], P4[55], G4[55] );
    BLACK_CELL BLACK_CELL_4_56 ( P3[48], G3[48], P3[56], G3[56], P4[56], G4[56] );
    BLACK_CELL BLACK_CELL_4_57 ( P3[49], G3[49], P3[57], G3[57], P4[57], G4[57] );
    BLACK_CELL BLACK_CELL_4_58 ( P3[50], G3[50], P3[58], G3[58], P4[58], G4[58] );
    BLACK_CELL BLACK_CELL_4_59 ( P3[51], G3[51], P3[59], G3[59], P4[59], G4[59] );
    BLACK_CELL BLACK_CELL_4_60 ( P3[52], G3[52], P3[60], G3[60], P4[60], G4[60] );
    BLACK_CELL BLACK_CELL_4_61 ( P3[53], G3[53], P3[61], G3[61], P4[61], G4[61] );
    BLACK_CELL BLACK_CELL_4_62 ( P3[54], G3[54], P3[62], G3[62], P4[62], G4[62] );
    BLACK_CELL BLACK_CELL_4_63 ( P3[55], G3[55], P3[63], G3[63], P4[63], G4[63] );
    BLACK_CELL BLACK_CELL_4_64 ( P3[56], G3[56], P3[64], G3[64], P4[64], G4[64] );

    // ---------------- Level 5 (span = 16) ----------------
    GRAY_CELL GRAY_CELL_25 (C[1], P4[17], G4[17], C[17]);
    GRAY_CELL GRAY_CELL_26 (C[2], P4[18], G4[18], C[18]);
    GRAY_CELL GRAY_CELL_27 (C[3], P4[19], G4[19], C[19]);
    GRAY_CELL GRAY_CELL_28 (C[4], P4[20], G4[20], C[20]);
    GRAY_CELL GRAY_CELL_29 (C[5], P4[21], G4[21], C[21]);
    GRAY_CELL GRAY_CELL_30 (C[6], P4[22], G4[22], C[22]);
    GRAY_CELL GRAY_CELL_31 (C[7], P4[23], G4[23], C[23]);
    GRAY_CELL GRAY_CELL_32 (C[8], P4[24], G4[24], C[24]);
    GRAY_CELL GRAY_CELL_33 (C[9], P4[25], G4[25], C[25]);
    GRAY_CELL GRAY_CELL_34 (C[10], P4[26], G4[26], C[26]);
    GRAY_CELL GRAY_CELL_35 (C[11], P4[27], G4[27], C[27]);
    GRAY_CELL GRAY_CELL_36 (C[12], P4[28], G4[28], C[28]);
    GRAY_CELL GRAY_CELL_37 (C[13], P4[29], G4[29], C[29]);
    GRAY_CELL GRAY_CELL_38 (C[14], P4[30], G4[30], C[30]);
    GRAY_CELL GRAY_CELL_39 (C[15], P4[31], G4[31], C[31]);
    GRAY_CELL GRAY_CELL_40 (C[16], P4[32], G4[32], C[32]);
    BLACK_CELL BLACK_CELL_5_33 ( P4[17], G4[17], P4[33], G4[33], P5[33], G5[33] );
    BLACK_CELL BLACK_CELL_5_34 ( P4[18], G4[18], P4[34], G4[34], P5[34], G5[34] );
    BLACK_CELL BLACK_CELL_5_35 ( P4[19], G4[19], P4[35], G4[35], P5[35], G5[35] );
    BLACK_CELL BLACK_CELL_5_36 ( P4[20], G4[20], P4[36], G4[36], P5[36], G5[36] );
    BLACK_CELL BLACK_CELL_5_37 ( P4[21], G4[21], P4[37], G4[37], P5[37], G5[37] );
    BLACK_CELL BLACK_CELL_5_38 ( P4[22], G4[22], P4[38], G4[38], P5[38], G5[38] );
    BLACK_CELL BLACK_CELL_5_39 ( P4[23], G4[23], P4[39], G4[39], P5[39], G5[39] );
    BLACK_CELL BLACK_CELL_5_40 ( P4[24], G4[24], P4[40], G4[40], P5[40], G5[40] );
    BLACK_CELL BLACK_CELL_5_41 ( P4[25], G4[25], P4[41], G4[41], P5[41], G5[41] );
    BLACK_CELL BLACK_CELL_5_42 ( P4[26], G4[26], P4[42], G4[42], P5[42], G5[42] );
    BLACK_CELL BLACK_CELL_5_43 ( P4[27], G4[27], P4[43], G4[43], P5[43], G5[43] );
    BLACK_CELL BLACK_CELL_5_44 ( P4[28], G4[28], P4[44], G4[44], P5[44], G5[44] );
    BLACK_CELL BLACK_CELL_5_45 ( P4[29], G4[29], P4[45], G4[45], P5[45], G5[45] );
    BLACK_CELL BLACK_CELL_5_46 ( P4[30], G4[30], P4[46], G4[46], P5[46], G5[46] );
    BLACK_CELL BLACK_CELL_5_47 ( P4[31], G4[31], P4[47], G4[47], P5[47], G5[47] );
    BLACK_CELL BLACK_CELL_5_48 ( P4[32], G4[32], P4[48], G4[48], P5[48], G5[48] );
    BLACK_CELL BLACK_CELL_5_49 ( P4[33], G4[33], P4[49], G4[49], P5[49], G5[49] );
    BLACK_CELL BLACK_CELL_5_50 ( P4[34], G4[34], P4[50], G4[50], P5[50], G5[50] );
    BLACK_CELL BLACK_CELL_5_51 ( P4[35], G4[35], P4[51], G4[51], P5[51], G5[51] );
    BLACK_CELL BLACK_CELL_5_52 ( P4[36], G4[36], P4[52], G4[52], P5[52], G5[52] );
    BLACK_CELL BLACK_CELL_5_53 ( P4[37], G4[37], P4[53], G4[53], P5[53], G5[53] );
    BLACK_CELL BLACK_CELL_5_54 ( P4[38], G4[38], P4[54], G4[54], P5[54], G5[54] );
    BLACK_CELL BLACK_CELL_5_55 ( P4[39], G4[39], P4[55], G4[55], P5[55], G5[55] );
    BLACK_CELL BLACK_CELL_5_56 ( P4[40], G4[40], P4[56], G4[56], P5[56], G5[56] );
    BLACK_CELL BLACK_CELL_5_57 ( P4[41], G4[41], P4[57], G4[57], P5[57], G5[57] );
    BLACK_CELL BLACK_CELL_5_58 ( P4[42], G4[42], P4[58], G4[58], P5[58], G5[58] );
    BLACK_CELL BLACK_CELL_5_59 ( P4[43], G4[43], P4[59], G4[59], P5[59], G5[59] );
    BLACK_CELL BLACK_CELL_5_60 ( P4[44], G4[44], P4[60], G4[60], P5[60], G5[60] );
    BLACK_CELL BLACK_CELL_5_61 ( P4[45], G4[45], P4[61], G4[61], P5[61], G5[61] );
    BLACK_CELL BLACK_CELL_5_62 ( P4[46], G4[46], P4[62], G4[62], P5[62], G5[62] );
    BLACK_CELL BLACK_CELL_5_63 ( P4[47], G4[47], P4[63], G4[63], P5[63], G5[63] );
    BLACK_CELL BLACK_CELL_5_64 ( P4[48], G4[48], P4[64], G4[64], P5[64], G5[64] );

    // ---------------- Level 6 (span = 32) ----------------
    GRAY_CELL GRAY_CELL_41 (C[1], P5[33], G5[33], C[33]);
    GRAY_CELL GRAY_CELL_42 (C[2], P5[34], G5[34], C[34]);
    GRAY_CELL GRAY_CELL_43 (C[3], P5[35], G5[35], C[35]);
    GRAY_CELL GRAY_CELL_44 (C[4], P5[36], G5[36], C[36]);
    GRAY_CELL GRAY_CELL_45 (C[5], P5[37], G5[37], C[37]);
    GRAY_CELL GRAY_CELL_46 (C[6], P5[38], G5[38], C[38]);
    GRAY_CELL GRAY_CELL_47 (C[7], P5[39], G5[39], C[39]);
    GRAY_CELL GRAY_CELL_48 (C[8], P5[40], G5[40], C[40]);
    GRAY_CELL GRAY_CELL_49 (C[9], P5[41], G5[41], C[41]);
    GRAY_CELL GRAY_CELL_50 (C[10], P5[42], G5[42], C[42]);
    GRAY_CELL GRAY_CELL_51 (C[11], P5[43], G5[43], C[43]);
    GRAY_CELL GRAY_CELL_52 (C[12], P5[44], G5[44], C[44]);
    GRAY_CELL GRAY_CELL_53 (C[13], P5[45], G5[45], C[45]);
    GRAY_CELL GRAY_CELL_54 (C[14], P5[46], G5[46], C[46]);
    GRAY_CELL GRAY_CELL_55 (C[15], P5[47], G5[47], C[47]);
    GRAY_CELL GRAY_CELL_56 (C[16], P5[48], G5[48], C[48]);
    GRAY_CELL GRAY_CELL_57 (C[17], P5[49], G5[49], C[49]);
    GRAY_CELL GRAY_CELL_58 (C[18], P5[50], G5[50], C[50]);
    GRAY_CELL GRAY_CELL_59 (C[19], P5[51], G5[51], C[51]);
    GRAY_CELL GRAY_CELL_60 (C[20], P5[52], G5[52], C[52]);
    GRAY_CELL GRAY_CELL_61 (C[21], P5[53], G5[53], C[53]);
    GRAY_CELL GRAY_CELL_62 (C[22], P5[54], G5[54], C[54]);
    GRAY_CELL GRAY_CELL_63 (C[23], P5[55], G5[55], C[55]);
    GRAY_CELL GRAY_CELL_64 (C[24], P5[56], G5[56], C[56]);
    GRAY_CELL GRAY_CELL_65 (C[25], P5[57], G5[57], C[57]);
    GRAY_CELL GRAY_CELL_66 (C[26], P5[58], G5[58], C[58]);
    GRAY_CELL GRAY_CELL_67 (C[27], P5[59], G5[59], C[59]);
    GRAY_CELL GRAY_CELL_68 (C[28], P5[60], G5[60], C[60]);
    GRAY_CELL GRAY_CELL_69 (C[29], P5[61], G5[61], C[61]);
    GRAY_CELL GRAY_CELL_70 (C[30], P5[62], G5[62], C[62]);
    GRAY_CELL GRAY_CELL_71 (C[31], P5[63], G5[63], C[63]);
    GRAY_CELL GRAY_CELL_72 (C[32], P5[64], G5[64], C[64]);

    // Post-processing: Sum and Cout
    assign Sum[0] = Cin ^ P[1];
    assign Sum[63:1] = C[63:1] ^ P[64:2];
    assign Cout = C[64];

endmodule

//--------------------------------Black Cell---------------------------

module BLACK_CELL
(
	input P_pre, G_pre,
	input P_cur, G_cur,
	output P_n, G_n
);

assign G_n = G_cur | ( P_cur & G_pre) ; 
assign P_n = P_pre & P_cur ;

endmodule

//--------------------------------Gray Cell---------------------------

module GRAY_CELL
(
	input G_pre,
	input P_cur, G_cur,
	output G_n
);

assign G_n = G_cur | ( P_cur & G_pre) ; 

endmodule




