/*
==================================================================================================
  _____ _             _   _               ____       _       _        _       _     _           
 |  ___| | ___   __ _| |_(_)_ __   __ _  |  _ \ ___ (_)_ __ | |_     / \   __| | __| | ___ _ __ 
 | |_  | |/ _ \ / _` | __| | '_ \ / _` | | |_) / _ \| | '_ \| __|   / _ \ / _` |/ _` |/ _ \ '__|
 |  _| | | (_) | (_| | |_| | | | | (_| | |  __/ (_) | | | | | |_   / ___ \ (_| | (_| |  __/ |   
 |_|   |_|\___/ \__,_|\__|_|_| |_|\__, | |_|   \___/|_|_| |_|\__| /_/   \_\__,_|\__,_|\___|_|   
                                  |___/                                                         
==================================================================================================
*/
module fpa
(
	input [31:0] operand_a, 
	input [31:0] operand_b,

	// Check Signals	
//	output        sign_a, sign_b,
//	output [7:0]  exp_a, exp_b,
//	output [23:0] frac_a, frac_b,
//	output [7:0]  exp_a_in, exp_b_in,
//	output [22:0] frac_a_in, frac_b_in,	
	
	output logic	[7:0]		exp_dif,
	output logic	[15:0]	exp_dif_pre,
	output logic	[7:0]		exp_greater,
	output logic	[63:0]	frac_new,
	
	// Field slices and unpacked results
	output logic	      	result_sign,
	output logic 	[7:0]  	result_exp,
	output logic 	[4:0]  	lzc_val,
	output logic 	[22:0] 	result_frac,
	
	
	output logic	[31:0]	result
);
	
	// ===========================================
	// 		 		Unpacked operands
	// ===========================================
	

	logic sign_a_in, sign_b_in;
	logic [7:0]  exp_a_in, exp_b_in;
	logic [22:0] frac_a_in, frac_b_in;

	logic sign_a, sign_b;
	logic [7:0]  exp_a, exp_b;
	logic [23:0] frac_a, frac_b;
	
	assign {sign_a_in, exp_a_in, frac_a_in} = operand_a;
	assign {sign_b_in, exp_b_in, frac_b_in} = operand_b;	
	
	assign sign_a = sign_a_in;
	assign sign_b = sign_b_in;

	// ===========================================
	// 		 			Wire / Logic 
	// ===========================================
	
	// Exponent related signals
//	logic [7:0]  exp_dif;       // Exponent difference after bias adjustment
//	logic [7:0]  exp_greater;   // The larger of the two exponents

	// Internal operation signals
//	logic [31:0] frac_new;         // New fraction after addition/subtraction

	// Control and status signals
	logic cout_add_sub;    // Carry out from add/sub operation
	logic frac_gt;         // Fraction greater than flag
	logic frac_eq;			  // Fraction equal flag
	logic sign_dif;        // Sign difference flag
	logic overflow;        // Overflow flag
	logic cout_exp_dif;

	logic        result_sign_main;
//	logic [4:0]  lzc_val;
	logic [7:0]  result_exp_main;
	logic [22:0] result_frac_main;
	logic [31:0] normal_result;
	logic [31:0] final_result;

	// ===========================================
	// 		 			Classification 
	// ===========================================	
	
	// Classification helpers
	logic a_is_zero, b_is_zero;
	logic a_is_subnormal, b_is_subnormal;
	logic a_is_inf, b_is_inf;
	logic a_is_nan, b_is_nan;
	logic Ea_is_zero, Eb_is_zero;
	logic Ea_is_FF, Eb_is_FF;
	logic Fa_is_zero, Fb_is_zero;
	logic Fa_is_nzero, Fb_is_nzero;

	classification		u_classification
	(
		.exp_a_in,			.exp_b_in,
		.frac_a_in,			.frac_b_in,
		
		.Ea_is_zero,		.Eb_is_zero,
		.Ea_is_FF,			.Eb_is_FF,
		.Fa_is_zero,		.Fb_is_zero,
		.Fa_is_nzero,		.Fb_is_nzero,
		
		.a_is_zero,			.b_is_zero,
		.a_is_subnormal,	.b_is_subnormal,
		.a_is_inf,			.b_is_inf,
		.a_is_nan,			.b_is_nan,
		
		.exp_a,				.exp_b,
		.frac_a,				.frac_b	
	);
	
	// ===========================================
	// 		 		Sign Logic
	// ===========================================	
	
	sign_logic		u_sign_logic
	(
		.sign_a,
		.sign_b,
		.cout_add_sub,
		.frac_gt,
		
		.result_sign	(result_sign_main)
	);

	// ===========================================
	// 		 	Exponent Calculation
	// ===========================================

	exp_calculation	u_exp_calculation
	(
		.exp_a, 
		.exp_b,
		
		.cout_exp_dif,
		.cout_add_sub,
		.exp_greater,
		.exp_dif_pre,
		.exp_dif
	);
	
	// ===========================================
	// 		 	Fraction Calculation
	// ===========================================
	
	frac_calculation	u_frac_calculation
	(
		.cout_add_sub,
		.sign_a,
		.sign_b,
		.exp_dif,
		.frac_a, 
		.frac_b,
		
		.overflow,
		.sign_dif,
		.frac_gt,
		.frac_eq,
		.frac_new
	);	
	
	// ===========================================
	// 		 		Normalization
	// ===========================================
	
	normalization	u_normalization
	(
		.exp_greater, 
		.overflow,
		.sign_dif,
		.frac_new,
		
		.result_exp			(result_exp_main),
		.lzc_val,
		.result_frac		(result_frac_main)
	);

	// ===========================================
	// 		Result Selection with Special Cases
	// ===========================================
	
	assign normal_result = {result_sign_main, result_exp_main, result_frac_main};

	special_detect		u_special_detect
	(
		.a_is_zero,		.b_is_zero,
		.a_is_inf,		.b_is_inf,
		.a_is_nan,		.b_is_nan,
		.sign_a,			.sign_b,
		.operand_a,		.operand_b,
		.normal_result,
		
		.final_result	
	);

	assign result       = final_result;
	assign result_sign  = final_result[31];
	assign result_exp   = final_result[30:23];
	assign result_frac  = final_result[22:0];
	
endmodule 

/*
==================================================================================================
				  ____                  _       _   ____       _            _   
				 / ___| _ __   ___  ___(_) __ _| | |  _ \  ___| |_ ___  ___| |_ 
				 \___ \| '_ \ / _ \/ __| |/ _` | | | | | |/ _ \ __/ _ \/ __| __|
				  ___) | |_) |  __/ (__| | (_| | | | |_| |  __/ ||  __/ (__| |_ 
				 |____/| .__/ \___|\___|_|\__,_|_| |____/ \___|\__\___|\___|\__|
						 |_|                                                      
==================================================================================================
*/

module special_detect
(
	input a_is_zero, b_is_zero,
	input a_is_inf, b_is_inf,
	input a_is_nan, b_is_nan,
	input	sign_a, sign_b,
	input result_exp_sign,
	input	[31:0]	operand_a, operand_b,
	input	[31:0]	normal_result,
	
	output logic	[31:0]	final_result	
);
	localparam logic [31:0] CANONICAL_QNAN = 32'h7FC0_0000;

	logic [31:0] special_result;
	logic        use_special;
	

	
	always_comb begin
		use_special    = 1'b0;
		special_result = normal_result;

	// ===========================================
	// 				Special by INPUT
	// ===========================================	
	
		if (a_is_nan) begin
			use_special    = 1'b1;
			special_result = CANONICAL_QNAN;
		end else if (b_is_nan) begin
			use_special    = 1'b1;
			special_result = CANONICAL_QNAN;
		end else if (a_is_inf && b_is_inf && (sign_a ^ sign_b)) begin
			use_special    = 1'b1;
			special_result = CANONICAL_QNAN;
		end else if (a_is_inf) begin
			use_special    = 1'b1;
			special_result = {sign_a, 8'hFF, 23'b0};
		end else if (b_is_inf) begin
			use_special    = 1'b1;
			special_result = {sign_b, 8'hFF, 23'b0};
		end else if (a_is_zero && b_is_zero) begin
			use_special    = 1'b1;
			special_result = {sign_a & sign_b, 31'b0};
		end else if (a_is_zero) begin
			use_special    = 1'b1;
			special_result = operand_b;
		end else if (b_is_zero) begin
			use_special    = 1'b1;
			special_result = operand_a;
		end else if ( (operand_a[30:0] == operand_b[30:0]) && !( sign_a == sign_b) ) begin
			use_special    = 1'b1;
			special_result = {1'b0, 8'h00, 23'b0};	
		end
	end

	
	
	// ===========================================
	// 				Select Result
	// ===========================================

	assign final_result = use_special ? special_result : normal_result;

endmodule 

/*
==================================================================================================
						____ _               _  __ _           _   _             
					  / ___| | __ _ ___ ___(_)/ _(_) ___ __ _| |_(_) ___  _ __  
					 | |   | |/ _` / __/ __| | |_| |/ __/ _` | __| |/ _ \| '_ \ 
					 | |___| | (_| \__ \__ \ |  _| | (_| (_| | |_| | (_) | | | |
					  \____|_|\__,_|___/___/_|_| |_|\___\__,_|\__|_|\___/|_| |_|
																									
==================================================================================================
*/
module classification
(
    input  [7:0]	exp_a_in, exp_b_in,
    input  [22:0] frac_a_in, frac_b_in,

    output logic  a_is_zero, b_is_zero,
    output logic  a_is_subnormal, b_is_subnormal,
    output logic  a_is_inf, b_is_inf,
    output logic  a_is_nan, b_is_nan,

    output logic  Ea_is_zero, Eb_is_zero,
    output logic  Ea_is_FF,   Eb_is_FF,
    output logic	Fa_is_zero, Fb_is_zero,
    output logic	Fa_is_nzero,Fb_is_nzero,
	 
	 output logic	[7:0]		exp_a, exp_b,
    output logic	[23:0]	frac_a, frac_b
);

    //==============================
    //  Exponent conditions
    //==============================
    // Ea_is_zero = all bits 0
    // Ea_is_FF   = all bits 1
    assign Ea_is_zero = ~(|exp_a_in);
    assign Eb_is_zero = ~(|exp_b_in);
    assign Ea_is_FF   = &exp_a_in;
    assign Eb_is_FF   = &exp_b_in;

    //==============================
    //  Fraction conditions
    //==============================
    assign Fa_is_zero  = ~(|frac_a_in);
    assign Fb_is_zero  = ~(|frac_b_in);
    assign Fa_is_nzero = |frac_a_in;    // direct gate form of ~Fa_is_zero
    assign Fb_is_nzero = |frac_b_in;

    //==============================
    //  IEEE-754 Class Detection
    //==============================
    // ZERO: exp=0 & frac=0
    // SUBNORMAL: exp=0 & frac!=0
    // INF: exp=FF & frac=0
    // NAN: exp=FF & frac!=0

    assign a_is_zero      = Ea_is_zero & Fa_is_zero;
    assign b_is_zero      = Eb_is_zero & Fb_is_zero;

    assign a_is_subnormal = Ea_is_zero & Fa_is_nzero;
    assign b_is_subnormal = Eb_is_zero & Fb_is_nzero;

    assign a_is_inf       = Ea_is_FF & Fa_is_zero;
    assign b_is_inf       = Eb_is_FF & Fb_is_zero;

    assign a_is_nan       = Ea_is_FF & Fa_is_nzero;
    assign b_is_nan       = Eb_is_FF & Fb_is_nzero;
	 
	// Hidden bit: 1 for normals, 0 for zero/subnormals/NaN/Inf (only used for add path)
	logic hidden_a;
	logic hidden_b;
	 
	always_comb begin
		hidden_a	=	1'b1;
		hidden_b	=	1'b1;
		exp_a			=	exp_a_in;
		exp_b			=	exp_b_in;

		if (a_is_subnormal) begin
			hidden_a		=	1'b0;
			exp_a			=	8'b0000_0001; // exp_a = -126
		end 
        
        if (b_is_subnormal) begin 
			hidden_b		=	1'b0;		
			exp_b			=	8'b0000_0001; // exp_b = -126
		end
		
        if ( a_is_subnormal && b_is_subnormal ) begin 
			hidden_b		=	1'b1;		
			exp_a			=	8'b0000_0000; 
			exp_b			=	8'b0000_0000;
		end		
		
	end
	
	assign frac_a = {hidden_a, frac_a_in};
	assign frac_b = {hidden_b, frac_b_in};
	
endmodule
/*
==================================================================================================
  _____                                   _      ____      _            _       _   _             
 | ____|_  ___ __   ___  _ __   ___ _ __ | |_   / ___|__ _| | ___ _   _| | __ _| |_(_) ___  _ __  
 |  _| \ \/ / '_ \ / _ \| '_ \ / _ \ '_ \| __| | |   / _` | |/ __| | | | |/ _` | __| |/ _ \| '_ \ 
 | |___ >  <| |_) | (_) | | | |  __/ | | | |_  | |__| (_| | | (__| |_| | | (_| | |_| | (_) | | | |
 |_____/_/\_\ .__/ \___/|_| |_|\___|_| |_|\__|  \____\__,_|_|\___|\__,_|_|\__,_|\__|_|\___/|_| |_|
            |_|                                                                                    
==================================================================================================
*/
module exp_calculation
(
	input	[7:0]	exp_a, 
	input	[7:0]	exp_b,
	
	output logic			cout_exp_dif,
	output logic			cout_add_sub,
	output logic [7:0]	exp_greater,
	output logic [15:0]	exp_dif_pre,
	output logic [7:0]	exp_dif
);
//	logic	[15:0]	exp_dif_pre;
	logic [15:0]	exp_pre;

	// ===========================================
	// 	 Calculate Exponent Difference 	
	// ===========================================
	
	add_sub	exp_dif_cal
	(
		 .i_operand_a	({8'b0, exp_a}),
		 .i_operand_b	({8'b0, exp_b}),
		 .cin				(1'b0),
		 .mode			(1'b1),					// Select: Sub

		 .o_sum			(exp_dif_pre),
		 .o_cout			()
	);

	add_sub	two_complement
	(
		 .i_operand_a	(16'd0),
		 .i_operand_b	(exp_dif_pre),
		 .cin				(cout_add_sub),
		 .mode			(cout_add_sub),

		 .o_sum			(exp_pre),
		 .o_cout			(cout_exp_dif)
	);
	
	// ===========================================
	// 	 	Select Greater Exponent 
	// ===========================================
	
	exp_mux	sel_exp
	(
		.sel	(cout_add_sub),
		.I0	(exp_a),			// Exponent of A
		.I1	(exp_b),			// Exponent of B
		
		.Y		(exp_greater)
	);

	assign cout_add_sub	= exp_dif_pre[8];
	assign exp_dif			= exp_pre[7:0];
	
endmodule 

/*
==================================================================================================
  _____               _   _                ____      _            _       _   _             
 |  ___| __ __ _  ___| |_(_) ___  _ __    / ___|__ _| | ___ _   _| | __ _| |_(_) ___  _ __  
 | |_ | '__/ _` |/ __| __| |/ _ \| '_ \  | |   / _` | |/ __| | | | |/ _` | __| |/ _ \| '_ \ 
 |  _|| | | (_| | (__| |_| | (_) | | | | | |__| (_| | | (__| |_| | | (_| | |_| | (_) | | | |
 |_|  |_|  \__,_|\___|\__|_|\___/|_| |_|  \____\__,_|_|\___|\__,_|_|\__,_|\__|_|\___/|_| |_|
                                                                                              
==================================================================================================
*/
module frac_calculation
(
	input				cout_add_sub,
	input				sign_a,
	input				sign_b,
	input	[7:0]		exp_dif,
	input	[23:0]	frac_a, 
	input	[23:0]	frac_b,
	
	output logic			overflow,
	output logic			sign_dif,
	output logic			frac_gt,	
	output logic			frac_eq,
	output logic [63:0]	frac_new
);
	// Exponent related signals
	logic [4:0]  exp_diff;      // Final exponent difference for shifting

	// Fraction related signals
	logic [23:0] frac_1;           // Fraction 1
	logic [23:0] frac_2;           // Fraction 2		
	logic [55:0] comp1;           // Complemented fraction 1
	logic [55:0] comp2;           // Complemented fraction 2
	logic [63:0] frac_2_align;    // Aligned fraction 2 after shifting

	// Control and status signals

	logic exp_dif_sel;     // Exponent difference selector
//	logic frac_gt;         // Fraction greater than flag
	logic comp1_sel;       // Complement selector for first operand
	logic comp2_sel;       // Complement selector for second operand

	// ===========================================
	// 	 Select Fraction of Lesser Exponent 
	// ===========================================
	
	frac_mux		fraction_greater
	(
		.sel	(cout_add_sub),
		.I0	(frac_a), 
		.I1	(frac_b),
		
		.Y		(frac_1)
	);	

	frac_mux		fraction_lesser
	(
		.sel	(cout_add_sub),
		.I0	(frac_b), 
		.I1	(frac_a),
		
		.Y		(frac_2)	// Frac need to be shift	
	);	

	
	// ===========================================
	// 		 		Shift Exponent 
	// ===========================================
	
	assign exp_dif_sel = (exp_dif[7] | exp_dif[6] | exp_dif[5]);
	
	exp_dif_mux		sel_exp_dif
	(
		.sel	(exp_dif_sel),
		.I0	(exp_dif[4:0]), 
		.I1	(5'b11111),
		
		.Y		(exp_diff)
	);
	
	SHIFTER_64bits		exponent_alignment
	(
		.A		({8'd0, frac_2, 32'd0}),		// Lesser Exponent 
		.B		(exp_diff),				// Exponent Diff to Shift 
		.Sel	(2'b00),					// Shift Right	
		.Y		(frac_2_align)			// New Fraction of Lesser
	);

	// ===========================================
	// 		 		Fraction COmputation 
	// ===========================================
	
	assign sign_dif = sign_a ^ sign_b;
	assign comp1_sel = ~frac_gt & sign_dif;
	assign comp2_sel =  frac_gt & sign_dif;
	
	comparator		frac_compare
	(
	  .operand_a	({8'b0, frac_1}), 
	  .operand_b	(frac_2_align[63:32]),
	  
	  .o_eq			(frac_eq), 
	  .o_lt			(), 
	  .o_gt			(frac_gt)
	);
	
	
	
	one_complement		comp_1st_frac
	(
		.i_comp	({frac_1, 32'd0}),
		.i_sel	(comp1_sel),
		
		.o_comp	(comp1)
	);

	one_complement		comp_2nd_frac
	(
		.i_comp	(frac_2_align[55:0]),
		.i_sel	(comp2_sel),
		
		.o_comp	(comp2)
	);
	
	
	
	
	adder_64bits		frac_calculate
	(
		 .A			({8'b0,comp1}), 
		 .B			({8'b0,comp2}),
		 .Cin			(sign_dif),
		 
		 .Sum			(frac_new),
		 .Cout		()
	);
	
	assign overflow = ~sign_dif & frac_new[56];
	
endmodule 

/*
==================================================================================================
					  _   _                            _ _          _   _             
					 | \ | | ___  _ __ _ __ ___   __ _| (_)______ _| |_(_) ___  _ __  
					 |  \| |/ _ \| '__| '_ ` _ \ / _` | | |_  / _` | __| |/ _ \| '_ \ 
					 | |\  | (_) | |  | | | | | | (_| | | |/ / (_| | |_| | (_) | | | |
					 |_| \_|\___/|_|  |_| |_| |_|\__,_|_|_/___\__,_|\__|_|\___/|_| |_|
																											  
==================================================================================================
*/
module normalization
( 
	input				overflow,
	input				sign_dif,
	input	[7:0]		exp_greater,
	input	[63:0]	frac_new,
	
	output logic [7:0]	result_exp,
	output logic [4:0]	lzc_val,
	output logic [22:0]	result_frac
);
	// Internal operation signals
	logic [63:0] frac_result_1;
	logic [63:0] frac_result_norm;
	logic [63:0] frac_result;
	logic [22:0] result_frac_rne;
	logic [15:0] result_exp_1;
	logic [7:0]  exp_result_1;
//	logic [4:0]  lzc_val;
   logic [7:0]	 denorm_exp;				// De-normalize exponent
	logic [63:0] frac_denorm_align;		// De-normalize fraction        
	
	// ===========================================
	// 		 		Normalization
	// ===========================================	

	adder_8bits		increment
	(
		.operand_a	(exp_greater),
		.operand_b	({7'b0,overflow}),
		.cin			(1'b0),

		.sum			(exp_result_1),
		.cout			()
	);
	
	SHIFTER_64bits		overflow_frac
	(
		.A		(frac_new),		
		.B		({5'b0,overflow}),	
		.Sel	(2'b00),								// Shift Right
		.Y		(frac_result_1)		
	);
	
	lzc_24bits		count_leading_zero
	(
		.x	(frac_result_1[55:32]),
		
		.q	(lzc_val)		
	);
	
	SHIFTER_64bits		underflow_frac
	(
		.A		({8'b0, frac_result_1[55:0]}),		
		.B		({2'b0,lzc_val}),		
		.Sel	(2'b10),								// Shift Left
		.Y		(frac_result_norm)		
	);
	
	
	
	add_sub	exp_align
	(
		 .i_operand_a	({8'b0, exp_result_1}),
		 .i_operand_b	({11'b0, lzc_val}),
		 .cin				(1'b0),
		 .mode			(1'b1),					// Select: Sub

		 .o_sum			(result_exp_1),
		 .o_cout			()
	);
	
	// ===========================================
	// 	 Negative Exponent Detect (subnormal)
	// ===========================================	
	
	denormalizer
	(
		 .result_exp_1,			// biased exponent after normalization		
		 .frac_result_norm,		// Fraction after normalization		

		 .denorm_exp,				// De-normalize exponent
		 .frac_denorm_align		// De-normalize fraction
	);	
	
	always_comb begin
		if (result_exp_1[9]) begin
			// If exp is negative => exp = 0000_0000 (-126, subnormal)
			result_exp	= denorm_exp;	
			frac_result	= frac_denorm_align;
		end else begin
			// Else is normal
			result_exp	= result_exp_1[7:0];
			frac_result = frac_result_norm;
		end
	end	
		
	// ===========================================
	// 		 			Round to Nearest
	// ===========================================	
	
	RNE		u_RNE
	(
	/*
		frac_result _norm[63:56] || frac_result_norm[55:32] || frac_result_norm[31:0] 
						v								v									v
					Zero Padding 		   24-Bits Fraction			32-bit Guard/Round/Sticky
	*/
		.frac_result,	
		
		.result_frac_rne
	);	
	
	// ===========================================
	// 		 	Inf. Exponent Detect 
	// ===========================================	
	
	always_comb begin
		if ( result_exp_1[7:0] == 8'hFF ) begin
		// If exp is negative => exp = 0000_0000 (-126, subnormal)
			result_frac = 24'd0;			
		end else begin
		// Else is normal
			result_frac = result_frac_rne;
		end
	end
	
endmodule 

/*
==================================================================================================
						  ____  _               _                _      
						 / ___|(_) __ _ _ __   | |    ___   __ _(_) ___ 
						 \___ \| |/ _` | '_ \  | |   / _ \ / _` | |/ __|
						  ___) | | (_| | | | | | |__| (_) | (_| | | (__ 
						 |____/|_|\__, |_| |_| |_____\___/ \__, |_|\___|
									 |___/                    |___/        
==================================================================================================
*/
module sign_logic 
(
	input		sign_a,
	input		sign_b,
	input		cout_add_sub,
	input		frac_gt,
	input		frac_eq,
	
	output	result_sign
);

	logic sign_dif;
	logic a_gt_b;

	// Sign differnt
	assign sign_dif = sign_a ^ sign_b;
	
	// gt = 0, cout = 0 => |A| < |B| => a_gt_b = 0
	// gt = 0, cout = 1 => |A| > |B| => a_gt_b = 1
	// gt = 1, cout = 0 => |A| > |B| => a_gt_b = 1
	// gt = 1, cout = 1 => |A| < |B| => a_gt_b = 0
	assign a_gt_b = ~(cout_add_sub ^ frac_gt);
	
	//	
	// Same sign, a_gt_b=0 			-> pick sign_a (OK either way)		
	// Same sign, a_gt_b=1 			-> pick sign_a (OK either way)
	// Different signs, a_gt_b=0 	-> |A|<=|B| -> pick sign_b 
	// Different signs, a_gt_b=1 	-> |A| >|B| -> pick sign_a
	always_comb begin
		if (!sign_dif) begin
			// same sign -> result sign is that sign
			result_sign = a_gt_b ? sign_a : sign_b;
		end else if (frac_eq) begin
			// exact cancellation -> +0
			result_sign = 1'b0;
		end else begin
			// opposite signs, pick sign of the larger magnitude
			result_sign = a_gt_b ? sign_b : sign_a;
		end
	end

endmodule 

/*
==================================================================================================
		  ____                       _   _          _   _                          _   
		 |  _ \ ___  _   _ _ __   __| | | |_ ___   | \ | | ___  __ _ _ __ ___  ___| |_ 
		 | |_) / _ \| | | | '_ \ / _` | | __/ _ \  |  \| |/ _ \/ _` | '__/ _ \/ __| __|
		 |  _ < (_) | |_| | | | | (_| | | || (_) | | |\  |  __/ (_| | | |  __/\__ \ |_ 
		 |_| \_\___/ \__,_|_| |_|\__,_|  \__\___/  |_| \_|\___|\__,_|_|  \___||___/\__|
																												 
==================================================================================================
*/
module RNE
(
/*
	frac_result[63:56] || frac_result[55:32] || frac_result[31:0] 
				v							v							v
		Zero Padding 		  24-Bits Fraction		32-bit Guard/Round/Sticky
*/
	input	[63:0]	frac_result,
		
	output logic	[22:0]	result_frac_rne
);

	// Guard:	frac_result_norm[31]
	// Round:	frac_result_norm[30]
	// Sticky:	OR( frac_result_norm[29:0] )

	logic G, R, S;		// Guard/Round/Sticky
	logic INC; 			// Increase
	logic LSB;			// Least Significant Bit
	
	logic	[31:0]	result_frac_tmp;
	
	assign G		=  frac_result[31];
	assign R		=  frac_result[30];
	assign S		= |frac_result[29:0];
	assign LSB 	=  frac_result[32];

	assign INC = G & ( R | S | LSB );
	
	adder_32bits 			
	(
		 .operand_a	( frac_result[63:32] ), 
		 .operand_b	( {31'd0, INC} ),
		 .cin			( 1'b0 ),
		 
		 .sum			( result_frac_tmp ),
		 .cout		()
	);

	assign result_frac_rne = result_frac_tmp[22:0];
	
endmodule 

/*
==================================================================================================
				  ____                                        _ _              
				 |  _ \  ___ _ __   ___  _ __ _ __ ___   __ _| (_)_______ _ __ 
				 | | | |/ _ \ '_ \ / _ \| '__| '_ ` _ \ / _` | | |_  / _ \ '__|
				 | |_| |  __/ | | | (_) | |  | | | | | | (_| | | |/ /  __/ |   
				 |____/ \___|_| |_|\___/|_|  |_| |_| |_|\__,_|_|_/___\___|_|   
																									
==================================================================================================
*/

module denormalizer
(
    input logic [15:0]  result_exp_1,			// biased exponent after normalization		
    input logic [63:0]	frac_result_norm,		// Fraction after normalization		

    output logic [7:0]	denorm_exp,				// De-normalize exponent
    output logic [63:0]	frac_denorm_align		// De-normalize fraction
);

	logic [7:0] ex_shift;
    
	 // Calculate amount of extra shift to reach Efield==0
	 adder_8bits		extra_shift
(
    .operand_a	(8'h01),
    .operand_b	(result_exp_1[7:0]),
    .cin			(result_exp_1[9]),

    .sum			(ex_shift),
    .cout		()
);
	 
	 
    SHIFTER_64bits denorm_shift
    (
        .A   (frac_result_norm),
        .B   (ex_shift[5:0]),	
        .Sel (2'b00), 						// Shift Right
        .Y   (frac_denorm_align)
    );
    
    // Final outputs
    assign denorm_exp    = 8'h00; // Must be 0 for subnormal numbers

endmodule

/*
==================================================================================================
  _                   _ _               _____                 ____                  _            
 | |    ___  __ _  __| (_)_ __   __ _  |__  /___ _ __ ___    / ___|___  _   _ _ __ | |_ ___ _ __ 
 | |   / _ \/ _` |/ _` | | '_ \ / _` |   / // _ \ '__/ _ \  | |   / _ \| | | | '_ \| __/ _ \ '__|
 | |__|  __/ (_| | (_| | | | | | (_| |  / /|  __/ | | (_) | | |__| (_) | |_| | | | | ||  __/ |   
 |_____\___|\__,_|\__,_|_|_| |_|\__, | /____\___|_|  \___/   \____\___/ \__,_|_| |_|\__\___|_|   
                                |___/                                                            
==================================================================================================
*/
module lzc_4bits
(
	input logic		[3:0]	x,		// Input Value
	
	output logic	[1:0]	q,		// Zero Count
	output logic			a		// All zero
);

	assign a 	= ~|x[3:0];
	assign q[1] = ~|x[3:2] & ~a;
	assign q[0] = ~x[3] & (x[2] | ~x[1]) & ~a;

endmodule 

// ======== lze ========

module lze	// Leading Zero Encoder
(
	input logic		[5:0]	a,		// Input Value
	
	output logic	[2:0]	q		// Zero Count
);

	assign q[0] = ( a[5] &  a[4] &  a[3] &  a[2] &  a[1] & ~a[0] )
					| ( a[5] &  a[4] &  a[3] & ~a[2] )
					| ( a[5] & ~a[4] );

	assign q[1] = ( a[5] &  a[4] &  a[3] &  a[2] &  a[1] &  a[0] )
					| ( a[5] &  a[4] &  a[3] & ~a[2] )
					| ( a[5] &  a[4] & ~a[3] );
					
	assign q[2] = ( a[5] &  a[4] &  a[3] &  a[2] &  a[1] &  a[0] )
					| ( a[5] &  a[4] &  a[3] &  a[2] &  a[1] & ~a[0] )
					| ( a[5] &  a[4] &  a[3] &  a[2] & ~a[1] );
					
endmodule 

// ======== lze_mux ========

module lze_mux
(
	input	[2:0]	sel,
	input	[1:0]	I0, I1, I2, I3, I4, I5,
	output[1:0] Y
);			

    always @(*) begin
        case (sel)
            3'd0: Y = I0;  
            3'd1: Y = I1; 
            3'd2: Y = I2;  
            3'd3: Y = I3; 
            3'd4: Y = I4;  
            3'd5: Y = I5; 				
            default: Y = 2'd0; 
        endcase
    end	
				
endmodule

// ======== lzc_24bits ========

module lzc_24bits
(
	input logic		[23:0]	x,		// Input Value
	
	output logic	[4:0]		q		// Zero Count
);

	logic a0, a1, a2, a3, a4, a5;
	logic [1:0] z0, z1, z2, z3, z4, z5;
	logic [5:0] a;

	lzc_4bits U0 (.x(x[ 3: 0]),  .q(z5), .a(a5));
	lzc_4bits U1 (.x(x[ 7: 4]),  .q(z4), .a(a4));
	lzc_4bits U2 (.x(x[11: 8]),  .q(z3), .a(a3));
	lzc_4bits U3 (.x(x[15:12]),  .q(z2), .a(a2));
	lzc_4bits U4 (.x(x[19:16]),  .q(z1), .a(a1));
	lzc_4bits U5 (.x(x[23:20]),  .q(z0), .a(a0));
  
//==============================
assign a = {a0, a1, a2, a3, a4, a5};
lze			lze0
(
	.a(a),	.q(q[4:2])
);
//==============================
lze_mux		lze_muxx
(
	.sel(q[4:2]),
	.I0(z0), 
	.I1(z1), 
	.I2(z2), 
	.I3(z3), 
	.I4(z4), 
	.I5(z5),
	.Y(q[1:0])
);	

endmodule 	

/*
==================================================================================================
				  _ _    ____                      _                           _   
				 / ( )  / ___|___  _ __ ___  _ __ | | ___ _ __ ___   ___ _ __ | |_ 
				 | |/  | |   / _ \| '_ ` _ \| '_ \| |/ _ \ '_ ` _ \ / _ \ '_ \| __|
				 | |   | |__| (_) | | | | | | |_) | |  __/ | | | | |  __/ | | | |_ 
				 |_|    \____\___/|_| |_| |_| .__/|_|\___|_| |_| |_|\___|_| |_|\__|
													 |_|                                    
==================================================================================================
*/
module one_complement
(
	input		[55:0]	i_comp,
	input					i_sel,
	
	output	[55:0]	o_comp
);

	assign o_comp = i_comp ^ {56{i_sel}};

endmodule 

/*
==================================================================================================
								  _       _     _      __  ____        _     
								 / \   __| | __| |    / / / ___| _   _| |__  
								/ _ \ / _` |/ _` |   / /  \___ \| | | | '_ \ 
							  / ___ \ (_| | (_| |  / /    ___) | |_| | |_) |
							 /_/   \_\__,_|\__,_| /_/    |____/ \__,_|_.__/ 
																							
==================================================================================================
*/
module add_sub
(
    input  logic [15:0]  i_operand_a,
    input  logic [15:0]  i_operand_b,
    input  logic        cin,
	 input  logic        mode,

    output logic [15:0]	o_sum,
    output logic        o_cout
);
	logic 			cin_1;
	logic [15:0]	n_operand_b;
	assign n_operand_b = i_operand_b ^ {16{mode}};
	assign cin_1 = cin | mode;

	adder_16bits		add_or_sub
	(
		 .operand_a	(i_operand_a),
		 .operand_b	(n_operand_b),
		 .cin			(cin_1),

		 .sum			(o_sum),
		 .cout		(o_cout)
	);

endmodule 

/*
==================================================================================================
												  __  __            
												 |  \/  |_   ___  __
												 | |\/| | | | \ \/ /
												 | |  | | |_| |>  < 
												 |_|  |_|\__,_/_/\_\
																		  
==================================================================================================
*/
// ======== exp_mux ========
module exp_mux
(
	input				sel,
	input		[7:0]	I0, I1,
	
	output	[7:0]	Y
);			

    always @(*) begin
        case (sel)
            1'b0: Y = I0;  
            1'b1: Y = I1;   
            default: Y = 8'd0; 
        endcase
    end	
				
endmodule 

// ======== exp_mux ========
module exp_dif_mux
(
	input				sel,
	input		[4:0]	I0, I1,
	
	output	[4:0]	Y
);			

    always @(*) begin
        case (sel)
            1'b0: Y = I0;  
            1'b1: Y = I1;   
            default: Y = 5'd0; 
        endcase
    end	
				
endmodule 

// ======== frac_mux ========

module frac_mux
(
	input					sel,
	input		[23:0]	I0, I1,
	
	output	[23:0]	Y
);			

    always @(*) begin
        case (sel)
            1'b0: Y = I0;  
            1'b1: Y = I1;   
            default: Y = 24'd0; 
        endcase
    end	
				
endmodule 
