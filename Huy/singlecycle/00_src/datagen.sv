module datagen (
	input logic [31:0] i_wb_data,
	input logic [2:0] i_sl_sel,
	output logic [31:0] o_data_gen
);

always_comb begin
	case (i_sl_sel)
		3'b000: o_data_gen = {{24{i_wb_data[7]}}, i_wb_data[7:0]};	 // lb
		3'b001: o_data_gen = {{16{i_wb_data[15]}}, i_wb_data[15:0]}; // lh
		3'b010: o_data_gen = i_wb_data;										 // lw
		3'b011: o_data_gen = {24'b0, i_wb_data[7:0]};					 // lbu
		3'b100: o_data_gen = {16'b0, i_wb_data[15:0]};					 // lhu
		default: o_data_gen = 32'b0;
	endcase
end

endmodule
