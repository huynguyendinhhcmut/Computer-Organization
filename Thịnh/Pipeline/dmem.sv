module dmem(
    input logic                 i_clk, //i_rstn,
    input logic                 i_lsu_addr_0,
    input logic     [14:0]      i_addr_odd0, i_addr_odd1, i_addr_even0, i_addr_even1,
    input logic     [ 7:0]      i_wdata_odd0, i_wdata_odd1, i_wdata_even0, i_wdata_even1,
    input logic                 i_we_odd0, i_we_odd1, i_we_even0, i_we_even1,
    output logic    [31:0]      o_rdata
);
// Internal signals
logic   [ 7:0]      rdata_odd0, rdata_odd1, rdata_even0, rdata_even1;

// DUT
dual_port_ram   dut_dmem_even   (
    .i_clk                      (   i_clk           ),
    // Port A
    .i_addr_a                   (   i_addr_even0    ),
    .i_data_in_a                (   i_wdata_even0   ),
    .i_we_a                     (   i_we_even0      ),
    .o_data_out_a               (   rdata_even0     ),
    // Port B
    .i_addr_b                   (   i_addr_even1    ),
    .i_data_in_b                (   i_wdata_even1   ),
    .i_we_b                     (   i_we_even1      ),
    .o_data_out_b               (   rdata_even1     )
);

dual_port_ram   dut_dmem_odd    (
    .i_clk                      (   i_clk           ),
    // Port A
    .i_addr_a                   (   i_addr_odd0     ),
    .i_data_in_a                (   i_wdata_odd0    ),
    .i_we_a                     (   i_we_odd0       ),
    .o_data_out_a               (   rdata_odd0      ),
    // Port B
    .i_addr_b                   (   i_addr_odd1     ),
    .i_data_in_b                (   i_wdata_odd1    ),
    .i_we_b                     (   i_we_odd1       ),
    .o_data_out_b               (   rdata_odd1      )
);

always @(*) begin
    case (i_lsu_addr_0)
        1'b0:   o_rdata =   {rdata_even0, rdata_odd0, rdata_even1, rdata_odd1};
        1'b1:   o_rdata =   {rdata_odd0, rdata_even0, rdata_odd1, rdata_even1};
    endcase
end

endmodule : dmem
