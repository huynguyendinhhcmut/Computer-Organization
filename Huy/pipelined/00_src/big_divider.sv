module big_divider (
    input logic [31:0] i_dividend, 
    input logic [31:0] i_divisor,  
    input logic        i_signed,  
    
    output logic [31:0] o_quotient,
    output logic [31:0] o_remainder
);

logic dividend_is_neg;
logic divisor_is_neg;
logic final_quotient_sign;
logic final_remainder_sign;

logic [31:0] dividend_mag; 
logic [31:0] divisor_mag;  

logic [31:0] unsigned_quotient;  
logic [31:0] unsigned_remainder;

logic [31:0] quotient, remainder, dividend, divisor;

logic div_by_zero;
logic signed_overflow;

fullAdder32b fa1 (.a(~i_dividend), .b(32'h1), .cin(0), .sum(dividend));
fullAdder32b fa2 (.a(~i_divisor), .b(32'h1), .cin(0), .sum(divisor));
fullAdder32b fa3 (.a(~unsigned_quotient), .b(32'h1), .cin(0), .sum(quotient));
fullAdder32b fa4 (.a(~unsigned_remainder), .b(32'h1), .cin(0), .sum(remainder));

assign div_by_zero = (i_divisor == 32'b0);
assign signed_overflow = (i_signed == 1'b1) && (i_dividend == 32'h80000000) && (i_divisor  == 32'hFFFFFFFF);

always @(*) begin
	dividend_is_neg = i_signed & i_dividend[31];
   divisor_is_neg  = i_signed & i_divisor[31];

   final_quotient_sign  = dividend_is_neg ^ divisor_is_neg;
   final_remainder_sign = dividend_is_neg; 
end

always @(*) begin
   if (dividend_is_neg)
		dividend_mag = dividend;
   else
      dividend_mag = i_dividend;
end

always @(*) begin  
	if (divisor_is_neg)
		divisor_mag = divisor;
   else
      divisor_mag = i_divisor;
end

division unsigned_divider_core (.i_dividend(dividend_mag), .i_divisor(divisor_mag), .o_quotient(unsigned_quotient), .o_remainder(unsigned_remainder));

always @(*) begin
	if (div_by_zero) begin
		o_quotient  = 32'hFFFFFFFF;
      o_remainder = i_dividend;
   end else if (signed_overflow) begin
      o_quotient  = 32'h80000000;
      o_remainder = 32'h0;
   end else begin
		if (final_quotient_sign)
			o_quotient = quotient; // Bù 2
      else
         o_quotient = unsigned_quotient;
        
      if (final_remainder_sign)
         o_remainder = remainder; // Bù 2
      else
         o_remainder = unsigned_remainder;
   end
end

endmodule