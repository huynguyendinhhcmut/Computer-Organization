module KSA_stage7 (
	input logic [31:0] g_in,
	input logic [31:0] p_in,
	input logic cin,
	output logic [32:0] Carry
);
	
assign Carry[0] = cin;
assign Carry[1] = g_in[0] | (p_in[0] & cin);
assign Carry[2] = g_in[1] | (p_in[1] & cin);
assign Carry[3] = g_in[2] | (p_in[2] & cin);
assign Carry[4] = g_in[3] | (p_in[3] & cin);
assign Carry[5] = g_in[4] | (p_in[4] & cin);
assign Carry[6] = g_in[5] | (p_in[5] & cin);
assign Carry[7] = g_in[6] | (p_in[6] & cin);
assign Carry[8] = g_in[7] | (p_in[7] & cin);
assign Carry[9] = g_in[8] | (p_in[8] & cin);
assign Carry[10] = g_in[9] | (p_in[9] & cin);
assign Carry[11] = g_in[10] | (p_in[10] & cin);
assign Carry[12] = g_in[11] | (p_in[11] & cin);
assign Carry[13] = g_in[12] | (p_in[12] & cin);
assign Carry[14] = g_in[13] | (p_in[13] & cin);
assign Carry[15] = g_in[14] | (p_in[14] & cin);
assign Carry[16] = g_in[15] | (p_in[15] & cin);
assign Carry[17] = g_in[16] | (p_in[16] & cin);
assign Carry[18] = g_in[17] | (p_in[17] & cin);
assign Carry[19] = g_in[18] | (p_in[18] & cin);
assign Carry[20] = g_in[19] | (p_in[19] & cin);
assign Carry[21] = g_in[20] | (p_in[20] & cin);
assign Carry[22] = g_in[21] | (p_in[21] & cin);
assign Carry[23] = g_in[22] | (p_in[22] & cin);
assign Carry[24] = g_in[23] | (p_in[23] & cin);
assign Carry[25] = g_in[24] | (p_in[24] & cin);
assign Carry[26] = g_in[25] | (p_in[25] & cin);
assign Carry[27] = g_in[26] | (p_in[26] & cin);
assign Carry[28] = g_in[27] | (p_in[27] & cin);
assign Carry[29] = g_in[28] | (p_in[28] & cin);
assign Carry[30] = g_in[29] | (p_in[29] & cin);
assign Carry[31] = g_in[30] | (p_in[30] & cin);
assign Carry[32] = g_in[31] | (p_in[31] & cin);

endmodule : KSA_stage7