module hazard (
	input logic [4:0] i_rs1_addr_decode, i_rs2_addr_decode,
	input logic [4:0] i_rs1_addr_execute, i_rs2_addr_execute, i_rd_addr_execute,
	input logic [4:0] i_rd_addr_memory, i_rd_addr_writeback,
	input logic i_pc_sel, i_rd_wren_memory, i_rd_wren_writeback,
	input logic [1:0] i_wb_sel_execute,
	
	output logic [1:0] o_foward_a_execution, o_foward_b_execution,
	output logic o_stall_fetch, 
	output logic o_stall_decode, o_flush_decode, 
	output logic o_flush_execute
);

always @(*) begin

	o_foward_a_execution = 2'b00;
	o_foward_b_execution = 2'b00;
	
	if (~&i_rs1_addr_execute)
		o_foward_a_execution = 2'b00;
	else if (~&i_rs2_addr_execute)
		o_foward_b_execution = 2'b00;
	else if (~(i_rd_addr_memory ^ i_rs1_addr_execute)) 
		o_foward_a_execution = 2'b01;
	else if (~(i_rd_addr_memory ^ i_rs2_addr_execute))
		o_foward_b_execution = 2'b01;
	else if (~(i_rd_addr_writeback ^ i_rs1_addr_execute)) 
		o_foward_a_execution = 2'b10;
	else if (~(i_rd_addr_writeback ^ i_rs2_addr_execute)) 
		o_foward_b_execution = 2'b10;
end

assign o_stall_fetch   = i_wb_sel_execute[1];
assign o_stall_decode  = i_wb_sel_execute[1];
assign o_flush_execute = i_wb_sel_execute[1] | i_pc_sel;
assign o_flush_decode  = i_pc_sel;

endmodule