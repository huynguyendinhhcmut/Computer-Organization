module pc_counter
(
  input logic	[31:0]	pc_next,
  input logic				run,
  input logic				i_clk,
  input logic				i_rst_n,
  
  output logic	[31:0]	pc
);
  
  always_ff @(posedge i_clk)
    if (!i_rst_n)
      pc <= 32'd0;
    else if (run)
      pc <= pc_next;
	else
      pc <= pc;

endmodule 