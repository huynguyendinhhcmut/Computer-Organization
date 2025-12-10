module bht (
    input  logic       i_enable,
    input  logic       i_branch,    
    input  logic [1:0] i_current_state, 
      
    output logic [1:0] o_next_state  
);

localparam [1:0] SNT = 2'b00; // Strongly Not Taken
localparam [1:0] WNT = 2'b01; // Weakly Not Taken
localparam [1:0] WT  = 2'b10; // Weakly Taken
localparam [1:0] ST  = 2'b11; // Strongly Taken

always @(*) begin 
    o_next_state = i_current_state;

    case (i_current_state)
        SNT: begin
            if (i_enable & i_branch)       o_next_state = WNT;
            else if (i_enable & ~i_branch) o_next_state = SNT;
        end

        WNT: begin
            if (i_enable & i_branch)       o_next_state = WT;
            else if (i_enable & ~i_branch) o_next_state = SNT;
        end

        WT: begin
            if (i_enable & i_branch)       o_next_state = ST;
            else if (i_enable & ~i_branch) o_next_state = WNT;
        end

        ST: begin
            if (i_enable & i_branch)       o_next_state = ST;
            else if (i_enable & ~i_branch) o_next_state = WT;
        end
            
        default: o_next_state = WNT;
        
    endcase
end

endmodule
