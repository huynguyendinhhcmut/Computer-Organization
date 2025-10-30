module lsu (
	input logic         i_clk, 												 // Global clock, active on the rising edge
	input logic         i_reset, 												 // Global active reset
	input logic  [31:0] i_lsu_addr, 											 // Address for data read/write
	input logic  [31:0] i_st_data, 											 // Data to be stored
	input logic         i_lsu_wren, 											 // Write enable signal (1 if writing)
	input logic  [31:0] i_io_sw, 												 // Input for switches
	input logic  [2:0]  i_bmask, 											    // check store type
	input logic  [3:0]  i_io_key, 											 // Input for keys
	
	output logic [31:0] o_ld_data, 											 // Data read from memory
	output logic [31:0] o_io_ledr, 											 // Output for red LEDs
	output logic [31:0] o_io_ledg, 											 // Output for green LEDs
	output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, // Output for 7-segment displays
	output logic [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7, // Output for 7-segment displays
	output logic [31:0] o_io_lcd 												 // Output for the LCD register.
);

//      __  __                                   __  __             
//     |  \/  | ___ _ __ ___   ___  _ __ _   _  |  \/  | __ _ _ __  
//     | |\/| |/ _ \ '_ ` _ \ / _ \| '__| | | | | |\/| |/ _` | '_ \ 
//     | |  | |  __/ | | | | | (_) | |  | |_| | | |  | | (_| | |_) |
//     |_|  |_|\___|_| |_| |_|\___/|_|   \__, | |_|  |_|\__,_| .__/ 
//                                       |___/               |_|   
localparam ADDR_MEM_BASE   = 32'h0000_0000; // D$ (Data Memory)
localparam ADDR_MEM_TOP    = 32'h0000_07FF; 

localparam ADDR_LEDR_BASE  = 32'h1000_0000; // Output Buffer (Red LEDs)
localparam ADDR_LEDR_TOP   = 32'h1000_0FFF;

localparam ADDR_LEDG_BASE  = 32'h1000_1000; // Output Buffer (Green LEDs)
localparam ADDR_LEDG_TOP   = 32'h1000_1FFF;

localparam ADDR_HEX03_BASE = 32'h1000_2000; // Output Buffer (HEX 3-0)
localparam ADDR_HEX03_TOP  = 32'h1000_2FFF;

localparam ADDR_HEX47_BASE = 32'h1000_3000; // Output Buffer (HEX 7-4)
localparam ADDR_HEX47_TOP  = 32'h1000_3FFF;

localparam ADDR_LCD_BASE   = 32'h1000_4000; // Output Buffer (LCD)
localparam ADDR_LCD_TOP    = 32'h1000_4FFF;

localparam ADDR_SW_BASE    = 32'h1001_0000; // Input Buffer (Switches)
localparam ADDR_SW_TOP     = 32'h1001_0FFF;

localparam ADDR_KEY_BASE   = 32'h1000_5000; // Input Buffer (Keys)
localparam ADDR_KEY_TOP    = 32'h1000_5FFF;

//         _       _     _                     ____                     _           
//        / \   __| | __| |_ __ ___  ___ ___  |  _ \  ___  ___ ___   __| | ___ _ __ 
//       / _ \ / _` |/ _` | '__/ _ \/ __/ __| | | | |/ _ \/ __/ _ \ / _` |/ _ \ '__|
//      / ___ \ (_| | (_| | | |  __/\__ \__ \ | |_| |  __/ (_| (_) | (_| |  __/ |   
//     /_/   \_\__,_|\__,_|_|  \___||___/___/ |____/ \___|\___\___/ \__,_|\___|_|   
//                                                                                  
logic addr_is_mem;
logic addr_is_ledr;
logic addr_is_ledg;
logic addr_is_hex03;
logic addr_is_hex47;
logic addr_is_lcd;
logic addr_is_sw;
logic addr_is_key;

assign addr_is_mem   = (i_lsu_addr >= ADDR_MEM_BASE)   && (i_lsu_addr <= ADDR_MEM_TOP);
assign addr_is_ledr  = (i_lsu_addr >= ADDR_LEDR_BASE)  && (i_lsu_addr <= ADDR_LEDR_TOP);
assign addr_is_ledg  = (i_lsu_addr >= ADDR_LEDG_BASE)  && (i_lsu_addr <= ADDR_LEDG_TOP);
assign addr_is_hex03 = (i_lsu_addr >= ADDR_HEX03_BASE) && (i_lsu_addr <= ADDR_HEX03_TOP);
assign addr_is_hex47 = (i_lsu_addr >= ADDR_HEX47_BASE) && (i_lsu_addr <= ADDR_HEX47_TOP);
assign addr_is_lcd   = (i_lsu_addr >= ADDR_LCD_BASE)   && (i_lsu_addr <= ADDR_LCD_TOP);
assign addr_is_sw    = (i_lsu_addr >= ADDR_SW_BASE)    && (i_lsu_addr <= ADDR_SW_TOP);
assign addr_is_key   = (i_lsu_addr >= ADDR_KEY_BASE)   && (i_lsu_addr <= ADDR_KEY_TOP);

logic [9:0] addr_even_1, addr_even_2, addr_odd_1, addr_odd_2;
logic [7:0] data_even_1, data_even_2, data_odd_1, data_odd_2;
logic we_even_1, we_even_2, we_odd_1, we_odd_2;
logic [31:0] mem_ld_data;
logic mem_wren;

assign mem_wren = i_lsu_wren && addr_is_mem; // write enable to D$

decodelsu decodelsu1 (.i_lsu_addr(i_lsu_addr), .i_st_data(i_st_data), .i_lsu_wren(mem_wren), .i_bmask(i_bmask), 
							 .o_addr_even_1(addr_even_1), .o_addr_even_2(addr_even_2), .o_addr_odd_1(addr_odd_1), .o_addr_odd_2(addr_odd_2),
							 .o_data_even_1(data_even_1), .o_data_even_2(data_even_2), .o_data_odd_1(data_odd_1), .o_data_odd_2(data_odd_2),
							 .o_we_even_1(we_even_1),     .o_we_even_2(we_even_2),     .o_we_odd_1(we_odd_1),     .o_we_odd_2(we_odd_2));
							 
memory mem (.i_clk(i_clk), .i_addr_even_1(addr_even_1), .i_addr_even_2(addr_even_2), .i_addr_odd_1(addr_odd_1), .i_addr_odd_2(addr_odd_2),
							      .i_data_even_1(data_even_1), .i_data_even_2(data_even_2), .i_data_odd_1(data_odd_1), .i_data_odd_2(data_odd_2),
							      .i_we_even_1(we_even_1),     .i_we_even_2(we_even_2),     .i_we_odd_1(we_odd_1),     .i_we_odd_2(we_odd_2),
				.o_data(mem_ld_data), .i_lsu_addr(i_lsu_addr[0]));			

always_comb begin
	o_ld_data = 32'h0; 
	if (addr_is_mem) begin
		o_ld_data = mem_ld_data;
   end else if (addr_is_sw) begin
		o_ld_data = i_io_sw;
	end else if (addr_is_key) begin
		o_ld_data = {28'b0, i_io_key};
   end else if (addr_is_ledr) begin
      o_ld_data = {15'b0, o_io_ledr[16:0]};
   end else if (addr_is_ledg) begin
      o_ld_data = {15'b0, o_io_ledg[16:0]};
   end else if (addr_is_lcd) begin
      o_ld_data = o_io_lcd;
   end else if (addr_is_hex03) begin
      o_ld_data = {1'b0, o_io_hex3[6:0], 1'b0, o_io_hex2[6:0], 
                   1'b0, o_io_hex1[6:0], 1'b0, o_io_hex0[6:0]};
   end else if (addr_is_hex47) begin
      o_ld_data = {1'b0, o_io_hex7[6:0], 1'b0, o_io_hex6[6:0], 
                   1'b0, o_io_hex5[6:0], 1'b0, o_io_hex4[6:0]};
   end
end


always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) begin
		o_io_ledr <= 32'b0;
      o_io_ledg <= 32'b0;
      o_io_hex0 <= 7'b0;
      o_io_hex1 <= 7'b0;
      o_io_hex2 <= 7'b0;
      o_io_hex3 <= 7'b0;
      o_io_hex4 <= 7'b0;
      o_io_hex5 <= 7'b0;
      o_io_hex6 <= 7'b0;
      o_io_hex7 <= 7'b0;
      o_io_lcd  <= 32'b0;
   end else begin
		if (i_lsu_wren) begin 
			if (addr_is_ledr) begin
				o_io_ledr <= {15'b0, i_st_data[16:0]}; 
         end else if (addr_is_ledg) begin
            o_io_ledg <= {24'b0, i_st_data[7:0]}; 
         end else if (addr_is_hex03) begin
				if (i_bmask == 3'b100) begin
					o_io_hex0 <= i_st_data[6:0];
               o_io_hex1 <= i_st_data[14:8];
               o_io_hex2 <= i_st_data[22:16];
               o_io_hex3 <= i_st_data[30:24];
         end
      end else if (addr_is_hex47) begin
			if (i_bmask == 3'b100) begin
               o_io_hex4 <= i_st_data[6:0];
               o_io_hex5 <= i_st_data[14:8];
					o_io_hex6 <= i_st_data[22:16];
               o_io_hex7 <= i_st_data[30:24];
         end
      end else if (addr_is_lcd) begin
         o_io_lcd <= i_st_data;
      end
		end
	end
end

endmodule
