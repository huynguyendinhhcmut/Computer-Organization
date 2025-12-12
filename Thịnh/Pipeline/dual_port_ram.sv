module dual_port_ram(
    input logic                 i_clk,
    // Port A   
    input logic     [14:0]      i_addr_a,
    input logic     [ 7:0]      i_data_in_a,
    input logic                 i_we_a,
    output logic    [ 7:0]      o_data_out_a,
    // Port B
    input logic     [14:0]      i_addr_b,
    input logic     [ 7:0]      i_data_in_b,
    input logic                 i_we_b,
    output logic    [ 7:0]      o_data_out_b
);
// Declare the memory array
logic [7:0] ram [0:32767];

// Port A operations
always @(posedge i_clk) begin
    if (i_we_a) begin
        ram[i_addr_a] <= i_data_in_a;
        o_data_out_a  <= i_data_in_a;
    end
    else
        o_data_out_a  <= ram[i_addr_a];
end

// Port B operations
always @(posedge i_clk) begin
    if (i_we_b) begin
        ram[i_addr_b] <= i_data_in_b;
        o_data_out_b  <= i_data_in_b;
    end
    else
        o_data_out_b  <= ram[i_addr_b];
end

endmodule : dual_port_ram
