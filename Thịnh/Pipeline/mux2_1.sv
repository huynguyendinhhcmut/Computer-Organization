module mux2_1
#(parameter N = 32)
(
	input logic [N-1:0] in0,
	input logic [N-1:0] in1,
	input logic sel,
	output logic [N-1:0] out
);

always @(*) begin
	case (sel)
		1'b0:	out = in0;
		1'b1: out = in1;
	endcase
end

endmodule : mux2_1