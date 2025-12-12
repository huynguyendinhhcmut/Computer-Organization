module decoder_addr_lsu(
    input logic     [31:0]      i_addr,
    output logic    [14:0]      o_addr_odd0, o_addr_odd1, o_addr_even0, o_addr_even1,           // Use for dmem
    output logic                o_addr_is_dmem, o_addr_is_ledg, o_addr_is_ledr, o_addr_is_sw,
    output logic                o_addr_is_hex30, o_addr_is_hex74, o_addr_is_lcd,
    output logic                o_addr_input_buffer, o_addr_output_buffer
);
// Internal signals
logic [31:0]    addr0, addr1, addr2, addr3;

//o_addr_is_dmem    = (|i_addr[31:16]) ? 0 : 1;
assign  o_addr_is_dmem    = ~(|(i_addr[31:16]));
assign  o_addr_is_ledr    = ~i_addr[31] & ~i_addr[30] & ~i_addr[29] & i_addr[28] & ~(|i_addr[27:12]);
assign  o_addr_is_ledg    = ~i_addr[31] & ~i_addr[30] & ~i_addr[29] & i_addr[28] & ~(|i_addr[27:13]) & i_addr[12];
assign  o_addr_is_sw      = ~i_addr[31] & ~i_addr[30] & ~i_addr[29] & i_addr[28] & ~(|i_addr[27:17]) & i_addr[16] & ~(|i_addr[15:12]);

assign  o_addr_is_hex30   = ~i_addr[31] & ~i_addr[30] & ~i_addr[29] & i_addr[28] & ~(|i_addr[27:14]) & i_addr[13] & ~i_addr[12];
assign  o_addr_is_hex74   = ~i_addr[31] & ~i_addr[30] & ~i_addr[29] & i_addr[28] & ~(|i_addr[27:14]) & i_addr[13] &  i_addr[12];
assign  o_addr_is_lcd     = ~i_addr[31] & ~i_addr[30] & ~i_addr[29] & i_addr[28] & ~(|i_addr[27:15]) & i_addr[14] & ~i_addr[13] & ~i_addr[12];

assign  o_addr_input_buffer   =   o_addr_is_sw;
assign  o_addr_output_buffer  =   o_addr_is_hex30 | o_addr_is_hex74 | o_addr_is_lcd;

// Calculate 4 address base on i_addr
FA32 dut0  ( .a(i_addr), .b(32'h0), .cin(1'b0), .s(addr0) );
FA32 dut1  ( .a(i_addr), .b(32'h1), .cin(1'b0), .s(addr1) );
FA32 dut2  ( .a(i_addr), .b(32'h2), .cin(1'b0), .s(addr2) );
FA32 dut3  ( .a(i_addr), .b(32'h3), .cin(1'b0), .s(addr3) );

// Based-on i_addr[0] to select the 1st address even or odd
always @(*) begin
    case (i_addr[0])
        1'b0:   begin
                    o_addr_even0  = {1'b0, addr0[15:1]};
                    o_addr_odd0   = {1'b0, addr1[15:1]};
                    o_addr_even1  = {1'b0, addr2[15:1]};
                    o_addr_odd1   = {1'b0, addr3[15:1]};
                end
        1'b1:   begin
                    o_addr_odd0   = {1'b0, addr0[15:1]};
                    o_addr_even0  = {1'b0, addr1[15:1]};
                    o_addr_odd1   = {1'b0, addr2[15:1]};
                    o_addr_even1  = {1'b0, addr3[15:1]};
                end
    endcase
end

endmodule : decoder_addr_lsu
