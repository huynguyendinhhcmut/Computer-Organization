/*
==================================================================================================
		 ____        _          __  __                                 
		|  _ \  __ _| |_ __ _  |  \/  | ___ _ __ ___   ___  _ __ _   _ 
		| | | |/ _` | __/ _` | | |\/| |/ _ \ '_ ` _ \ / _ \| '__| | | |
		| |_| | (_| | || (_| | | |  | |  __/ | | | | | (_) | |  | |_| |
		|____/ \__,_|\__\__,_| |_|  |_|\___|_| |_| |_|\___/|_|   \__, |
																					|___/ 
==================================================================================================
*/
module memory 
(
    input				i_clk,
	 input				i_rst,
    input	[31:0]	i_addr,		// Adress input
    input	[31:0]	i_wdata,		// Data to write

    input				i_lsu_wren,	// Write enable
	 input				i_dm_access,
	 input	[ 3:0]	i_bmask,		//	Store-Load Type
	 
    output	[31:0]	o_rdata		// Data read from memory
);
/*
	- For quad_port_ram, the address usage detect as:
		+ Port A: XXXX_XX00
		+ Port B: XXXX_XX01
		+ Port C: XXXX_XX10
		+ Port D: XXXX_XX11	
		
						i_bmask = {op5, funct3}
						+-------+-----------+
						|i_bmask| function  |
						|-------|-----------|
						|  0000 |	 lb	  |
						|  0001 | 	 lh	  |
						|  0010 | 	 lw	  |
						|  0100 | 	 lbu	  |
						|  0101 | 	 lhu	  |
						|  1000 | 	 sb	  |
						|  1001 | 	 sh	  |
						|  1010 | 	 sw	  |
						+-------+-----------+

	-And for the i_bmask, the value write to RAM would be change due to address. 
	To do that, we would use a Decoder for selecting value
	
	- For example, SW operation:
	At address = 0x0000_0000
		+ Data Port A: i_wdata[ 7: 0]
		+ Data Port B: i_wdata[15: 8]
		+ Data Port C: i_wdata[23:16]
		+ Data Port D: i_wdata[31:24]
		
	At address = 0x0000_0010
		+ Data Port A: i_wdata[23:16]
		+ Data Port B: i_wdata[31:24]	
		+ Data Port C: i_wdata[ 7: 0]
		+ Data Port D: i_wdata[15: 8]
*/

	// ===========================================
	//          	Internal wire 
	// ===========================================
	logic			we_a;		
	logic			we_b;			
	logic			we_c;			
	logic			we_d; 	

	logic [9:0]	addr_a;
	logic [9:0]	addr_b;
	logic [9:0]	addr_c;
	logic [9:0]	addr_d;

	logic [7:0]	data_in_a;
	logic [7:0]	data_in_b;
	logic [7:0]	data_in_c;
	logic [7:0]	data_in_d;
	
	logic [7:0]	data_out_a;
	logic [7:0]	data_out_b;
	logic [7:0]	data_out_c;
	logic [7:0]	data_out_d;
	
	logic i_wren;
	
	assign i_wren = i_lsu_wren &  i_dm_access;

	quad_port_ram		u_ram	(
		.i_clk,
		.addr_a, .data_in_a, .we_a(we_a & i_wren), .data_out_a,	// Port A
		.addr_b, .data_in_b, .we_b(we_b & i_wren), .data_out_b,	// Port B
		.addr_c, .data_in_c, .we_c(we_c & i_wren), .data_out_c,	// Port C
		.addr_d, .data_in_d, .we_d(we_d & i_wren), .data_out_d	// Port D
	);

	write_decode		u_write_decode(
		.i_addr,			// Adress input
		.i_wdata,		// Data to write

		.i_lsu_wren,	// Write enable
		.i_bmask,		//	Store-Load Type

		.addr_a, .data_in_a, .we_a,	// Port A
		.addr_b, .data_in_b, .we_b,	// Port B
		.addr_c, .data_in_c, .we_c,	// Port C
		.addr_d, .data_in_d, .we_d		// Port D
	);	
	
	load_decode			u_load_decode(
		 .i_addr,		// Adress input
		 .i_lsu_wren,	// Write enable
		 .i_bmask,		//	Store-Load Type
		 
		 .data_out_a,
		 .data_out_b,
		 .data_out_c,
		 .data_out_d,
		 
		 .o_rdata 
	);
	
endmodule 

/*
==================================================================================================

																		  
==================================================================================================
*/
// ======== addr_decode ========
module write_decode
(
    input	[31:0]	i_addr,		// Adress input
    input	[31:0]	i_wdata,		// Data to write

    input				i_lsu_wren,	// Write enable
	 input	[ 3:0]	i_bmask,		//	Store-Load Type
	 

    output logic			we_a, 		
    output logic			we_b,			
    output logic			we_c,			
    output logic			we_d, 	

    output logic [9:0]	addr_a,
    output logic [9:0]	addr_b,
    output logic [9:0]	addr_c,
    output logic [9:0]	addr_d,
	 
    output logic [7:0]	data_in_a,
    output logic [7:0]	data_in_b,
    output logic [7:0]	data_in_c,
    output logic [7:0]	data_in_d
);			
	// ===========================================
	// 		 		Internal wire 
	// ===========================================		
	logic [10:0] Addr0;
	logic [10:0] Addr1;
	logic [10:0] Addr2;
	logic [10:0] Addr3;
	logic [ 2:0] bmask;

	assign bmask = i_bmask[2:0];
	assign Addr0 = i_addr[10:0];
	
	adder_16bits	u_addr1	(.operand_a({5'd0, Addr0}), .operand_b(16'd1), .cin(1'b0), .sum(Addr1), .cout());
	adder_16bits	u_addr2	(.operand_a({5'd0, Addr0}), .operand_b(16'd2), .cin(1'b0), .sum(Addr2), .cout());
	adder_16bits	u_addr3	(.operand_a({5'd0, Addr0}), .operand_b(16'd3), .cin(1'b0), .sum(Addr3), .cout());
	
	
	always_comb begin
		 we_a			= 1'b0;		
		 we_b			= 1'b0;			
		 we_c			= 1'b0;			
		 we_d			= 1'b0; 	

		 addr_a		= Addr0;
		 addr_b		= Addr1;
		 addr_c		= Addr2;
		 addr_d		= Addr3;
		 
		 data_in_a	= 8'h00;
		 data_in_b	= 8'h00;
		 data_in_c	= 8'h00;
		 data_in_d	= 8'h00;
		
		if (bmask == 3'b000) begin				// Byte
			if (i_addr[1:0] == 2'b00) begin
				addr_a		= Addr0;
				data_in_a	= i_wdata[7:0]; 
				we_a			= i_bmask[3]; 
			end else 
			if (i_addr[1:0] == 2'b01) begin
				addr_b		= Addr1;
				data_in_b	= i_wdata[7:0]; 
				we_b			= i_bmask[3];  
			end
			if (i_addr[1:0] == 2'b10) begin
				addr_c		= Addr2;
				data_in_c	= i_wdata[7:0]; 
				we_c			= i_bmask[3];  
			end else 
			if (i_addr[1:0] == 2'b11) begin
				addr_d		= Addr3;
				data_in_d	= i_wdata[7:0]; 
				we_d			= i_bmask[3];  
			end	
			
			
		end else 
		if (bmask == 3'b001) begin				// Half-word
			if (i_addr[1:0] == 2'b00) begin
				addr_a		= Addr0;
				data_in_a	= i_wdata[7:0]; 
				we_a			= i_bmask[3]; 
				
				addr_b		= Addr1;
				data_in_b	= i_wdata[15:8]; 
				we_b			= i_bmask[3]; 
				
			end else 
			if (i_addr[1:0] == 2'b01) begin
				addr_b		= Addr1;
				data_in_b	= i_wdata[7:0]; 
				we_b			= i_bmask[3];
				
				addr_c		= Addr2;
				data_in_c	= i_wdata[15:8]; 
				we_c			= i_bmask[3];
			
			end
			if (i_addr[1:0] == 2'b10) begin
				addr_c		= Addr2;
				data_in_c	= i_wdata[7:0]; 
				we_c			= i_bmask[3]; 
				
				addr_d		= Addr3;
				data_in_d	= i_wdata[15:8]; 
				we_d			= i_bmask[3];
				
			end else 
			if (i_addr[1:0] == 2'b11) begin
				addr_d		= Addr3;
				data_in_d	= i_wdata[7:0]; 
				we_d			= i_bmask[3];
				
				addr_a		= Addr0;
				data_in_a	= i_wdata[15:8]; 
				we_a			= i_bmask[3];
			end
			
		end else 
		if (bmask == 3'b010) begin				// Word
			if (i_addr[1:0] == 2'b00) begin
				addr_a		= Addr0;
				data_in_a	= i_wdata[7:0]; 
				we_a			= i_bmask[3];
				
				addr_b		= Addr1;
				data_in_b	= i_wdata[15:8]; 
				we_b			= i_bmask[3];
				
				addr_c		= Addr2;
				data_in_c	= i_wdata[23:16]; 
				we_c			= i_bmask[3];
				
				addr_d		= Addr3;
				data_in_d	= i_wdata[31:24]; 
				we_d			= i_bmask[3];
				
			end else 
			if (i_addr[1:0] == 2'b01) begin
				addr_b		= Addr1;
				data_in_b	= i_wdata[7:0]; 
				we_b			= i_bmask[3];
				
				addr_c		= Addr2;
				data_in_c	= i_wdata[15:8]; 
				we_c			= i_bmask[3];
				
				addr_d		= Addr3;
				data_in_d	= i_wdata[23:16]; 
				we_d			= i_bmask[3];
				
				addr_a		= Addr0;
				data_in_a	= i_wdata[31:24]; 
				we_a			= i_bmask[3];
				
			end
			if (i_addr[1:0] == 2'b10) begin
				addr_c		= Addr2;
				data_in_c	= i_wdata[7:0]; 
				we_c			= i_bmask[3];
				
				addr_d		= Addr3;
				data_in_d	= i_wdata[15:8]; 
				we_d			= i_bmask[3];
				
				addr_a		= Addr0;
				data_in_a	= i_wdata[23:16]; 
				we_a			= i_bmask[3];
				
				addr_b		= Addr1;
				data_in_b	= i_wdata[31:24]; 
				we_b			= i_bmask[3];
				
			end else 
			if (i_addr[1:0] == 2'b11) begin
				addr_d		= Addr3;
				data_in_d	= i_wdata[7:0]; 
				we_d			= i_bmask[3];
				
				addr_a		= Addr0;
				data_in_a	= i_wdata[15:8]; 
				we_a			= i_bmask[3];
				
				addr_b		= Addr1;
				data_in_b	= i_wdata[23:16]; 
				we_b			= i_bmask[3];
				
				addr_c		= Addr2;
				data_in_c	= i_wdata[31:24]; 
				we_c			= i_bmask[3];
		
			end
		end
	end
	
endmodule 


/*
==================================================================================================

																		  
==================================================================================================
*/
// ======== addr_decode ========
module load_decode
(
    input	[31:0]	i_addr,		// Adress input
    input				i_lsu_wren,	// Write enable
	 input	[ 3:0]	i_bmask,		//	Store-Load Type
	 
    input logic [7:0]	data_out_a,
    input logic [7:0]	data_out_b,
    input logic [7:0]	data_out_c,
    input logic [7:0]	data_out_d,
	 
	 output logic [31:0]	o_rdata
	 
);			

	always_comb begin		 
		 o_rdata	= 32'h0000_0000;
		if (!i_lsu_wren) begin
			if (i_bmask == 4'b0000) begin				// Signed Byte
				if (i_addr[1:0] == 2'b00) begin
					o_rdata = {{24{data_out_a[7]}}, data_out_a};
				end else 
				if (i_addr[1:0] == 2'b01) begin
					o_rdata = {{24{data_out_b[7]}}, data_out_b};
				end
				if (i_addr[1:0] == 2'b10) begin
					o_rdata = {{24{data_out_c[7]}}, data_out_c};
				end else 
				if (i_addr[1:0] == 2'b11) begin
					o_rdata = {{24{data_out_d[7]}}, data_out_d};
				end			
				
			end else 
			if (i_bmask == 4'b0001) begin				// Signed Half-word
				if (i_addr[1:0] == 2'b00) begin
					o_rdata = {{16{data_out_b[7]}}, data_out_b, data_out_a};
				end else 
				if (i_addr[1:0] == 2'b01) begin
					o_rdata = {{16{data_out_c[7]}}, data_out_c, data_out_b};
				end
				if (i_addr[1:0] == 2'b10) begin
					o_rdata = {{16{data_out_d[7]}}, data_out_d, data_out_c};	
				end else 
				if (i_addr[1:0] == 2'b11) begin
					o_rdata = {{16{data_out_a[7]}}, data_out_a, data_out_d};
				end
				
			end else 
			if (i_bmask == 4'b0010) begin				// Word
				if (i_addr[1:0] == 2'b00) begin
					o_rdata = {data_out_d, data_out_c, data_out_b, data_out_a};
				end else 
				if (i_addr[1:0] == 2'b01) begin
					o_rdata = {data_out_a, data_out_d, data_out_c, data_out_b};
				end
				if (i_addr[1:0] == 2'b10) begin
					o_rdata = {data_out_b, data_out_a, data_out_d, data_out_c};
				end else 
				if (i_addr[1:0] == 2'b11) begin
					o_rdata = {data_out_c, data_out_b, data_out_a, data_out_d};
				end
				
			end else 
			if (i_bmask == 4'b0100) begin				// UnSigned Byte
				if (i_addr[1:0] == 2'b00) begin
					o_rdata = {24'd0, data_out_a};
				end else 
				if (i_addr[1:0] == 2'b01) begin
					o_rdata = {24'd0, data_out_b};		
				end
				if (i_addr[1:0] == 2'b10) begin
					o_rdata = {24'd0, data_out_c};			
				end else 
				if (i_addr[1:0] == 2'b11) begin
					o_rdata = {24'd0, data_out_d};
				end
				
			end else 
			if (i_bmask == 4'b0101) begin				// UnSigned Half-word
				if (i_addr[1:0] == 2'b00) begin
					o_rdata = {16'd0, data_out_b, data_out_a};			
				end else 
				if (i_addr[1:0] == 2'b01) begin
					o_rdata = {16'd0, data_out_c, data_out_b};			
				end
				if (i_addr[1:0] == 2'b10) begin
					o_rdata = {16'd0, data_out_d, data_out_c};				
				end else 
				if (i_addr[1:0] == 2'b11) begin
					o_rdata = {16'd0, data_out_a, data_out_d};
				end
			end
		end
	end
	
endmodule 