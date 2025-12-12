module pipelined (
    input logic                 i_clk, i_reset,
    input logic     [31:0]      i_io_sw,
    output logic    [31:0]      o_pc_debug,
    output logic                o_insn_vld,
    output logic                o_ctrl,
    output logic                o_mispred,
    output logic    [31:0]      o_io_ledr, o_io_ledg,
    output logic    [ 6:0]      o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
    output logic    [31:0]      o_io_lcd
);
// Internal signals
logic   [ 6: 0]     opcode, funct7;
logic   [ 2: 0]     funct3;
logic   [ 1: 0]     wb_sel, extend_data_sel, wb_sel_EX;
logic               data_sel, opa_sel, opb_sel;
logic               rd_wren, lsu_wren;
logic               br_un;
logic   [ 2: 0]     imm_sel;
logic   [ 3: 0]     alu_op;
logic               ctrl, pc_branch_sel, pc_jump_sel;
logic               stall_IF, flush_IF;
logic               stall_ID, flush_ID;
logic               stall_EX, flush_EX;
logic               stall_DM, flush_DM;
logic               stall_WB, flush_WB;
logic               forward_a, forward_b;
logic   [ 4: 0]     rs1_addr_EX, rs2_addr_EX, rd_addr_EX;
logic   [ 4: 0]     rs1_addr_DM, rs2_addr_DM, rd_addr_DM;
logic   [ 4: 0]     rd_addr_WB;
logic               debug_pc_next;

/* ----- DUT ----- */
control_unit        dut_control_unit        (
    .i_op                                   (   opcode                  ),
    .i_funct3                               (   funct3                  ),
    .i_funct7_5                             (   funct7[5]               ),
    //.i_ges                                  (),
    .o_data_sel                             (   data_sel                ),
    .o_rd_wren                              (   rd_wren                 ),
    .o_br_un                                (   br_un                   ),
    .o_opa_sel                              (   opa_sel                 ),
    .o_opb_sel                              (   opb_sel                 ),
    .o_mem_wren                             (   lsu_wren                ),
    .o_insn_vld                             (   o_insn_vld              ),
    .o_imm_sel                              (   imm_sel                 ),
    .o_alu_op                               (   alu_op                  ),
    .o_wb_sel                               (   wb_sel                  ),
    .o_sl_sel                               (   extend_data_sel         ),
    .o_pc_branch_sel                        (   pc_branch_sel           ),
    .o_pc_jump_sel                          (   pc_jump_sel             ),
    .o_ctrl                                 (   ctrl                    )
);

datapath            dut_datapath            (
    .i_clk                                  (   i_clk                   ),
    .i_rstn                                 (   i_reset                 ),
    .i_io_sw                                (   i_io_sw                 ),
    .o_ledg                                 (   o_io_ledg               ),
    .o_ledr                                 (   o_io_ledr               ),
    .o_lcd                                  (   o_io_lcd                ),
    .o_hex0                                 (   o_io_hex0               ),
    .o_hex1                                 (   o_io_hex1               ),
    .o_hex2                                 (   o_io_hex2               ),
    .o_hex3                                 (   o_io_hex3               ),
    .o_hex4                                 (   o_io_hex4               ),
    .o_hex5                                 (   o_io_hex5               ),
    .o_hex6                                 (   o_io_hex6               ),
    .o_hex7                                 (   o_io_hex7               ),
    .i_extend_data_sel_ID                   (   extend_data_sel         ),
    .i_data_sel_ID                          (   data_sel                ),
    .i_br_un_ID                             (   br_un                   ),
    .i_lsu_wren_ID                          (   lsu_wren                ),
    .i_opa_sel_ID                           (   opa_sel                 ),
    .i_opb_sel_ID                           (   opb_sel                 ),
    .i_wb_sel_ID                            (   wb_sel                  ),
    .i_pc_jump_sel_ID                       (   pc_jump_sel             ),
    .i_pc_branch_sel_ID                     (   pc_branch_sel           ),
    .i_ctrl_ID                              (   ctrl                    ),
    .i_alu_op_ID                            (   alu_op                  ),
    .i_rd_wren_ID                           (   rd_wren                 ),
    .i_imm_sel_ID                           (   imm_sel                 ),
    .o_op_ID                                (   opcode                  ),
    .o_wb_sel_EX                            (   wb_sel_EX               ),
    .o_funct3_ID                            (   funct3                  ),
    .o_funct7_ID                            (   funct7                  ),
    .o_ctrl                                 (   o_ctrl                  ),
    .o_pc_debug                             (   o_pc_debug              ),
    .i_stall_IF                             (   stall_IF                ),
    .i_flush_IF                             (   flush_IF                ),
    .i_stall_ID                             (   stall_ID                ),
    .i_flush_ID                             (   flush_ID                ),
    .i_stall_EX                             (   stall_EX                ),
    .i_flush_EX                             (   flush_EX                ),
    .i_stall_DM                             (   stall_DM                ),
    .i_flush_DM                             (   flush_DM                ),
    .i_stall_WB                             (   stall_WB                ),
    .i_flush_WB                             (   flush_WB                ),
    .i_forward_a_EX                         (   forward_a               ),
    .i_forward_b_EX                         (   forward_b               ),
    .o_rs1_addr_EX                          (   rs1_addr_EX             ),
    .o_rs2_addr_EX                          (   rs2_addr_EX             ),
    .o_rd_addr_EX                           (   rd_addr_EX              ),
    .o_rs1_addr_DM                          (   rs1_addr_DM             ),
    .o_rs2_addr_DM                          (   rs2_addr_DM             ),
    .o_rd_addr_DM                           (   rd_addr_DM              ),
    .o_rd_addr_WB                           (   rd_addr_WB              ),
    .o_debug_pc_next_EX                     (   debug_pc_next           )
);

hazard_unit         dut_hazard_unit         (
    .i_rs1_addr_EX                          (   rs1_addr_EX             ),
    .i_rs2_addr_EX                          (   rs2_addr_EX             ),
    .i_rd_addr_EX                           (   rd_addr_EX              ),
    .i_rs1_addr_DM                          (   rs1_addr_DM             ),
    .i_rs2_addr_DM                          (   rs2_addr_DM             ),
    .i_rd_addr_DM                           (   rd_addr_DM              ),
    .i_rd_addr_WB                           (   rd_addr_WB              ),
    .i_debug_pc_next                        (   debug_pc_next           ),
    .o_forward_a_EX                         (   forward_a               ),
    .o_forward_b_EX                         (   forward_b               ),
    .o_stall_IF                             (   stall_IF                ),
    .o_flush_IF                             (   flush_IF                ),
    .o_stall_ID                             (   stall_ID                ),
    .o_flush_ID                             (   flush_ID                ),
    .o_stall_EX                             (   stall_EX                ),
    .o_flush_EX                             (   flush_EX                ),
    .o_stall_DM                             (   stall_DM                ),
    .o_flush_DM                             (   flush_DM                ),
    .o_stall_WB                             (   stall_WB                ),
    .o_flush_WB                             (   flush_WB                ),
    .i_wb_sel_EX                            (   wb_sel_EX               )
);

endmodule : pipelined
