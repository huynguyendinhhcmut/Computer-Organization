module driver (
  input  logic        i_clk    ,
  input  logic        i_reset  ,
  output logic [31:0] o_sw_data
);

initial begin
  o_sw_data = 32'h12345678;
end

endmodule
