module output_buffer(
    input logic                 i_clk, i_rstn,
    input logic                 i_lsu_wren,
    input logic                 i_addr_output_buffer,
    input logic     [31:0]      i_wdata,
    output logic    [31:0]      o_output_buffer
);

reg_32bit   dut_output_buffer   (
    .clk                        (   i_clk                                   ),
    .rst_n                      (   i_rstn                                  ),
    .en                         (   i_lsu_wren & i_addr_output_buffer       ),
    .d                          (   i_wdata                                 ),
    .q                          (   o_output_buffer                         )
);

endmodule : output_buffer
