module KSA_top (
	input logic [31:0] a,
	input logic [31:0] b,
	input logic cin,
	output logic [31:0] sum,
	output logic cout
);

logic [31:0] g, p;
logic [31:0] b_in;
assign b_in = (cin == 1) ? (b ^ {32{cin}}) : b;
KSA_stage1 stage1 (.a(a), .b(b_in), .g(g), .p(p));

logic [31:0] g_stage2, p_stage2;
KSA_stage2 stage2 (.g_in(g), .p_in(p), .g_out(g_stage2), .p_out(p_stage2));

logic [31:0] g_stage3, p_stage3;
KSA_stage3 stage3 (.g_in(g_stage2), .p_in(p_stage2), .g_out(g_stage3), .p_out(p_stage3));

logic [31:0] g_stage4, p_stage4;
KSA_stage4 stage4 (.g_in(g_stage3), .p_in(p_stage3), .g_out(g_stage4), .p_out(p_stage4));

logic [31:0] g_stage5, p_stage5;
KSA_stage5 stage5 (.g_in(g_stage4), .p_in(p_stage4), .g_out(g_stage5), .p_out(p_stage5));

logic [31:0] g_stage6, p_stage6;
KSA_stage6 stage6 (.g_in(g_stage5), .p_in(p_stage5), .g_out(g_stage6), .p_out(p_stage6));

logic [32:0] Carry;
KSA_stage7 stage7 (.g_in(g_stage6), .p_in(p_stage6), .cin(cin), .Carry(Carry));

assign cout = Carry[32];
assign sum = p[31:0] ^ Carry[31:0];


endmodule : KSA_top