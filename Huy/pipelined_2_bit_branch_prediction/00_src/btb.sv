module btb (
	input logic         i_clk, i_btb_wren,
	input logic [31:0]  i_pc_four,
	input logic [54:0]  i_btb_data,
	input logic [31:0]  i_btb_addr,
	
	output logic [31:0] o_pc_predict,
    output logic [2:0] o_predict
);

logic [54:0] pc_predict;
logic hit, pre_hit;

ram_btb rambtb (.i_clk(i_clk),		       .i_btb_wren(i_btb_wren),
					 .i_addr(i_btb_addr[11:2]), .i_data(i_btb_data[31:0]),
    
					 .o_data(pc_predict[31:0]));
					 
ram_tag_valid ramtagvalid (.i_clk(i_clk),		         .i_btb_wren(i_btb_wren),
									.i_addr(i_btb_addr[11:2]), .i_data(i_btb_data[54:32]),
    
									.o_data(pc_predict[54:32]));

assign pre_hit = (~(pc_predict[51] ^ i_btb_addr[31])) & (~(pc_predict[50] ^ i_btb_addr[30])) &
				 (~(pc_predict[49] ^ i_btb_addr[29])) & (~(pc_predict[48] ^ i_btb_addr[28])) &
				 (~(pc_predict[47] ^ i_btb_addr[27])) & (~(pc_predict[46] ^ i_btb_addr[26])) &
				 (~(pc_predict[45] ^ i_btb_addr[25])) & (~(pc_predict[44] ^ i_btb_addr[24])) &
				 (~(pc_predict[43] ^ i_btb_addr[23])) & (~(pc_predict[42] ^ i_btb_addr[22])) &
				 (~(pc_predict[41] ^ i_btb_addr[21])) & (~(pc_predict[40] ^ i_btb_addr[20])) &
				 (~(pc_predict[39] ^ i_btb_addr[19])) & (~(pc_predict[38] ^ i_btb_addr[18])) &
				 (~(pc_predict[37] ^ i_btb_addr[17])) & (~(pc_predict[36] ^ i_btb_addr[16])) &
				 (~(pc_predict[35] ^ i_btb_addr[15])) & (~(pc_predict[34] ^ i_btb_addr[14])) &
				 (~(pc_predict[33] ^ i_btb_addr[13])) & (~(pc_predict[32] ^ i_btb_addr[12]));
	
assign hit = pre_hit & pc_predict[52];
assign o_predict = pc_predict[54:52];

always @(*) begin
	if (hit) 
		o_pc_predict = pc_predict[31:0];
	else
		o_pc_predict = i_pc_four;
end

endmodule

