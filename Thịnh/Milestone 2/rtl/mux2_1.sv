module mux2_1
#(parameter N = 32)
(
	input logic [N-1:0] in0,
	input logic [N-1:0] in1,
	input logic sel,
	output logic [N-1:0] out
);

always @(*) begin
	if (sel)
		out = in1;
	else
		out = in0;
end

endmodule : mux2_1