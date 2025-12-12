module decoder_hex(
    input logic     [3:0]      i_bin_data,
    output logic    [6:0]      o_hex_data
);

always @(*) begin
    case(i_bin_data)
        4'h0:	o_hex_data = 7'b100_0000;
		4'h1:	o_hex_data = 7'b111_1001;
		4'h2:	o_hex_data = 7'b010_0100;
		4'h3:	o_hex_data = 7'b011_0000;
		4'h4:	o_hex_data = 7'b001_1001;
		4'h5:	o_hex_data = 7'b001_0010;
		4'h6:	o_hex_data = 7'b000_0010;
		4'h7:	o_hex_data = 7'b111_1000;
		4'h8:	o_hex_data = 7'b000_0000;
		4'h9:	o_hex_data = 7'b001_0000;
		4'hA:	o_hex_data = 7'b000_1000;
		4'hB:	o_hex_data = 7'b000_0011;
		4'hC:	o_hex_data = 7'b100_0110;
		4'hD:	o_hex_data = 7'b010_0001;
		4'hE:	o_hex_data = 7'b000_0110;
		4'hF:	o_hex_data = 7'b000_1110;    
    endcase
end

endmodule : decoder_hex