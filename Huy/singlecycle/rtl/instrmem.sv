module instrmem (
    input  logic [31:0] i_pc,
    output logic [31:0] o_instr
);

logic [3:0][7:0] memory [0:255];  
logic [31:0] temp_mem [0:255];   
	
initial begin
	$readmemh("/home/nguyendinhhuy/verilogCode/sem251/milestone2_singlecycle/rtl/program.txt", temp_mem);

	memory[0][0] = temp_mem[0][7:0];
	memory[0][1] = temp_mem[0][15:8];
	memory[0][2] = temp_mem[0][23:16];
	memory[0][3] = temp_mem[0][31:24];
    
   	memory[1][0] = temp_mem[1][7:0];
	memory[1][1] = temp_mem[1][15:8];
	memory[1][2] = temp_mem[1][23:16];
	memory[1][3] = temp_mem[1][31:24];
	
	memory[2][0] = temp_mem[2][7:0];
	memory[2][1] = temp_mem[2][15:8];
	memory[2][2] = temp_mem[2][23:16];
	memory[2][3] = temp_mem[2][31:24];
	
	memory[3][0] = temp_mem[3][7:0];
	memory[3][1] = temp_mem[3][15:8];
	memory[3][2] = temp_mem[3][23:16];
	memory[3][3] = temp_mem[3][31:24];
	
	memory[4][0] = temp_mem[4][7:0];
	memory[4][1] = temp_mem[4][15:8];
	memory[4][2] = temp_mem[4][23:16];
	memory[4][3] = temp_mem[4][31:24];
	
	memory[5][0] = temp_mem[5][7:0];
	memory[5][1] = temp_mem[5][15:8];
	memory[5][2] = temp_mem[5][23:16];
	memory[5][3] = temp_mem[5][31:24];
	
	memory[6][0] = temp_mem[6][7:0];
	memory[6][1] = temp_mem[6][15:8];
	memory[6][2] = temp_mem[6][23:16];
	memory[6][3] = temp_mem[6][31:24];
	
	memory[7][0] = temp_mem[7][7:0];
	memory[7][1] = temp_mem[7][15:8];
	memory[7][2] = temp_mem[7][23:16];
	memory[7][3] = temp_mem[7][31:24];
	
	memory[8][0] = temp_mem[8][7:0];
	memory[8][1] = temp_mem[8][15:8];
	memory[8][2] = temp_mem[8][23:16];
	memory[8][3] = temp_mem[8][31:24];
	
	memory[9][0] = temp_mem[9][7:0];
	memory[9][1] = temp_mem[9][15:8];
	memory[9][2] = temp_mem[9][23:16];
	memory[9][3] = temp_mem[9][31:24];
	
	memory[10][0] = temp_mem[10][7:0];
	memory[10][1] = temp_mem[10][15:8];
	memory[10][2] = temp_mem[10][23:16];
	memory[10][3] = temp_mem[10][31:24];
	
	memory[11][0] = temp_mem[11][7:0];
	memory[11][1] = temp_mem[11][15:8];
	memory[11][2] = temp_mem[11][23:16];
	memory[11][3] = temp_mem[11][31:24];
	
	memory[12][0] = temp_mem[12][7:0];
	memory[12][1] = temp_mem[12][15:8];
	memory[12][2] = temp_mem[12][23:16];
	memory[12][3] = temp_mem[12][31:24];
	
	memory[13][0] = temp_mem[13][7:0];
	memory[13][1] = temp_mem[13][15:8];
	memory[13][2] = temp_mem[13][23:16];
	memory[13][3] = temp_mem[13][31:24];
	
	memory[14][0] = temp_mem[14][7:0];
	memory[14][1] = temp_mem[14][15:8];
	memory[14][2] = temp_mem[14][23:16];
	memory[14][3] = temp_mem[14][31:24];
	
	memory[15][0] = temp_mem[15][7:0];
	memory[15][1] = temp_mem[15][15:8];
	memory[15][2] = temp_mem[15][23:16];
	memory[15][3] = temp_mem[15][31:24];
	
	memory[16][0] = temp_mem[16][7:0];
	memory[16][1] = temp_mem[16][15:8];
	memory[16][2] = temp_mem[16][23:16];
	memory[16][3] = temp_mem[16][31:24];
	
	memory[17][0] = temp_mem[17][7:0];
	memory[17][1] = temp_mem[17][15:8];
	memory[17][2] = temp_mem[17][23:16];
	memory[17][3] = temp_mem[17][31:24];
	
	memory[18][0] = temp_mem[18][7:0];
	memory[18][1] = temp_mem[18][15:8];
	memory[18][2] = temp_mem[18][23:16];
	memory[18][3] = temp_mem[18][31:24];
	
	memory[19][0] = temp_mem[19][7:0];
	memory[19][1] = temp_mem[19][15:8];
	memory[19][2] = temp_mem[19][23:16];
	memory[19][3] = temp_mem[19][31:24];
	
	memory[20][0] = temp_mem[20][7:0];
	memory[20][1] = temp_mem[20][15:8];
	memory[20][2] = temp_mem[20][23:16];
	memory[20][3] = temp_mem[20][31:24];
	
	memory[21][0] = temp_mem[21][7:0];
	memory[21][1] = temp_mem[21][15:8];
	memory[21][2] = temp_mem[21][23:16];
	memory[21][3] = temp_mem[21][31:24];
	
	memory[22][0] = temp_mem[22][7:0];
	memory[22][1] = temp_mem[22][15:8];
	memory[22][2] = temp_mem[22][23:16];
	memory[22][3] = temp_mem[22][31:24];
	
	memory[23][0] = temp_mem[23][7:0];
	memory[23][1] = temp_mem[23][15:8];
	memory[23][2] = temp_mem[23][23:16];
	memory[23][3] = temp_mem[23][31:24];
	
	memory[24][0] = temp_mem[24][7:0];
	memory[24][1] = temp_mem[24][15:8];
	memory[24][2] = temp_mem[24][23:16];
	memory[24][3] = temp_mem[24][31:24];
	
	memory[25][0] = temp_mem[25][7:0];
	memory[25][1] = temp_mem[25][15:8];
	memory[25][2] = temp_mem[25][23:16];
	memory[25][3] = temp_mem[25][31:24];
	
	memory[26][0] = temp_mem[26][7:0];
	memory[26][1] = temp_mem[26][15:8];
	memory[26][2] = temp_mem[26][23:16];
	memory[26][3] = temp_mem[26][31:24];
	
	memory[27][0] = temp_mem[27][7:0];
	memory[27][1] = temp_mem[27][15:8];
	memory[27][2] = temp_mem[27][23:16];
	memory[27][3] = temp_mem[27][31:24];
	
	memory[28][0] = temp_mem[28][7:0];
	memory[28][1] = temp_mem[28][15:8];
	memory[28][2] = temp_mem[28][23:16];
	memory[28][3] = temp_mem[28][31:24];
	
	memory[29][0] = temp_mem[29][7:0];
	memory[29][1] = temp_mem[29][15:8];
	memory[29][2] = temp_mem[29][23:16];
	memory[29][3] = temp_mem[29][31:24];
	
	memory[30][0] = temp_mem[30][7:0];
	memory[30][1] = temp_mem[30][15:8];
	memory[30][2] = temp_mem[30][23:16];
	memory[30][3] = temp_mem[30][31:24];
	
	memory[31][0] = temp_mem[31][7:0];
	memory[31][1] = temp_mem[31][15:8];
	memory[31][2] = temp_mem[31][23:16];
	memory[31][3] = temp_mem[31][31:24];
	
	memory[32][0] = temp_mem[32][7:0];
	memory[32][1] = temp_mem[32][15:8];
	memory[32][2] = temp_mem[32][23:16];
	memory[32][3] = temp_mem[32][31:24];
	
	memory[33][0] = temp_mem[33][7:0];
	memory[33][1] = temp_mem[33][15:8];
	memory[33][2] = temp_mem[33][23:16];
	memory[33][3] = temp_mem[33][31:24];
	
	memory[34][0] = temp_mem[34][7:0];
	memory[34][1] = temp_mem[34][15:8];
	memory[34][2] = temp_mem[34][23:16];
	memory[34][3] = temp_mem[34][31:24];
	
	memory[35][0] = temp_mem[35][7:0];
	memory[35][1] = temp_mem[35][15:8];
	memory[35][2] = temp_mem[35][23:16];
	memory[35][3] = temp_mem[35][31:24];
	
	memory[36][0] = temp_mem[36][7:0];
	memory[36][1] = temp_mem[36][15:8];
	memory[36][2] = temp_mem[36][23:16];
	memory[36][3] = temp_mem[36][31:24];
	
	memory[37][0] = temp_mem[37][7:0];
	memory[37][1] = temp_mem[37][15:8];
	memory[37][2] = temp_mem[37][23:16];
	memory[37][3] = temp_mem[37][31:24];
	
	memory[38][0] = temp_mem[38][7:0];
	memory[38][1] = temp_mem[38][15:8];
	memory[38][2] = temp_mem[38][23:16];
	memory[38][3] = temp_mem[38][31:24];
	
	memory[39][0] = temp_mem[39][7:0];
	memory[39][1] = temp_mem[39][15:8];
	memory[39][2] = temp_mem[39][23:16];
	memory[39][3] = temp_mem[39][31:24];
	
	memory[40][0] = temp_mem[40][7:0];
	memory[40][1] = temp_mem[40][15:8];
	memory[40][2] = temp_mem[40][23:16];
	memory[40][3] = temp_mem[40][31:24];
	
	memory[41][0] = temp_mem[41][7:0];
	memory[41][1] = temp_mem[41][15:8];
	memory[41][2] = temp_mem[41][23:16];
	memory[41][3] = temp_mem[41][31:24];
	
	memory[42][0] = temp_mem[42][7:0];
	memory[42][1] = temp_mem[42][15:8];
	memory[42][2] = temp_mem[42][23:16];
	memory[42][3] = temp_mem[42][31:24];
	
end

assign o_instr = memory[i_pc[31:2]];

endmodule

