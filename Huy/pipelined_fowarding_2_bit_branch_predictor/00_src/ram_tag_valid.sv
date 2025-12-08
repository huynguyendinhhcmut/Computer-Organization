module ram_tag_valid (
    input logic  i_clk,
    input logic  i_btb_wren,
    input logic  [9:0]  i_addr,
    input logic  [22:0] i_data,
    
	 output logic [22:0] o_data
);

reg [22:0] ram [0:1023];

initial begin
        $readmemh("/home/yellow/ctmt_cttt_4/pipelined_fowarding_2_bit_branch_predictor/02_test/bht_init_file.txt", ram);
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

