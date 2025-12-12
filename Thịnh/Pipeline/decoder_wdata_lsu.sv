module decoder_wdata_lsu(
    input logic     [31:0]      i_wdata,
    input logic                 i_addr_0,
    input logic     [ 3:0]      i_byte_en,
    output logic    [31:0]      o_wdata_output_buffer,
    output logic    [ 7:0]      o_wdata_odd0, o_wdata_odd1, o_wdata_even0, o_wdata_even1
);

always @(*) begin
    case (i_addr_0)
        1'b0:   begin
                    o_wdata_even0   =   i_wdata[ 7: 0] & {8{i_byte_en[0]}};
                    o_wdata_odd0    =   i_wdata[15: 8] & {8{i_byte_en[1]}};
                    o_wdata_even1   =   i_wdata[23:16] & {8{i_byte_en[2]}};
                    o_wdata_odd1    =   i_wdata[31:24] & {8{i_byte_en[3]}};
                end
        1'b1:   begin
                    o_wdata_odd0    =   i_wdata[ 7: 0] & {8{i_byte_en[0]}};
                    o_wdata_even0   =   i_wdata[15: 8] & {8{i_byte_en[1]}};
                    o_wdata_odd1    =   i_wdata[23:16] & {8{i_byte_en[2]}};
                    o_wdata_even1   =   i_wdata[31:24] & {8{i_byte_en[3]}};
                end
    endcase
end

assign  o_wdata_output_buffer[ 7: 0]    =   i_wdata[ 7: 0] & {8{i_byte_en[0]}};
assign  o_wdata_output_buffer[15: 8]    =   i_wdata[15: 8] & {8{i_byte_en[1]}};
assign  o_wdata_output_buffer[23:16]    =   i_wdata[23:16] & {8{i_byte_en[2]}};
assign  o_wdata_output_buffer[31:24]    =   i_wdata[31:24] & {8{i_byte_en[3]}};

endmodule : decoder_wdata_lsu
