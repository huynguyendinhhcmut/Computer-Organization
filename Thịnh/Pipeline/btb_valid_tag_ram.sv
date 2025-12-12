module btb_valid_tag_ram(
    input logic                 i_clk,
    input logic                 i_btb_wren,
    input logic     [ 9:0]      i_waddr,
    input logic     [ 9:0]      i_raddr,
    input logic     [20:0]      i_wdata,
    output logic    [20:0]      o_data
);

reg [20:0]  ram [0:1023];

initial begin
    $readmemh("/home/norman/milestone3/rtl/btb_init_file.txt", ram);
end

// Write data
always_ff @(posedge i_clk) begin
    if (i_btb_wren) begin
        ram[i_waddr] <=  i_wdata;
    end
end

// Read data
always_ff @(negedge i_clk) begin
    o_data <=   ram[i_raddr];
end

endmodule : btb_valid_tag_ram
