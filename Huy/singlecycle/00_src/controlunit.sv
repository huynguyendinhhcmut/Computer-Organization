module controlunit (
	input logic [6:0] i_op,
	input logic [14:12] i_funct3,
	input logic i_funct7_5,
	input logic i_funct7_0,
	input logic i_br_less, i_br_equal,
	
	output logic o_data_sel, o_pc_sel, o_rd_wren, o_br_un, o_opa_sel, o_opb_sel, o_mem_wren, o_insn_vld,
	output logic [2:0] o_imm_sel,
	output logic [4:0] o_alu_op, 
	output logic [1:0] o_wb_sel,
	output logic [2:0] o_sl_sel,
	output logic [2:0] o_bmask
);

logic rv32i;
logic R_type, S_type, B_type, J_type;
logic I_type_3, I_type_19, I_type_103;
logic U_type_23, U_type_55;
logic lb, lh, lw, lbu, lhu;																			                     // I_type(3)
logic addi, slli, slti, sltiu, xori, srli, srai, ori, andi;									                     // I_type(19)
logic auipc;																								                     // U_type(23)
logic sb, sh, sw;														   								                     // S_type(35)
logic add, sub, sll, slt, sltu, XOR, srl, sra, OR, AND, mul, mulh, mulhsu, mulhu, div, divu, rem, remu;	// R_type(51)
logic lui;																									                     // U_type(55)
logic beq, bne, blt, bge, bltu, bgeu;																                     // B_type(99)
logic jalr;																									                     // I_type(103)
logic jal;																									                     // J_type(111)

//      ___           _                   _   _               _____                      
//     |_ _|_ __  ___| |_ _ __ _   _  ___| |_(_) ___  _ __   |_   _|   _ _ __   ___  ___ 
//      | || '_ \/ __| __| '__| | | |/ __| __| |/ _ \| '_ \    | || | | | '_ \ / _ \/ __|
//      | || | | \__ \ |_| |  | |_| | (__| |_| | (_) | | | |   | || |_| | |_) |  __/\__ \
//     |___|_| |_|___/\__|_|   \__,_|\___|\__|_|\___/|_| |_|   |_| \__, | .__/ \___||___/
//                                                                 |___/|_|              
assign rv32i      =  i_op[0] &  i_op[1];
assign I_type_3   = ~i_op[6] & ~i_op[5] & ~i_op[4] & ~i_op[3] & ~i_op[2] & rv32i; 	// 0000011(3) 
assign I_type_19  = ~i_op[6] & ~i_op[5] &  i_op[4] & ~i_op[3] & ~i_op[2] & rv32i; 	// 0010011(19)
assign I_type_103 =  i_op[6] &  i_op[5] & ~i_op[4] & ~i_op[3] &  i_op[2] & rv32i;	// 1100111(103)
assign S_type     = ~i_op[6] &  i_op[5] & ~i_op[4] & ~i_op[3] & ~i_op[2] & rv32i;	// 0100011(35)
assign R_type     = ~i_op[6] &  i_op[5] &  i_op[4] & ~i_op[3] & ~i_op[2] & rv32i;	// 0110011(51)
assign B_type     =  i_op[6] &  i_op[5] & ~i_op[4] & ~i_op[3] & ~i_op[2] & rv32i;	// 1100011(99)
assign U_type_23  = ~i_op[6] & ~i_op[5] &  i_op[4] & ~i_op[3] &  i_op[2] & rv32i;	// 0010111(23)
assign U_type_55  = ~i_op[6] &  i_op[5] &  i_op[4] & ~i_op[3] &  i_op[2] & rv32i;	// 0110111(55)
assign J_type     =  i_op[6] &  i_op[5] & ~i_op[4] &  i_op[3] &  i_op[2] & rv32i;	// 1101111(111)


//      ___       _                         ___           _                   _   _                 
//     |_ _|_ __ | |_ ___  __ _  ___ _ __  |_ _|_ __  ___| |_ _ __ _   _  ___| |_(_) ___  _ __  ___ 
//      | || '_ \| __/ _ \/ _` |/ _ \ '__|  | || '_ \/ __| __| '__| | | |/ __| __| |/ _ \| '_ \/ __|
//      | || | | | ||  __/ (_| |  __/ |     | || | | \__ \ |_| |  | |_| | (__| |_| | (_) | | | \__ \
//     |___|_| |_|\__\___|\__, |\___|_|    |___|_| |_|___/\__|_|   \__,_|\___|\__|_|\___/|_| |_|___/
//                        |___/  

// I_type(3)                                                                  
assign lb    =               ~i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & I_type_3;		// funct3 = 000
assign lh    =               ~i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & I_type_3;		// funct3 = 001
assign lw    =               ~i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & I_type_3;		// funct3 = 010
assign lbu   =                i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & I_type_3;		// funct3 = 100
assign lhu   =                i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & I_type_3;		// funct3 = 101

// I_type(19)
assign addi  =               ~i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & I_type_19;	// funct3 = 000
assign slli  = ~i_funct7_5 & ~i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & I_type_19;	// funct3 = 001, funct7[30] = 0
assign slti  =               ~i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & I_type_19;	// funct3 = 010
assign sltiu =               ~i_funct3[14] &  i_funct3[13] &  i_funct3[12] & I_type_19;	// fucnt3 = 011
assign xori  =                i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & I_type_19;	// fucnt3 = 100
assign srli  = ~i_funct7_5 &  i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & I_type_19;	// fucnt3 = 101, funct7[30] = 0
assign srai  =  i_funct7_5 &  i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & I_type_19;	// fucnt3 = 101, funct7[30] = 1
assign ori   =                i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & I_type_19;	// fucnt3 = 110
assign andi  =                i_funct3[14] &  i_funct3[13] &  i_funct3[12] & I_type_19;	// fucnt3 = 111

// U_type(23)
assign auipc = U_type_23;

// S_type(35)
assign sb    =               ~i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & S_type;		// funct3 = 000
assign sh    =               ~i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & S_type;		// funct3 = 001
assign sw    =               ~i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & S_type;		// funct3 = 010

// R_type(51)
assign add    = ~i_funct7_5 & ~i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 000, funct7[30] = 0
assign sub    =  i_funct7_5 & ~i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 000, funct7[30] = 1
assign sll    = ~i_funct7_5 & ~i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 001, funct7[30] = 0
assign slt    = ~i_funct7_5 & ~i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 010, funct7[30] = 0
assign sltu   = ~i_funct7_5 & ~i_funct3[14] &  i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 011, funct7[30] = 0 
assign XOR    = ~i_funct7_5 &  i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 100, funct7[30] = 0
assign srl    = ~i_funct7_5 &  i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 101, funct7[30] = 0
assign sra    =  i_funct7_5 &  i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 101, funct7[30] = 1
assign OR     = ~i_funct7_5 &  i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 110, funct7[30] = 0
assign AND    = ~i_funct7_5 &  i_funct3[14] &  i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 111, funct7[30] = 0
assign mul    =  i_funct7_0 & ~i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 000, funct7[25] = 1
assign mulh   =  i_funct7_0 & ~i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 001, funct7[25] = 1
assign mulhsu =  i_funct7_0 & ~i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 010, funct7[25] = 1
assign mulhu  =  i_funct7_0 & ~i_funct3[14] &  i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 011, funct7[25] = 1
assign div    =  i_funct7_0 &  i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 100, funct7[25] = 1
assign divu   =  i_funct7_0 &  i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 101, funct7[25] = 1
assign rem    =  i_funct7_0 &  i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & R_type;		// funct3 = 110, funct7[25] = 1
assign remu   =  i_funct7_0 &  i_funct3[14] &  i_funct3[13] &  i_funct3[12] & R_type;		// funct3 = 111, funct7[25] = 1

// U_type(55)
assign lui   = U_type_55;

// B_type(99)
assign beq   =               ~i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & B_type;		// funct3 = 000
assign bne   =               ~i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & B_type;		// funct3 = 001
assign blt   =                i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & B_type;		// funct3 = 100
assign bge   =                i_funct3[14] & ~i_funct3[13] &  i_funct3[12] & B_type;		// funct3 = 101
assign bltu  =                i_funct3[14] &  i_funct3[13] & ~i_funct3[12] & B_type;		// funct3 = 110
assign bgeu  =                i_funct3[14] &  i_funct3[13] &  i_funct3[12] & B_type;		// funct3 = 111

// I_type(103)
assign jalr  =               ~i_funct3[14] & ~i_funct3[13] & ~i_funct3[12] & I_type_103;	// funct3 = 000

// J_type(111) 
assign jal 	 = J_type;

//      ___           _                   _   _                   ____                     _           
//     |_ _|_ __  ___| |_ _ __ _   _  ___| |_(_) ___  _ __  ___  |  _ \  ___  ___ ___   __| | ___ _ __ 
//      | || '_ \/ __| __| '__| | | |/ __| __| |/ _ \| '_ \/ __| | | | |/ _ \/ __/ _ \ / _` |/ _ \ '__|
//      | || | | \__ \ |_| |  | |_| | (__| |_| | (_) | | | \__ \ | |_| |  __/ (_| (_) | (_| |  __/ |   
//     |___|_| |_|___/\__|_|   \__,_|\___|\__|_|\___/|_| |_|___/ |____/ \___|\___\___/ \__,_|\___|_|   
// 
                                                                                                    					  
always_comb begin
	o_pc_sel  = 0; o_rd_wren = 0;        o_imm_sel  = 3'b000; o_insn_vld = 0;     o_br_un    = 0; o_opa_sel = 0; 
	o_opb_sel = 0; o_alu_op  = 5'b00000; o_mem_wren = 0;      o_wb_sel   = 2'b00; o_data_sel = 0; o_sl_sel  = 3'b000;
		
	if (I_type_3) begin
		o_pc_sel  = 0; o_rd_wren = 1;        o_imm_sel  = 3'b000; o_opa_sel  = 0; 
		o_opb_sel = 1; o_alu_op  = 5'b00000; o_mem_wren = 0;      o_wb_sel   = 2'b10; o_data_sel = 1; 
		if (lb) begin		  
			o_sl_sel = 3'b000; o_insn_vld = 1;
		end else if (lh)  begin
			o_sl_sel = 3'b001; o_insn_vld = 1;
		end else if (lw)  begin
			o_sl_sel = 3'b010; o_insn_vld = 1;
		end else if (lbu) begin 
			o_sl_sel = 3'b011; o_insn_vld = 1;
		end else if (lhu) begin
			o_sl_sel = 3'b100; o_insn_vld = 1;
		end
	end
		
	else if (I_type_19) begin
		o_pc_sel  = 0; o_rd_wren = 1;  o_imm_sel = 3'b000; o_opa_sel = 0; 
		o_opb_sel = 1; o_mem_wren = 0; o_wb_sel  = 2'b01;  o_data_sel = 0;
		if (addi) begin
			o_alu_op = 5'b00000; o_insn_vld = 1;
		end else if (slli)  begin
			o_alu_op = 5'b00111; o_insn_vld = 1;	
		end else if (slti)  begin
			o_alu_op = 5'b00010; o_insn_vld = 1;
		end else if (sltiu) begin
			o_alu_op = 5'b00011; o_insn_vld = 1;
		end else if (xori)  begin
			o_alu_op = 5'b00100; o_insn_vld = 1;
		end else if (srli)  begin
			o_alu_op = 5'b01000; o_insn_vld = 1;
		end else if (srai)  begin
			o_alu_op = 5'b01001; o_insn_vld = 1;
		end else if (ori)   begin
			o_alu_op = 5'b00101; o_insn_vld = 1;
		end else if (andi)  begin
			o_alu_op = 5'b00110; o_insn_vld = 1;	
		end
	end
	
	else if (auipc) begin
		o_pc_sel  = 0; o_rd_wren = 1;        o_imm_sel  = 3'b100; o_insn_vld = 1;     o_opa_sel  = 1; 
		o_opb_sel = 1; o_alu_op  = 5'b00000; o_mem_wren = 0;      o_wb_sel   = 2'b01; o_data_sel = 0;
	end
	
	else if (S_type) begin	// sb, sw, sh
		o_pc_sel  = 0; o_rd_wren = 0;        o_imm_sel  = 3'b001; o_insn_vld = 1;     o_opa_sel  = 0; 
		o_opb_sel = 1; o_alu_op  = 5'b00000; o_mem_wren = 1;      o_data_sel = 0;	
	end

	else if (R_type) begin
		o_pc_sel  = 0; o_rd_wren = 1;  o_insn_vld = 1;     o_opa_sel = 0; 
		o_opb_sel = 0; o_mem_wren = 0; o_wb_sel   = 2'b01; o_data_sel = 0;
		if (add) begin
			o_alu_op = 5'b00000; o_insn_vld = 1;	
		end else if (sub)  begin  
			o_alu_op = 5'b00001; o_insn_vld = 1;	
		end else if (sll)  begin  
			o_alu_op = 5'b00111; o_insn_vld = 1;	
		end else if (slt)  begin  
			o_alu_op = 5'b00010; o_insn_vld = 1;	
		end else if (sltu) begin 
			o_alu_op = 5'b00011; o_insn_vld = 1;	
		end else if (XOR) begin  
			o_alu_op = 5'b00100; o_insn_vld = 1;	
		end else if (srl) begin  
			o_alu_op = 5'b01000; o_insn_vld = 1;	
		end else if (sra) begin  
			o_alu_op = 5'b01001; o_insn_vld = 1;	
		end else if (OR)  begin   
			o_alu_op = 5'b00101; o_insn_vld = 1;	
		end else if (AND) begin  
			o_alu_op = 5'b00110; o_insn_vld = 1;
		end else if (mul) begin  
			o_alu_op = 5'b01011; o_insn_vld = 1;
		end else if (mulh) begin  
			o_alu_op = 5'b01100; o_insn_vld = 1;
		end else if (mulhsu) begin  
			o_alu_op = 5'b01101; o_insn_vld = 1;
		end else if (mulhu) begin  
			o_alu_op = 5'b01110; o_insn_vld = 1;
		end else if (div) begin  
			o_alu_op = 5'b01111; o_insn_vld = 1;
		end else if (divu) begin  
			o_alu_op = 5'b10000; o_insn_vld = 1;
		end else if (rem) begin  
			o_alu_op = 5'b10001; o_insn_vld = 1;
		end else if (remu) begin  
			o_alu_op = 5'b10010; o_insn_vld = 1;
		end
	end
	
	else if (lui) begin
		o_pc_sel  = 0; o_rd_wren = 1;        o_imm_sel  = 3'b100; o_insn_vld = 1;
		o_opb_sel = 1; o_alu_op  = 5'b01010; o_mem_wren = 0;      o_wb_sel   = 2'b01; o_data_sel = 0;
	end
	
	else if (B_type) begin
		o_rd_wren = 0; o_imm_sel = 3'b010;   o_insn_vld = 1; o_opa_sel  = 1; 
		o_opb_sel = 1; o_alu_op  = 5'b00000; o_mem_wren = 0; o_data_sel = 0;
		if (beq) begin
			o_br_un = 1;
			if (i_br_equal) 
				o_pc_sel = 1;
			else
				o_pc_sel = 0;
		end else if (bne) begin
			o_br_un = 1;
			if (~i_br_equal) 
				o_pc_sel = 1;
			else
				o_pc_sel = 0;
		end else if (blt) begin
			o_br_un = 1;
			if (i_br_less) 
				o_pc_sel = 1;
			else
				o_pc_sel = 0;
		end else if (bge) begin
			o_br_un = 1;
			if (~i_br_less) 
				o_pc_sel = 1;
			else
				o_pc_sel = 0;
		end else if (bltu) begin
			o_br_un = 0;
			if (i_br_less) 
				o_pc_sel = 1;
			else
				o_pc_sel = 0;
		end else if (bgeu) begin
			o_br_un = 0;
			if (~i_br_less) 
				o_pc_sel = 1;
			else
				o_pc_sel = 0;
		end
	end

	else if (jalr) begin	  // jalr
		o_pc_sel  = 1; o_rd_wren = 1;       o_imm_sel  = 3'b000; o_insn_vld = 1;     o_opa_sel  = 0; 
		o_opb_sel = 1; o_alu_op  = 5'b00000; o_mem_wren = 0;      o_wb_sel   = 2'b00; o_data_sel = 0;
	end
	
	else if (jal) begin	  // jal
		o_pc_sel  = 1; o_rd_wren = 1;       o_imm_sel  = 3'b011; o_insn_vld = 1;     o_opa_sel  = 1; 
		o_opb_sel = 1; o_alu_op  = 5'b00000; o_mem_wren = 0;      o_wb_sel   = 2'b00; o_data_sel = 0;
	end
	
end

assign o_bmask = {sw, sh, sb};
	
endmodule