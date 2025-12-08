module dual_port_ram (
    input logic clk,

    // Port A
    input logic [14:0] addr_a,
    input logic [7:0] data_in_a,
    input logic we_a, // Write enable for Port A
    output logic [7:0] data_out_a,

    // Port B
    input logic [14:0] addr_b,
    input logic [7:0] data_in_b,
    input logic we_b, // Write enable for Port B
    output logic [7:0] data_out_b
);

// Declare the memory array
logic [7:0] ram [0:32767];

initial begin
        $readmemh("/home/yellow/ctmt_cttt_4/pipelined_fowarding_2_bit_branch_predictor/02_test/dmem_init_file.hex", ram);
end

// Port A operations
always @(posedge clk) begin
	if (we_a) begin
		ram[addr_a] <= data_in_a; // Write operation
		data_out_a <= data_in_a;
	end else 
		data_out_a <= ram[addr_a];
end

// Port B operations
always @(posedge clk) begin
	if (we_b) begin
		ram[addr_b] <= data_in_b; // Write operation
		data_out_b <= data_in_b;
	end else
		data_out_b <= ram[addr_b];
end

endmodule

