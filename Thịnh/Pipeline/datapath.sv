module datapath(
    // General signals
    input logic                 i_clk, i_rstn,
    input logic     [31: 0]     i_io_sw,
    output logic    [31: 0]     o_ledg, o_ledr, o_lcd,
    output logic    [ 7: 0]     o_hex0, o_hex1, o_hex2, o_hex3, o_hex4, o_hex5, o_hex6, o_hex7,
    // Control signals
    // IF stage
    // ID stage
    input logic                 i_ctrl_ID,
    input logic     [ 1: 0]     i_extend_data_sel_ID,
    input logic                 i_data_sel_ID,
    input logic                 i_br_un_ID,
    input logic                 i_lsu_wren_ID,
    input logic                 i_opa_sel_ID, i_opb_sel_ID,
    input logic     [ 1: 0]     i_wb_sel_ID,
    input logic                 i_pc_jump_sel_ID, i_pc_branch_sel_ID,
    input logic     [ 3: 0]     i_alu_op_ID,
    input logic                 i_rd_wren_ID,
    input logic     [ 2: 0]     i_imm_sel_ID,
    output logic    [ 1: 0]     o_wb_sel_EX,
    output logic    [ 6: 0]     o_op_ID,
    output logic    [ 2: 0]     o_funct3_ID,
    output logic    [ 6: 0]     o_funct7_ID,
    // EX stage
    // DM stage
    // WB stage
    output logic                o_ctrl,
    output logic    [31: 0]     o_pc_debug,
    // Hazard signals
    input logic                 i_stall_IF, i_flush_IF,
    input logic                 i_stall_ID, i_flush_ID,
    input logic                 i_stall_EX, i_flush_EX,
    input logic                 i_stall_DM, i_flush_DM,
    input logic                 i_stall_WB, i_flush_WB,
    input logic     [ 1: 0]     i_forward_a_EX, i_forward_b_EX,
    output logic    [ 4: 0]     o_rs1_addr_EX, o_rs2_addr_EX, o_rd_addr_EX,
    output logic    [ 4: 0]     o_rs1_addr_DM, o_rs2_addr_DM, o_rd_addr_DM,
    output logic    [ 4: 0]     o_rd_addr_WB,
    output logic                o_debug_pc_next_EX
);
/* Internals signal */
// In-Out IF
logic   [31:0]      predicted_pc_IF, pc_plus4_IF, pc_next, pc_IF;
logic               btb_hit_IF, target_match, debug_pc_next;
logic   [31:0]      normal_pc, debug_pc1, debug_pc;
// In-Out ID             
logic   [31:0]      current_instr;
logic   [31:0]      rs1_data_ID, rs2_data_ID;
logic   [31:0]      imm_ID;
logic   [31:0]      pc_ID, pc_plus4_ID;
logic               btb_hit_ID;
// In-Out EX
logic               rd_wren_EX, lsu_wren_EX, br_un_EX;
logic               pc_sel, data_sel_EX;
logic               btb_hit_EX, ctrl_EX;
logic   [31:0]      pc_EX, pc_plus4_EX, alu_result_EX;
logic   [31:0]      rs1_data_EX, rs2_data_EX;
logic   [31:0]      rs1_tmp, rs2_tmp;
logic   [31:0]      imm_EX;
logic   [ 1:0]      wb_sel_EX, extend_data_sel_EX;
logic               opa_sel_EX, opb_sel_EX;
logic   [ 2:0]      funct3_EX;
logic               pc_jump_sel_EX, pc_branch_sel_EX;
logic   [ 3:0]      alu_op_EX;
logic   [31:0]      src_a_EX, src_b_EX;
logic               compare;
// In-Out DM
logic               rd_wren_DM, lsu_wren_DM, data_sel_DM;
logic   [ 1:0]      extend_data_sel_DM, wb_sel_DM;
logic               ctrl_DM;
logic   [ 2:0]      funct3_DM;
logic   [31:0]      alu_result_DM, pc_DM, pc_plus4_DM, rs2_data_DM, lsu_data_DM;
// In-Out WB
logic               rd_wren_WB, data_sel_WB;
logic   [ 1:0]      extend_data_sel_WB, wb_sel_WB;
logic   [31:0]      final_wdata;
logic   [31:0]      alu_result_WB, pc_plus4_WB, lsu_data_WB, data_WB, extend_data_WB;



/* ----- DUT in IF ----- */
FA32 dut_pc_plus4   (
    .a              (   pc_IF       ),
    .b              (   32'h4       ),
    .cin            (   1'b0        ),
    .s              (   pc_plus4_IF )
);

mux2_1  #(.N(32))
dut_normal_pc       (
    .in0            (   pc_IF               ),
    .in1            (   predicted_pc_IF     ),
    .sel            (   btb_hit_IF          ),
    .out            (   normal_pc           )
);

mux2_1  #(.N(32))
dut_debug_pc_1      (
    .in0            (   pc_plus4_EX         ),
    .in1            (   alu_result_EX       ),
    .sel            (   pc_sel              ),
    .out            (   debug_pc1           )
);

mux2_1  #(.N(32))
dut_debug_pc_2      (
    .in0            (   debug_pc1           ),
    .in1            (   predicted_pc_IF     ),
    .sel            (   target_match        ),
    .out            (   debug_pc            )
);

mux2_1  #(.N(32))
dut_pc_next         (
    .in0            (   normal_pc           ),
    .in1            (   debug_pc            ),
    .sel            (   debug_pc_next       ),
    .out            (   pc_next             )
);

btb     dut_btb                 (
    .i_clk                      (   i_clk               ),
    .i_pc_IF                    (   pc_IF               ),
    .i_pc_plus4_EX              (   pc_plus4_EX         ),
    .i_pc_update                (   pc_EX               ),
    .i_target_update            (   alu_result_EX       ),
    .i_update_btb_en            (   pc_sel              ),
    .i_pc_sel                   (   pc_sel              ),
    .i_btb_hit_EX               (   btb_hit_EX          ),
    .o_predicted_pc_IF          (   predicted_pc_IF     ),
    .o_pc_plus4_not_branch      (   pc_plus4_EX         ),
    .o_btb_hit                  (   btb_hit_IF          ),
    .o_target_match             (   target_match        ),
    .o_debug_pc_next            (   debug_pc_next       )
);

IF_reg  dut_IF_reg  (
    .i_clk          (   i_clk               ),
    .i_rstn         (   i_rstn              ),
    .i_pc_next      (   pc_next             ),
    .stall_IF       (   i_stall_IF          ),
    .flush_IF       (   i_flush_IF          ),
    .o_pc_IF        (   pc_IF               )
);

/* ----- DUT in ID ----- */
instrmem    dut_imem    (
    .i_clk              (   i_clk           ),
    .i_rst              (   i_rstn          ),
    .stall_ID           (   i_stall_ID      ),
    .flush_ID           (   i_flush_ID      ),
    .i_pc               (   pc_IF           ),
    .o_instr            (   current_instr   )
);

regfile dut_regfile     (
    .clk                (   i_clk                   ),
    .rst_n              (   i_rstn                  ),
    .WE3                (   rd_wren_WB              ),
    .A1                 (   current_instr[19:15]    ),
    .A2                 (   current_instr[24:20]    ),
    .A3                 (   o_rd_addr_WB            ),
    .WD3                (   final_wdata             ),
    .RD1                (   rs1_data_ID             ),
    .RD2                (   rs2_data_ID             )
);

immgen  dut_immgen      (
    .in                 (   current_instr[31:7]     ),
    .imm_sel            (   i_imm_sel_ID            ),
    .out                (   imm_ID                  )
);

ID_reg  dut_ID_reg      (
    .i_clk              (   i_clk                   ),
    .i_rst              (   i_rstn                  ),
    .i_pc_ID            (   pc_IF                   ),
    .i_pc_plus4_ID      (   pc_plus4_IF             ),
    .i_btb_hit_ID       (   btb_hit_IF              ),
    .stall_ID           (   i_stall_ID              ),
    .flush_ID           (   i_flush_ID              ),
    .o_pc_ID            (   pc_ID                   ),
    .o_pc_plus4_ID      (   pc_plus4_ID             ),
    .o_btb_hit_ID       (   btb_hit_ID              )
);

assign  o_op_ID =   current_instr[6:0];

/* ----- DUT in EX ----- */
mux4_1  dut_mux_forward_a       (
    .in0                        (   rs1_data_EX     ),
    .in1                        (   final_wdata     ),
    .in2                        (   alu_result_DM   ),
    .in3                        (   32'hCAFE_CAFE   ),
    .sel                        (   i_forward_a_EX  ),
    .out                        (   rs1_tmp         )
);

mux4_1  dut_mux_forward_b       (
    .in0                        (   rs2_data_EX     ),
    .in1                        (   final_wdata     ),
    .in2                        (   alu_result_DM   ),
    .in3                        (   32'hCAFE_CAFE   ),
    .sel                        (   i_forward_b_EX  ),
    .out                        (   rs2_tmp         )   
);

mux2_1  dut_mux_a               (
    .in0                        (   rs1_tmp         ),
    .in1                        (   pc_EX           ),
    .sel                        (   opa_sel_EX      ),
    .out                        (   src_a_EX        )
);

mux2_1  dut_mux_b               (
    .in0                        (   rs2_tmp         ),
    .in1                        (   imm_EX          ),
    .sel                        (   opb_sel_EX      ),
    .out                        (   src_b_EX        )
);

alu     dut_alu                 (
    .i_operand_a                (   src_a_EX        ),
    .i_operand_b                (   src_b_EX        ),
    .i_alu_op                   (   alu_op_EX       ),
    .o_alu_data                 (   alu_result_EX   ),
);

brc     dut_brc                 (
    .A                          (   rs1_tmp     ),
    .B                          (   rs2_tmp     ),
    .sign                       (   br_un_EX    ),
    .i_funct3                   (   funct3_EX   ),
    .o_compare                  (   compare     )
);

assign  pc_sel  =   (compare & i_pc_branch_sel_ID) | i_pc_jump_sel_ID;

EX_reg  dut_EX_reg              (
    .i_clk                      (   i_clk                                   ),
    .i_rst                      (   i_rstn                                  ),
    .i_rs1_addr_EX              (   current_instr[19:15]                    ),
    .i_rs2_addr_EX              (   current_instr[24:20]                    ),
    .i_rd_addr_EX               (   current_instr[11: 7]                    ),
    .i_rs1_data_EX              (   rs1_data_ID                             ),
    .i_rs2_data_EX              (   rs2_data_ID                             ),
    .i_pc_EX                    (   pc_ID                                   ),
    .i_imm_EX                   (   imm_ID                                  ),
    .i_pc_plus4_EX              (   pc_plus4_ID                             ),
    .i_rd_wren_EX               (   i_rd_wren_ID                            ),
    .i_wb_sel_EX                (   i_wb_sel_ID                             ),
    .i_opa_sel_EX               (   i_opa_sel_ID                            ),
    .i_opb_sel_EX               (   i_opb_sel_ID                            ),
    .i_lsu_wren_EX              (   i_lsu_wren_ID                           ),
    .i_funct3_EX                (   o_funct3_ID                             ),
    .i_br_un_EX                 (   i_br_un_ID                              ),
    .i_data_sel_EX              (   i_data_sel_ID                           ),
    .i_extend_data_sel_EX       (   i_extend_data_sel_ID                    ),
    .i_btb_hit_EX               (   btb_hit_ID                              ),
    .o_btb_hit_EX               (   btb_hit_EX                              ),
    .o_pc_EX                    (   pc_EX                                   ),
    .o_rs1_data_EX              (   rs1_data_EX                             ),
    .o_rs2_data_EX              (   rs2_data_EX                             ),
    .o_pc_plus4_EX              (   pc_plus4_EX                             ),
    .o_imm_EX                   (   imm_EX                                  ),
    .o_rd_addr_EX               (   o_rd_addr_EX                            ),
    .o_rd_wren_EX               (   rd_wren_EX                              ),
    .o_wb_sel_EX                (   wb_sel_EX                               ),
    .o_opa_sel_EX               (   opa_sel_EX                              ),
    .o_opb_sel_EX               (   opb_sel_EX                              ),
    .o_lsu_wren_EX              (   lsu_wren_EX                             ),
    .o_funct3_EX                (   funct3_EX                               ),
    .o_br_un_EX                 (   br_un_EX                                ),
    .o_data_sel_EX              (   data_sel_EX                             ),
    .o_extend_data_sel_EX       (   extend_data_sel_EX                      ),
    .i_pc_jump_sel_EX           (   i_pc_jump_sel_ID                        ),
    .i_pc_branch_sel_EX         (   i_pc_branch_sel_ID                      ),
    .i_ctrl_EX                  (   i_ctrl_ID                               ),
    .i_alu_op_EX                (   i_alu_op_EX                             ),
    .o_alu_op_EX                (   alu_op_EX                               ),
    .o_pc_jump_sel_EX           (   pc_jump_sel_EX                          ),
    .o_pc_branch_sel_EX         (   pc_branch_sel_EX                        ),
    .o_ctrl_EX                  (   ctrl_EX                                 ),
    .stall_EX                   (   i_stall_EX                              ),
    .flush_EX                   (   i_flush_EX                              ),
    .o_rs1_addr_EX              (   o_rs1_addr_EX                           ),
    .o_rs2_addr_EX              (   o_rs2_addr_EX                           )
);

assign  o_wb_sel_EX =   wb_sel_EX;

/* ----- DUT in DM ----- */
lsu     dut_lsu     (
    .i_clk          (   i_clk           ),
    .i_rstn         (   i_rstn          ),
    .i_lsu_addr     (   alu_result_DM   ),
    .i_st_data      (   rs2_data_DM     ),
    .i_io_sw        (   i_io_sw         ),
    .i_funct3       (   funct3_DM       ),
    .i_lsu_wren     (   lsu_wren_DM     ),
    .o_ld_data      (   lsu_data_DM     ),
    .o_ledg         (   o_ledg          ),
    .o_ledr         (   o_ledr          ),
    .o_lcd          (   o_lcd           ),
    .o_hex0         (   o_hex0          ),
    .o_hex1         (   o_hex1          ),
    .o_hex2         (   o_hex2          ),
    .o_hex3         (   o_hex3          ),
    .o_hex4         (   o_hex4          ),
    .o_hex5         (   o_hex5          ),
    .o_hex6         (   o_hex6          ),
    .o_hex7         (   o_hex7          )
);

DM_reg  dut_DM_reg          (
    .i_clk                  (   i_clk                   ),
    .i_rst                  (   i_rstn                  ),
    .i_rs1_addr_DM          (   o_rs1_addr_EX           ),
    .i_rs2_addr_DM          (   o_rs2_addr_EX           ),
    .i_rd_addr_DM           (   o_rd_addr_EX            ),
    .i_alu_result_DM        (   alu_result_EX           ),
    .i_rs2_data_DM          (   rs2_tmp                 ),
    .i_pc_DM                (   pc_EX                   ),     
    .i_pc_plus4_DM          (   pc_plus4_EX             ),
    .i_rd_wren_DM           (   rd_wren_EX              ),
    .i_wb_sel_DM            (   wb_sel_EX               ),
    .i_lsu_wren_DM          (   lsu_wren_EX             ),
    .i_data_sel_DM          (   data_sel_EX             ),
    .i_extend_data_sel_DM   (   extend_data_sel_EX      ),
    .i_ctrl_DM              (   ctrl_EX                 ),
    .i_funct3_DM            (   funct3_EX               ),
    .o_funct3_DM            (   funct3_DM               ),
    .o_ctrl_DM              (   ctrl_DM                 ),
    .o_pc_DM                (   pc_DM                   ),
    .o_pc_plus4_DM          (   pc_plus4_DM             ),
    .o_alu_result_DM        (   alu_result_DM           ),
    .o_rs2_data_DM          (   rs2_data_DM             ),
    .o_rd_wren_DM           (   rd_wren_DM              ),
    .o_wb_sel_DM            (   wb_sel_DM               ),
    .o_lsu_wren             (   lsu_wren_DM             ),
    .o_data_sel_DM          (   data_sel_DM             ),
    .o_extend_data_sel_DM   (   extend_data_sel_DM      ),
    .stall_DM               (   i_stall_DM              ),
    .flush_DM               (   i_flush_DM              ),
    .o_rs1_addr_DM          (   o_rs1_addr_DM           ),
    .o_rs2_addr_DM          (   o_rs2_addr_DM           ),
    .o_rd_addr_DM           (   o_rd_addr_DM            )
);

/* ----- DUT in WB ----- */
datagen     dut_datagen     (
    .i_raw_data             (   data_WB             ),
    .i_sel_data_gen         (   extend_data_sel_WB  ),
    .o_gen_data             (   extend_data_WB      )
);

mux2_1      dut_mux_data    (
    .in0                    (   data_WB         ),
    .in1                    (   extend_data_WB  ),
    .sel                    (   data_sel_WB     ),
    .out                    (   final_wdata     )
);

WB_reg      dut_WB_reg      (
    .i_clk                  (   i_clk               ),
    .i_rst                  (   i_rstn              ),
    .i_rd_addr_WB           (   o_rd_addr_DM        ),
    .i_pc_WB                (   pc_DM               ),
    .i_pc_plus4_WB          (   pc_plus4_DM         ),
    .i_alu_result_WB        (   alu_result_DM       ),
    .i_lsu_data_WB          (   lsu_data_DM         ),
    .i_rd_wren_WB           (   rd_wren_DM          ),
    .i_wb_sel_WB            (   wb_sel_DM           ),
    .i_data_sel_WB          (   data_sel_DM         ),
    .i_extend_data_sel_WB   (   extend_data_sel_DM  ),
    .i_ctrl_WB              (   ctrl_DM             ),
    .o_ctrl_WB              (   o_ctrl              ),
    .o_pc_debug             (   o_pc_debug          ),
    .o_pc_plus4_WB          (   pc_plus4_WB         ),
    .o_alu_result_WB        (   alu_result_WB       ),
    .o_lsu_data_WB          (   lsu_data_WB         ),
    .o_rd_wren_WB           (   rd_wren_WB          ),
    .o_wb_sel_WB            (   wb_sel_WB           ),
    .o_data_sel_WB          (   data_sel_WB         ),
    .o_extend_data_sel_WB   (   extend_data_sel_WB  ),
    .stall_WB               (   i_stall_WB          ),
    .flush_WB               (   i_flush_WB          ),
    .o_rd_addr_WB           (   o_rd_addr_WB        )
);

endmodule : datapath
