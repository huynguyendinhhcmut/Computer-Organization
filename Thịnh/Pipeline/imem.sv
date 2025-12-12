module imem(
    input logic                 i_clk, i_rstn,
    input logic                 stall_ID, flush_ID,
    input logic     [31:0]      i_addr,
    output logic    [31:0]      o_instr
);

logic   [31:0]  memory  [0:2047];

initial begin
    $readmemh("/home/norman/milestone3/rtl/program.txt", memory);
end

always @(posedge i_clk or negedge i_rstn) begin
    if (~i_rstn)
        o_instr <= 'h0;
    else if (stall_ID)
        o_instr <= o_instr;
    else if (flush_ID)
        o_instr <= 'h0;
    else
        o_instr <= memory[i_addr[31:2]];
end

endmodule : imem
