module flip_flop_fetch_decode (
	input logic         i_clk, i_reset, i_stall_decode, i_flush_decode,
	input logic  [31:0] i_pc_fetch, i_instr_fetch,
	 
	output logic [31:0] o_pc_decode, o_instr_decode
);

logic clock, reset; 

assign clock = i_clk & ~i_stall_decode;
assign reset = i_reset & ~i_flush_decode;

always_ff @(posedge clock or negedge reset) begin
	if (~reset) 
		o_pc_decode <= 32'b0;
	else 
		o_pc_decode <= i_pc_fetch;
end

always_ff @(posedge clock or negedge reset) begin
	if (~reset) 
		o_instr_decode <= 32'b0;
	else 
		o_instr_decode <= i_instr_fetch;
end

endmodule
