module alu (
    input logic     [31:0]      i_operand_a,
    input logic     [31:0]      i_operand_b,
    input logic     [ 4:0]      i_alu_op,
    output logic    [31:0]      o_alu_data
);
logic   [31:0]      add_sub, shift;
logic   [ 2:0]      compare;

KSA_top             dut_add_sub     (
    .a                              (   i_operand_a     ),
    .b                              (   i_operand_b     ),
    .cin                            (   i_alu_op[0]     ),
    .sum                            (   add_sub         )
);

Barrel_shifter      dut_shifter     (
    .in                             (   i_operand_a                             ),
    .sel                            (   {i_alu_op[2], i_alu_op[1]^i_alu_op[0]}  ),
    .B                              (   i_operand_b[4:0]                        ),
    .out                            (   shift                                   )
);

Comparator          dut_compare     (
    .A                              (   i_operand_a     ),
    .B                              (   i_operand_b     ),
    .sign                           (   ~i_alu_op[0]    ),
    .GES                            (   compare         )
);

always @(*) begin
    case(i_alu_op)
        4'b0000:    o_alu_data  =   add_sub;
        4'b0001:    o_alu_data  =   add_sub;
        4'b0010:    o_alu_data  =   compare[0];
        4'b0011:    o_alu_data  =   compare[0];
        4'b0100:    o_alu_data  =   i_operand_a ^ i_operand_b;
        4'b0101:    o_alu_data  =   i_operand_a | i_operand_b;
        4'b0110:    o_alu_data  =   i_operand_a & i_operand_b;
        4'b0111:    o_alu_data  =   shift;
        4'b1000:    o_alu_data  =   shift;
        4'b1001:    o_alu_data  =   shift;
        4'b1010:    o_alu_data  =   i_operand_b;
        default:    o_alu_data  =   32'hCAFE_CAFE;
    endcase
end

endmodule : alu
