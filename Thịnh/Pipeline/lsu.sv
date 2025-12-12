module lsu (
    input logic                 i_clk, i_rstn,
    input logic     [31:0]      i_lsu_addr,
    input logic     [31:0]      i_st_data,
    input logic     [31:0]      i_io_sw,
    input logic     [ 2:0]      i_funct3,
    input logic                 i_lsu_wren,
    output logic    [31:0]      o_ld_data,
    output logic    [31:0]      o_ledg, o_ledr,
    output logic    [31:0]      o_lcd,
    output logic    [ 7:0]      o_hex0, o_hex1, o_hex2, o_hex3, o_hex4, o_hex5, o_hex6, o_hex7
);
// Internal signals
logic   [ 3:0]      byte_en;
logic   [ 1:0]      sel_lsu;
logic   [ 7:0]      wdata_odd0, wdata_odd1, wdata_even0, wdata_even1;
logic   [31:0]      wdata_out_buff;
logic   [31:0]      rdata_dmem;
logic   [31:0]      io_sw;
logic   [31:0]      output_buffer;
logic   [ 7:0]      hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;

//DUT
decoder_lsu     dut_decoder_lsu     (
    .i_lsu_addr                     (   i_lsu_addr      ),
    .i_funct3                       (   i_funct3        ),
    .i_st_data                      (   i_st_data       ),
    .i_lsu_wren                     (   i_lsu_wren      ),
    .o_byte_en                      (   byte_en         ),
    .o_sel_lsu                      (   sel_lsu         ),
    .o_wdata_odd0                   (   wdata_odd0      ),
    .o_wdata_odd1                   (   wdata_odd1      ),
    .o_wdata_even0                  (   wdata_even0     ),
    .o_wdata_even1                  (   wdata_even1     ),
    .o_wdata_out_buff               (   wdata_out_buff  )
);

dmem            dut_dmem            (
    .i_clk                          (   i_clk                           ),
    .i_lsu_addr_0                   (   i_lsu_addr[0]                   ),
    .i_addr_odd0                    (   dut_decoder_lsu.addr_odd0       ),
    .i_addr_odd1                    (   dut_decoder_lsu.addr_odd1       ),
    .i_addr_even0                   (   dut_decoder_lsu.addr_even0      ),
    .i_addr_even1                   (   dut_decoder_lsu.addr_even1      ),
    .i_wdata_odd0                   (   wdata_odd0                      ),
    .i_wdata_odd1                   (   wdata_odd1                      ),
    .i_wdata_even0                  (   wdata_even0                     ),
    .i_wdata_even1                  (   wdata_even1                     ),
    .i_we_odd0                      (   dut_decoder_lsu.we_odd0         ),
    .i_we_odd1                      (   dut_decoder_lsu.we_odd1         ),
    .i_we_even0                     (   dut_decoder_lsu.we_even0        ),
    .i_we_even1                     (   dut_decoder_lsu.we_even1        ),
    .o_rdata                        (   rdata_dmem                      )
);

input_buffer    dut_input_buffer    (
    .i_clk                          (   i_clk   ),
    .i_rstn                         (   i_rstn  ),
    .i_io_sw                        (   i_io_sw ),
    .o_io_sw                        (   io_sw   )
);

output_buffer   dut_output_buffer   (
    .i_clk                          (   i_clk                               ),
    .i_rstn                         (   i_rstn                              ),
    .i_lsu_wren                     (   i_lsu_wren                          ),
    .i_addr_output_buffer           (   dut_decoder_lsu.addr_out_buff       ),
    .i_wdata                        (   wdata_out_buff                      ),
    .o_output_buffer                (   output_buffer                       )
);

// Mux output LSU
always @(*) begin
    case(sel_lsu)
        2'b00:      o_ld_data   =   rdata_dmem;
        2'b01:      o_ld_data   =   io_sw;
        2'b10:      o_ld_data   =   output_buffer;
        default:    o_ld_data   =   32'hFAFA_FAFA;
    endcase
end

// Decode hex led
// HEX3-0
decoder_hex dut_hex0 ( .i_bin_data(output_buffer[ 3: 0]), .o_hex_data(hex0) );
decoder_hex dut_hex1 ( .i_bin_data(output_buffer[ 7: 4]), .o_hex_data(hex1) );
decoder_hex dut_hex2 ( .i_bin_data(output_buffer[11: 8]), .o_hex_data(hex2) );
decoder_hex dut_hex3 ( .i_bin_data(output_buffer[15:12]), .o_hex_data(hex3) );
// HEX7-4
decoder_hex dut_hex4 ( .i_bin_data(output_buffer[ 3: 0]), .o_hex_data(hex4) );
decoder_hex dut_hex5 ( .i_bin_data(output_buffer[ 7: 4]), .o_hex_data(hex5) );
decoder_hex dut_hex6 ( .i_bin_data(output_buffer[11: 8]), .o_hex_data(hex6) );
decoder_hex dut_hex7 ( .i_bin_data(output_buffer[15:12]), .o_hex_data(hex7) );

// LEDR, LEDG, HEX3-0, HEX7-4, LCD
assign  o_ledr  =   (dut_decoder_lsu.addr_ledr)  ? output_buffer : 32'h0;
assign  o_ledg  =   (dut_decoder_lsu.addr_ledg)  ? output_buffer : 32'h0;
assign  o_hex0  =   (dut_decoder_lsu.addr_hex30) ? {1'b0, hex0}  : 8'h0;
assign  o_hex1  =   (dut_decoder_lsu.addr_hex30) ? {1'b0, hex1}  : 8'h0;
assign  o_hex2  =   (dut_decoder_lsu.addr_hex30) ? {1'b0, hex2}  : 8'h0;
assign  o_hex3  =   (dut_decoder_lsu.addr_hex30) ? {1'b0, hex3}  : 8'h0;
assign  o_hex4  =   (dut_decoder_lsu.addr_hex74) ? {1'b0, hex4}  : 8'h0;
assign  o_hex5  =   (dut_decoder_lsu.addr_hex74) ? {1'b0, hex5}  : 8'h0;
assign  o_hex6  =   (dut_decoder_lsu.addr_hex74) ? {1'b0, hex6}  : 8'h0;
assign  o_hex7  =   (dut_decoder_lsu.addr_hex74) ? {1'b0, hex7}  : 8'h0;
assign  o_lcd   =   (dut_decoder_lsu.addr_lcd)   ? output_buffer : 32'h0;


endmodule : lsu
