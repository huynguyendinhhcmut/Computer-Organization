module DM_reg (
    // General signals
    input logic                 i_clk, i_rst,
    input logic     [ 4:0]      i_rs1_addr_DM, i_rs2_addr_DM, i_rd_addr_DM,   
    input logic     [31:0]      i_alu_result_DM,
    input logic     [31:0]      i_rs2_data_DM,
    input logic     [31:0]      i_pc_DM,
    input logic     [31:0]      i_pc_plus4_DM,
    input logic                 i_rd_wren_DM,
    input logic     [ 1:0]      i_wb_sel_DM,
    input logic                 i_lsu_wren_DM,
    input logic                 i_data_sel_DM,
    input logic     [ 1:0]      i_extend_data_sel_DM,
    input logic                 i_ctrl_DM,
    input logic     [ 2:0]      i_funct3_DM,
    output logic    [ 2:0]      o_funct3_DM,
    output logic                o_ctrl_DM,
    output logic    [31:0]      o_pc_DM,
    output logic    [31:0]      o_pc_plus4_DM,
    output logic    [31:0]      o_alu_result_DM,
    output logic    [31:0]      o_rs2_data_DM,
    output logic                o_rd_wren_DM,
    output logic    [ 1:0]      o_wb_sel_DM,
    output logic                o_lsu_wren_DM,
    output logic                o_data_sel_DM,
    output logic    [ 1:0]      o_extend_data_sel_DM,
    // Hazard signals
    input logic                 stall_DM, flush_DM,
    output logic    [ 4:0]      o_rs1_addr_DM, o_rs2_addr_DM, o_rd_addr_DM
);

dff dut_pc          (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_pc_DM         ),
    .stall          (   stall_DM        ),
    .flush          (   flush_DM        ),
    .q              (   o_pc_DM         )
);

dff dut_pc_plus4    (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_pc_plus4_DM   ),
    .stall          (   stall_DM        ),
    .flush          (   flush_DM        ),
    .q              (   o_pc_plus4_DM   )
);

dff dut_alu_result  (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_alu_result_DM ),
    .stall          (   stall_DM        ),
    .flush          (   flush_DM        ),
    .q              (   o_alu_result_DM )
);

dff dut_rs2_data    (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_rs2_data_DM   ),
    .stall          (   stall_DM        ),
    .flush          (   flush_DM        ),
    .q              (   o_rs2_data_DM   )
);

dff #(.WIDTH(5))
dut_rs1_addr    (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_rs1_addr_DM   ),
    .stall          (   stall_DM        ),
    .flush          (   flush_DM        ),
    .q              (   o_rs1_addr_DM   )
);

dff #(.WIDTH(5))
dut_rs2_addr    (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_rs2_addr_DM   ),
    .stall          (   stall_DM        ),
    .flush          (   flush_DM        ),
    .q              (   o_rs2_addr_DM   )
);

dff #(.WIDTH(5))
dut_rd_addr     (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_rd_addr_DM    ),
    .stall          (   stall_DM        ),
    .flush          (   flush_DM        ),
    .q              (   o_rd_addr_DM    )
);

dff #(.WIDTH(1))
dut_rd_wren                     (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_rd_wren_DM            ),
    .stall                      (   stall_DM                ),
    .flush                      (   flush_DM                ),
    .q                          (   o_rd_wren_DM            )
);

dff #(.WIDTH(2))
dut_wb_sel                      (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_wb_sel_DM             ),
    .stall                      (   stall_DM                ),
    .flush                      (   flush_DM                ),
    .q                          (   o_wb_sel_DM             )
);

dff #(.WIDTH(1))
dut_lsu_wren                    (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_lsu_wren_DM           ),
    .stall                      (   stall_DM                ),
    .flush                      (   flush_DM                ),
    .q                          (   o_lsu_wren_DM           )
);

dff #(.WIDTH(1))
dut_data_sel                    (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_data_sel_DM           ),
    .stall                      (   stall_DM                ),
    .flush                      (   flush_DM                ),
    .q                          (   o_data_sel_DM           )
);

dff #(.WIDTH(2))
dut_extend_data_sel             (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_extend_data_sel_DM    ),
    .stall                      (   stall_DM                ),
    .flush                      (   flush_DM                ),
    .q                          (   o_extend_data_sel_DM    )
);

dff #(.WIDTH(1))
dut_ctrl                        (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_ctrl_DM               ),
    .stall                      (   stall_DM                ),
    .flush                      (   flush_DM                ),
    .q                          (   o_ctrl_DM               )
);

dff #(.WIDTH(3))
dut_funct3                      (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_funct3_DM             ),
    .stall                      (   stall_DM                ),
    .flush                      (   flush_DM                ),
    .q                          (   o_funct3_DM             )
);

endmodule : DM_reg
