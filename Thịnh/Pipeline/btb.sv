module btb(
    input logic                 i_clk,                      //i_rstn,
    input logic     [31:0]      i_pc_IF,
    input logic     [31:0]      i_pc_plus4_EX,
    input logic     [31:0]      i_pc_update,
    input logic     [31:0]      i_target_update,
    input logic                 i_update_btb_en,            //i_taken_update, 
    //input logic                 i_is_jump_or_branch,
    input logic                 i_pc_sel,                   // This signal from EX stage
    input logic                 i_btb_hit_EX,
    output logic    [31:0]      o_predicted_pc_IF,
    output logic    [31:0]      o_pc_plus4_not_branch,
    output logic                o_btb_hit,
//    output logic                o_not_branch,
    output logic                o_target_match,
    output logic                o_debug_pc_next
);
logic   [ 9:0]  index_in, index_btb;
logic   [19:0]  tag_in, tag_btb;
logic           valid;
logic   [31:0]  predicted_pc;
logic   [31:0]  predicted_pc_cmp1, predicted_pc_cmp2;
logic           valid1, valid2;
logic   [19:0]  tag_btb1, tag_btb2;


assign  index_in        =   i_pc_IF[11: 2];
assign  tag_in          =   i_pc_IF[31:12];

//assign  index_update    =   i_pc_update[11: 2];
//assign  tag_update      =   i_pc_update[31:12];

// Instance BTB RAM & Valid-Tag RAM
// Store target pc
btb_ram                 dut_target  (
    .i_clk                          (   i_clk               ),
    .i_btb_wren                     (   i_update_btb_en     ),
    .i_waddr                        (   i_pc_update[11: 2]  ),
    .i_raddr                        (   index_in            ),
    .i_wdata                        (   i_target_update     ),
    .o_data                         (   predicted_pc        )
);

// Store Valid-Tag
btb_valid_tag_ram       dut_valid_tag   (
    .i_clk                              (   i_clk                       ),
    .i_btb_wren                         (   i_update_btb_en             ),
    .i_waddr                            (   i_pc_update[11: 2]          ),
    .i_raddr                            (   index_in                    ),
    .i_wdata                            (   {1'b1, i_pc_update[31:12]}  ),
    .o_data                             (   {valid, tag_btb}            )
);

// Predicted_pc, Valid, Tag when compare with result from EX stage
always_ff @(posedge i_clk) begin
    predicted_pc_cmp1   <=  predicted_pc;
end

always_ff @(posedge i_clk) begin
    predicted_pc_cmp2   <=  predicted_pc_cmp1;
end

always_ff @(posedge i_clk) begin
    valid1      <=  valid;
    tag_btb1    <=  tag_btb;
end

always_ff @(posedge i_clk) begin
    valid2      <=  valid1;
    tag_btb2    <=  tag_btb1;
end
//

assign  o_predicted_pc_IF       =   (valid & ~(|(tag_in ^ tag_btb))) ? predicted_pc : o_pc_plus4_not_branch;
assign  o_btb_hit               =   ~(|(tag_in ^ tag_btb)) & valid;
//assign  o_target_match          =   (|(i_target_update ^ o_predicted_pc_IF)) ? 0 : 1;

assign  o_target_match          =   ~(|(i_target_update ^ predicted_pc_cmp2)) & ~(|(i_pc_update[31:12] ^ tag_btb2)) & i_pc_sel;

assign  o_debug_pc_next         =   (i_btb_hit_EX & (~i_pc_sel)) | (i_btb_hit_EX & i_pc_sel & (~o_target_match)) | ((~i_btb_hit_EX & i_pc_sel));

//assign  o_pc_plus4_not_branch   =   i_pc_plus4_DM;
always_ff @(posedge i_clk) begin
    o_pc_plus4_not_branch   <=  i_pc_plus4_EX;
end
//assign  o_not_branch            =   ~i_pc_sel;

endmodule : btb
