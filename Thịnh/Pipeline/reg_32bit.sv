module reg_32bit (
	input logic clk, rst_n,
	input logic en,
	input logic [31:0] d,
	output logic [31:0] q
);
logic [31:0] d_temp;

always @(*) begin
    case (en)
        1'b0: d_temp = q;
        1'b1: d_temp = d;
    endcase
end

always @(negedge clk or negedge rst_n) begin
	if (~rst_n) begin
		q <= 32'h0000_0000;
	end
    else begin
		q <= d_temp;
	end
end

endmodule : reg_32bit
