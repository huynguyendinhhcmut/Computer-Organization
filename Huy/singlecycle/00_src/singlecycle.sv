module singlecycle (
	input logic         i_clk, 					// Global clock, active on the rising edge.
	input logic         i_rst_n,					// Global low active reset.
	input logic  [31:0] i_io_sw,		// Input for switches.
	input logic  [3:0]  i_io_btn,		// Input for buttons.
	
	output logic [31:0] o_pc_debug,	// Debug program counter.
	output logic        o_insn_vld,			// Instruction valid.
	output logic [31:0] o_io_ledr,	// Output for driving red LEDs.
	output logic [31:0] o_io_ledg, 	// Output for driving green LEDs.
	output logic [6:0]  o_io_hex0, 	// Output for driving 7-segment LED0 displays.
	output logic [6:0]  o_io_hex1, 	// Output for driving 7-segment LED1 displays.
	output logic [6:0]  o_io_hex2, 	// Output for driving 7-segment LED2 displays.
	output logic [6:0]  o_io_hex3, 	// Output for driving 7-segment LED3 displays.
	output logic [6:0]  o_io_hex4, 	// Output for driving 7-segment LED4 displays.
	output logic [6:0]  o_io_hex5, 	// Output for driving 7-segment LED5 displays.
	output logic [6:0]  o_io_hex6, 	// Output for driving 7-segment LED6 displays.
	output logic [6:0]  o_io_hex7, 	// Output for driving 7-segment LED7 displays.
	output logic [31:0] o_io_lcd	// Output for driving the LCD register.
);

logic [31:0] alu_data, data_gen;
logic [31:0] pc_next, pc_four, pc, instr;
logic [31:0] rs1_data, rs2_data;
logic [31:0] immext, operand_a, operand_b;
logic [31:0] final_wb_data, wb_data;
logic [31:0] ld_data;

logic pc_sel, rd_wren, opa_sel, opb_sel, br_un, br_less, br_equal, insn_vld, data_sel, mem_wren;
logic [1:0] wb_sel;
logic [2:0] imm_sel, sl_sel;
logic [3:0] alu_op;

always_comb begin // pc_next
	if (pc_sel)
		pc_next = alu_data;
	else
		pc_next = pc_four;
end

always_ff @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) 
		pc <= 32'b0;
	else
		pc <= pc_next;
end

fullAdder32b pcfour (.a(pc), .b(32'h4), .cin(1'b0), .sum(pc_four)); // pc_four

instrmem instr_mem (.i_pc(pc), .o_instr(instr)); // instruction memory

regfile reg_file (.i_clk(i_clk), .i_rst_n(i_rst_n), 
						.i_rs1_addr(instr[19:15]), .i_rs2_addr(instr[24:20]), .i_rd_addr(instr[11:7]), 
						.i_rd_data(final_wb_data), .i_rd_wren(rd_wren), .o_rs1_data(rs1_data), .o_rs2_data(rs2_data)); // register file

immgen imm_gen (.i_instr(instr[31:7]), .i_imm_sel(imm_sel), .o_immext(immext));

always_comb begin // select operand a
	if (opa_sel)
		operand_a = pc;
	else
		operand_a = rs1_data;
end

always_comb begin // select operand b
	if (opb_sel)
		operand_b = immext;
	else
		operand_b = rs2_data;
end

brc brc1 (.i_rs1_data(rs1_data), .i_rs2_data(rs2_data), .i_br_un(br_un), .o_br_less(br_less), .o_br_equal(br_equal)); // branch	

alu alu1 (.i_operand_a(operand_a), .i_operand_b(operand_b), .i_alu_op(alu_op), .o_alu_data(alu_data)); // alu

lsu lsu1 (.i_clk(i_clk), .i_rst(i_rst_n), .i_lsu_addr(alu_data), .i_st_data(rs2_data), .i_lsu_wren(mem_wren), .i_io_btn(i_io_btn),
			 .i_io_sw(i_io_sw), .i_funct3(instr[14:12]),
			 .o_ld_data(ld_data), .o_io_ledr(o_io_ledr), .o_io_ledg(o_io_ledg),
			 .o_io_hex0(o_io_hex0), .o_io_hex1(o_io_hex1), .o_io_hex2(o_io_hex2), .o_io_hex3(o_io_hex3), 
			 .o_io_hex4(o_io_hex4), .o_io_hex5(o_io_hex5), .o_io_hex6(o_io_hex6), .o_io_hex7(o_io_hex7),	
			 .o_io_lcd(o_io_lcd)); // lsu

datagen data_gen1 (.i_wb_data(wb_data), .i_sl_sel(sl_sel), .o_data_gen(data_gen)); // out data generate

always_comb begin // final wb data
	if (data_sel)
		final_wb_data = data_gen;
	else
		final_wb_data = wb_data;
end

mux4to1 sel_wb_data(.i_data_0(pc_four), .i_data_1(alu_data), .i_data_2(ld_data), .i_data_3(32'b0), .i_sel(wb_sel), .o_data(wb_data)); // wb_data select

controlunit control (.i_op(instr[6:0]), 	  .i_funct3(instr[14:12]), .i_funct7_5(instr[30]), .i_br_less(br_less), .i_br_equal(br_equal),
							.o_data_sel(data_sel), .o_pc_sel(pc_sel),       .o_rd_wren(rd_wren),    .o_br_un(br_un), 
							.o_opa_sel(opa_sel),   .o_opb_sel(opb_sel),     .o_mem_wren(mem_wren),  .o_sl_sel(sl_sel),   .o_insn_vld(insn_vld),
							.o_imm_sel(imm_sel),   .o_alu_op(alu_op),       .o_wb_sel(wb_sel));	// control unit

always_ff @(posedge i_clk or negedge i_rst_n) begin	// out pc debug
	if (~i_rst_n)
		o_pc_debug <= 32'b0;
	else
		o_pc_debug <= pc;
end

always_ff @(posedge i_clk or negedge i_rst_n) begin	// out instruction valid
	if (~i_rst_n)
		o_insn_vld <= 0;
	else
		o_insn_vld <= insn_vld;
end

endmodule
