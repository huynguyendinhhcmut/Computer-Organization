module reg_32bit (
	input logic clk, rst_n,
	input logic en,
	input logic [31:0] d,
	output logic [31:0] q
);

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		q <= 32'h0000_0000;
	end else if (en) begin
		q <= d;
	end
end

endmodule : reg_32bit