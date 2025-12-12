module input_buffer(
    input logic                 i_clk, i_rstn,
    input logic     [31:0]      i_io_sw,
    output logic    [31:0]      o_io_sw
);

reg_32bit   dut_input_buffer    (
    .clk                        (   i_clk   ),
    .rst_n                      (   i_rstn  ),
    .en                         (   1'b1    ),
    .d                          (   i_io_sw ),
    .q                          (   o_io_sw )
);

endmodule : input_buffer
