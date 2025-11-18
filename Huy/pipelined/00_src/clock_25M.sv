module clock_25M (
    input  logic clk50,      // Clock 50 MHz từ kit
    input  logic i_reset,    // Reset active low
    output logic o_clk       // Clock đầu ra 25 MHz
);

always_ff @(posedge clk50 or negedge i_reset) begin
	if (~i_reset)
		o_clk <= 1'b0;
    else
      o_clk <= ~o_clk;        // Toggle
end

endmodule