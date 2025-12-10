module ghr (
    input  logic       i_clk,
    input  logic       i_reset,
    input  logic       i_enable,     
    input  logic       i_serial_in,

    output logic [9:0] o_ghr_reg,    
    output logic [9:0] o_ghr_next    
);

logic [9:0] r_ghr;     
logic [9:0] next_ghr;  
    
always @(*) begin
    if (i_enable)
        next_ghr = {r_ghr[8:0], i_serial_in}; 
    else
        next_ghr = r_ghr; 
end

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset)
        r_ghr <= 10'b0;
    else
        r_ghr <= next_ghr;
end
    
assign o_ghr_reg  = r_ghr;    
assign o_ghr_next = next_ghr; 

endmodule
