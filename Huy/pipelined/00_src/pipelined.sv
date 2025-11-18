module pipelined (
	input logic         i_clk, 		// Global clock, active on the rising edge.
	input logic         i_reset,		// Global low active reset.
	input logic  [31:0] i_io_sw,		// Input for switches.
	input logic  [1:0]  i_io_key,		// Input for keys.
	
	output logic 		  o_ctrl,      // Control transfer instructions (branch or jump).
	output logic 		  o_mispred,   // Mispredict.
	output logic [31:0] o_pc_debug,	// Debug program counter.
	output logic        o_insn_vld,	// Instruction valid.
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
	output logic [31:0] o_io_lcd	   // Output for driving the LCD register.
);

logic stall_fetch, stall_decode, flush_decode, flush_execute;

hazard hazard1 (.i_rs1_addr_decode(rs1_addr_decode),       .i_rs2_addr_decode(rs2_addr_decode),
					 .i_rs1_addr_execute(rs1_addr_execute),     .i_rs2_addr_execute(rs2_addr_execute), 
					 .i_rd_addr_execute(rd_addr_execute),       .i_rd_addr_memory(rd_addr_memory),
					 .i_rd_addr_writeback(rd_addr_writeback),   .i_pc_sel(pc_sel),
					 .i_wb_sel_execute(wb_sel_execute),			  .i_rd_wren_memory(rd_wren_memory),
					 .i_rd_wren_writeback(rd_wren_writeback),

					 .o_foward_a_execution(foward_a_execution), .o_foward_b_execution(foward_b_execution),
					 .o_stall_fetch(stall_fetch),               .o_stall_decode(stall_decode), 
					 .o_flush_decode(flush_decode),             .o_flush_execute(flush_execute));

//      _____    _       _     
//     |  ___|__| |_ ___| |__  
//     | |_ / _ \ __/ __| '_ \ 
//     |  _|  __/ || (__| | | |
//     |_|  \___|\__\___|_| |_|
//                             

logic pc_sel;
logic [31:0] pc_fetch, pc_four, pc_next;
logic [31:0] instr_fetch, pc_instr_fetch;

assign pc_sel = pc_jump_sel_execute | pc_br_sel_execute;

logic clk_fetch;
assign clk_fetch = i_clk & ~stall_fetch;
always_ff @(posedge clk_fetch or negedge i_reset) begin
	if (~i_reset) 
		pc_fetch <= 0;
	else
		pc_fetch <= pc_next;
end

fullAdder32b pcfour (.a(pc_fetch), .b(32'h4), .cin(1'b0), .sum(pc_four)); // pc_four

always @(*) begin
	if (pc_sel)
		pc_next = alu_data_execute;
	else
		pc_next = pc_four;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		pc_instr_fetch <= 0;
	else
		pc_instr_fetch <= pc_next;
end

instrmem instr_mem (.i_clk(i_clk), .i_reset(i_reset), .i_pc(pc_instr_fetch), .o_instr(instr_fetch)); // instruction memory

//      ____                     _      
//     |  _ \  ___  ___ ___   __| | ___ 
//     | | | |/ _ \/ __/ _ \ / _` |/ _ \
//     | |_| |  __/ (_| (_) | (_| |  __/
//     |____/ \___|\___\___/ \__,_|\___|
//                                      

logic [31:0] pc_decode, instr_decode;
logic pc_jump_sel_decode, rd_wren_decode;
logic br_un_decode, opa_sel_decode, opb_sel_decode;
logic mem_wren_decode, insn_vld_decode;
logic [2:0] imm_sel_decode, br_sel_decode, sl_sel_decode, bmask_decode;
logic [4:0] alu_op_decode;
logic [1:0] wb_sel_decode;
logic [31:0] rs1_data_decode, rs2_data_decode, immext_decode;
logic [4:0] rs1_addr_decode, rs2_addr_decode, rd_addr_decode;

assign rs1_addr_decode = instr_decode[19:15];
assign rs2_addr_decode = instr_decode[24:20];
assign rd_addr_decode  = instr_decode[11:7];

logic reset_decode, clk_decode;
assign clk_decode = i_clk & ~stall_decode;
assign reset_decode = ~i_reset | ~flush_decode;
always_ff @(posedge clk_decode or negedge reset_decode) begin
	if (~reset_decode) begin
		instr_decode <= 0;
		pc_decode    <= 0;
	end else begin
		instr_decode <= instr_fetch;
		pc_decode    <= pc_fetch;
	end
end

regfile registerfile (.i_clk(i_clk),                    .i_reset(i_reset), 				
							 .i_rs1_addr(instr_decode[19:15]), .i_rs2_addr(instr_decode[24:20]), 	
							 .i_rd_addr(instr_decode[11:7]),   .i_rd_data(wb_data), 
							 .i_rd_wren(rd_wren_writeback),
							 
							 .o_rs1_data(rs1_data_decode),     .o_rs2_data(rs2_data_decode));

controlunit ctrlunit (.i_op(instr_decode[6:0]),      .i_funct3(instr_decode[14:12]),
							 .i_funct7_5(instr_decode[30]), .i_funct7_0(instr_decode[25]),
							 
							 .o_pc_sel(pc_jump_sel_decode), .o_rd_wren(rd_wren_decode), 
							 .o_br_un(br_un_decode),        .o_opa_sel(opa_sel_decode), 
							 .o_opb_sel(opb_sel_decode),    .o_mem_wren(mem_wren_decode), 
							 .o_insn_vld(insn_vld_decode),  .o_imm_sel(imm_sel_decode), 
						    .o_br_sel(br_sel_decode),      .o_alu_op(alu_op_decode),
							 .o_wb_sel(wb_sel_decode),      .o_sl_sel(sl_sel_decode),
	                   .o_bmask(bmask_decode));
							 
immgen imm_gen (.i_instr(instr_decode[31:7]), .i_imm_sel(imm_sel_decode), 

					 .o_immext(immext_decode));

//      _____                     _       
//     | ____|_  _____  ___ _   _| |_ ___ 
//     |  _| \ \/ / _ \/ __| | | | __/ _ \
//     | |___ >  <  __/ (__| |_| | ||  __/
//     |_____/_/\_\___|\___|\__,_|\__\___|
//                                        

logic pc_jump_sel_execute, pc_br_sel_execute;
logic [31:0] alu_data_execute, operand_a_execute, operand_b_execute, pre_opa_execute, pre_opb_execute;
logic [31:0] pc_execute, pc_four_execute;
logic [4:0] rs1_addr_execute, rs2_addr_execute, rd_addr_execute;
logic [31:0] rs1_data_execute, rs2_data_execute, immext_execute;
logic rd_wren_execute;
logic br_un_execute, opa_sel_execute, opb_sel_execute;
logic mem_wren_execute, insn_vld_execute;
logic [2:0] imm_sel_execute, br_sel_execute, sl_sel_execute, bmask_execute;
logic [4:0] alu_op_execute;
logic [1:0] wb_sel_execute;
logic [1:0] foward_a_execution, foward_b_execution;

logic reset_execute;
assign reset_execute = ~i_reset | ~flush_execute;
always_ff @(posedge i_clk or negedge reset_execute) begin
	if (~reset_execute) begin
		pc_execute          <= 0;
		rs1_addr_execute    <= 0;
		rs2_addr_execute    <= 0;
		rd_addr_execute     <= 0;
		rs1_data_execute    <= 0;
		rs2_data_execute    <= 0;
		immext_execute      <= 0;
		pc_jump_sel_execute <= 0;
		rd_wren_execute     <= 0;
		br_un_execute       <= 0;
		opa_sel_execute     <= 0;
		opb_sel_execute     <= 0;
		mem_wren_execute    <= 0;
		insn_vld_execute    <= 0;
		imm_sel_execute     <= 0;
		br_sel_execute      <= 0;
		sl_sel_execute      <= 0;
		bmask_execute       <= 0;
		alu_op_execute      <= 0;
		wb_sel_execute      <= 0;
	end else begin
		pc_execute          <= pc_decode;
		rs1_addr_execute    <= rs1_addr_decode;
		rs2_addr_execute    <= rs2_addr_decode;
		rd_addr_execute     <= rd_addr_decode;
		rs1_data_execute    <= rs1_data_decode;
		rs2_data_execute    <= rs2_data_decode;
		immext_execute      <= immext_decode;
		pc_jump_sel_execute <= pc_jump_sel_decode;
		rd_wren_execute     <= rd_wren_decode;
		br_un_execute       <= br_un_decode;
		opa_sel_execute     <= opa_sel_decode;
		opb_sel_execute     <= opb_sel_decode;
		mem_wren_execute    <= mem_wren_decode;
		insn_vld_execute    <= insn_vld_decode;
		imm_sel_execute     <= imm_sel_decode;
		br_sel_execute      <= br_sel_decode;
		sl_sel_execute      <= sl_sel_decode;
		bmask_execute       <= bmask_decode;
		alu_op_execute      <= alu_op_decode;
		wb_sel_execute      <= wb_sel_decode;
	end
end

mux4to1 fowardA (.i_data_0(rs1_data_execute), .i_data_1(alu_pc4_data_memory), 
					  .i_data_2(wb_data),          .i_data_3(0),
					  .i_sel(foward_a_execution),  .o_data(pre_opa_execute));
					  
mux4to1 fowardB (.i_data_0(rs2_data_execute), .i_data_1(alu_pc4_data_memory), 
					  .i_data_2(wb_data),          .i_data_3(0),
					  .i_sel(foward_b_execution),  .o_data(pre_opb_execute));
					
always @(*) begin
	if (opa_sel_execute)
		operand_a_execute = pc_execute;
	else
		operand_a_execute = pre_opa_execute;
end

always @(*) begin
	if (opb_sel_execute)
		operand_b_execute = immext_execute;
	else
		operand_b_execute = pre_opb_execute;
end

alu alu1 (.i_operand_a(operand_a_execute), .i_operand_b(operand_b_execute), .i_alu_op(alu_op_execute), .o_alu_data(alu_data_execute)); // alu
brc brc1 (.i_rs1_data(pre_opa_execute), .i_rs2_data(pre_opb_execute), .i_br_un(br_un_execute), .i_br_sel(br_sel_execute), .o_pc_sel(pc_br_sel_execute));
fullAdder32b pcfourexecute (.a(pc_execute), .b(32'h4), .cin(1'b0), .sum(pc_four_execute)); // pc_four

//      __  __                                 
//     |  \/  | ___ _ __ ___   ___  _ __ _   _ 
//     | |\/| |/ _ \ '_ ` _ \ / _ \| '__| | | |
//     | |  | |  __/ | | | | | (_) | |  | |_| |
//     |_|  |_|\___|_| |_| |_|\___/|_|   \__, |
//                                       |___/ 

logic [31:0] alu_pc4_data_memory, alu_data_memory, pc_memory, pc_four_memory;
logic [1:0] wb_sel_memory;
logic [31:0] rs2_data_memory;
logic mem_wren_memory, insn_vld_memory, rd_wren_memory;
logic [2:0] sl_sel_memory, bmask_memory;
logic [31:0] ld_data_memory;
logic [4:0] rd_addr_memory;

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) begin
		alu_data_memory <= 0;
		pc_four_memory  <= 0;
		wb_sel_memory   <= 0;
		rs2_data_memory <= 0;
		mem_wren_memory <= 0;
		sl_sel_memory   <= 0;
		bmask_memory    <= 0;
		pc_memory       <= 0;
		insn_vld_memory <= 0;
		rd_addr_memory  <= 0;
		rd_wren_memory  <= 0;
	end else begin
		alu_data_memory <= alu_data_execute;
		pc_four_memory  <= pc_four_execute;
		wb_sel_memory   <= wb_sel_execute;
		rs2_data_memory <= rs2_data_execute;
		mem_wren_memory <= mem_wren_execute;
		sl_sel_memory   <= sl_sel_execute;
		bmask_memory    <= bmask_execute;
		pc_memory       <= pc_execute;
		insn_vld_memory <= insn_vld_execute;
		rd_addr_memory  <= rd_addr_execute;
		rd_wren_memory  <= rd_wren_execute;
	end
end

always @(*) begin
	if (wb_sel_memory[0])
		alu_pc4_data_memory = alu_data_memory;
	else
		alu_pc4_data_memory = pc_four_memory;
end

lsu lsu1 (.i_clk(i_clk),                .i_reset(i_reset), 
          .i_lsu_addr(alu_data_memory), .i_st_data(rs2_data_memory), 
			 .i_lsu_wren(mem_wren_memory), .i_sl_sel(sl_sel_memory),
			 .i_io_sw(i_io_sw),            .i_bmask(bmask_memory), 
			 .i_io_key(i_io_key),
			 
			 .o_ld_data(ld_data_memory),   .o_io_ledr(o_io_ledr), 
			 .o_io_ledg(o_io_ledg),        .o_io_hex0(o_io_hex0), 
			 .o_io_hex1(o_io_hex1),        .o_io_hex2(o_io_hex2), 
			 .o_io_hex3(o_io_hex3),        .o_io_hex4(o_io_hex4), 
			 .o_io_hex5(o_io_hex5),        .o_io_hex6(o_io_hex6), 
			 .o_io_hex7(o_io_hex7),	       .o_io_lcd(o_io_lcd)); // lsu

//     __        __    _ _         ____             _    
//     \ \      / / __(_) |_ ___  | __ )  __ _  ___| | __
//      \ \ /\ / / '__| | __/ _ \ |  _ \ / _` |/ __| |/ /
//       \ V  V /| |  | | ||  __/ | |_) | (_| | (__|   < 
//        \_/\_/ |_|  |_|\__\___| |____/ \__,_|\___|_|\_\
//                                                       

logic [31:0] wb_data, alu_pc4_data_writeback;
logic rd_wren_writeback;
logic [1:0] wb_sel_writeback;
logic [4:0] rd_addr_writeback;

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) begin
		alu_pc4_data_writeback <= 0;
		wb_sel_writeback       <= 0;
		o_pc_debug             <= 0;
		o_insn_vld             <= 0;
		rd_addr_writeback      <= 0;
		rd_wren_writeback      <= 0;
	end else begin
		alu_pc4_data_writeback <= alu_pc4_data_memory;
		wb_sel_writeback       <= wb_sel_memory;
		o_pc_debug             <= pc_memory;
		o_insn_vld             <= insn_vld_memory;
		rd_addr_writeback      <= rd_addr_memory;
		rd_wren_writeback      <= rd_wren_memory;
	end
end

always @(*) begin
	if (wb_sel_writeback[1])
		wb_data = ld_data_memory;
	else
		wb_data = alu_pc4_data_writeback;
end

endmodule