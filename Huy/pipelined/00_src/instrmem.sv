module instrmem (
	input  logic i_clk, i_reset, i_flush_decode, i_stall_decode,
   input  logic [31:0] i_pc,
   output logic [31:0] o_instr
);

logic [31:0] memory [0:2047];   
	
initial begin
   $readmemh("/home/nguyendinhhuy/rtl/pipelined/rtl/program.txt", memory);
end

always @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_instr <= 32'b0;
	else if (i_stall_decode)
		o_instr <= o_instr;
	else if (i_flush_decode)
		o_instr <= 32'b0;
	else
		o_instr <= memory[i_pc[31:2]];
end

endmodule
