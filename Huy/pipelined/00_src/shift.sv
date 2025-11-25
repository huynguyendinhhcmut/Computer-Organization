module shift (
	input logic [31:0] data_in,
	input logic rightleft, arith,
	input logic [4:0] shift_amount,
	output logic [31:0] data_out
);

logic [31:0] data1, data2, data3, data4, data5, data6;

always @(*) begin
	case (rightleft)
		1'b0: data1[31:0] = data_in[31:0];
		1'b1: data1[31:0] = {data_in[0],  data_in[1],  data_in[2],  data_in[3],
                   			data_in[4],  data_in[5],  data_in[6],  data_in[7],
                   			data_in[8],  data_in[9],  data_in[10], data_in[11],
                   			data_in[12], data_in[13], data_in[14], data_in[15],
                   			data_in[16], data_in[17], data_in[18], data_in[19],
                   			data_in[20], data_in[21], data_in[22], data_in[23],
                   			data_in[24], data_in[25], data_in[26], data_in[27],
                   			data_in[28], data_in[29], data_in[30], data_in[31] };
	endcase
end

always @(*) begin
	case ({arith, shift_amount[4]})
		2'b00: data2[31:0] = data1[31:0];
		2'b01: data2[31:0] = {16'b0, data1[31:16]};
		2'b10: data2[31:0] = data1[31:0];
		2'b11: data2[31:0] = {{16{data_in[31]}}, data1[31:16]};
		default: data2[31:0] = 32'b0;
	endcase
end

always @(*) begin
	case ({arith, shift_amount[3]})
		2'b00: data3[31:0] = data2[31:0];
		2'b01: data3[31:0] = {8'b0, data2[31:8]};
		2'b10: data3[31:0] = data2[31:0];
		2'b11: data3[31:0] = {{8{data_in[31]}}, data2[31:8]};
		default: data3[31:0] = 32'b0;
	endcase
end

always @(*) begin
	case ({arith, shift_amount[2]})
		2'b00: data4[31:0] = data3[31:0];
		2'b01: data4[31:0] = {4'b0, data3[31:4]};
		2'b10: data4[31:0] = data3[31:0];
		2'b11: data4[31:0] = {{4{data_in[31]}}, data3[31:4]};
		default: data4[31:0] = 32'b0;
	endcase
end

always @(*) begin
    case ({arith, shift_amount[1]})
      2'b00: data5[31:0] = data4[31:0];
      2'b01: data5[31:0] = {2'b0, data4[31:2]};
      2'b10: data5[31:0] = data4[31:0];
      2'b11: data5[31:0] = {{2{data_in[31]}}, data4[31:2]};
		default: data5[31:0] = 32'b0;
    endcase
end

always @(*) begin
    case ({arith, shift_amount[0]})
      2'b00: data6[31:0] = data5[31:0];
      2'b01: data6[31:0] = {1'b0, data5[31:1]};
      2'b10: data6[31:0] = data5[31:0];
      2'b11: data6[31:0] = {{data_in[31]}, data5[31:1]};
		default: data6[31:0] = 32'b0;
    endcase
end
	
always @(*) begin
        case (rightleft)
                1'b0: data_out[31:0] = data6[31:0];
                1'b1: data_out[31:0] = {data6[0],  data6[1],  data6[2],  data6[3],
                                        data6[4],  data6[5],  data6[6],  data6[7],
                                        data6[8],  data6[9],  data6[10], data6[11],
                                        data6[12], data6[13], data6[14], data6[15],
                                        data6[16], data6[17], data6[18], data6[19],
                                        data6[20], data6[21], data6[22], data6[23],
                                        data6[24], data6[25], data6[26], data6[27],
                                        data6[28], data6[29], data6[30], data6[31] };
        endcase
end

endmodule
