module flip_flop_memory_writeback (
	input logic         i_clk, i_reset,
	input logic         i_rd_wren_memory, i_insn_vld_memory,
	input logic  [31:0] i_pc_memory,
	input logic  [1:0]  i_wb_sel_memory,
	input logic  [31:0] i_alu_pc4_data_memory,
	input logic  [4:0]  i_rd_addr_memory,
	input logic 	    i_ctrl_memory,
	input logic  [31:0] i_io_sw, 
	input logic  [1:0]  i_io_key,
	
	output logic        o_rd_wren_writeback, o_insn_vld_writeback,
	output logic [31:0] o_pc_writeback,
	output logic [1:0]  o_wb_sel_writeback,
	output logic [31:0] o_alu_pc4_data_writeback,
	output logic [4:0]  o_rd_addr_writeback,
	output logic 	    o_ctrl,
	output logic [31:0] o_io_sw, 
	output logic [1:0]  o_io_key
);

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_rd_wren_writeback <= 0;
	else 
		o_rd_wren_writeback <= i_rd_wren_memory;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_insn_vld_writeback <= 0;
	else 
		o_insn_vld_writeback <= i_insn_vld_memory;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_pc_writeback <= 0;
	else 
		o_pc_writeback <= i_pc_memory;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_wb_sel_writeback <= 0;
	else 
		o_wb_sel_writeback <= i_wb_sel_memory;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_alu_pc4_data_writeback <= 0;
	else 
		o_alu_pc4_data_writeback <= i_alu_pc4_data_memory;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_rd_addr_writeback <= 0;
	else 
		o_rd_addr_writeback <= i_rd_addr_memory;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_ctrl <= 0;
	else 
		o_ctrl <= i_ctrl_memory;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset)
		o_io_sw <= 0;
	else
		o_io_sw <= i_io_sw;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset)
		o_io_key <= 0;
	else
		o_io_key <= i_io_key;
end

endmodule
