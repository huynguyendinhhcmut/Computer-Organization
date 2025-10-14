module decoder_input_lsu (
	input logic 	[31:0] 		i_lsu_addr,
	input logic 	[31:0] 		i_st_data,
	input logic 					i_lsu_wren,
	input logic 	[2:0]			i_funct3,
	output logic 	[1:0]			sel_output_lsu,
	output logic 	[2:0]			sel_wren,
	output logic 	[3:0]			wbe,
	output logic 	[31:0]		waddr, raddr,
	output logic	[31:0]		o_wdata
	
);
// Internal signals
logic [31:0] mapping_addr;

// Mapping Address
always @(i_lsu_addr) begin
	if (i_lsu_addr >= 32'h0000_2000 && i_lsu_addr <= 32'h0000_23ff) begin
		mapping_addr = i_lsu_addr & 32'hffff_dfff;
	end
	else begin
		mapping_addr = i_lsu_addr;
	end
end

// Write Data
assign o_wdata = i_st_data;

// Address base for LB, LH, LW, LBU, LHU
assign raddr = mapping_addr & 32'hffff_fffc;

// Address base for SB, SH, SW
always_comb begin
	case (i_funct3)
		3'b000: 	waddr = mapping_addr;							// SB
		3'b001: 	waddr = mapping_addr & 32'hffff_fffe;		// SH
		3'b010: 	waddr = mapping_addr & 32'hffff_fffc;		// SW
		default:	waddr = 32'h0000_0000;
	endcase
end

// Write enable for SB, SH, SW
always @(i_funct3, waddr) begin
	// SB
	if (i_funct3 == 3'b000) begin
		case (waddr[1:0])
			2'b00: 	wbe = 4'b0001;
			2'b01: 	wbe = 4'b0010;
			2'b10: 	wbe = 4'b0100;
			2'b11: 	wbe = 4'b1000;
			default: wbe = 4'b0000;
		endcase
	end
	// SH
	else if (i_funct3 == 3'b001) begin
		case (waddr[1:0])
			2'b00:	wbe = 4'b0011;
			2'b10:	wbe = 4'b1100;
			default:	wbe = 4'b0000;
		endcase
	end
	// SW
	else if (i_funct3 == 3'b010) begin
						wbe = 4'b1111;
	end
	else begin
						wbe = 4'b0000;
	end
end

// sel_output_lsu
always_comb begin
	if (i_lsu_addr >= 32'h0000_7800 && i_lsu_addr <= 32'h0000_780f) begin
		sel_output_lsu = 2'b00;		// Switch
	end else if (i_lsu_addr >= 32'h0000_7010 && i_lsu_addr <= 32'h0000_701f) begin
		sel_output_lsu = 2'b01;		// Green LEDs
	end else if (i_lsu_addr >= 32'h0000_7000 && i_lsu_addr <= 32'h0000_700f) begin
		sel_output_lsu = 2'b01;		// Red LEDs
	end else if (i_lsu_addr >= 32'h0000_2000 && i_lsu_addr <= 32'h0000_3fff) begin
		sel_output_lsu = 2'b10;		// Data Memory
	end else if (i_lsu_addr >= 32'h0000_0000 && i_lsu_addr <= 32'h0000_1fff) begin
		sel_output_lsu = 2'b11;		// Instruction Memory
	end else begin
		sel_output_lsu = 2'b00;
	end
end

// Write enable for lsu
always_comb begin
	if (i_lsu_wren) begin
		case (sel_output_lsu)
			2'b00:	sel_wren = 3'b001;	// Input Buffer
			2'b01:	sel_wren = 3'b010;	// Output Buffer
			2'b10:	sel_wren = 3'b100;	//	Data Memory
			2'b11:	sel_wren = 3'b000;
		endcase
	end
	else begin
						sel_wren	= 3'b000;
	end
end

/*
always_comb begin
	case (i_lsu_addr) inside
		[32'h0000_7800 : 32'h0000_780f]:	sel_output_lsu = 2'b00;		// Switch
		[32'h0000_7010 : 32'h0000_701f]:	sel_output_lsu = 2'b01;		// Green LEDs
		[32'h0000_7000 : 32'h0000_700f]:	sel_output_lsu = 2'b01;		// Red LEDs
		[32'h0000_2000 : 32'h0000_3fff]:	sel_output_lsu = 2'b10;		// Data Memory
		[32'h0000_0000 : 32'h0000_1fff]:	sel_output_lsu	= 2'b11;		// Instruction Memory
		default								 :	sel_output_lsu	= 2'b00;
	endcase
end
*/

endmodule : decoder_input_lsu