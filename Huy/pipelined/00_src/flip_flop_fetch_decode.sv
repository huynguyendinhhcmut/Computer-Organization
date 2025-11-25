module flip_flop_fetch_decode (
	input logic         i_clk, i_reset, i_stall_decode, i_flush_decode,
	input logic  [31:0] i_pc_fetch,
	 
	output logic [31:0] o_pc_decode
);

always_ff @(posedge i_clk or negedge i_reset) begin
        if (~i_reset) begin
            o_pc_decode    <= 32'b0;
        end else begin
            if (i_flush_decode) begin
                o_pc_decode    <= 32'b0;
            end else if (i_stall_decode) begin
                o_pc_decode    <= o_pc_decode;    
            end else begin
                o_pc_decode    <= i_pc_fetch;
            end
        end
    end

endmodule
