module comparator32b_signed (
    input logic [31:0] a, b,
    input logic signed_mode,   // 0 = unsigned, 1 = signed
    output logic Eq, Gr, Lt
);

logic Eq_u, Gr_u, Lt_u;

comparator32b cmp_unsigned (.a(a), .b(b), .Eq(Eq_u), .Gr(Gr_u), .Lt(Lt_u));

always_comb begin
    if (signed_mode) begin
		if (a[31] != b[31]) begin
			Eq = 1'b0;
				if (a[31] == 1'b1 && b[31] == 1'b0) begin
					Lt = 1'b1; Gr = 1'b0;
            end else begin
                Gr = 1'b1; Lt = 1'b0;
            end
      end else begin
			Eq = Eq_u;
         Gr = Gr_u;
         Lt = Lt_u;
      end
    end else begin
        Eq = Eq_u;
        Gr = Gr_u;
        Lt = Lt_u;
    end
end

endmodule

module comparator32b (
	input logic [31:0] a, b,
   output logic Eq, Gr, Lt
);

logic [7:0] gr1, lt1;
logic [1:0] gr2, lt2;

comparator4b cmp0_3   (.a(a[3:0]),   .b(b[3:0]),   .Gr(gr1[0]), .Lt(lt1[0]));
comparator4b cmp4_7   (.a(a[7:4]),   .b(b[7:4]),   .Gr(gr1[1]), .Lt(lt1[1]));
comparator4b cmp8_11  (.a(a[11:8]),  .b(b[11:8]),  .Gr(gr1[2]), .Lt(lt1[2]));
comparator4b cmp12_15 (.a(a[15:12]), .b(b[15:12]), .Gr(gr1[3]), .Lt(lt1[3]));
comparator4b cmp16_19 (.a(a[19:16]), .b(b[19:16]), .Gr(gr1[4]), .Lt(lt1[4]));
comparator4b cmp20_23 (.a(a[23:20]), .b(b[23:20]), .Gr(gr1[5]), .Lt(lt1[5]));
comparator4b cmp24_27 (.a(a[27:24]), .b(b[27:24]), .Gr(gr1[6]), .Lt(lt1[6]));
comparator4b cmp28_31 (.a(a[31:28]), .b(b[31:28]), .Gr(gr1[7]), .Lt(lt1[7]));

comparator4b cmp2_0 (.a(gr1[3:0]), .b(lt1[3:0]), .Gr(gr2[0]), .Lt(lt2[0]));
comparator4b cmp2_1 (.a(gr1[7:4]), .b(lt1[7:4]), .Gr(gr2[1]), .Lt(lt2[1]));

comparator2b cmp2_final (.a(gr2), .b(lt2), .Gr(Gr), .Lt(Lt));

assign Eq = (~Gr) & (~Lt);

endmodule

module comparator4b (
	input logic [3:0] a, b,
   output logic Gr, Lt, Eq
);

assign Eq = (~(a[3] ^ b[3])) & (~(a[2] ^ b[2])) & (~(a[1] ^ b[1])) & (~(a[0] ^ b[0]));
assign Gr = (a[3] & ~b[3]) | ((~(a[3] ^ b[3])) & a[2] & ~b[2]) | ((~(a[3] ^ b[3])) & (~(a[2] ^ b[2])) & a[1] & ~b[1]) | ((~(a[3] ^ b[3])) & (~(a[2] ^ b[2])) & (~(a[1] ^ b[1])) & a[0] & ~b[0]);
assign Lt = (~a[3] & b[3]) | ((~(a[3] ^ b[3])) & ~a[2] & b[2]) | ((~(a[3] ^ b[3])) & (~(a[2] ^ b[2])) & ~a[1] & b[1]) | ((~(a[3] ^ b[3])) & (~(a[2] ^ b[2])) & (~(a[1] ^ b[1])) & ~a[0] & b[0]);

endmodule

module comparator2b (
    	input logic [1:0] a, b,
    	output logic Gr, Lt, Eq
);

assign Gr = (a[0] & ~b[1] & ~b[0]) | (a[1] & ~b[1]) | (a[1] & a[0] & ~b[0]);
assign Lt = (~a[1] & ~a[0] & b[0]) | (~a[1] & b[1]) | (~a[0] & b[1] & b[0]);
assign Eq = (~a[1] & ~a[0] & ~b[1] & ~b[0]) | (~a[1] & a[0] & ~b[1] & b[0]) | (a[1] & ~a[0] & b[1] & ~b[0]) | (a[1] & a[0] & b[1] & b[0]);

endmodule