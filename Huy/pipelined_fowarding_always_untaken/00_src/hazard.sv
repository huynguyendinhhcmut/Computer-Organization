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

logic rdMEM_rs1EX, rdMEM_rs2EX, rdWB_rs1EX, rdWB_rs2EX;

assign rdMEM_rs1EX = (~(i_rd_addr_memory[4] ^ i_rs1_addr_execute[4])) &
		     (~(i_rd_addr_memory[3] ^ i_rs1_addr_execute[3])) &
		     (~(i_rd_addr_memory[2] ^ i_rs1_addr_execute[2])) &
		     (~(i_rd_addr_memory[1] ^ i_rs1_addr_execute[1])) &
		     (~(i_rd_addr_memory[0] ^ i_rs1_addr_execute[0]));
		     
assign rdMEM_rs2EX = (~(i_rd_addr_memory[4] ^ i_rs2_addr_execute[4])) &
		     (~(i_rd_addr_memory[3] ^ i_rs2_addr_execute[3])) &
		     (~(i_rd_addr_memory[2] ^ i_rs2_addr_execute[2])) &
		     (~(i_rd_addr_memory[1] ^ i_rs2_addr_execute[1])) &
		     (~(i_rd_addr_memory[0] ^ i_rs2_addr_execute[0]));
		    
assign rdWB_rs1EX  = (~(i_rd_addr_writeback[4] ^ i_rs1_addr_execute[4])) &
		     (~(i_rd_addr_writeback[3] ^ i_rs1_addr_execute[3])) &
		     (~(i_rd_addr_writeback[2] ^ i_rs1_addr_execute[2])) &
		     (~(i_rd_addr_writeback[1] ^ i_rs1_addr_execute[1])) &
		     (~(i_rd_addr_writeback[0] ^ i_rs1_addr_execute[0]));
		 
assign rdWB_rs2EX  = (~(i_rd_addr_writeback[4] ^ i_rs2_addr_execute[4])) &
		     (~(i_rd_addr_writeback[3] ^ i_rs2_addr_execute[3])) &
		     (~(i_rd_addr_writeback[2] ^ i_rs2_addr_execute[2])) &
		     (~(i_rd_addr_writeback[1] ^ i_rs2_addr_execute[1])) &
		     (~(i_rd_addr_writeback[0] ^ i_rs2_addr_execute[0]));

always @(*) begin

	o_foward_a_execution = 2'b00;
	
	if (&(~i_rs1_addr_execute))
		o_foward_a_execution = 2'b00;
	else if (rdMEM_rs1EX) 
		o_foward_a_execution = 2'b01;
	else if (rdWB_rs1EX) 
		o_foward_a_execution = 2'b10;
end

always @(*) begin

	o_foward_b_execution = 2'b00;
	
	if (&(~i_rs2_addr_execute))
		o_foward_b_execution = 2'b00;
	else if (rdMEM_rs2EX)
		o_foward_b_execution = 2'b01;
	else if (rdWB_rs2EX) 
		o_foward_b_execution = 2'b10;
end

assign o_stall_fetch   = i_wb_sel_execute[1];
assign o_stall_decode  = i_wb_sel_execute[1];
assign o_flush_execute = i_wb_sel_execute[1] | i_pc_sel;
assign o_flush_decode  = i_pc_sel;

endmodule
