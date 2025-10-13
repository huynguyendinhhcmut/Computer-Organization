module data_mem
#(	parameter ADDR_WIDTH 		= 32,
	parameter DATA_MEM_WIDTH 	= 8,
	parameter WRDATA				= 32,
//	parameter DMEM_BYTES			= 8192		// 8KB = 8 * (2^10) Byte
	parameter DMEM_BYTES			= 1024		// 1KB = 1 * (2^10) Byte (0x2000 - 0x23FF)
)
(
	input	logic										i_clk,
	input logic 	[WRDATA-1:0]				i_wdata,
	input logic 	[ADDR_WIDTH-1:0]			i_waddr, i_raddr,
	input logic										i_wren,
	input logic 	[3:0]							i_wbe,				// byte-enable dependent on funct3
	output logic 	[WRDATA-1:0]				o_rd_data
);

bit [DATA_MEM_WIDTH-1:0] mem_element [DMEM_BYTES-1:0];
bit [ADDR_WIDTH-1:0] waddr, waddr0, waddr1, waddr2, waddr3;
bit [ADDR_WIDTH-1:0] raddr0, raddr1, raddr2, raddr3;


assign waddr0 = i_waddr[ADDR_WIDTH-1:0] | 32'h0000_0000;
assign waddr1 = i_waddr[ADDR_WIDTH-1:0] | 32'h0000_0001;
assign waddr2 = i_waddr[ADDR_WIDTH-1:0] | 32'h0000_0002;
assign waddr3 = i_waddr[ADDR_WIDTH-1:0] | 32'h0000_0003;


assign raddr0 = i_raddr | 32'h0000_0000;
assign raddr1 = i_raddr | 32'h0000_0001;
assign raddr2 = i_raddr | 32'h0000_0002;
assign raddr3 = i_raddr | 32'h0000_0003;


always @(posedge i_clk) begin
	if (i_wren) begin
		if (i_wbe[0]) mem_element[waddr0][DATA_MEM_WIDTH-1:0] <= i_wdata[7:0];
		if (i_wbe[1]) mem_element[waddr1][DATA_MEM_WIDTH-1:0] <= i_wdata[15:8];
		if (i_wbe[2]) mem_element[waddr2][DATA_MEM_WIDTH-1:0] <= i_wdata[23:16];
		if (i_wbe[3]) mem_element[waddr3][DATA_MEM_WIDTH-1:0] <= i_wdata[31:24];
	end
	else begin
						  mem_element[waddr0][DATA_MEM_WIDTH-1:0] <= mem_element[waddr0][DATA_MEM_WIDTH-1:0];
						  mem_element[waddr1][DATA_MEM_WIDTH-1:0] <= mem_element[waddr1][DATA_MEM_WIDTH-1:0];
						  mem_element[waddr2][DATA_MEM_WIDTH-1:0] <= mem_element[waddr2][DATA_MEM_WIDTH-1:0];
						  mem_element[waddr3][DATA_MEM_WIDTH-1:0] <= mem_element[waddr3][DATA_MEM_WIDTH-1:0];
	end
end

always_comb begin
	o_rd_data [7:0]	= mem_element[raddr0];
	o_rd_data [15:8]	= mem_element[raddr1];
	o_rd_data [23:16]	= mem_element[raddr2];
	o_rd_data [31:24]	= mem_element[raddr3];
end

endmodule : data_mem