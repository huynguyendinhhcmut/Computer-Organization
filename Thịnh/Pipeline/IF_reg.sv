module IF_reg (
    input logic             i_clk, i_rstn,
    input logic     [31:0]  i_pc_next,
    input logic             stall_IF, flush_IF,
    output logic    [31:0]  o_pc_IF
);

dff dut_IF_reg  (
    .clk        (   i_clk       ),
    .rst        (   i_rstn      ),
    .d          (   i_pc_next   ),
    .stall      (   stall_IF    ),
    .flush      (   flush_IF    ),
    .q          (   o_pc_IF     )
);

endmodule : IF_reg
