module bht (
    input  logic [1:0] i_state,       
    input  logic       i_valid, 

    output logic       o_predict,     
    output logic [1:0] o_next_state   
);

localparam [1:0] SNT = 2'b00; // Strongly Not Taken
localparam [1:0] WNT = 2'b01; // Weakly Not Taken
localparam [1:0] WT  = 2'b10; // Weakly Taken
localparam [1:0] ST  = 2'b11; // Strongly Taken
    
assign o_predict = o_next_state[1];

always @(*) begin
    case (i_state)
        SNT: begin
            if (i_valid) 
                o_next_state = WNT; 
            else                
                o_next_state = SNT;
            end

        WNT: begin
            if (i_valid) 
                o_next_state = WT;  
            else                
                o_next_state = SNT; 
            end

        WT: begin
            if (i_valid) 
                o_next_state = ST;  
            else                
                o_next_state = WNT; 
            end

        ST: begin
            if (i_valid) 
                o_next_state = ST;  
            else                
                o_next_state = WT;  
            end
            
            default: o_next_state = WNT; 
        endcase
    end

endmodule
