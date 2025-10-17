module instrmem (
    input  logic [31:0] i_pc,
    output logic [31:0] o_instr
);

logic [3:0][7:0] memory [0:255];  
logic [31:0] temp_mem [0:255];   
	
initial begin
	 $readmemh("program1.txt", temp_mem);

    memory[0][0] = temp_mem[0];
    memory[0][1] = temp_mem[1];
    memory[0][2] = temp_mem[2];
    memory[0][3] = temp_mem[3];

    memory[1][0] = temp_mem[4];
    memory[1][1] = temp_mem[5];
    memory[1][2] = temp_mem[6];
    memory[1][3] = temp_mem[7];

    memory[2][0] = temp_mem[8];
    memory[2][1] = temp_mem[9];
    memory[2][2] = temp_mem[10];
    memory[2][3] = temp_mem[11];

    memory[3][0] = temp_mem[12];
    memory[3][1] = temp_mem[13];
    memory[3][2] = temp_mem[14];
    memory[3][3] = temp_mem[15];

    memory[4][0] = temp_mem[16];
    memory[4][1] = temp_mem[17];
    memory[4][2] = temp_mem[18];
    memory[4][3] = temp_mem[19];

    memory[5][0] = temp_mem[20];
    memory[5][1] = temp_mem[21];
    memory[5][2] = temp_mem[22];
    memory[5][3] = temp_mem[23];

    memory[6][0] = temp_mem[24];
    memory[6][1] = temp_mem[25];
    memory[6][2] = temp_mem[26];
    memory[6][3] = temp_mem[27];

    memory[7][0] = temp_mem[28];
    memory[7][1] = temp_mem[29];
    memory[7][2] = temp_mem[30];
    memory[7][3] = temp_mem[31];

    memory[8][0] = temp_mem[32];
    memory[8][1] = temp_mem[33];
    memory[8][2] = temp_mem[34];
    memory[8][3] = temp_mem[35];

    memory[9][0] = temp_mem[36];
    memory[9][1] = temp_mem[37];
    memory[9][2] = temp_mem[38];
    memory[9][3] = temp_mem[39];

    memory[10][0] = temp_mem[40];
    memory[10][1] = temp_mem[41];
    memory[10][2] = temp_mem[42];
    memory[10][3] = temp_mem[43];

    memory[11][0] = temp_mem[44];
    memory[11][1] = temp_mem[45];
    memory[11][2] = temp_mem[46];
    memory[11][3] = temp_mem[47];

    memory[12][0] = temp_mem[48];
    memory[12][1] = temp_mem[49];
    memory[12][2] = temp_mem[50];
    memory[12][3] = temp_mem[51];

    memory[13][0] = temp_mem[52];
    memory[13][1] = temp_mem[53];
    memory[13][2] = temp_mem[54];
    memory[13][3] = temp_mem[55];

    memory[14][0] = temp_mem[56];
    memory[14][1] = temp_mem[57];
    memory[14][2] = temp_mem[58];
    memory[14][3] = temp_mem[59];

    memory[15][0] = temp_mem[60];
    memory[15][1] = temp_mem[61];
    memory[15][2] = temp_mem[62];
    memory[15][3] = temp_mem[63];

    memory[16][0] = temp_mem[64];
    memory[16][1] = temp_mem[65];
    memory[16][2] = temp_mem[66];
    memory[16][3] = temp_mem[67];

    memory[17][0] = temp_mem[68];
    memory[17][1] = temp_mem[69];
    memory[17][2] = temp_mem[70];
    memory[17][3] = temp_mem[71];

    memory[18][0] = temp_mem[72];
    memory[18][1] = temp_mem[73];
    memory[18][2] = temp_mem[74];
    memory[18][3] = temp_mem[75];

    memory[19][0] = temp_mem[76];
    memory[19][1] = temp_mem[77];
    memory[19][2] = temp_mem[78];
    memory[19][3] = temp_mem[79];

    memory[20][0] = temp_mem[80];
    memory[20][1] = temp_mem[81];
    memory[20][2] = temp_mem[82];
    memory[20][3] = temp_mem[83];

    memory[21][0] = temp_mem[84];
    memory[21][1] = temp_mem[85];
    memory[21][2] = temp_mem[86];
    memory[21][3] = temp_mem[87];

    memory[22][0] = temp_mem[88];
    memory[22][1] = temp_mem[89];
    memory[22][2] = temp_mem[90];
    memory[22][3] = temp_mem[91];

    memory[23][0] = temp_mem[92];
    memory[23][1] = temp_mem[93];
    memory[23][2] = temp_mem[94];
    memory[23][3] = temp_mem[95];

    memory[24][0] = temp_mem[96];
    memory[24][1] = temp_mem[97];
    memory[24][2] = temp_mem[98];
    memory[24][3] = temp_mem[99];

    memory[25][0] = temp_mem[100];
    memory[25][1] = temp_mem[101];
    memory[25][2] = temp_mem[102];
    memory[25][3] = temp_mem[103];

    memory[26][0] = temp_mem[104];
    memory[26][1] = temp_mem[105];
    memory[26][2] = temp_mem[106];
    memory[26][3] = temp_mem[107];

    memory[27][0] = temp_mem[108];
    memory[27][1] = temp_mem[109];
    memory[27][2] = temp_mem[110];
    memory[27][3] = temp_mem[111];

    memory[28][0] = temp_mem[112];
    memory[28][1] = temp_mem[113];
    memory[28][2] = temp_mem[114];
    memory[28][3] = temp_mem[115];

    memory[29][0] = temp_mem[116];
    memory[29][1] = temp_mem[117];
    memory[29][2] = temp_mem[118];
    memory[29][3] = temp_mem[119];

    memory[30][0] = temp_mem[120];
    memory[30][1] = temp_mem[121];
    memory[30][2] = temp_mem[122];
    memory[30][3] = temp_mem[123];

    memory[31][0] = temp_mem[124];
    memory[31][1] = temp_mem[125];
    memory[31][2] = temp_mem[126];
    memory[31][3] = temp_mem[127];

    memory[32][0] = temp_mem[128];
    memory[32][1] = temp_mem[129];
    memory[32][2] = temp_mem[130];
    memory[32][3] = temp_mem[131];

    memory[33][0] = temp_mem[132];
    memory[33][1] = temp_mem[133];
    memory[33][2] = temp_mem[134];
    memory[33][3] = temp_mem[135];

    memory[34][0] = temp_mem[136];
    memory[34][1] = temp_mem[137];
    memory[34][2] = temp_mem[138];
    memory[34][3] = temp_mem[139];

    memory[35][0] = temp_mem[140];
    memory[35][1] = temp_mem[141];
    memory[35][2] = temp_mem[142];
    memory[35][3] = temp_mem[143];

    memory[36][0] = temp_mem[144];
    memory[36][1] = temp_mem[145];
    memory[36][2] = temp_mem[146];
    memory[36][3] = temp_mem[147];

    memory[37][0] = temp_mem[148];
    memory[37][1] = temp_mem[149];
    memory[37][2] = temp_mem[150];
    memory[37][3] = temp_mem[151];

    memory[38][0] = temp_mem[152];
    memory[38][1] = temp_mem[153];
    memory[38][2] = temp_mem[154];
    memory[38][3] = temp_mem[155];

    memory[39][0] = temp_mem[156];
    memory[39][1] = temp_mem[157];
    memory[39][2] = temp_mem[158];
    memory[39][3] = temp_mem[159];

    memory[40][0] = temp_mem[160];
    memory[40][1] = temp_mem[161];
    memory[40][2] = temp_mem[162];
    memory[40][3] = temp_mem[163];

    memory[41][0] = temp_mem[164];
    memory[41][1] = temp_mem[165];
    memory[41][2] = temp_mem[166];
    memory[41][3] = temp_mem[167];

    memory[42][0] = temp_mem[168];
    memory[42][1] = temp_mem[169];
    memory[42][2] = temp_mem[170];
    memory[42][3] = temp_mem[171];

end

assign o_instr = memory[i_pc[31:2]];

endmodule
