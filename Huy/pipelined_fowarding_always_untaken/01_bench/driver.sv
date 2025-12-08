module driver (
  input  logic        i_clk  ,
  input  logic        i_reset,
  output logic [31:0] i_io_sw
);

  initial begin
    i_io_sw = 32'h12345678;
  end

endmodule : driver



