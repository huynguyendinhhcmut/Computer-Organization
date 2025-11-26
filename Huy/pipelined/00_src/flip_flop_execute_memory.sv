module flip_flop_execute_memory (
	input logic         i_clk, i_reset,
	input logic  [31:0] i_pc_execute, i_pc_four_execute,
	input logic         i_rd_wren_execute, i_insn_vld_execute, i_mem_wren_execute,
	input logic  [1:0]  i_wb_sel_execute,
	input logic  [2:0]  i_sl_sel_execute, i_bmask_execute,
	input logic  [31:0] i_alu_data_execute,
	input logic  [4:0]  i_rd_addr_execute,
	input logic  [31:0] i_pre_opb_execute,
	
	output logic [31:0] o_pc_memory, o_pc_four_memory,
	output logic        o_rd_wren_memory, o_insn_vld_memory, o_mem_wren_memory,
	output logic [1:0]  o_wb_sel_memory,
	output logic [2:0]  o_sl_sel_memory, o_bmask_memory,
	output logic [31:0] o_alu_data_memory,
	output logic [4:0]  o_rd_addr_memory,
	output logic [31:0] o_pre_opb_memory
);

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_pc_memory <= 0;
	else
		o_pc_memory <= i_pc_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_pc_four_memory <= 0;
	else
		o_pc_four_memory <= i_pc_four_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_rd_wren_memory <= 0;
	else
		o_rd_wren_memory <= i_rd_wren_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_insn_vld_memory <= 0;
	else
		o_insn_vld_memory <= i_insn_vld_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_mem_wren_memory <= 0;
	else
		o_mem_wren_memory <= i_mem_wren_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_wb_sel_memory <= 0;
	else
		o_wb_sel_memory <= i_wb_sel_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_sl_sel_memory <= 0;
	else
		o_sl_sel_memory <= i_sl_sel_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_bmask_memory <= 0;
	else
		o_bmask_memory <= i_bmask_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_alu_data_memory <= 0;
	else
		o_alu_data_memory <= i_alu_data_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_rd_addr_memory <= 0;
	else
		o_rd_addr_memory <= i_rd_addr_execute;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_pre_opb_memory <= 0;
	else
		o_pre_opb_memory <= i_pre_opb_execute;
end

endmodule
