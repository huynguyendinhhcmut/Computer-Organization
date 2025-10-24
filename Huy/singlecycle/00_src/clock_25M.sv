module clock_25M (
    input  logic clk50,      // Clock 50 MHz từ kit
    input  logic i_rst_n,    // Reset active low
    output logic i_clk       // Clock đầu ra 25 MHz
);

always_ff @(posedge clk50 or negedge i_rst_n) begin
	if (~i_rst_n)
		i_clk <= 1'b0;
    else
      i_clk <= ~i_clk;        // Toggle
end

endmodule