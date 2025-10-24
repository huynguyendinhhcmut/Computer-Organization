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
	input               i_clk,				// Globalclock,active on the rising edge
	input               i_rst,				// Global active reset 
	input   [31:0]      i_lsu_addr,		// Address input (was i_alu_data)
	input   [31:0]      i_st_data,		// Data to store (was i_rs2_data)

	input               i_lsu_wren,		// Write enable signal (was mem_wren)
	input   [3:0]       i_bmask,			// Store-Load Type: {op5, funct3}

	output  [31:0]      o_ld_data,		// Data read from memory

	
	// I/O Peripheral Inputs 
	input   [31:0]       i_io_sw,       // Switches					(0x1001_0000 - 0x1001_0FFF)
	
	// I/O Peripheral Outputs
	output logic [31:0] o_io_ledr,		// Red LEDs					(0x1000_0000 - 0x1000_0FFF)
	output logic [31:0] o_io_ledg,		// Green LEDs				(0x1000_1000 - 0x1000_1FFF)
	output logic [ 7:0] o_io_hex_0,		// 7-segment displays	(0x1000_2000 + offset)
	output logic [ 7:0] o_io_hex_1,
	output logic [ 7:0] o_io_hex_2,
	output logic [ 7:0] o_io_hex_3,
	output logic [ 7:0] o_io_hex_4,		// 7-segment displays	(0x1000_3000 + offset)
	output logic [ 7:0] o_io_hex_5,
	output logic [ 7:0] o_io_hex_6,
	output logic [ 7:0] o_io_hex_7,
	output logic [31:0] o_io_lcd			// LCD Control Register	(0x1000_4000 - 0x1000_4FFF)
);

/*
		+----------------------------+-----------------------------------------------+
		| 		Boundary address       | 		Mapping (Milestone 2 Specification)      |
		+----------------------------+-----------------------------------------------+
		| 0x1001_1000 -- 0xFFFF_FFFF | 								( Reserved )           |
		| 0x1001_0000 -- 0x1001_0FFF | Switches					( Required )           |
		| 0x1000_5000 -- 0x1000_FFFF | 								( Reserved )           |
		| 0x1000_4000 -- 0x1000_4FFF | LCD Control Registers                         |
		| 0x1000_3000 -- 0x1000_3FFF | Seven-segment LEDs 7-4                        |
		| 0x1000_2000 -- 0x1000_2FFF | Seven-segment LEDs 3-0                        |
		| 0x1000_1000 -- 0x1000_1FFF | Green LEDs 				( Required )           |
		| 0x1000_0000 -- 0x1000_0FFF | Red LEDs 					( Required )           |
		| 0x0000_0800 -- 0x0FFF_FFFF | 								( Reserved )           |
		| 0x0000_0000 -- 0x0000_07FF | Data Memory (2KiB)		( Required )           |
		+----------------------------+-----------------------------------------------+
		
		- 0x1001_0XXX	: Input I/O
		- 0x1000_XXXX	: Output I/O
		- 0x0000_0XXX	: Data Memory

*/
// Data Memory: 0x2000 to 0x3FFF (8KiB)
    localparam DM_SIZE_BYTES = 2048; // 2 KiB
    
    // --- INTERNAL SIGNALS ---
    logic [31:0] ld_data_mux; // Holds the final data to be loaded
    logic        i_dm_access;
    logic        i_in_access;  
    logic        i_out_access;

    // Data read from each potential source
    logic [31:0] dm_ld_data;
    logic [31:0] in_ld_data;
    
    // ===========================================
    //          I/O Decoder
    // ===========================================  
    io_decoder u_io_decoder (
        .i_lsu_addr     (i_lsu_addr),
        .o_dm_access    (i_dm_access),
        .o_in_access    (i_in_access),
        .o_out_access   (i_out_access)
    );

    // ===========================================
    // 				Data Memory (RAM)
    // ===========================================  

    memory	u_memory (
        .i_clk          (i_clk),
		  .i_rst				(i_rst),
        .i_addr    		(i_lsu_addr),						// Address
        .i_wdata     	(i_st_data),						// Write Data
        .i_wren       	(i_lsu_wren & i_dm_access),	// Only write if DM is accessed
        .i_bmask        (i_bmask),
        .o_rdata      	(dm_ld_data)						// Read Data
    );

    // ===========================================
    // 	Output Buffer (Memory-Mapped Writes)
    // ===========================================  
    output_buffer		u_output_buffer (
        .i_clk          (i_clk),
        .i_rst          (i_rst),
        .i_lsu_addr     (i_lsu_addr),
        .i_wdata      	(i_st_data),
        .i_wren     		(i_lsu_wren),
        .i_out_access   (i_out_access),
        .o_io_ledr      (o_io_ledr),
        .o_io_ledg      (o_io_ledg),
        .o_io_hex_0     (o_io_hex_0),
        .o_io_hex_1     (o_io_hex_1),
        .o_io_hex_2     (o_io_hex_2),
        .o_io_hex_3     (o_io_hex_3),
        .o_io_hex_4     (o_io_hex_4),
        .o_io_hex_5     (o_io_hex_5),
        .o_io_hex_6     (o_io_hex_6),
        .o_io_hex_7     (o_io_hex_7),
        .o_io_lcd       (o_io_lcd)
    );

    // ===========================================
    // 	Input Buffer (Memory-Mapped Reads)
    // ===========================================  
    input_buffer	u_input_buffer (
        .i_clk          (i_clk),
        .i_lsu_addr     (i_lsu_addr),
        .i_in_access    (i_in_access),
        .i_io_sw        (i_io_sw),

        .o_io_rdata		(in_ld_data) // Read Data
    );
    
    // ===========================================
    //          Final Load Data Mux
    // =========================================== 

    always @(*) begin
        o_ld_data = 32'h0; // Default: 0 for reserved/invalid addresses
        
        if (i_dm_access) begin
            // Data Memory access
            o_ld_data = dm_ld_data;
        end else if (i_in_access) begin
            // Input I/O access
            o_ld_data = in_ld_data;
        end
        // If reads from the output I/O region (0x70XX) are not defined, so they default to 0.
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
module memory
(
    input				i_clk,
	 input				i_rst,
    input	[31:0]	i_addr,		// Adress input
    input	[31:0]	i_wdata,		// Data to write

    input				i_wren,		// Write enable
	 input	[3:0]		i_bmask,		//	Store-Load Type
	 
    output	[31:0]	o_rdata		// Data read from memory
);

/*
		i_bmask = {op5, funct3}
	
		+-------+-----------+
		|i_bmask| function  |
		|-------|-----------|
		|  0000 |	 lb	  |
		|  0001 | 	 lh	  |
		|  0010 | 	 lw	  |
		|  0100 | 	 lbu	  | 
		|  0110 | 	 lhu	  |
		|  1000 | 	 sb	  |
		|  1001 | 	 sh	  |
		|  1010 | 	 sw	  |
		+-------+-----------+
*/

	// Data Memory: 0x2000 to 0x3FFF (2KiB)
	localparam DM_SIZE_BYTES = 2048; 	
 
	// 1024 x 8-bit memory
	reg [7:0] mem [0:DM_SIZE_BYTES-1];
	
	// ===========================================
	// 		 		Internal wire 
	// ===========================================		
	logic [ 7:0] Addr;
   
	assign Addr = i_addr[10:0];

	// ===========================================
	// 		 		Store operation
	// ===========================================	
	
	always @(posedge i_clk) begin
	  if (i_wren) begin
			case (i_bmask)
				 4'b1000: if (Addr < DM_SIZE_BYTES) begin		// sb
					mem[Addr] 	<= i_wdata[7:0];
				end
				 4'b1001: if (Addr < DM_SIZE_BYTES-1) begin	// sh
					mem[Addr] 	<= i_wdata[7:0];
					mem[Addr+1] <= i_wdata[15:8];
				 end
				 4'b1010: if (Addr < DM_SIZE_BYTES-3) begin	// sw
					mem[Addr] 	<= i_wdata[7:0];
					mem[Addr+1] <= i_wdata[15:8];
					mem[Addr+2] <= i_wdata[23:16];
					mem[Addr+3] <= i_wdata[31:24];
				 end
				 default: ; // No operation
			endcase
	  end
	end

	// ===========================================
	// 		 		Load operation
	// ===========================================	

	always @(*) begin
	  case (i_bmask)
			4'b0000: o_rdata = {{24{mem[Addr][7]}},					 	  mem[Addr]};	// lb
			4'b0001: o_rdata = {{16{mem[Addr+1][7]}},		 mem[Addr+1], mem[Addr]};	// lh
			4'b0010: o_rdata = {mem[Addr+3], mem[Addr+2], mem[Addr+1], mem[Addr]};	// lw
			4'b0100: o_rdata = {24'h0, 									 	  mem[Addr]};	// lbu
			4'b0110: o_rdata = {16'h0,							 mem[Addr+1], mem[Addr]};	// lhu
			default: o_rdata = 32'h0;
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
	input               i_clk,				// Globalclock,active on the rising edge
	input               i_rst,				// Global active reset 
	input   [31:0]      i_lsu_addr,		// Address input (was i_alu_data)
	input   [31:0]      i_wdata,			// Data to Write (was i_rs2_data)

	input               i_wren,		// Write enable signal (was mem_wren)
	input	  [ 3:0]		  i_bmask,			//	Store-Load Type
	input               i_out_access,

	// I/O Peripheral Outputs
	output logic [31:0] o_io_ledr,		// Red LEDs					(0x1000_0000 - 0x1000_0FFF)
													// 31 - 17 : (Reserved)
													// 16 -  0 : 17-bit data connected to the array of 17 redLEDs in order.
													
	output logic [31:0] o_io_ledg,		// Green LEDs				(0x1000_1000 - 0x1000_1FFF)
													// 31 - 8 : (Reserved)
													//  7 - 0 :  8-bit data connected to the array of 8 green LEDs in order.
													
	output logic [ 7:0] o_io_hex_0,		// 7-segment displays	(0x1000_2000 + offset)
	output logic [ 7:0] o_io_hex_1,
	output logic [ 7:0] o_io_hex_2,
	output logic [ 7:0] o_io_hex_3,
	output logic [ 7:0] o_io_hex_4,		// 7-segment displays	(0x1000_3000 + offset)
	output logic [ 7:0] o_io_hex_5,
	output logic [ 7:0] o_io_hex_6,
	output logic [ 7:0] o_io_hex_7,
	
	output logic [31:0] o_io_lcd			// LCD Control Register	(0x1000_4000 - 0x1000_4FFF)
													// 	  31 : ON
													// 30 - 11 : (Reserved)
													// 	  10 : EN
													// 	   9 : RS
													// 	   8 : R/W
													//  7 -  0 : Data
);


	// ===========================================
	// 		 		I/O Memory Declare
	// ===========================================
	
	reg [ 7:0] mem_hex_0_3 [0:3];
	reg [ 7:0] mem_hex_4_7 [0:3];
	reg [31:0] mem_ledr;
	reg [31:0] mem_ledg;
	reg [31:0] mem_lcd;
	
	// ===========================================
	// 		 		Internal wire 
	// ===========================================
	
	logic 			access_ledr;
	logic 			access_ledg;
	logic 			access_hex03;
	logic 			access_hex47;
	logic 			access_lcd;
	logic	[15:0]	Addr;
   
	assign Addr = i_lsu_addr[1:0];

	// ===========================================
	// 		 		Address Decode
	// ===========================================	
	
	assign access_ledr	=	(i_lsu_addr[15:12] == 4'h0);
	assign access_ledg	=	(i_lsu_addr[15:12] == 4'h1);
	assign access_hex03	=	(i_lsu_addr[15:12] == 4'h2);
	assign access_hex47	=	(i_lsu_addr[15:12] == 4'h3);
	assign access_lcd		=	(i_lsu_addr[15:12] == 4'h4);
	
	// ===========================================
	// 		 		Write operation
	// ===========================================	
	
	always @(posedge i_clk or negedge i_rst) begin
		if (!i_rst) begin
			// Reset for internal registers
			mem_ledr <= 32'h0;
			mem_ledg <= 32'h0;
			mem_lcd  <= 32'h0;
			mem_hex_0_3[0] <= 8'h0; mem_hex_0_3[1] <= 8'h0; 
			mem_hex_0_3[2] <= 8'h0; mem_hex_0_3[3] <= 8'h0; 
			mem_hex_4_7[0] <= 8'h0; mem_hex_4_7[1] <= 8'h0; 
			mem_hex_4_7[2] <= 8'h0; mem_hex_4_7[3] <= 8'h0; 
		end else begin
			if (i_wren && i_out_access && access_hex03) begin
				case (i_bmask)
					4'b1000: begin 									// sb
						mem_hex_0_3[Addr]   <= i_wdata[7:0];
					end
					4'b1001: begin										// sh
						mem_hex_0_3[Addr]   <= i_wdata[7:0];
						mem_hex_0_3[Addr+1] <= i_wdata[15:8];
					end
					4'b1010: begin										// sw
						mem_hex_0_3[Addr]   <= i_wdata[7:0];
						mem_hex_0_3[Addr+1] <= i_wdata[15:8];
						mem_hex_0_3[Addr+2] <= i_wdata[23:16];
						mem_hex_0_3[Addr+3] <= i_wdata[31:24];
					end
					default: ; // No operation
				endcase
			end
			if (i_wren && i_out_access && access_hex47) begin
				case (i_bmask)
					4'b1000: begin 									// sb
						mem_hex_4_7[Addr]   <= i_wdata[7:0];
					end
					4'b1001: begin		 								// sh
						mem_hex_4_7[Addr]   <= i_wdata[7:0];
						mem_hex_4_7[Addr+1] <= i_wdata[15:8];
					end
					4'b1010: begin										// sw
						mem_hex_4_7[Addr]   <= i_wdata[7:0];
						mem_hex_4_7[Addr+1] <= i_wdata[15:8];
						mem_hex_4_7[Addr+2] <= i_wdata[23:16];
						mem_hex_4_7[Addr+3] <= i_wdata[31:24];
					end
					default: ; // No operation
				endcase
			end	  
			if (i_wren && i_out_access && access_ledr) begin
				mem_ledr	<=	i_wdata;
			end		  
			if (i_wren && i_out_access && access_ledg) begin
				mem_ledg	<=	i_wdata;
			end		  
			if (i_wren && i_out_access && access_lcd) begin
				mem_lcd	<=	i_wdata;
			end
		end
	end

	// ===========================================
	// 		 		Output Assignments
	// ===========================================	

	// Hex 0-3 are stored sequentially 0x2000-0x2003.
	assign o_io_hex_0 = mem_hex_0_3[0];
	assign o_io_hex_1 = mem_hex_0_3[1];
	assign o_io_hex_2 = mem_hex_0_3[2];
	assign o_io_hex_3 = mem_hex_0_3[3];

	// Hex 4-7 are stored sequentially 0x3000-0x3003.
	assign o_io_hex_4 = mem_hex_4_7[0];
	assign o_io_hex_5 = mem_hex_4_7[1];
	assign o_io_hex_6 = mem_hex_4_7[2];
	assign o_io_hex_7 = mem_hex_4_7[3];

	// LED/LCD outputs
	assign o_io_ledr = mem_ledr;
	assign o_io_ledg = mem_ledg;
	assign o_io_lcd = mem_lcd;

	
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
	input						i_clk,					// Globalclock,active on the rising edge
	input                i_rst,					// Global active reset 
	input		[31:0]		i_lsu_addr,				// Address input (was i_alu_data)

	input						i_in_access,			// Address is in the input region

	// I/O Peripheral Inputs (Memory-Mapped Read Sources)
	input	[31:0]			i_io_sw,        		// Switches	(0x1001_0000 - 0x1001_0FFF)
															// 31 -18 : (Reserved)
															// 17		 : Reset
															//	16 - 0 : 17-bit data from SW16 to SW0 respectively.
															
	
	output logic	[31:0]	o_io_rdata			// Data read from I/O
);


	always @(posedge i_clk or negedge i_rst) begin
		if (!i_rst) begin							
			o_io_rdata = 32'd0;
		end else	
		if (i_in_access) begin							
			o_io_rdata = i_io_sw;
		end else begin
			o_io_rdata = o_io_rdata;
		end
	end

endmodule 


/*
==================================================================================================
				  ___    _____    ____                     _           
				 |_ _|  / / _ \  |  _ \  ___  ___ ___   __| | ___ _ __ 
				  | |  / / | | | | | | |/ _ \/ __/ _ \ / _` |/ _ \ '__|
				  | | / /| |_| | | |_| |  __/ (_| (_) | (_| |  __/ |   
				 |___/_/  \___/  |____/ \___|\___\___/ \__,_|\___|_|   
																						 
==================================================================================================
*/
module io_decoder
(
	input				[31:0]	i_lsu_addr,		// Address input (was i_alu_data)

	output logic				o_dm_access,	// Data Memory Access
	output logic				o_in_access,	// Input Buffer Access
	output logic				o_out_access	// Output Buffer Access
);

	// Data Memory Access (DM): 0x0000_0000 to 0x0000_07FF (2KiB)
	// Check that bits [31:11] are all 0.
	assign o_dm_access = (i_lsu_addr[31:11] == 21'h0);

	// Output I/O Access (OUT): 0x1000_0000 to 0x1000_4FFF
	// Check that bits [31:16] are 16'h1000 (0x1000)
	// AND bits [15:12] are 4'h0 through 4'h4 (0x0 to 0x4)
	assign o_out_access = (i_lsu_addr[31:16] == 16'h1000);

	// Input I/O Access (IN): 0x1001_0000 to 0x1001_0FFF
	// Check that bits [31:16] are 16'h1001 (0x1001)
	// AND bits [15:12] are 4'h0 (0x0)
	assign o_in_access = (i_lsu_addr[31:16] == 16'h1001) && (i_lsu_addr[15:12] == 4'h0); 
	
endmodule 


