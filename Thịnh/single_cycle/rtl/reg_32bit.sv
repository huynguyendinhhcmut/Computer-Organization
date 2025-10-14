module reg_32bit (
	input logic clk, rst_n,
	input logic en,
	input logic [31:0] d,
	output logic [31:0] q
);
logic [31:0] d_tmp;
logic [31:0] q_tmp;

assign q_tmp = q;
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		q <= 32'h0000_0000;
	end else begin
		q <= d_tmp;
	end
end


mux2_1 input_mux (
	.in0	(	q_tmp	),
	.in1	(	d		),
	.sel	(	en		),
	.out	(	d_tmp	)
);


endmodule : reg_32bit