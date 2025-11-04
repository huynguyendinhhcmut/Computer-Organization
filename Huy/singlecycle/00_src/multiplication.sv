module multiplication (
	input logic [31:0] i_a, i_b,
	input logic i_sign_a,  
	input logic i_sign_b,  
	output logic [63:0] o_mul
);

logic a_is_neg;
logic b_is_neg;
logic final_sign;
logic [31:0] pre_a_mag, pre_b_mag; 
logic [31:0] a_mag; 
logic [31:0] b_mag;
logic [63:0] pre_mag_result; 
logic [63:0] mag_result; 

fullAdder32b fa1 (.a(~i_a), .b(32'h1), .cin(0), .sum(pre_a_mag));
fullAdder32b fa2 (.a(~i_b), .b(32'h1), .cin(0), .sum(pre_b_mag));

always @(*) begin
    a_is_neg = i_sign_a & i_a[31];
    b_is_neg = i_sign_b & i_b[31];
    final_sign = a_is_neg ^ b_is_neg;
	 if (a_is_neg)
        a_mag = pre_a_mag; 
    else
        a_mag = i_a;     
       
    if (b_is_neg)
        b_mag = pre_b_mag; 
    else
        b_mag = i_b;     
end

multiply32x32 mul_unsigned_core (.a(a_mag), .b(b_mag), .mul(mag_result));
fullAdder64b fa3 (.a(~mag_result), .b(64'h1), .cin(0), .sum(pre_mag_result));

always @(*) begin
    if (final_sign)
        o_mul = pre_mag_result; 
    else
        o_mul = mag_result;     
end

endmodule