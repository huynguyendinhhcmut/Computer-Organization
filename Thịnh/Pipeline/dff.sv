module dff
#(
    parameter   int WIDTH   = 32
)
(
    input   logic                 clk, rst,
    input   logic     [WIDTH-1:0] d,
    input   logic                 stall, flush,
    output  logic                 q
);
logic [WIDTH-1:0] d_tmp;

assign d_tmp = (~stall) ? q : d;

always_ff @(posedge clk or negedge rst) begin
    if (~rst)
        q <= 'h0;
    else if (flush)
        q <= 'h0;
    else if (~stall)
        q <= d_tmp;
    else
        q <= d_tmp;
end


endmodule : dff
