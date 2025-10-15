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

module fullAdder (
        input logic a, b, cin,
        output logic sum, cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (cin & (a^b));

endmodule
