/*
==================================================================================================
											 _     ____  _   _ 
											| |   / ___|| | | |
											| |   \___ \| | | |
											| |___ ___) | |_| |
											|_____|____/ \___/ 
													  
==================================================================================================
*/
module lsu
(
    input				i_clk,
    input	[31:0]	i_alu_data,		// Adress input
    input	[31:0]	i_rs2_data,		// Data to write

    input				mem_wren, 		// Write enable
	 input	[3:0]		sl_sel,			//	Store-Load Type
	 
    output	[31:0]	o_ld_data		// Data read from memory
);

/*
	sl_sel = {op5, funct3}

	sl_sel| function
	------|-----------
	 0000 |	lb
	 0001 | 	lh
	 0010 | 	lw
	 0100 | 	lbu
	 0110 | 	lhu
	 1000 | 	sb
	 1001 | 	sh
	 1010 | 	sw

*/

	// 1024 x 8-bit memory
	reg [7:0] mem [0:255];

	
	// Internal wire 
	logic [31:0] WD2;
	logic [7:0] Addr;
   
	assign Addr = i_alu_data[7:0];

	
	// Store operation
	always @(posedge i_clk) begin
	  if (mem_wren) begin
			case (sl_sel)
				 4'b1000: if (Addr < 256) 			// sb
						mem[Addr] 	<= WD2[7:0];
				 4'b1001: if (Addr < 255) begin	// sh
						mem[Addr] 	<= WD2[7:0];
						mem[Addr+1] <= WD2[15:8];
				 end
				 4'b1010: if (Addr < 253) begin	// sw
						mem[Addr] 	<= WD2[7:0];
						mem[Addr+1] <= WD2[15:8];
						mem[Addr+2] <= WD2[23:16];
						mem[Addr+3] <= WD2[31:24];
				 end
				 default: ; // No operation
			endcase
	  end
	end



	// Load operation
	always @(*) begin
	  case (sl_sel)
			4'b0000: o_ld_data = {{24{mem[Addr][7]}}, mem[Addr]};								// lb
			4'b0001: o_ld_data = {{16{mem[Addr+1][7]}}, mem[Addr+1], mem[Addr]};			// lh
			4'b0010: o_ld_data = {mem[Addr+3], mem[Addr+2], mem[Addr+1], mem[Addr]};	// lw
			4'b0100: o_ld_data = {24'h0, mem[Addr]};												// lbu
			4'b0110: o_ld_data = {16'h0, mem[Addr+1], mem[Addr]};								// lhu
			default: o_ld_data = 32'h0;
	  endcase
	end

endmodule 

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
module data_mem
(
    input				i_clk,
    input	[31:0]	i_alu_data,		// Adress input
    input	[31:0]	i_rs2_data,		// Data to write

    input				mem_wren, 		// Write enable
	 input	[3:0]		sl_sel,			//	Store-Load Type
	 
    output	[31:0]	o_ld_data		// Data read from memory
);

/*
	sl_sel = {op5, funct3}

	sl_sel| function
	------|-----------
	 0000 |	lb
	 0001 | 	lh
	 0010 | 	lw
	 0100 | 	lbu
	 0110 | 	lhu
	 1000 | 	sb
	 1001 | 	sh
	 1010 | 	sw

*/

	// 1024 x 8-bit memory
	reg [7:0] mem [0:255];

	
	// Internal wire 
	logic [31:0] WD2;
	logic [7:0] Addr;
   
	assign Addr = i_alu_data[7:0];

	
	// Store operation
	always @(posedge i_clk) begin
	  if (mem_wren) begin
			case (sl_sel)
				 4'b1000: if (Addr < 256) 			// sb
						mem[Addr] 	<= WD2[7:0];
				 4'b1001: if (Addr < 255) begin	// sh
						mem[Addr] 	<= WD2[7:0];
						mem[Addr+1] <= WD2[15:8];
				 end
				 4'b1010: if (Addr < 253) begin	// sw
						mem[Addr] 	<= WD2[7:0];
						mem[Addr+1] <= WD2[15:8];
						mem[Addr+2] <= WD2[23:16];
						mem[Addr+3] <= WD2[31:24];
				 end
				 default: ; // No operation
			endcase
	  end
	end



	// Load operation
	always @(*) begin
	  case (sl_sel)
			4'b0000: o_ld_data = {{24{mem[Addr][7]}}, mem[Addr]};								// lb
			4'b0001: o_ld_data = {{16{mem[Addr+1][7]}}, mem[Addr+1], mem[Addr]};			// lh
			4'b0010: o_ld_data = {mem[Addr+3], mem[Addr+2], mem[Addr+1], mem[Addr]};	// lw
			4'b0100: o_ld_data = {24'h0, mem[Addr]};												// lbu
			4'b0110: o_ld_data = {16'h0, mem[Addr+1], mem[Addr]};								// lhu
			default: o_ld_data = 32'h0;
	  endcase
	end

endmodule 

/*
==================================================================================================
				___        _               _     ____         __  __           
			  / _ \ _   _| |_ _ __  _   _| |_  | __ ) _   _ / _|/ _| ___ _ __ 
			 | | | | | | | __| '_ \| | | | __| |  _ \| | | | |_| |_ / _ \ '__|
			 | |_| | |_| | |_| |_) | |_| | |_  | |_) | |_| |  _|  _|  __/ |   
			  \___/ \__,_|\__| .__/ \__,_|\__| |____/ \__,_|_| |_|  \___|_|   
								  |_|                                              
==================================================================================================
*/
module output_buffer
(

);


endmodule 


/*
==================================================================================================
			  ___                   _     ____         __  __           
			 |_ _|_ __  _ __  _   _| |_  | __ ) _   _ / _|/ _| ___ _ __ 
			  | || '_ \| '_ \| | | | __| |  _ \| | | | |_| |_ / _ \ '__|
			  | || | | | |_) | |_| | |_  | |_) | |_| |  _|  _|  __/ |   
			 |___|_| |_| .__/ \__,_|\__| |____/ \__,_|_| |_|  \___|_|   
						  |_|                                              
==================================================================================================
*/
module input_buffer
(

);


endmodule 


/*
==================================================================================================

==================================================================================================
*/



/*
==================================================================================================

==================================================================================================
*/

