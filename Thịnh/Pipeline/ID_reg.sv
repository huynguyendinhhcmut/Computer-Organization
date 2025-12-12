module ID_reg(
    input logic             i_clk, i_rst,
    input logic     [31:0]  i_pc_ID,
    input logic     [31:0]  i_pc_plus4_ID,
    //input logic             i_rd_wren_ID, i_wb_sel_ID,
    //input logic             i_is_jump_or_branch_ID,
    input logic             stall_ID, flush_ID,
    input logic             i_btb_hit_ID,
    output logic            o_btb_hit_ID,
    output logic    [31:0]  o_pc_ID,
    output logic    [31:0]  o_pc_plus4_ID
    //output logic            o_rd_wren_ID, o_wb_sel_ID
    //output logic            o_is_jump_or_branch_ID
);

dff #(.WIDTH(32)) dut_pc_ID   (
    .clk                    (   i_clk       ),
    .rst                    (   i_rst       ),
    .d                      (   i_pc_ID     ),
    .stall                  (   stall_ID    ),
    .flush                  (   flush_ID    ),
    .q                      (   o_pc_ID     )
);

dff #(.WIDTH(32)) dut_pc_plus4_ID (
    .clk                        (   i_clk           ),
    .rst                        (   i_rst           ),
    .d                          (   i_pc_plus4_ID   ),
    .stall                      (   stall_ID        ),
    .flush                      (   flush_ID        ),
    .q                          (   o_pc_plus4_ID   )
);

dff #(.WIDTH(1)) dut_btb_hit    (
    .clk                        (   i_clk           ),
    .rst                        (   i_rst           ),
    .d                          (   i_btb_hit_ID    ),
    .stall                      (   stall_ID        ),
    .flush                      (   flush_ID        ),
    .q                          (   o_btb_hit_ID    )
);

/*
dff #(.WIDTH(1))
dut_is_jump_or_branch           (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rst                   ),
    .d                          (   i_is_jump_or_branch_ID  ),
    .stall                      (   stall_ID                ),
    .flush                      (   flush_ID                ),
    .q                          (   o_is_jump_or_branch_ID  )
);


dff #(.WIDTH(1))
dut_rd_wren                     (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rstn                  ),
    .d                          (   i_rd_wren_ID            ),
    .stall                      (   stall_ID                ),
    .flush                      (   flush_ID                ),
    .q                          (   o_rd_wren_ID            )
);

dff #(.WIDTH(1))
dut_wb_sel                      (
    .clk                        (   i_clk                   ),
    .rst                        (   i_rstn                  ),
    .d                          (   i_wb_sel_ID             ),
    .stall                      (   stall_ID                ),
    .flush                      (   flush_ID                ),
    .q                          (   o_wb_sel_ID             )
);
*/

endmodule : ID_reg
