module EX_reg (
    // General signals
    input logic                 i_clk, i_rst,
    input logic     [ 4:0]      i_rs1_addr_EX, i_rs2_addr_EX, i_rd_addr_EX,
    input logic     [31:0]      i_rs1_data_EX, i_rs2_data_EX,
    input logic     [31:0]      i_pc_EX,
    input logic     [31:0]      i_imm_EX,
    input logic     [31:0]      i_pc_plus4_EX,
    input logic                 i_rd_wren_EX,
    input logic     [ 1:0]      i_wb_sel_EX,
    input logic                 i_opa_sel_EX, i_opb_sel_EX,
    input logic                 i_lsu_wren_EX,
    input logic     [ 2:0]      i_funct3_EX,
    input logic                 i_br_un_EX,
    input logic                 i_data_sel_EX,
    input logic     [ 1:0]      i_extend_data_sel_EX,
    input logic                 i_btb_hit_EX,
    output logic                o_btb_hit_EX,
    output logic    [31:0]      o_pc_EX,
    output logic    [31:0]      o_rs1_data_EX, o_rs2_data_EX,
    output logic    [31:0]      o_pc_plus4_EX,
    output logic    [31:0]      o_imm_EX,
    output logic    [ 4:0]      o_rd_addr_EX,
    output logic                o_rd_wren_EX,
    output logic    [ 1:0]      o_wb_sel_EX,
    output logic                o_opa_sel_EX, o_opb_sel_EX,
    output logic                o_lsu_wren_EX,
    output logic    [ 2:0]      o_funct3_EX,
    output logic                o_br_un_EX,
    output logic                o_data_sel_EX,
    output logic    [ 1:0]      o_extend_data_sel_EX,
    // Control signals
    input logic                 i_pc_jump_sel_EX, i_pc_branch_sel_EX,
    input logic                 i_ctrl_EX,
    input logic     [31:0]      i_alu_op_EX,
    output logic    [31:0]      o_alu_op_EX,
    output logic                o_pc_jump_sel_EX, o_pc_branch_sel_EX,
    output logic                o_ctrl_EX,
    // Hazard signals
    input logic                 stall_EX, flush_EX,
    output logic                o_rs1_addr_EX, o_rs2_addr_EX
);
logic   [31:0]  rs1_addr_tmp, rs2_addr_tmp, rd_addr_tmp;

dff #(.WIDTH(5))
dut_rs1_addr            (
    .clk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_rs1_addr_EX   ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   rs1_addr_tmp    )
);

dff #(.WIDTH(5))
dut_rs2_addr            (
    .clk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_rs2_addr_EX   ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   rs2_addr_tmp    )
);

dff #(.WIDTH(5))
dut_rd_addr             (
    .clk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_rd_addr_EX    ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   rd_addr_tmp     )
);

dff #(.WIDTH(32))
dut_pc                  (
    .clk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_pc_EX         ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   o_pc_EX         )
);

dff dut_pc_plus4        (
    .clk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_pc_plus4_EX   ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   o_pc_plus4_EX   )
);

dff dut_rs1_data        (
    .ckk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_rs1_data_EX   ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   o_rs1_data_EX   )
);

dff dut_rs2_data        (
    .ckk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_rs2_data_EX   ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   o_rs2_data_EX   )
);

dff dut_imm_gen         (
    .clk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_imm_EX        ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   o_imm_EX        )
);

dff #(.WIDTH(4))
dut_alu_op              (
    .clk                (   i_clk           ),
    .rst                (   i_rst           ),
    .d                  (   i_alu_op_EX     ),
    .stall              (   stall_EX        ),
    .flush              (   flush_EX        ),
    .q                  (   o_alu_op_EX     )
);

dff #(.WIDTH(1))
dut_pc_jump_sel         (
    .clk                (   i_clk               ),
    .rst                (   i_rst               ),
    .d                  (   i_pc_jump_sel_EX    ),
    .stall              (   stall_EX            ),
    .flush              (   flush_EX            ),
    .q                  (   o_pc_jump_sel_EX    )
);

dff #(.WIDTH(1))
dut_pc_branch_sel       (
    .clk                (   i_clk               ),
    .rst                (   i_rst               ),
    .d                  (   i_pc_branch_sel_EX  ),
    .stall              (   stall_EX            ),
    .flush              (   flush_EX            ),
    .q                  (   o_pc_branch_sel_EX  )
);

dff #(.WIDTH(1))
dut_ctrl                (
    .clk                (   i_clk                   ),
    .rst                (   i_rst                   ),
    .d                  (   i_ctrl_EX               ),
    .stall              (   stall_EX                ),
    .flush              (   flush_EX                ),
    .q                  (   o_ctrl_EX               )
);

dff #(.WIDTH(1))
dut_rd_wren                     (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_rd_wren_EX            ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_rd_wren_EX            )
);

dff #(.WIDTH(2))
dut_wb_sel                      (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_wb_sel_EX             ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_wb_sel_EX             )
);

dff #(.WIDTH(1))
dut_opa_sel                     (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_opa_sel_EX            ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_opa_sel_EX            )
);

dff #(.WIDTH(1))
dut_opb_sel                     (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_opb_sel_EX            ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_opb_sel_EX            )
);

dff #(.WIDTH(1))
dut_lsu_wren                    (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_lsu_wren_EX           ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_lsu_wren_EX           )
);

dff #(.WIDTH(3))
dut_funct3                      (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_funct3_EX             ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_funct3_EX             )
);

dff #(.WIDTH(1))
dut_br_un                       (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_br_un_EX              ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_br_un_EX              )
);

dff #(.WIDTH(1))
dut_data_sel                    (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_data_sel_EX           ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_data_sel_EX           )
);

dff #(.WIDTH(2))
dut_extend_data_sel             (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_extend_data_sel_EX    ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_extend_data_sel_EX    )
);

dff #(.WIDTH(1))
dut_btb_hit                     (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_btb_hit_EX            ),
    .stall                      (   stall_EX                ),
    .flush                      (   flush_EX                ),
    .q                          (   o_btb_hit_EX            )
);

endmodule : EX_reg
