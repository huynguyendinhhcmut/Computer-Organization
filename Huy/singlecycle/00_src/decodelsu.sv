module decodelsu (
	input logic  [31:0] i_lsu_addr,
	input logic  [31:0] i_st_data,
	input logic         i_lsu_wren,
	input logic  [2:0]  i_funct3,
	
	output logic [1:0]  o_sel_output_lsu,
	output logic [2:0]  o_sel_wren,
	output logic [3:0]  o_wbe, // write byte enable
	output logic [31:0] o_waddr, o_raddr,
	output logic [31:0] o_wdata
);

endmodule
