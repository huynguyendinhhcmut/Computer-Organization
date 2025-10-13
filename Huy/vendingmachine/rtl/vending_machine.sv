module vending_machine (
	input logic i_clk,
	input logic i_nickle, i_dime, i_quarter,
	output logic o_soda,
	output logic [2:0] o_change
);

logic [4:0] i_money;
logic [5:0] sum, pre_sum, cont_sum;
logic [6:0] pre_pre_o_change, pre_o_change;
logic Gr, Lt, Eq, GrEq, compare;

always @(*) begin
	case ({i_quarter, i_dime, i_nickle})
		3'b001: i_money = 5'b00101;
		3'b010: i_money = 5'b01010;
		3'b100: i_money = 5'b11001;
		default: i_money = 5'b0;
	endcase
end

fullAdder5b fa1 (.a(i_money), .b(cont_sum), .cin(0), .sum(pre_sum));

always_ff @(posedge i_clk) begin
	sum <= pre_sum;
end

comparator6b comp1 (.a(sum), .b(6'b010100), .Gr(Gr), .Lt(Lt), .Eq(Eq));

assign GrEq = Gr | Eq;

always @(*) begin
	case (GrEq)
		1'b0: compare = 0;
		1'b1: compare = 1;
	endcase
end
	
always @(*) begin
	case ({GrEq, Lt})
		1'b01: cont_sum = sum;
		1'b10: cont_sum = 6'b0;
		default: cont_sum = 6'b0;
	endcase
end


fullAdder6b fa2 (.a(sum), .b(6'b010100), .cin(1), .sum(pre_pre_o_change));

always @(*) begin
	case (compare)
		1'b0: pre_o_change = 0;
		1'b1: pre_o_change = pre_pre_o_change;
	endcase
end

always @(*) begin
	case (pre_o_change) 
		7'b0: o_change = 3'b000;
		7'b0000101: o_change = 3'b001;
		7'b0001010: o_change = 3'b010;
		7'b0001111: o_change = 3'b011;
		7'b0010100: o_change = 3'b100;
		default: o_change = 3'b000;
	endcase
end

assign o_soda = compare;
	
endmodule