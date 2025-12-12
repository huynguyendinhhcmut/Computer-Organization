module control_unit (
    input logic     [ 6:0]      i_op,
    input logic     [ 2:0]      i_funct3,
    input logic                 i_funct7_5,
    //input logic                 i_funct7_0,
    input logic     [ 2:0]      i_ges,
    //input logic                 br_less, br_equal,
    output logic                o_data_sel, o_rd_wren, o_br_un, o_opa_sel, o_opb_sel, o_mem_wren, o_insn_vld,
    output logic    [ 2:0]      o_imm_sel,
    output logic    [ 3:0]      o_alu_op,
    output logic    [ 1:0]      o_wb_sel,
    output logic    [ 1:0]      o_sl_sel,
    output logic    [ 2:0]      o_bmask,
    output logic                o_pc_branch_sel, o_pc_jump_sel,
    output logic                o_ctrl    //  o_ctrl
);
// Internal signals
logic       br_less, br_equal;
logic       rv32i;
logic       I_type3, I_type19, I_type103;
logic       U_type23, U_type55;
logic       S_type, R_type, B_type, J_type;

logic       LB, LH, LW, LBU, LHU;
logic       ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI;
logic       JALR;

logic       AUIPC;
logic       LUI;

logic       SB, SH, SW;

logic       ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND;

logic       BEQ, BNE, BLT, BGE, BLTU, BGEU;

logic       JAL;

// Assignment
assign  br_less     =   i_ges[0];
assign  br_equal    =   i_ges[1];


// Instruction Types
assign rv32i        = i_op[0] & i_op[1];
assign I_type3      = ~i_op[6] & ~i_op[5] & ~i_op[4] & ~i_op[3] & ~i_op[2] & rv32i;
assign I_type19     = ~i_op[6] & ~i_op[5] & i_op[4] & ~i_op[3] & ~i_op[2] & rv32i;
assign I_type103    = i_op[6] & i_op[5] & ~i_op[4] & ~i_op[3] & i_op[2] & rv32i;
assign U_type23     = ~i_op[6] & ~i_op[5] & i_op[4] & ~i_op[3] & i_op[2] & rv32i;
assign U_type55     = ~i_op[6] & i_op[5] & i_op[4] & ~i_op[3] & i_op[2] & rv32i;
assign S_type       = ~i_op[6] & i_op[5] & ~i_op[4] & ~i_op[3] & ~i_op[2] & rv32i;
assign R_type       = ~i_op[6] & i_op[5] & i_op[4] & ~i_op[3] & ~i_op[2] & rv32i;
assign B_type       = i_op[6] & i_op[5] & ~i_op[4] & ~i_op[3] & ~i_op[2] & rv32i;
assign J_type       = i_op[6] & i_op[5] & ~i_op[4] & i_op[3] & i_op[2] & rv32i;

// Type I
assign LB           = I_type3 & ~i_funct3[2] & ~i_funct3[1] & ~i_funct3[0];
assign LH           = I_type3 & ~i_funct3[2] & ~i_funct3[1] &  i_funct3[0];
assign LW           = I_type3 & ~i_funct3[2] &  i_funct3[1] & ~i_funct3[0];
assign LBU          = I_type3 &  i_funct3[2] & ~i_funct3[1] & ~i_funct3[0];
assign LHU          = I_type3 &  i_funct3[2] & ~i_funct3[1] &  i_funct3[0];

assign ADDI         = I_type19 & ~i_funct3[2] & ~i_funct3[1] & ~i_funct3[0];
assign SLLI         = I_type19 & ~i_funct3[2] & ~i_funct3[1] &  i_funct3[0];
assign SLTI         = I_type19 & ~i_funct3[2] &  i_funct3[1] & ~i_funct3[0];
assign SLTIU        = I_type19 & ~i_funct3[2] &  i_funct3[1] &  i_funct3[0];
assign XORI         = I_type19 &  i_funct3[2] & ~i_funct3[1] & ~i_funct3[0];
assign SRLI         = I_type19 &  i_funct3[2] & ~i_funct3[1] &  i_funct3[0] & ~i_funct7_5;
assign SRAI         = I_type19 &  i_funct3[2] & ~i_funct3[1] &  i_funct3[0] &  i_funct7_5;
assign ORI          = I_type19 &  i_funct3[2] &  i_funct3[1] & ~i_funct3[0];
assign ANDI         = I_type19 &  i_funct3[2] &  i_funct3[1] &  i_funct3[0];

assign JALR         = I_type103 & ~i_funct3[2] & ~i_funct3[1] & ~i_funct3[0];

// Type U
assign AUIPC        = U_type23;

assign LUI          = U_type55;

// Type S
assign SB           = S_type & ~i_funct3[2] & ~i_funct3[1] & ~i_funct3[0];
assign SH           = S_type & ~i_funct3[2] & ~i_funct3[1] &  i_funct3[0];
assign SW           = S_type & ~i_funct3[2] &  i_funct3[1] & ~i_funct3[0];

// Type R
assign ADD          = R_type & ~i_funct3[2] & ~i_funct3[1] & ~i_funct3[0] & ~i_funct7_5;
assign SUB          = R_type & ~i_funct3[2] & ~i_funct3[1] & ~i_funct3[0] &  i_funct7_5;
assign SLL          = R_type & ~i_funct3[2] & ~i_funct3[1] &  i_funct3[0] & ~i_funct7_5;
assign SLT          = R_type & ~i_funct3[2] &  i_funct3[1] & ~i_funct3[0] & ~i_funct7_5;
assign SLTU         = R_type & ~i_funct3[2] &  i_funct3[1] &  i_funct3[0] & ~i_funct7_5;
assign XOR          = R_type &  i_funct3[2] & ~i_funct3[1] & ~i_funct3[0] & ~i_funct7_5;
assign SRL          = R_type &  i_funct3[2] & ~i_funct3[1] &  i_funct3[0] & ~i_funct7_5;
assign SRA          = R_type &  i_funct3[2] & ~i_funct3[1] &  i_funct3[0] &  i_funct7_5;
assign OR           = R_type &  i_funct3[2] &  i_funct3[1] & ~i_funct3[0] & ~i_funct7_5;
assign AND          = R_type &  i_funct3[2] &  i_funct3[1] &  i_funct3[0] & ~i_funct7_5;

// Type B
assign BEQ          = B_type & ~i_funct3[2] & ~i_funct3[1] & ~i_funct3[0];
assign BNE          = B_type & ~i_funct3[2] & ~i_funct3[1] &  i_funct3[0];
assign BLT          = B_type &  i_funct3[2] & ~i_funct3[1] & ~i_funct3[0];
assign BGE          = B_type &  i_funct3[2] & ~i_funct3[1] &  i_funct3[0];
assign BLTU         = B_type &  i_funct3[2] &  i_funct3[1] & ~i_funct3[0];
assign BGEU         = B_type &  i_funct3[2] &  i_funct3[1] & ~i_funct3[0];

// Type J
assign JAL          = J_type;

// o_pc_sel
always @(*) begin
    if (I_type3) begin
        //o_pc_sel    = 1'b0;
        o_rd_wren   = 1'b1;
        o_imm_sel   = 3'b000;
        o_br_un     = 1'b1;
        o_opa_sel   = 1'b0;
        o_opb_sel   = 1'b0;
        o_alu_op    = 4'b0000;
        o_mem_wren  = 1'b0;
        o_wb_sel    = 2'b10;
        o_data_sel  = 1'b1;
        if      (LB) begin
            o_sl_sel    = 3'b000;
            o_insn_vld  = 1'b1;
        end
        else if (LH) begin
            o_sl_sel    = 3'b001;
            o_insn_vld  = 1'b1;
        end
        else if (LW) begin
            o_sl_sel    = 3'b010;
            o_insn_vld  = 1'b1;
        end
        else if (LBU) begin
            o_sl_sel    = 3'b011;
            o_insn_vld  = 1'b1;
        end
        else if (LHU) begin
            o_sl_sel    = 3'b100;
            o_insn_vld  = 1'b1;
        end
    end
    else if (I_type19) begin
        //o_pc_sel    = 1'b0;
        o_rd_wren   = 1'b1;
        o_imm_sel   = 3'b000;
        o_br_un     = 1'b1;
        o_opa_sel   = 1'b0;
        o_opb_sel   = 1'b1;
        o_mem_wren  = 1'b0;
        o_wb_sel    = 2'b01;
        o_data_sel  = 1'b0;
        o_sl_sel    = 3'b000;
        if      (ADDI) begin
            o_alu_op    = 4'b0000;
            o_insn_vld  = 1'b1;
        end
        else if (SLLI) begin
            o_alu_op    = 4'b0111;
            o_insn_vld  = 1'b1;
        end
        else if (SLTI) begin
            o_alu_op    = 4'b0010;
            o_insn_vld  = 1'b1;
        end
        else if (SLTIU) begin
            o_alu_op    = 4'b0011;
            o_insn_vld  = 1'b1;
        end
        else if (XORI) begin
            o_alu_op    = 4'b0100;
            o_insn_vld  = 1'b1;
        end
        else if (SRLI) begin
            o_alu_op    = 4'b1000;
            o_insn_vld  = 1'b1;
        end
        else if (SRAI) begin
            o_alu_op    = 4'b1001;
            o_insn_vld  = 1'b1;
        end
        else if (ORI) begin
            o_alu_op    = 4'b0101;
            o_insn_vld  = 1'b1;
        end
        else if (ANDI) begin
            o_alu_op    = 4'b0110;
            o_insn_vld  = 1'b1;
        end
    end
    else if (I_type103) begin
        //o_pc_sel    = 1'b1;
        o_rd_wren   = 1'b1;
        o_imm_sel   = 3'b000;
        o_br_un     = 1'b1;
        o_opa_sel   = 1'b0;
        o_opb_sel   = 1'b1;
        o_alu_op    = 4'b0000;
        o_mem_wren  = 1'b0;
        o_wb_sel    = 2'b00;
        o_data_sel  = 1'b0;
        o_sl_sel    = 3'b000;
        o_insn_vld  = 1'b1;
    end
    else if (U_type23) begin
        //o_pc_sel    = 1'b0;
        o_rd_wren   = 1'b1;
        o_imm_sel   = 3'b100;
        o_br_un     = 1'b1;
        o_opa_sel   = 1'b1;
        o_opb_sel   = 1'b1;
        o_alu_op    = 4'b0000;
        o_mem_wren  = 1'b0;
        o_wb_sel    = 2'b00;
        o_data_sel  = 1'b0;
        o_sl_sel    = 3'b000;
        o_insn_vld  = 1'b1;       
    end
    else if (U_type55) begin
        //o_pc_sel    = 1'b0;
        o_rd_wren   = 1'b1;
        o_imm_sel   = 3'b100;
        o_br_un     = 1'b1;
        o_opa_sel   = 1'b0;
        o_opb_sel   = 1'b1;
        o_alu_op    = 4'b1010;
        o_mem_wren  = 1'b0;
        o_wb_sel    = 2'b01;
        o_data_sel  = 1'b0;
        o_sl_sel    = 3'b000;
        o_insn_vld  = 1'b1;       
    end
    else if (S_type) begin
        //o_pc_sel    = 1'b0;
        o_rd_wren   = 1'b0;
        o_imm_sel   = 3'b001;
        o_br_un     = 1'b1;
        o_opa_sel   = 1'b0;
        o_opb_sel   = 1'b1;
        o_alu_op    = 4'b0000;
        o_mem_wren  = 1'b1;
        o_wb_sel    = 2'b00;
        o_data_sel  = 1'b0;
        o_sl_sel    = 3'b000;
        o_insn_vld  = 1'b1;       
    end
    else if (R_type) begin
        //o_pc_sel    = 1'b0;
        o_rd_wren   = 1'b1;
        o_imm_sel   = 3'b000;
        o_br_un     = 1'b1;
        o_opa_sel   = 1'b0;
        o_opb_sel   = 1'b0;
        o_mem_wren  = 1'b0;
        o_wb_sel    = 2'b01;
        o_data_sel  = 1'b0;
        o_sl_sel    = 3'b000;
        o_insn_vld  = 1'b1;
        if (ADD)
            o_alu_op    = 4'b0000;
        else if (SUB)
            o_alu_op    = 4'b0001;
        else if (SLL)
            o_alu_op    = 4'b0111;
        else if (SLT)
            o_alu_op    = 4'b0010;
        else if (SLTU)
            o_alu_op    = 4'b0011;
        else if (XOR)
            o_alu_op    = 4'b0100;
        else if (SRL)
            o_alu_op    = 4'b1000;
        else if (SRA)
            o_alu_op    = 4'b1001;
        else if (OR)
            o_alu_op    = 4'b0101;
        else if (AND)
            o_alu_op    = 4'b0110;
    end
    else if (B_type) begin
        o_rd_wren   = 1'b0;
        o_imm_sel   = 3'b010;
        o_opa_sel   = 1'b1;
        o_opb_sel   = 1'b1;
        o_alu_op    = 4'b0000;
        o_mem_wren  = 1'b0;
        o_wb_sel    = 2'b01;
        o_data_sel  = 1'b0;
        o_sl_sel    = 3'b000;
        if (BEQ) begin
            o_br_un     = 1'b0;
            //o_pc_sel    = (br_equal) ? 1:0;
            o_insn_vld  = 1'b1;
        end
        else if (BNE) begin
            o_br_un     = 1'b0;
            //o_pc_sel    = (~br_equal) ? 1:0;
            o_insn_vld  = 1'b1;
        end
        else if (BLT) begin
            o_br_un     = 1'b0;
            //o_pc_sel    = (br_less) ? 1:0;
            o_insn_vld  = 1'b1;
        end
        else if (BGE) begin
            o_br_un     = 1'b0;
            //o_pc_sel    = (~br_equal && ~br_less) ? 1:0;
            o_insn_vld  = 1'b1;
        end
        else if (BLTU) begin
            o_br_un     = 1'b1;
            //o_pc_sel    = (br_less) ? 1:0;
            o_insn_vld  = 1'b1;
        end
        else if (BGEU) begin
            o_br_un     = 1'b1;
            //o_pc_sel    = (~br_equal && ~br_less) ? 1:0;
            o_insn_vld  = 1'b1;
        end
    end
    else if (J_type) begin
        //o_pc_sel    = 1'b1;
        o_rd_wren   = 1'b1;
        o_imm_sel   = 3'b011;
        o_br_un     = 1'b1;
        o_opa_sel   = 1'b1;
        o_opb_sel   = 1'b1;
        o_alu_op    = 4'b0000;
        o_mem_wren  = 1'b0;
        o_wb_sel    = 2'b00;
        o_data_sel  = 1'b0;
        o_sl_sel    = 3'b000;
        o_insn_vld  = 1'b1;  
    end
end

assign o_bmask = {SW, SH, SB};

assign o_ctrl               =   B_type | J_type | JALR;
assign o_update_btb_en      =   B_type | J_type | JALR;
assign o_pc_branch_sel      =   B_type;
assign o_pc_jump_sel        =   J_type | JALR;

endmodule : control_unit
