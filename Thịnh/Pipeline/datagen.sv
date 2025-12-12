module datagen(
    input logic     [31:0]      i_raw_data,
    input logic     [ 1:0]      i_sel_data_gen,
    output logic    [31:0]      o_gen_data
);

always @(*) begin
    case(i_sel_data_gen)
        2'b00:  o_gen_data  =   {{24{i_raw_data[7]}}, i_raw_data[7:0]};         // LB
        2'b01:  o_gen_data  =   {{16{i_raw_data[15]}}, i_raw_data[15:0]};       // LH
        2'b10:  o_gen_data  =   {24'b0, i_raw_data[7:0]};                       // LBU
        2'b11:  o_gen_data  =   {16'b0, i_raw_data[15:0]};                      // LHU
    endcase
end

endmodule : datagen