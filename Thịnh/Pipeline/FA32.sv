module FA32 (
	input logic [31:0] a, b,
	input logic cin,
	output logic [31:0] s,
	output logic cout
);
logic [30:0] co;

FA1 dut0 (.a(a[0]), .b(b[0]), .cin(cin), .s(s[0]), .cout(co[0]));
FA1 dut1 (.a(a[1]), .b(b[1]), .cin(co[0]), .s(s[1]), .cout(co[1]));
FA1 dut2 (.a(a[2]), .b(b[2]), .cin(co[1]), .s(s[2]), .cout(co[2]));
FA1 dut3 (.a(a[3]), .b(b[3]), .cin(co[2]), .s(s[3]), .cout(co[3]));
FA1 dut4 (.a(a[4]), .b(b[4]), .cin(co[3]), .s(s[4]), .cout(co[4]));
FA1 dut5 (.a(a[5]), .b(b[5]), .cin(co[4]), .s(s[5]), .cout(co[5]));
FA1 dut6 (.a(a[6]), .b(b[6]), .cin(co[5]), .s(s[6]), .cout(co[6]));
FA1 dut7 (.a(a[7]), .b(b[7]), .cin(co[6]), .s(s[7]), .cout(co[7]));
FA1 dut8 (.a(a[8]), .b(b[8]), .cin(co[7]), .s(s[8]), .cout(co[8]));
FA1 dut9 (.a(a[9]), .b(b[9]), .cin(co[8]), .s(s[9]), .cout(co[9]));
FA1 dut10 (.a(a[10]), .b(b[10]), .cin(co[9]), .s(s[10]), .cout(co[10]));
FA1 dut11 (.a(a[11]), .b(b[11]), .cin(co[10]), .s(s[11]), .cout(co[11]));
FA1 dut12 (.a(a[12]), .b(b[12]), .cin(co[11]), .s(s[12]), .cout(co[12]));
FA1 dut13 (.a(a[13]), .b(b[13]), .cin(co[12]), .s(s[13]), .cout(co[13]));
FA1 dut14 (.a(a[14]), .b(b[14]), .cin(co[13]), .s(s[14]), .cout(co[14]));
FA1 dut15 (.a(a[15]), .b(b[15]), .cin(co[14]), .s(s[15]), .cout(co[15]));
FA1 dut16 (.a(a[16]), .b(b[16]), .cin(co[15]), .s(s[16]), .cout(co[16]));
FA1 dut17 (.a(a[17]), .b(b[17]), .cin(co[16]), .s(s[17]), .cout(co[17]));
FA1 dut18 (.a(a[18]), .b(b[18]), .cin(co[17]), .s(s[18]), .cout(co[18]));
FA1 dut19 (.a(a[19]), .b(b[19]), .cin(co[18]), .s(s[19]), .cout(co[19]));
FA1 dut20 (.a(a[20]), .b(b[20]), .cin(co[19]), .s(s[20]), .cout(co[20]));
FA1 dut21 (.a(a[21]), .b(b[21]), .cin(co[20]), .s(s[21]), .cout(co[21]));
FA1 dut22 (.a(a[22]), .b(b[22]), .cin(co[21]), .s(s[22]), .cout(co[22]));
FA1 dut23 (.a(a[23]), .b(b[23]), .cin(co[22]), .s(s[23]), .cout(co[23]));
FA1 dut24 (.a(a[24]), .b(b[24]), .cin(co[23]), .s(s[24]), .cout(co[24]));
FA1 dut25 (.a(a[25]), .b(b[25]), .cin(co[24]), .s(s[25]), .cout(co[25]));
FA1 dut26 (.a(a[26]), .b(b[26]), .cin(co[25]), .s(s[26]), .cout(co[26]));
FA1 dut27 (.a(a[27]), .b(b[27]), .cin(co[26]), .s(s[27]), .cout(co[27]));
FA1 dut28 (.a(a[28]), .b(b[28]), .cin(co[27]), .s(s[28]), .cout(co[28]));
FA1 dut29 (.a(a[29]), .b(b[29]), .cin(co[28]), .s(s[29]), .cout(co[29]));
FA1 dut30 (.a(a[30]), .b(b[30]), .cin(co[29]), .s(s[30]), .cout(co[30]));
FA1 dut31 (.a(a[31]), .b(b[31]), .cin(co[30]), .s(s[31]), .cout(cout));

endmodule : FA32