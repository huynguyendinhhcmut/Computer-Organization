module comparator6b ( 
			input logic [5:0] a, b, 
			output logic Gr, Lt, Eq 
); 

logic [2:0] Gr2, Lt2, Eq2; 
  
comparator2b cmp1 (.a(a[1:0]), .b(b[1:0]), .Gr(Gr2[0]), .Lt(Lt2[0]), .Eq(Eq2[0])); 
comparator2b cmp2 (.a(a[3:2]), .b(b[3:2]), .Gr(Gr2[1]), .Lt(Lt2[1]), .Eq(Eq2[1])); 
comparator2b cmp3 (.a(a[5:4]), .b(b[5:4]), .Gr(Gr2[2]), .Lt(Lt2[2]), .Eq(Eq2[2])); 
  
assign Gr = Gr2[2] | (Eq2[2] & Gr2[1]) | (Eq2[2] & Eq2[1] & Gr2[0]); 
assign Lt = Lt2[2] | (Eq2[2] & Lt2[1]) | (Eq2[2] & Eq2[1] & Lt2[0]); 
assign Eq = Eq2[2] & Eq2[1] & Eq2[0];

endmodule

module comparator2b (
    	input logic [1:0] a, b,
    	output logic Gr, Lt, Eq
);

assign Gr = (a[0] & ~b[1] & ~b[0]) | (a[1] & ~b[1]) | (a[1] & a[0] & ~b[0]);
assign Lt = (~a[1] & ~a[0] & b[0]) | (~a[1] & b[1]) | (~a[0] & b[1] & b[0]);
assign Eq = (~a[1] & ~a[0] & ~b[1] & ~b[0]) | (~a[1] & a[0] & ~b[1] & b[0]) | (a[1] & ~a[0] & b[1] & ~b[0]) | (a[1] & a[0] & b[1] & b[0]);

endmodule
