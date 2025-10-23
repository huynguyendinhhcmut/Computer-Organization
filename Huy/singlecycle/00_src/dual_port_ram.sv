module dual_port_ram (
    input logic clk,

    // Port A
    input logic [9:0] addr_a,
    input logic [7:0] data_in_a,
    input logic we_a, // Write enable for Port A
    output logic [7:0] data_out_a,

    // Port B
    input logic [9:0] addr_b,
    input logic [7:0] data_in_b,
    input logic we_b, // Write enable for Port B
    output logic [7:0] data_out_b
);

// Declare the memory array
logic [7:0] ram [0:1023];

// Port A operations
always @(posedge clk) begin
	if (we_a)
		ram[addr_a] <= data_in_a; // Write operation
end

// Port B operations
always @(posedge clk) begin
	if (we_b)
		ram[addr_b] <= data_in_b; // Write operation
end
	 
assign data_out_a = ram[addr_a];
assign data_out_b = ram[addr_b];

endmodule