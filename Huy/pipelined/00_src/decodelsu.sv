module decodelsu (
	input logic  [31:0] i_lsu_addr,
	input logic  [31:0] i_st_data,
	input logic         i_lsu_wren,
	input logic  [2:0]  i_bmask,
	
	output logic [9:0]  o_addr_even_1, o_addr_even_2, o_addr_odd_1, o_addr_odd_2,
	output logic [7:0]  o_data_even_1, o_data_even_2, o_data_odd_1, o_data_odd_2,
	output logic        o_we_even_1, o_we_even_2, o_we_odd_1, o_we_odd_2
);

logic [9:0] mapped_addr_even_1, mapped_addr_even_2, mapped_addr_odd_1, mapped_addr_odd_2;
logic [9:0] next_addr_even1, next_addr_even2, next_addr_odd1, next_addr_odd2;
logic [3:0] check;

assign check = {i_bmask, i_lsu_wren};

fullAdder10b map_addr_even1 (.a(i_lsu_addr[9:0]), .b(10'h2), .cin(1'b0), .sum(next_addr_even1)); // even1 = addr + 2
assign next_addr_odd1 = i_lsu_addr[9:0] & 10'h3fe;														       // odd1  = addr - 1
fullAdder10b map_addr_even2 (.a(next_addr_even1), .b(10'h1), .cin(1'b0), .sum(next_addr_even2)); // even2 = addr + 3
fullAdder10b map_addr_odd2  (.a(next_addr_odd1 ), .b(10'h2), .cin(1'b0), .sum(next_addr_odd2 )); // odd2  = addr + 1

always_comb begin
	if (~i_lsu_addr[0]) begin
		mapped_addr_even_1 = i_lsu_addr[10:1];
		mapped_addr_odd_1  = i_lsu_addr[10:1];
		mapped_addr_even_2 = {1'b0, next_addr_even1[9:1]};
		mapped_addr_odd_2  = {1'b0, next_addr_even1[9:1]};
	end else begin
		mapped_addr_odd_1  = {1'b0, next_addr_odd1 [9:1]};
		mapped_addr_even_1 = {1'b0, next_addr_odd2 [9:1]};
		mapped_addr_odd_2  = {1'b0, next_addr_odd2 [9:1]};
		mapped_addr_even_2 = {1'b0, next_addr_even2[9:1]};
	end
end

always_comb begin

	o_addr_even_1 = mapped_addr_even_1;
	o_data_even_1 = 8'b0; 
	o_we_even_1   = 0; 
			
	o_addr_even_2 = mapped_addr_even_2;
	o_data_even_2 = 8'b0; 
	o_we_even_2   = 0; 
			
	o_addr_odd_1  = mapped_addr_odd_1;
	o_data_odd_1  = 8'b0; 
	o_we_odd_1    = 0; 
			
	o_addr_odd_2  = mapped_addr_odd_2;
	o_data_odd_2  = 8'b0; 
	o_we_odd_2    = 0; 
	
	if (check == 4'b0011) begin // sb
		if (~i_lsu_addr[0]) begin
			o_addr_even_1 = mapped_addr_even_1;
			o_data_even_1 = i_st_data[7:0]; 
			o_we_even_1   = 1; 
		end else begin
			o_addr_odd_1  = mapped_addr_odd_1;
			o_data_odd_1  = i_st_data[7:0]; 
			o_we_odd_1    = 1; 
		end
	end else if (check == 4'b0101) begin // sh
		if(~i_lsu_addr[0]) begin
			o_addr_even_1 = mapped_addr_even_1;
			o_data_even_1 = i_st_data[7:0]; 
			o_we_even_1   = 1; 
			
			o_addr_odd_1  = mapped_addr_odd_1;
			o_data_odd_1  = i_st_data[15:8]; 
			o_we_odd_1    = 1; 
		end else begin 
			o_addr_even_2 = mapped_addr_even_2;
			o_data_even_2 = i_st_data[15:8]; 
			o_we_even_2   = 1; 
			
			o_addr_odd_1  = mapped_addr_odd_1;
			o_data_odd_1  = i_st_data[7:0]; 
			o_we_odd_1    = 1; 
		end
	end else if (check == 4'b1001) begin // sw
		if (~i_lsu_addr[0]) begin
			o_addr_even_1 = mapped_addr_even_1;
			o_data_even_1 = i_st_data[7:0]; 
			o_we_even_1   = 1; 
			
			o_addr_even_2 = mapped_addr_even_2;
			o_data_even_2 = i_st_data[23:16]; 
			o_we_even_2   = 1; 
			
			o_addr_odd_1  = mapped_addr_odd_1;
			o_data_odd_1  = i_st_data[15:8]; 
			o_we_odd_1    = 1; 
			
			o_addr_odd_2  = mapped_addr_odd_2;
			o_data_odd_2  = i_st_data[31:24]; 
			o_we_odd_2    = 1; 
		end else begin
			o_addr_even_1 = mapped_addr_even_1;
			o_data_even_1 = i_st_data[7:0]; 
			o_we_even_1   = 1; 
			
			o_addr_even_2 = mapped_addr_even_2;
			o_data_even_2 = i_st_data[23:16]; 
			o_we_even_2   = 1; 
			
			o_addr_odd_1  = mapped_addr_odd_1;
			o_data_odd_1  = i_st_data[15:8]; 
			o_we_odd_1    = 1; 
			
			o_addr_odd_2  = mapped_addr_odd_2;
			o_data_odd_2  = i_st_data[31:24]; 
			o_we_odd_2    = 1; 
		end
	end
end

endmodule
