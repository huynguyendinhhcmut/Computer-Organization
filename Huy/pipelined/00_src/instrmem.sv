module instrmem (
	input  logic i_clk, i_reset,
   input  logic [31:0] i_pc,
   output logic [31:0] o_instr
);

logic [31:0] memory [0:2047];   
	
initial begin
   $readmemh("program.txt", memory);
end

always @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) 
		o_instr <= 32'b0;
	else
		o_instr <= memory[i_pc[31:2]];
end

endmodule
