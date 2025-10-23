module memory (
	input logic i_clk,
	input logic [9:0] i_addr_0, i_addr_1, i_addr_2, i_addr_3,
	input logic [7:0] i_data_0, i_data_1, i_data_2, i_data_3,
	input logic i_we_0, i_we_1, i_we_2, i_we_3,
	output logic [31:0] o_data
);

dual_port_ram mem1 (.clk(i_clk), .addr_a(i_addr_0), .data_in_a(i_data_0), .we_a(i_we_0), .data_out_a(o_data[7:0]), 
				                     .addr_b(i_addr_1), .data_in_b(i_data_1), .we_b(i_we_1), .data_out_b(o_data[23:16]));
dual_port_ram mem2 (.clk(i_clk), .addr_a(i_addr_2), .data_in_a(i_data_2), .we_a(i_we_2), .data_out_a(o_data[15:8]), 
				                     .addr_b(i_addr_3), .data_in_b(i_data_3), .we_b(i_we_3), .data_out_b(o_data[31:24]));
				
endmodule	