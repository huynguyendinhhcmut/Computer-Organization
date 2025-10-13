module regfile (
	input logic i_clk, 					// Global clock.
	input logic i_rst_n, 				// Global active reset.
	input logic [4:0] i_rs1_addr, 	// Address of the first source register.
	input logic [4:0] i_rs2_addr, 	// Address of the second source register.
	input logic [4:0] i_rd_addr, 		// Address of the destination register.
	input logic [31:0] i_rd_data, 	// Data to write to the destination register.
	input logic i_rd_wren, 				// Write enable for the destination register.

	output logic [31:0] o_rs1_data, 	// Data from the first source register.
	output logic [31:0] o_rs2_data 	// Data from the second source register.
);

logic [31:0] register [31:0];

always_comb begin
  if (i_rs1_addr == 5'd0)
    o_rs1_data = 32'd0;
  else
    o_rs1_data = register[i_rs1_addr];
end

always_comb begin	 
  if (i_rs2_addr == 5'd0)
    o_rs2_data = 32'd0;
  else
    o_rs2_data = register[i_rs2_addr];
end
  
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
      register[0]  <= 0; 
		register[1]  <= 0; 
		register[2]  <= 0; 
		register[3]  <= 0; 
		register[4]  <= 0; 
		register[5]  <= 0; 
		register[6]  <= 0; 
		register[7]  <= 0;
      register[8]  <= 0; 
		register[9]  <= 0; 
		register[10] <= 0; 
		register[11] <= 0; 
		register[12] <= 0; 
		register[13] <= 0; 
		register[14] <= 0; 
		register[15] <= 0;
      register[16] <= 0; 
		register[17] <= 0; 
		register[18] <= 0; 
		register[19] <= 0; 
		register[20] <= 0; 
		register[21] <= 0; 
		register[22] <= 0; 
		register[23] <= 0;
      register[24] <= 0; 
		register[25] <= 0; 
		register[26] <= 0; 
		register[27] <= 0; 
		register[28] <= 0; 
		register[29] <= 0; 
		register[30] <= 0; 
		register[31] <= 0;
    end else begin
      if (i_rd_wren && (i_rd_addr != 5'd0)) begin
			register[i_rd_addr] <= i_rd_data;
      end else
			register[0] <= 32'b0;
    end
  end
endmodule
