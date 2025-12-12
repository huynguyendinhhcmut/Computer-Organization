module KSA_stage6 (
	input logic [31:0] g_in,
	input logic [31:0] p_in,
	output logic [31:0] g_out,
	output logic [31:0] p_out
);

//g0 & p0
assign g_out[0] = g_in[0];
assign p_out[0] = p_in[0];
//g1-0 & p1-0
assign g_out[1] = g_in[1];
assign p_out[1] = p_in[1];
//g2-0 & p2-0
assign g_out[2] = g_in[2];
assign p_out[2] = p_in[2];
//g3-0 & p3-0
assign g_out[3] = g_in[3];
assign p_out[3] = p_in[3];
//g4-0 & p4-0
assign g_out[4] = g_in[4];
assign p_out[4] = p_in[4];
//g5-0 & p5-0
assign g_out[5] = g_in[5];
assign p_out[5] = p_in[5];
//g6-0 & p6-0
assign g_out[6] = g_in[6];
assign p_out[6] = p_in[6];
//g7-0 & p7-0
assign g_out[7] = g_in[7];
assign p_out[7] = p_in[7];  
//g8-0 & p8-0
assign g_out[8] = g_in[8];
assign p_out[8] = p_in[8];
//g9-0 & p9-0
assign g_out[9] = g_in[9];
assign p_out[9] = p_in[9];
//g10-0 & p10-0
assign g_out[10] = g_in[10];
assign p_out[10] = p_in[10];
//g11-0 & p11-0
assign g_out[11] = g_in[11];
assign p_out[11] = p_in[11];
//g12-0 & p12-0
assign g_out[12] = g_in[12];
assign p_out[12] = p_in[12];
//g13-0 & p13-0
assign g_out[13] = g_in[13];
assign p_out[13] = p_in[13];
//g14-0 & p14-0
assign g_out[14] = g_in[14];
assign p_out[14] = p_in[14];
//g15-0 & p15-0
assign g_out[15] = g_in[15];
assign p_out[15] = p_in[15];

black_cell black_16to0 (.Gik(g_in[16]), .Gkj(g_in[0]), .Pik(p_in[16]), .Pkj(p_in[0]), .G(g_out[16]), .P(p_out[16]));
black_cell black_17to1 (.Gik(g_in[17]), .Gkj(g_in[1]), .Pik(p_in[17]), .Pkj(p_in[1]), .G(g_out[17]), .P(p_out[17]));
black_cell black_18to2 (.Gik(g_in[18]), .Gkj(g_in[2]), .Pik(p_in[18]), .Pkj(p_in[2]), .G(g_out[18]), .P(p_out[18]));
black_cell black_19to3 (.Gik(g_in[19]), .Gkj(g_in[3]), .Pik(p_in[19]), .Pkj(p_in[3]), .G(g_out[19]), .P(p_out[19]));
black_cell black_20to4 (.Gik(g_in[20]), .Gkj(g_in[4]), .Pik(p_in[20]), .Pkj(p_in[4]), .G(g_out[20]), .P(p_out[20]));
black_cell black_21to5 (.Gik(g_in[21]), .Gkj(g_in[5]), .Pik(p_in[21]), .Pkj(p_in[5]), .G(g_out[21]), .P(p_out[21]));
black_cell black_22to6 (.Gik(g_in[22]), .Gkj(g_in[6]), .Pik(p_in[22]), .Pkj(p_in[6]), .G(g_out[22]), .P(p_out[22]));
black_cell black_23to7 (.Gik(g_in[23]), .Gkj(g_in[7]), .Pik(p_in[23]), .Pkj(p_in[7]), .G(g_out[23]), .P(p_out[23]));
black_cell black_24to8 (.Gik(g_in[24]), .Gkj(g_in[8]), .Pik(p_in[24]), .Pkj(p_in[8]), .G(g_out[24]), .P(p_out[24]));
black_cell black_25to9 (.Gik(g_in[25]), .Gkj(g_in[9]), .Pik(p_in[25]), .Pkj(p_in[9]), .G(g_out[25]), .P(p_out[25]));
black_cell black_26to10 (.Gik(g_in[26]), .Gkj(g_in[10]), .Pik(p_in[26]), .Pkj(p_in[10]), .G(g_out[26]), .P(p_out[26]));
black_cell black_27to11 (.Gik(g_in[27]), .Gkj(g_in[11]), .Pik(p_in[27]), .Pkj(p_in[11]), .G(g_out[27]), .P(p_out[27]));
black_cell black_28to12 (.Gik(g_in[28]), .Gkj(g_in[12]), .Pik(p_in[28]), .Pkj(p_in[12]), .G(g_out[28]), .P(p_out[28]));
black_cell black_29to13 (.Gik(g_in[29]), .Gkj(g_in[13]), .Pik(p_in[29]), .Pkj(p_in[13]), .G(g_out[29]), .P(p_out[29]));
black_cell black_30to14 (.Gik(g_in[30]), .Gkj(g_in[14]), .Pik(p_in[30]), .Pkj(p_in[14]), .G(g_out[30]), .P(p_out[30]));
black_cell black_31to15 (.Gik(g_in[31]), .Gkj(g_in[15]), .Pik(p_in[31]), .Pkj(p_in[15]), .G(g_out[31]), .P(p_out[31]));

endmodule : KSA_stage6