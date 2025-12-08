module ram_btb (
    input logic  i_clk,
    input logic  i_btb_wren,
    input logic  [9:0]  i_addr,
    input logic  [31:0] i_data,
    
	 output logic [31:0] o_data
);

reg [31:0] ram [0:1023];

initial begin
	$readmemh("/home/yellow/ctmt_cttt_4/pipelined_fowarding_always_taken_1_bit_branch_prediction/02_test/btb_init_file.txt", ram);
end

always_ff @(posedge i_clk) begin
	if (i_btb_wren) begin
		ram[i_addr] <= i_data;
	end
end

always_ff @(negedge i_clk) begin
	o_data <= ram[i_addr];
end

endmodule
