module decoder_byte_en_lsu(
    input logic                 i_addr_0,
    input logic     [ 2:0]      i_funct3,
    input logic                 i_lsu_wren,
    output logic    [ 3:0]      o_byte_en,
    output logic                o_we_odd0, o_we_odd1, o_we_even0, o_we_even1
);
logic [3:0] byte_en_tmp;

always @(*) begin
    case (i_funct3)
        3'b000:     byte_en_tmp = 4'b0001;
        3'b001:     byte_en_tmp = 4'b0011;
        3'b010:     byte_en_tmp = 4'b1111;
        default:    byte_en_tmp = 4'b0000;
    endcase
end

assign  o_byte_en   = byte_en_tmp & {4{i_lsu_wren}};

always @(*) begin
    case (i_addr_0)
        1'b0:   begin 
                    o_we_even0  =   byte_en_tmp[0];
                    o_we_odd0   =   byte_en_tmp[1];
                    o_we_even1  =   byte_en_tmp[2];
                    o_we_odd1   =   byte_en_tmp[3];
                end
        1'b1:   begin
                    o_we_odd0   =   byte_en_tmp[0];
                    o_we_even0  =   byte_en_tmp[1];
                    o_we_odd1   =   byte_en_tmp[2];
                    o_we_even1  =   byte_en_tmp[3];
                end
    endcase
end

endmodule : decoder_byte_en_lsu
