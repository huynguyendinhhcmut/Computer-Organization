module lsu (
	input logic         i_clk, 												 // Global clock, active on the rising edge
	input logic         i_reset, 												 // Global active reset
	input logic  [31:0] i_lsu_addr, 											 // Address for data read/write
	input logic  [31:0] i_st_data, 											 // Data to be stored
	input logic         i_lsu_wren, 											 // Write enable signal (1 if writing)
	input logic  [31:0] i_io_sw, 												 // Input for switches
	input logic  [2:0]  i_bmask, i_sl_sel, 								 // check store load type
	input logic  [1:0]  i_io_key, 											 // Input for keys
	
	output logic [31:0] o_ld_data, 											 // Data read from memory
	output logic [31:0] o_io_ledr, 											 // Output for red LEDs
	output logic [31:0] o_io_ledg, 											 // Output for green LEDs
	output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, // Output for 7-segment displays
	output logic [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7, // Output for 7-segment displays
	output logic [31:0] o_io_lcd 												 // Output for the LCD register.
);

logic [31:0] o_ld_data_ledr, o_ld_data_ledg, o_ld_data_lcd, o_ld_data_hex03, o_ld_data_hex47;

//      __  __                                   __  __             
//     |  \/  | ___ _ __ ___   ___  _ __ _   _  |  \/  | __ _ _ __  
//     | |\/| |/ _ \ '_ ` _ \ / _ \| '__| | | | | |\/| |/ _` | '_ \ 
//     | |  | |  __/ | | | | | (_) | |  | |_| | | |  | | (_| | |_) |
//     |_|  |_|\___|_| |_| |_|\___/|_|   \__, | |_|  |_|\__,_| .__/ 
//                                       |___/               |_|   
/*
localparam ADDR_MEM_BASE   = 32'h0000_0000; // D$ (Data Memory)
localparam ADDR_MEM_TOP    = 32'h0000_FFFF; 

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
*/

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
logic pre_addr_is_sw, addr_is_sw;
logic addr_is_key;

assign addr_is_mem   = ~i_lsu_addr[31] & ~i_lsu_addr[30] & ~i_lsu_addr[29] & ~i_lsu_addr[28] &
							  ~i_lsu_addr[27] & ~i_lsu_addr[26] & ~i_lsu_addr[25] & ~i_lsu_addr[24] & 
							  ~i_lsu_addr[23] & ~i_lsu_addr[22] & ~i_lsu_addr[21] & ~i_lsu_addr[20] & 
							  ~i_lsu_addr[19] & ~i_lsu_addr[18] & ~i_lsu_addr[17] & ~i_lsu_addr[16];
							  
assign addr_is_ledr  = ~i_lsu_addr[31] & ~i_lsu_addr[30] & ~i_lsu_addr[29] &  i_lsu_addr[28] &
							  ~i_lsu_addr[27] & ~i_lsu_addr[26] & ~i_lsu_addr[25] & ~i_lsu_addr[24] & 
							  ~i_lsu_addr[23] & ~i_lsu_addr[22] & ~i_lsu_addr[21] & ~i_lsu_addr[20] & 
							  ~i_lsu_addr[19] & ~i_lsu_addr[18] & ~i_lsu_addr[17] & ~i_lsu_addr[16] & 
							  ~i_lsu_addr[15] & ~i_lsu_addr[14] & ~i_lsu_addr[13] & ~i_lsu_addr[12];
							  
assign addr_is_ledg  = ~i_lsu_addr[31] & ~i_lsu_addr[30] & ~i_lsu_addr[29] &  i_lsu_addr[28] &
							  ~i_lsu_addr[27] & ~i_lsu_addr[26] & ~i_lsu_addr[25] & ~i_lsu_addr[24] & 
							  ~i_lsu_addr[23] & ~i_lsu_addr[22] & ~i_lsu_addr[21] & ~i_lsu_addr[20] & 
							  ~i_lsu_addr[19] & ~i_lsu_addr[18] & ~i_lsu_addr[17] & ~i_lsu_addr[16] & 
							  ~i_lsu_addr[15] & ~i_lsu_addr[14] & ~i_lsu_addr[13] &  i_lsu_addr[12];
							  
assign addr_is_hex03 = ~i_lsu_addr[31] & ~i_lsu_addr[30] & ~i_lsu_addr[29] &  i_lsu_addr[28] &
							  ~i_lsu_addr[27] & ~i_lsu_addr[26] & ~i_lsu_addr[25] & ~i_lsu_addr[24] & 
							  ~i_lsu_addr[23] & ~i_lsu_addr[22] & ~i_lsu_addr[21] & ~i_lsu_addr[20] & 
							  ~i_lsu_addr[19] & ~i_lsu_addr[18] & ~i_lsu_addr[17] & ~i_lsu_addr[16] & 
							  ~i_lsu_addr[15] & ~i_lsu_addr[14] &  i_lsu_addr[13] & ~i_lsu_addr[12];
							  
assign addr_is_hex47 = ~i_lsu_addr[31] & ~i_lsu_addr[30] & ~i_lsu_addr[29] &  i_lsu_addr[28] &
							  ~i_lsu_addr[27] & ~i_lsu_addr[26] & ~i_lsu_addr[25] & ~i_lsu_addr[24] & 
							  ~i_lsu_addr[23] & ~i_lsu_addr[22] & ~i_lsu_addr[21] & ~i_lsu_addr[20] & 
							  ~i_lsu_addr[19] & ~i_lsu_addr[18] & ~i_lsu_addr[17] & ~i_lsu_addr[16] & 
							  ~i_lsu_addr[15] & ~i_lsu_addr[14] &  i_lsu_addr[13] &  i_lsu_addr[12];
							  
assign addr_is_lcd   = ~i_lsu_addr[31] & ~i_lsu_addr[30] & ~i_lsu_addr[29] &  i_lsu_addr[28] &
							  ~i_lsu_addr[27] & ~i_lsu_addr[26] & ~i_lsu_addr[25] & ~i_lsu_addr[24] & 
							  ~i_lsu_addr[23] & ~i_lsu_addr[22] & ~i_lsu_addr[21] & ~i_lsu_addr[20] & 
							  ~i_lsu_addr[19] & ~i_lsu_addr[18] & ~i_lsu_addr[17] & ~i_lsu_addr[16] & 
							  ~i_lsu_addr[15] &  i_lsu_addr[14] & ~i_lsu_addr[13] & ~i_lsu_addr[12];
							  
assign pre_addr_is_sw    = ~i_lsu_addr[31] & ~i_lsu_addr[30] & ~i_lsu_addr[29] &  i_lsu_addr[28] &
							  ~i_lsu_addr[27] & ~i_lsu_addr[26] & ~i_lsu_addr[25] & ~i_lsu_addr[24] & 
							  ~i_lsu_addr[23] & ~i_lsu_addr[22] & ~i_lsu_addr[21] & ~i_lsu_addr[20] & 
							  ~i_lsu_addr[19] & ~i_lsu_addr[18] & ~i_lsu_addr[17] &  i_lsu_addr[16] & 
							  ~i_lsu_addr[15] & ~i_lsu_addr[14] & ~i_lsu_addr[13] & ~i_lsu_addr[12];
							  
assign addr_is_key   = ~i_lsu_addr[31] & ~i_lsu_addr[30] & ~i_lsu_addr[29] &  i_lsu_addr[28] &
							  ~i_lsu_addr[27] & ~i_lsu_addr[26] & ~i_lsu_addr[25] & ~i_lsu_addr[24] & 
							  ~i_lsu_addr[23] & ~i_lsu_addr[22] & ~i_lsu_addr[21] & ~i_lsu_addr[20] & 
							  ~i_lsu_addr[19] & ~i_lsu_addr[18] & ~i_lsu_addr[17] & ~i_lsu_addr[16] & 
							  ~i_lsu_addr[15] &  i_lsu_addr[14] & ~i_lsu_addr[13] &  i_lsu_addr[12];

logic [14:0] addr_even_1, addr_even_2, addr_odd_1, addr_odd_2;
logic [7:0] data_even_1, data_even_2, data_odd_1, data_odd_2;
logic we_even_1, we_even_2, we_odd_1, we_odd_2;
logic [31:0] mem_ld_data, data_gen;
logic mem_wren;

assign mem_wren = i_lsu_wren && addr_is_mem; // write enable to D$

decodelsu decodelsu1 (.i_lsu_addr(i_lsu_addr), .i_st_data(i_st_data), .i_lsu_wren(mem_wren), .i_bmask(i_bmask), 
							 .o_addr_even_1(addr_even_1), .o_addr_even_2(addr_even_2), .o_addr_odd_1(addr_odd_1), .o_addr_odd_2(addr_odd_2),
							 .o_data_even_1(data_even_1), .o_data_even_2(data_even_2), .o_data_odd_1(data_odd_1), .o_data_odd_2(data_odd_2),
							 .o_we_even_1(we_even_1),     .o_we_even_2(we_even_2),     .o_we_odd_1(we_odd_1),     .o_we_odd_2(we_odd_2));
							 
memory mem (.i_clk(i_clk), .i_addr_even_1(addr_even_1), .i_addr_even_2(addr_even_2), .i_addr_odd_1(addr_odd_1), .i_addr_odd_2(addr_odd_2),
		.i_reset(i_reset),			      .i_data_even_1(data_even_1), .i_data_even_2(data_even_2), .i_data_odd_1(data_odd_1), .i_data_odd_2(data_odd_2),
							      .i_we_even_1(we_even_1),     .i_we_even_2(we_even_2),     .i_we_odd_1(we_odd_1),     .i_we_odd_2(we_odd_2),
				.o_data(mem_ld_data), .i_lsu_addr(i_lsu_addr[0]));			

datagen data_gen1 (.i_wb_data(mem_ld_data), .i_sl_sel(i_sl_sel), .o_data_gen(data_gen)); // out data generate

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset)
		addr_is_sw <= 32'b0;
	else 
            	addr_is_sw <= pre_addr_is_sw;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset)
		o_ld_data_ledr <= 32'b0;
	else if (addr_is_ledr)
            	o_ld_data_ledr <= {15'b0, o_io_ledr[16:0]};
	else
		o_ld_data_ledr <= 32'b0;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset)
		o_ld_data_ledg <= 32'b0;
	else if (addr_is_ledg)
            	o_ld_data_ledg <= {15'b0, o_io_ledg[16:0]};
	else
		o_ld_data_ledg <= 32'b0;
end
   
always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset)
		o_ld_data_lcd <= 32'b0;
	else if (addr_is_lcd) 
            	o_ld_data_lcd <= o_io_lcd;
	else
		o_ld_data_lcd <= 32'b0;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset)
		o_ld_data_hex03 <= 32'b0;
	else if (addr_is_hex03)
            	o_ld_data_hex03 <= {1'b0, o_io_hex3[6:0], 1'b0, o_io_hex2[6:0], 
                          1'b0, o_io_hex1[6:0], 1'b0, o_io_hex0[6:0]};
	else
		o_ld_data_hex03 <= 32'b0;
end

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset)
		o_ld_data_hex47 <= 32'b0;
	else if (addr_is_hex47)
            	o_ld_data_hex47 <= {1'b0, o_io_hex7[6:0], 1'b0, o_io_hex6[6:0], 
                          1'b0, o_io_hex5[6:0], 1'b0, o_io_hex4[6:0]};
	else
		o_ld_data_hex47 <= 32'b0;
end

logic check_addr_sw;
assign check_addr_sw = pre_addr_is_sw | addr_is_sw;

always @(*) begin

        o_ld_data = 32'b0; 

        if (addr_is_mem) begin
            o_ld_data = data_gen;
        end if (check_addr_sw) begin
            o_ld_data = i_io_sw;
        end if (addr_is_key) begin
            o_ld_data = {30'b0, i_io_key};
        end if (addr_is_ledr) begin
            o_ld_data = o_ld_data_ledr;
        end if (addr_is_ledg) begin
            o_ld_data = o_ld_data_ledg;
        end if (addr_is_lcd) begin
            o_ld_data = o_ld_data_lcd;
        end if (addr_is_hex03) begin
            o_ld_data = o_ld_data_hex03;
        end if (addr_is_hex47) begin
            o_ld_data = o_ld_data_hex47;
        end
    end


always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) begin
		o_io_ledr <= 32'b0;
      o_io_ledg <= 32'b0;
      o_io_lcd  <= 32'b0;
   end else begin
		if (i_lsu_wren) begin 
			if (addr_is_ledr) begin
				o_io_ledr <= {15'b0, i_st_data[16:0]}; 
         end else if (addr_is_ledg) begin
            o_io_ledg <= {24'b0, i_st_data[7:0]}; 
         end else if (addr_is_lcd) begin
				o_io_lcd <= i_st_data;
			end
		end
	end
end

logic [3:0] io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7;

always_ff @(posedge i_clk or negedge i_reset) begin
	if (~i_reset) begin
		io_hex0 <= 4'b0;
		io_hex1 <= 4'b0;
		io_hex2 <= 4'b0;
		io_hex3 <= 4'b0;
		io_hex4 <= 4'b0;
		io_hex5 <= 4'b0;
		io_hex6 <= 4'b0;
		io_hex7 <= 4'b0;
	end else if (i_lsu_wren && addr_is_hex03 && (i_bmask == 3'b100)) begin
		io_hex0 <= i_st_data[3:0];
      io_hex1 <= i_st_data[7:4];
      io_hex2 <= i_st_data[11:8];
      io_hex3 <= i_st_data[15:12];
	end else if (i_lsu_wren && addr_is_hex47 && (i_bmask == 3'b100)) begin
		io_hex4 <= i_st_data[3:0];
      io_hex5 <= i_st_data[7:4];
      io_hex6 <= i_st_data[11:8];
      io_hex7 <= i_st_data[15:12];
	end
end

decode_hex hexled0 (.in(io_hex0), .out(o_io_hex0));
decode_hex hexled1 (.in(io_hex1), .out(o_io_hex1));
decode_hex hexled2 (.in(io_hex2), .out(o_io_hex2));
decode_hex hexled3 (.in(io_hex3), .out(o_io_hex3));

decode_hex hexled4 (.in(io_hex4), .out(o_io_hex4));
decode_hex hexled5 (.in(io_hex5), .out(o_io_hex5));
decode_hex hexled6 (.in(io_hex6), .out(o_io_hex6));
decode_hex hexled7 (.in(io_hex7), .out(o_io_hex7));

endmodule


