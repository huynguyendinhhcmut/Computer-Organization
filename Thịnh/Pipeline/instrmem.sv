module instrmem(
    input  logic                i_clk, i_rst, flush_ID, stall_ID,
    input  logic    [31:0]      i_pc,
    output logic    [31:0]      o_instr
);

logic [31:0] memory [0:4095];   
	
initial begin
    $readmemh("C:\Users\phong\Downloads\Milestone3\pipelined\rtl\program.txt", memory);
end

always @(posedge i_clk or negedge i_rst) begin
    if (~i_rst) 
        o_instr <= 32'b0;
    else if (stall_ID)
        o_instr <= o_instr;
    else if (flush_ID)
        o_instr <= 32'b0;
    else
    o_instr <= memory[i_pc[31:2]];
end


endmodule : instrmem
