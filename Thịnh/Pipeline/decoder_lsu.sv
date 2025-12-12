module decoder_lsu(
    input logic     [31:0]      i_lsu_addr,
    input logic     [ 2:0]      i_funct3,
    input logic     [31:0]      i_st_data,
    input logic                 i_lsu_wren,
    output logic    [ 3:0]      o_byte_en,
    output logic    [ 1:0]      o_sel_lsu,
    output logic    [ 7:0]      o_wdata_odd0, o_wdata_odd1, o_wdata_even0, o_wdata_even1,
    output logic    [31:0]      o_wdata_out_buff
);
// Internal signals
logic   [14:0]      addr_odd0, addr_odd1, addr_even0, addr_even1;
logic               addr_dmem, addr_ledg, addr_ledr, addr_sw, addr_hex30, addr_hex74, addr_lcd, addr_in_buff, addr_out_buff;
logic   [ 3:0]      byte_en;
logic               we_odd0, we_odd1, we_even0, we_even1;

// DUT
decoder_addr_lsu        dut_decode_addr     (
    .i_addr                                 (   i_lsu_addr      ),
    .o_addr_odd0                            (   addr_odd0       ),
    .o_addr_odd1                            (   addr_odd1       ),
    .o_addr_even0                           (   addr_even0      ),
    .o_addr_even1                           (   addr_even1      ),
    .o_addr_is_dmem                         (   addr_dmem       ),
    .o_addr_is_ledg                         (   addr_ledg       ),
    .o_addr_is_ledr                         (   addr_ledr       ),
    .o_addr_is_sw                           (   addr_sw         ),
    .o_addr_is_hex30                        (   addr_hex30      ),
    .o_addr_is_hex74                        (   addr_hex74      ),
    .o_addr_is_lcd                          (   addr_lcd        ),
    .o_addr_input_buffer                    (   addr_in_buff    ),
    .o_addr_output_buffer                   (   addr_out_buff   )
);

decoder_byte_en_lsu     dut_decode_byte_en  (
    .i_addr_0                               (   i_lsu_addr[0]   ),
    .i_funct3                               (   i_funct3        ),
    .i_lsu_wren                             (   i_lsu_wren      ),
    .o_byte_en                              (   byte_en         ),
    .o_we_odd0                              (   we_odd0         ),
    .o_we_odd1                              (   we_odd1         ),
    .o_we_even0                             (   we_even0        ),
    .o_we_even1                             (   we_even1        )
);

decoder_out_sel_lsu     dut_decode_out_sel  (
    .i_addr_mem                             (   addr_dmem       ),
    .i_addr_input_buffer                    (   addr_in_buff    ),
    .i_addr_output_buffer                   (   addr_out_buff   ),
    .o_sel_lsu                              (   o_sel_lsu       )
);

decoder_wdata_lsu       dut_wdata           (
    .i_wdata                                (   i_st_data           ),
    .i_addr_0                               (   i_lsu_addr[0]       ),
    .i_byte_en                              (   byte_en             ),
    .o_wdata_output_buffer                  (   o_wdata_out_buff    ),
    .o_wdata_odd0                           (   o_wdata_odd0        ),
    .o_wdata_odd1                           (   o_wdata_odd1        ),
    .o_wdata_even0                          (   o_wdata_even0       ),
    .o_wdata_even1                          (   o_wdata_even1       )
);


endmodule : decoder_lsu
