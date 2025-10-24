module quad_port_ram 
(
    input logic i_clk,

    // Port A
    input logic [9:0]	addr_a,
    input logic [7:0]	data_in_a,
    input logic			we_a, 		// Write enable for Port A
    output logic [7:0]	data_out_a,

    // Port B
    input logic [9:0]	addr_b,
    input logic [7:0]	data_in_b,
    input logic			we_b,			// Write enable for Port B
    output logic [7:0]	data_out_b,
	 
	 // Port C
    input logic [9:0]	addr_c,
    input logic [7:0]	data_in_c,
    input logic			we_c,			// Write enable for Port C
    output logic [7:0]	data_out_c,
	 
	 // Port D
    input logic [9:0]	addr_d,
    input logic [7:0]	data_in_d,
    input logic			we_d, 		// Write enable for Port D
    output logic [7:0]	data_out_d
);

//	// ===========================================
//	// 		 	Declare the memory array
//	// ===========================================
//	logic [7:0] ram0 [0:1023];
//	logic [7:0] ram1 [0:1023];
//
//	// ===========================================
//	// 		 		Internal RAM 
//	// ===========================================
//	
//	// Port A operations
//	always @(posedge i_clk) begin
//		if (we_a)
//			ram0[addr_a] <= data_in_a; // Write operation
//	end
//
//	// Port B operations
//	always @(posedge i_clk) begin
//		if (we_b)
//			ram0[addr_b] <= data_in_b; // Write operation
//	end
//
//	// Port C operations
//	always @(posedge i_clk) begin
//		if (we_c)
//			ram1[addr_c] <= data_in_c; // Write operation
//	end
//
//	// Port D operations
//	always @(posedge i_clk) begin
//		if (we_d)
//			ram1[addr_d] <= data_in_d; // Write operation
//	end
//
//		 
//	assign data_out_a = ram0[addr_a];
//	assign data_out_b = ram0[addr_b];
//	assign data_out_c = ram1[addr_c];
//	assign data_out_d = ram1[addr_d];


	 // ===========================================
    //       Declare the FOUR memory arrays
    // ===========================================
    logic [7:0] ram_laneA [0:511]; // RAM for Port A
    logic [7:0] ram_laneB [0:511]; // RAM for Port B
    logic [7:0] ram_laneC [0:511]; // RAM for Port C
    logic [7:0] ram_laneD [0:511]; // RAM for Port D

    // ===========================================
    //             Port A operations
    // ===========================================
    always @(posedge i_clk) begin
        if (we_a)
            ram_laneA[addr_a] <= data_in_a;
    end
    assign data_out_a = ram_laneA[addr_a];

    // ===========================================
    //             Port B operations
    // ===========================================
    always @(posedge i_clk) begin
        if (we_b)
            ram_laneB[addr_b] <= data_in_b;
    end
    assign data_out_b = ram_laneB[addr_b];

    // ===========================================
    //             Port C operations
    // ===========================================
    always @(posedge i_clk) begin
        if (we_c)
            ram_laneC[addr_c] <= data_in_c;
    end
    assign data_out_c = ram_laneC[addr_c];

    // ===========================================
    //             Port D operations
    // ===========================================
    always @(posedge i_clk) begin
        if (we_d)
            ram_laneD[addr_d] <= data_in_d;
    end
    assign data_out_d = ram_laneD[addr_d];
	 
	 
	 
endmodule 