module memory (
	input logic i_clk,
	input logic [9:0] i_addr_even_1, i_addr_even_2, i_addr_odd_1, i_addr_odd_2,
	input logic [7:0] i_data_even_1, i_data_even_2, i_data_odd_1, i_data_odd_2,
	input logic i_we_even_1, i_we_even_2, i_we_odd_1, i_we_odd_2,
	output logic [31:0] o_data
);

dual_port_ram memeven (.clk(i_clk), .addr_a(i_addr_even_1), .data_in_a(i_data_even_1), .we_a(i_we_even_1), .data_out_a(o_data[7:0]), 
				                        .addr_b(i_addr_even_2), .data_in_b(i_data_even_2), .we_b(i_we_even_2), .data_out_b(o_data[23:16]));
dual_port_ram memodd  (.clk(i_clk), .addr_a(i_addr_odd_1 ), .data_in_a(i_data_odd_1 ), .we_a(i_we_odd_1 ), .data_out_a(o_data[15:8]), 
				                        .addr_b(i_addr_odd_2 ), .data_in_b(i_data_odd_2 ), .we_b(i_we_odd_2 ), .data_out_b(o_data[31:24]));
				
endmodule	