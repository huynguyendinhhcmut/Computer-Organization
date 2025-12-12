module hazard_unit(
    input logic     [ 4:0]      i_rs1_addr_EX, i_rs2_addr_EX, i_rd_addr_EX,
    input logic     [ 4:0]      i_rs1_addr_DM, i_rs2_addr_DM, i_rd_addr_DM,
    input logic     [ 4:0]      i_rd_addr_WB,
    //input logic                 i_pc_sel,
    input logic                 i_debug_pc_next,
    output logic    [ 1:0]      o_forward_a_EX, o_forward_b_EX,
    output logic                o_stall_IF, o_flush_IF, 
    output logic                o_stall_ID, o_flush_ID,
    output logic                o_stall_EX, o_flush_EX,
    output logic                o_stall_DM, o_flush_DM,
    output logic                o_stall_WB, o_flush_WB,
    // Control signals
    input logic     [ 1:0]      i_wb_sel_EX
);
// Internal signals
logic       equal_EX_ID1, equal_EX_ID2, equal_EX_WB1, equal_EX_WB2;
logic       zero_EX1, zero_EX2, zero_DM1, zero_DM2;

// Compare address of rs1, rs2 with rd
// 0: rs == rd
// 1: rs != rd
assign  equal_EX_DM1    =   i_rs1_addr_EX ^ i_rd_addr_DM;
assign  equal_EX_DM2    =   i_rs2_addr_EX ^ i_rd_addr_DM;
assign  equal_EX_WB1    =   i_rs1_addr_EX ^ i_rd_addr_WB;
assign  equal_EX_WB2    =   i_rs2_addr_EX ^ i_rd_addr_WB;

// Check RS is R0?
assign  zero_EX1        =   ~(|(i_rs1_addr_EX ^ 5'b00000));
assign  zero_EX2        =   ~(|(i_rs2_addr_EX ^ 5'b00000));
assign  zero_DM1        =   ~(|(i_rs1_addr_DM ^ 5'b00000));
assign  zero_DM2        =   ~(|(i_rs2_addr_DM ^ 5'b00000));

// Forward signals
always @(*) begin
    if      (!(|equal_EX_DM1))
        o_forward_a_EX  =   2'b10;
    else if (!(|equal_EX_WB1))
        o_forward_a_EX  =   2'b01;
    else if (zero_EX1 || zero_DM1)
        o_forward_a_EX  =   2'b00;
    else
        o_forward_a_EX  =   2'b00;
end

always @(*) begin
    if      (!(|equal_EX_DM2))
        o_forward_b_EX  =   2'b10;
    else if (!(|equal_EX_WB2))
        o_forward_b_EX  =   2'b01;
    else if (zero_EX2 || zero_DM2)
        o_forward_b_EX  =   2'b00;
    else
        o_forward_b_EX  =   2'b00;
end

// Stall IF
assign  o_stall_IF  =   i_wb_sel_EX[1];
assign  o_flush_IF  =   0;

// Stall and Flush ID
assign  o_stall_ID  =   i_wb_sel_EX[1];
assign  o_flush_ID  =   i_debug_pc_next;

// Stall and Flush EX
assign  o_stall_EX  =   0;
assign  o_flush_EX  =   i_wb_sel_EX[1] | i_debug_pc_next;

// Stall and FLush DM
assign  o_stall_DM  =   0;
assign  o_flush_DM  =   0;

// Stall and Flush WB
assign  o_stall_WB  =   0;
assign  o_flush_WB  =   0;

endmodule : hazard_unit
