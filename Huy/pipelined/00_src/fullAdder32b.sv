module fullAdder32b (
        input logic [31:0] a, b,
        input logic cin,
        output logic [31:0] sum,
        output logic cout
);

logic [31:0] carry;

fullAdder fa1 (.sum(sum[0]),   .a(a[0]),  .b(b[0]^cin),  .cin(cin),       .cout(carry[0]));
fullAdder fa2 (.sum(sum[1]),   .a(a[1]),  .b(b[1]^cin),  .cin(carry[0]),  .cout(carry[1]));
fullAdder fa3 (.sum(sum[2]),   .a(a[2]),  .b(b[2]^cin),  .cin(carry[1]),  .cout(carry[2]));
fullAdder fa4 (.sum(sum[3]),   .a(a[3]),  .b(b[3]^cin),  .cin(carry[2]),  .cout(carry[3]));
fullAdder fa5 (.sum(sum[4]),   .a(a[4]),  .b(b[4]^cin),  .cin(carry[3]),  .cout(carry[4]));
fullAdder fa6 (.sum(sum[5]),   .a(a[5]),  .b(b[5]^cin),  .cin(carry[4]),  .cout(carry[5]));
fullAdder fa7 (.sum(sum[6]),   .a(a[6]),  .b(b[6]^cin),  .cin(carry[5]),  .cout(carry[6]));
fullAdder fa8 (.sum(sum[7]),   .a(a[7]),  .b(b[7]^cin),  .cin(carry[6]),  .cout(carry[7]));
fullAdder fa9 (.sum(sum[8]),   .a(a[8]),  .b(b[8]^cin),  .cin(carry[7]),  .cout(carry[8]));
fullAdder fa10 (.sum(sum[9]),  .a(a[9]),  .b(b[9]^cin),  .cin(carry[8]),  .cout(carry[9]));
fullAdder fa11 (.sum(sum[10]), .a(a[10]), .b(b[10]^cin), .cin(carry[9]),  .cout(carry[10]));
fullAdder fa12 (.sum(sum[11]), .a(a[11]), .b(b[11]^cin), .cin(carry[10]), .cout(carry[11]));
fullAdder fa13 (.sum(sum[12]), .a(a[12]), .b(b[12]^cin), .cin(carry[11]), .cout(carry[12]));
fullAdder fa14 (.sum(sum[13]), .a(a[13]), .b(b[13]^cin), .cin(carry[12]), .cout(carry[13]));
fullAdder fa15 (.sum(sum[14]), .a(a[14]), .b(b[14]^cin), .cin(carry[13]), .cout(carry[14]));
fullAdder fa16 (.sum(sum[15]), .a(a[15]), .b(b[15]^cin), .cin(carry[14]), .cout(carry[15]));
fullAdder fa17 (.sum(sum[16]), .a(a[16]), .b(b[16]^cin), .cin(carry[15]), .cout(carry[16]));
fullAdder fa18 (.sum(sum[17]), .a(a[17]), .b(b[17]^cin), .cin(carry[16]), .cout(carry[17]));
fullAdder fa19 (.sum(sum[18]), .a(a[18]), .b(b[18]^cin), .cin(carry[17]), .cout(carry[18]));
fullAdder fa20 (.sum(sum[19]), .a(a[19]), .b(b[19]^cin), .cin(carry[18]), .cout(carry[19]));
fullAdder fa21 (.sum(sum[20]), .a(a[20]), .b(b[20]^cin), .cin(carry[19]), .cout(carry[20]));
fullAdder fa22 (.sum(sum[21]), .a(a[21]), .b(b[21]^cin), .cin(carry[20]), .cout(carry[21]));
fullAdder fa23 (.sum(sum[22]), .a(a[22]), .b(b[22]^cin), .cin(carry[21]), .cout(carry[22]));
fullAdder fa24 (.sum(sum[23]), .a(a[23]), .b(b[23]^cin), .cin(carry[22]), .cout(carry[23]));
fullAdder fa25 (.sum(sum[24]), .a(a[24]), .b(b[24]^cin), .cin(carry[23]), .cout(carry[24]));
fullAdder fa26 (.sum(sum[25]), .a(a[25]), .b(b[25]^cin), .cin(carry[24]), .cout(carry[25]));
fullAdder fa27 (.sum(sum[26]), .a(a[26]), .b(b[26]^cin), .cin(carry[25]), .cout(carry[26]));
fullAdder fa28 (.sum(sum[27]), .a(a[27]), .b(b[27]^cin), .cin(carry[26]), .cout(carry[27]));
fullAdder fa29 (.sum(sum[28]), .a(a[28]), .b(b[28]^cin), .cin(carry[27]), .cout(carry[28]));
fullAdder fa30 (.sum(sum[29]), .a(a[29]), .b(b[29]^cin), .cin(carry[28]), .cout(carry[29]));
fullAdder fa31 (.sum(sum[30]), .a(a[30]), .b(b[30]^cin), .cin(carry[29]), .cout(carry[30]));
fullAdder fa32 (.sum(sum[31]), .a(a[31]), .b(b[31]^cin), .cin(carry[30]), .cout(carry[31]));

xor (cout, carry[31], cin);

endmodule

module fullAdder10b (
	input logic [9:0] a, b,
   input logic cin,
   output logic [9:0] sum,
   output logic cout
);

logic [9:0] carry;

fullAdder fa1 (.sum(sum[0]),   .a(a[0]),  .b(b[0]^cin),  .cin(cin),       .cout(carry[0]));
fullAdder fa2 (.sum(sum[1]),   .a(a[1]),  .b(b[1]^cin),  .cin(carry[0]),  .cout(carry[1]));
fullAdder fa3 (.sum(sum[2]),   .a(a[2]),  .b(b[2]^cin),  .cin(carry[1]),  .cout(carry[2]));
fullAdder fa4 (.sum(sum[3]),   .a(a[3]),  .b(b[3]^cin),  .cin(carry[2]),  .cout(carry[3]));
fullAdder fa5 (.sum(sum[4]),   .a(a[4]),  .b(b[4]^cin),  .cin(carry[3]),  .cout(carry[4]));
fullAdder fa6 (.sum(sum[5]),   .a(a[5]),  .b(b[5]^cin),  .cin(carry[4]),  .cout(carry[5]));
fullAdder fa7 (.sum(sum[6]),   .a(a[6]),  .b(b[6]^cin),  .cin(carry[5]),  .cout(carry[6]));
fullAdder fa8 (.sum(sum[7]),   .a(a[7]),  .b(b[7]^cin),  .cin(carry[6]),  .cout(carry[7]));
fullAdder fa9 (.sum(sum[8]),   .a(a[8]),  .b(b[8]^cin),  .cin(carry[7]),  .cout(carry[8]));
fullAdder fa10 (.sum(sum[9]),  .a(a[9]),  .b(b[9]^cin),  .cin(carry[8]),  .cout(carry[9]));

xor (cout, carry[9], cin);

endmodule

module fullAdder15b (
	input logic [14:0] a, b,
   input logic cin,
   output logic [14:0] sum,
   output logic cout
);

logic [14:0] carry;

fullAdder fa1 (.sum(sum[0]),   .a(a[0]),  .b(b[0]^cin),  .cin(cin),       .cout(carry[0]));
fullAdder fa2 (.sum(sum[1]),   .a(a[1]),  .b(b[1]^cin),  .cin(carry[0]),  .cout(carry[1]));
fullAdder fa3 (.sum(sum[2]),   .a(a[2]),  .b(b[2]^cin),  .cin(carry[1]),  .cout(carry[2]));
fullAdder fa4 (.sum(sum[3]),   .a(a[3]),  .b(b[3]^cin),  .cin(carry[2]),  .cout(carry[3]));
fullAdder fa5 (.sum(sum[4]),   .a(a[4]),  .b(b[4]^cin),  .cin(carry[3]),  .cout(carry[4]));
fullAdder fa6 (.sum(sum[5]),   .a(a[5]),  .b(b[5]^cin),  .cin(carry[4]),  .cout(carry[5]));
fullAdder fa7 (.sum(sum[6]),   .a(a[6]),  .b(b[6]^cin),  .cin(carry[5]),  .cout(carry[6]));
fullAdder fa8 (.sum(sum[7]),   .a(a[7]),  .b(b[7]^cin),  .cin(carry[6]),  .cout(carry[7]));
fullAdder fa9 (.sum(sum[8]),   .a(a[8]),  .b(b[8]^cin),  .cin(carry[7]),  .cout(carry[8]));
fullAdder fa10 (.sum(sum[9]),  .a(a[9]),  .b(b[9]^cin),  .cin(carry[8]),  .cout(carry[9]));
fullAdder fa11 (.sum(sum[10]), .a(a[10]), .b(b[10]^cin), .cin(carry[9]),  .cout(carry[10]));
fullAdder fa12 (.sum(sum[11]), .a(a[11]), .b(b[11]^cin), .cin(carry[10]), .cout(carry[11]));
fullAdder fa13 (.sum(sum[12]), .a(a[12]), .b(b[12]^cin), .cin(carry[11]), .cout(carry[12]));
fullAdder fa14 (.sum(sum[13]), .a(a[13]), .b(b[13]^cin), .cin(carry[12]), .cout(carry[13]));
fullAdder fa15 (.sum(sum[14]), .a(a[14]), .b(b[14]^cin), .cin(carry[13]), .cout(carry[14]));

xor (cout, carry[14], cin);

endmodule


module fullAdder (
        input logic a, b, cin,
        output logic sum, cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (cin & (a^b));

endmodule



module fullAdder64b (
        input logic [63:0] a, b,
        input logic cin,
        output logic [63:0] sum,
        output logic cout
);

logic [63:0] carry;

fullAdder fa1 (.sum(sum[0]),   .a(a[0]),  .b(b[0]^cin),  .cin(cin),       .cout(carry[0]));
fullAdder fa2 (.sum(sum[1]),   .a(a[1]),  .b(b[1]^cin),  .cin(carry[0]),  .cout(carry[1]));
fullAdder fa3 (.sum(sum[2]),   .a(a[2]),  .b(b[2]^cin),  .cin(carry[1]),  .cout(carry[2]));
fullAdder fa4 (.sum(sum[3]),   .a(a[3]),  .b(b[3]^cin),  .cin(carry[2]),  .cout(carry[3]));
fullAdder fa5 (.sum(sum[4]),   .a(a[4]),  .b(b[4]^cin),  .cin(carry[3]),  .cout(carry[4]));
fullAdder fa6 (.sum(sum[5]),   .a(a[5]),  .b(b[5]^cin),  .cin(carry[4]),  .cout(carry[5]));
fullAdder fa7 (.sum(sum[6]),   .a(a[6]),  .b(b[6]^cin),  .cin(carry[5]),  .cout(carry[6]));
fullAdder fa8 (.sum(sum[7]),   .a(a[7]),  .b(b[7]^cin),  .cin(carry[6]),  .cout(carry[7]));
fullAdder fa9 (.sum(sum[8]),   .a(a[8]),  .b(b[8]^cin),  .cin(carry[7]),  .cout(carry[8]));
fullAdder fa10 (.sum(sum[9]),  .a(a[9]),  .b(b[9]^cin),  .cin(carry[8]),  .cout(carry[9]));
fullAdder fa11 (.sum(sum[10]), .a(a[10]), .b(b[10]^cin), .cin(carry[9]),  .cout(carry[10]));
fullAdder fa12 (.sum(sum[11]), .a(a[11]), .b(b[11]^cin), .cin(carry[10]), .cout(carry[11]));
fullAdder fa13 (.sum(sum[12]), .a(a[12]), .b(b[12]^cin), .cin(carry[11]), .cout(carry[12]));
fullAdder fa14 (.sum(sum[13]), .a(a[13]), .b(b[13]^cin), .cin(carry[12]), .cout(carry[13]));
fullAdder fa15 (.sum(sum[14]), .a(a[14]), .b(b[14]^cin), .cin(carry[13]), .cout(carry[14]));
fullAdder fa16 (.sum(sum[15]), .a(a[15]), .b(b[15]^cin), .cin(carry[14]), .cout(carry[15]));
fullAdder fa17 (.sum(sum[16]), .a(a[16]), .b(b[16]^cin), .cin(carry[15]), .cout(carry[16]));
fullAdder fa18 (.sum(sum[17]), .a(a[17]), .b(b[17]^cin), .cin(carry[16]), .cout(carry[17]));
fullAdder fa19 (.sum(sum[18]), .a(a[18]), .b(b[18]^cin), .cin(carry[17]), .cout(carry[18]));
fullAdder fa20 (.sum(sum[19]), .a(a[19]), .b(b[19]^cin), .cin(carry[18]), .cout(carry[19]));
fullAdder fa21 (.sum(sum[20]), .a(a[20]), .b(b[20]^cin), .cin(carry[19]), .cout(carry[20]));
fullAdder fa22 (.sum(sum[21]), .a(a[21]), .b(b[21]^cin), .cin(carry[20]), .cout(carry[21]));
fullAdder fa23 (.sum(sum[22]), .a(a[22]), .b(b[22]^cin), .cin(carry[21]), .cout(carry[22]));
fullAdder fa24 (.sum(sum[23]), .a(a[23]), .b(b[23]^cin), .cin(carry[22]), .cout(carry[23]));
fullAdder fa25 (.sum(sum[24]), .a(a[24]), .b(b[24]^cin), .cin(carry[23]), .cout(carry[24]));
fullAdder fa26 (.sum(sum[25]), .a(a[25]), .b(b[25]^cin), .cin(carry[24]), .cout(carry[25]));
fullAdder fa27 (.sum(sum[26]), .a(a[26]), .b(b[26]^cin), .cin(carry[25]), .cout(carry[26]));
fullAdder fa28 (.sum(sum[27]), .a(a[27]), .b(b[27]^cin), .cin(carry[26]), .cout(carry[27]));
fullAdder fa29 (.sum(sum[28]), .a(a[28]), .b(b[28]^cin), .cin(carry[27]), .cout(carry[28]));
fullAdder fa30 (.sum(sum[29]), .a(a[29]), .b(b[29]^cin), .cin(carry[28]), .cout(carry[29]));
fullAdder fa31 (.sum(sum[30]), .a(a[30]), .b(b[30]^cin), .cin(carry[29]), .cout(carry[30]));
fullAdder fa32 (.sum(sum[31]), .a(a[31]), .b(b[31]^cin), .cin(carry[30]), .cout(carry[31]));
fullAdder fa33 (.sum(sum[32]), .a(a[32]), .b(b[32]^cin), .cin(carry[31]), .cout(carry[32]));
fullAdder fa34 (.sum(sum[33]), .a(a[33]), .b(b[33]^cin), .cin(carry[32]), .cout(carry[33]));
fullAdder fa35 (.sum(sum[34]), .a(a[34]), .b(b[34]^cin), .cin(carry[33]), .cout(carry[34]));
fullAdder fa36 (.sum(sum[35]), .a(a[35]), .b(b[35]^cin), .cin(carry[34]), .cout(carry[35]));
fullAdder fa37 (.sum(sum[36]), .a(a[36]), .b(b[36]^cin), .cin(carry[35]), .cout(carry[36]));
fullAdder fa38 (.sum(sum[37]), .a(a[37]), .b(b[37]^cin), .cin(carry[36]), .cout(carry[37]));
fullAdder fa39 (.sum(sum[38]), .a(a[38]), .b(b[38]^cin), .cin(carry[37]), .cout(carry[38]));
fullAdder fa40 (.sum(sum[39]), .a(a[39]), .b(b[39]^cin), .cin(carry[38]), .cout(carry[39]));
fullAdder fa41 (.sum(sum[40]), .a(a[40]), .b(b[40]^cin), .cin(carry[39]), .cout(carry[40]));
fullAdder fa42 (.sum(sum[41]), .a(a[41]), .b(b[41]^cin), .cin(carry[40]), .cout(carry[41]));
fullAdder fa43 (.sum(sum[42]), .a(a[42]), .b(b[42]^cin), .cin(carry[41]), .cout(carry[42]));
fullAdder fa44 (.sum(sum[43]), .a(a[43]), .b(b[43]^cin), .cin(carry[42]), .cout(carry[43]));
fullAdder fa45 (.sum(sum[44]), .a(a[44]), .b(b[44]^cin), .cin(carry[43]), .cout(carry[44]));
fullAdder fa46 (.sum(sum[45]), .a(a[45]), .b(b[45]^cin), .cin(carry[44]), .cout(carry[45]));
fullAdder fa47 (.sum(sum[46]), .a(a[46]), .b(b[46]^cin), .cin(carry[45]), .cout(carry[46]));
fullAdder fa48 (.sum(sum[47]), .a(a[47]), .b(b[47]^cin), .cin(carry[46]), .cout(carry[47]));
fullAdder fa49 (.sum(sum[48]), .a(a[48]), .b(b[48]^cin), .cin(carry[47]), .cout(carry[48]));
fullAdder fa50 (.sum(sum[49]), .a(a[49]), .b(b[49]^cin), .cin(carry[48]), .cout(carry[49]));
fullAdder fa51 (.sum(sum[50]), .a(a[50]), .b(b[50]^cin), .cin(carry[49]), .cout(carry[50]));
fullAdder fa52 (.sum(sum[51]), .a(a[51]), .b(b[51]^cin), .cin(carry[50]), .cout(carry[51]));
fullAdder fa53 (.sum(sum[52]), .a(a[52]), .b(b[52]^cin), .cin(carry[51]), .cout(carry[52]));
fullAdder fa54 (.sum(sum[53]), .a(a[53]), .b(b[53]^cin), .cin(carry[52]), .cout(carry[53]));
fullAdder fa55 (.sum(sum[54]), .a(a[54]), .b(b[54]^cin), .cin(carry[53]), .cout(carry[54]));
fullAdder fa56 (.sum(sum[55]), .a(a[55]), .b(b[55]^cin), .cin(carry[54]), .cout(carry[55]));
fullAdder fa57 (.sum(sum[56]), .a(a[56]), .b(b[56]^cin), .cin(carry[55]), .cout(carry[56]));
fullAdder fa58 (.sum(sum[57]), .a(a[57]), .b(b[57]^cin), .cin(carry[56]), .cout(carry[57]));
fullAdder fa59 (.sum(sum[58]), .a(a[58]), .b(b[58]^cin), .cin(carry[57]), .cout(carry[58]));
fullAdder fa60 (.sum(sum[59]), .a(a[59]), .b(b[59]^cin), .cin(carry[58]), .cout(carry[59]));
fullAdder fa61 (.sum(sum[60]), .a(a[60]), .b(b[60]^cin), .cin(carry[59]), .cout(carry[60]));
fullAdder fa62 (.sum(sum[61]), .a(a[61]), .b(b[61]^cin), .cin(carry[60]), .cout(carry[61]));
fullAdder fa63 (.sum(sum[62]), .a(a[62]), .b(b[62]^cin), .cin(carry[61]), .cout(carry[62]));
fullAdder fa64 (.sum(sum[63]), .a(a[63]), .b(b[63]^cin), .cin(carry[62]), .cout(carry[63]));

xor (cout, carry[63], cin);

endmodule
