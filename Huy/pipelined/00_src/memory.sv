module memory (
	input logic i_clk,
	input logic i_lsu_addr,
	input logic [9:0] i_addr_even_1, i_addr_even_2, i_addr_odd_1, i_addr_odd_2,
	input logic [7:0] i_data_even_1, i_data_even_2, i_data_odd_1, i_data_odd_2,
	input logic i_we_even_1, i_we_even_2, i_we_odd_1, i_we_odd_2,
	output logic [31:0] o_data
);

logic [7:0] data1, data2, data3, data4;

dual_port_ram memeven (.clk(i_clk), .addr_a(i_addr_even_1), .data_in_a(i_data_even_1), .we_a(i_we_even_1), .data_out_a(data1), 
				                        .addr_b(i_addr_even_2), .data_in_b(i_data_even_2), .we_b(i_we_even_2), .data_out_b(data2));
dual_port_ram memodd  (.clk(i_clk), .addr_a(i_addr_odd_1 ), .data_in_a(i_data_odd_1 ), .we_a(i_we_odd_1 ), .data_out_a(data3), 
				                        .addr_b(i_addr_odd_2 ), .data_in_b(i_data_odd_2 ), .we_b(i_we_odd_2 ), .data_out_b(data4));
always @(*) begin
	if (~i_lsu_addr) 
		o_data = {data4, data2, data3, data1};
	else
		o_data = {data2, data4, data1, data3};
end
				
endmodule	
