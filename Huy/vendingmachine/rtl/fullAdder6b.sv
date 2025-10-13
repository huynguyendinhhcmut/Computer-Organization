module fullAdder6b (
        input logic [5:0] a, b,
        input logic cin,
        output logic [6:0] sum
);

logic [5:0] carry;

fullAdder fa1 (.sum(sum[0]), .a(a[0]), .b(b[0]^cin), .cin(cin),      .cout(carry[0]));
fullAdder fa2 (.sum(sum[1]), .a(a[1]), .b(b[1]^cin), .cin(carry[0]), .cout(carry[1]));
fullAdder fa3 (.sum(sum[2]), .a(a[2]), .b(b[2]^cin), .cin(carry[1]), .cout(carry[2]));
fullAdder fa4 (.sum(sum[3]), .a(a[3]), .b(b[3]^cin), .cin(carry[2]), .cout(carry[3]));
fullAdder fa5 (.sum(sum[4]), .a(a[4]), .b(b[4]^cin), .cin(carry[3]), .cout(carry[4]));
fullAdder fa6 (.sum(sum[5]), .a(a[5]), .b(b[5]^cin), .cin(carry[4]), .cout(carry[5]));

xor (sum[6], carry[5], cin);

endmodule