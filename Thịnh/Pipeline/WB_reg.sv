module WB_reg(
    // General signals
    input logic                 i_clk, i_rst ,
    input logic     [ 4:0]      i_rd_addr_WB,
    input logic     [31:0]      i_pc_WB,
    input logic     [31:0]      i_pc_plus4_WB,
    input logic     [31:0]      i_alu_result_WB,
    input logic     [31:0]      i_lsu_data_WB,
    input logic                 i_rd_wren_WB,
    input logic     [ 1:0]      i_wb_sel_WB,
    input logic                 i_data_sel_WB,
    input logic     [ 1:0]      i_extend_data_sel_WB,
    input logic                 i_ctrl_WB,
    output logic                o_ctrl_WB,
    output logic    [31:0]      o_pc_debug,
    output logic    [31:0]      o_pc_plus4_WB,
    output logic    [31:0]      o_alu_result_WB,
    output logic    [31:0]      o_lsu_data_WB,
    output logic                o_rd_wren_WB,
    output logic    [ 1:0]      o_wb_sel_WB,
    output logic                o_data_sel_WB,
    output logic    [ 1:0]      o_extend_data_sel_WB,
    // Hazard signals
    input logic                 stall_WB, flush_WB,
    output logic    [ 4:0]      o_rd_addr_WB
);

dff dut_pc          (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_pc_WB         ),
    .stall          (   stall_WB        ),
    .flush          (   flush_WB        ),
    .q              (   o_pc_debug      )
);

dff dut_pc_plus4    (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_pc_plus4_WB   ),
    .stall          (   stall_WB        ),
    .flush          (   flush_WB        ),
    .q              (   o_pc_plus4_WB   )
);

dff dut_alu_result  (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_alu_result_WB ),
    .stall          (   stall_WB        ),
    .flush          (   flush_WB        ),
    .q              (   o_alu_result_WB )
);

dff dut_lsu_data    (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_lsu_data_WB   ),
    .stall          (   stall_WB        ),
    .flush          (   flush_WB        ),
    .q              (   o_lsu_data_WB   )
);

dff dut_rd_addr     (
    .clk            (   i_clk           ),
    .rst            (   i_rst           ),
    .d              (   i_rd_addr_WB    ),
    .stall          (   stall_WB        ),
    .flush          (   flush_WB        ),
    .q              (   o_rd_addr_WB    )
);

dff #(.WIDTH(1))
dut_rd_wren                     (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_rd_wren_WB            ),
    .stall                      (   stall_WB                ),
    .flush                      (   flush_WB                ),
    .q                          (   o_rd_wren_WB            )
);

dff #(.WIDTH(2))
dut_wb_sel                      (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_wb_sel_WB             ),
    .stall                      (   stall_WB                ),
    .flush                      (   flush_WB                ),
    .q                          (   o_wb_sel_WB             )
);

dff #(.WIDTH(1))
dut_data_sel                    (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_data_sel_WB           ),
    .stall                      (   stall_WB                ),
    .flush                      (   flush_WB                ),
    .q                          (   o_data_sel_WB           )
);

dff #(.WIDTH(2))
dut_extend_data_sel             (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_extend_data_sel_WB    ),
    .stall                      (   stall_WB                ),
    .flush                      (   flush_WB                ),
    .q                          (   o_extend_data_sel_WB    )
);

dff #(.WIDTH(1))
dut_ctrl                        (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_ctrl_WB               ),
    .stall                      (   stall_WB                ),
    .flush                      (   flush_WB                ),
    .q                          (   o_ctrl_WB               )
);

endmodule : WB_reg
