module decoder_out_sel_lsu(
    input logic                 i_addr_mem, i_addr_input_buffer, i_addr_output_buffer,
    output logic    [ 1:0]      o_sel_lsu
);

always @(*) begin
    if (i_addr_mem)
        o_sel_lsu   = 2'b00;
    else if (i_addr_input_buffer)
        o_sel_lsu   = 2'b01;
    else if (i_addr_output_buffer)
        o_sel_lsu   = 2'b10;
    else
        o_sel_lsu   = 2'b11;
end

endmodule : decoder_out_sel_lsu
