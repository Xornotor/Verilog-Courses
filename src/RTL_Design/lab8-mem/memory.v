module memory(addr, clk, wr, rd, data);
  parameter AWIDTH = 5;
  parameter DWIDTH = 8;
  input wire clk, wr, rd;
  input wire [AWIDTH-1:0] addr;
  inout wire [DWIDTH-1:0] data;

  reg [DWIDTH-1:0] memory[(2**AWIDTH)-1:0];
  reg [DWIDTH-1:0] data_out;

  assign data = rd ? data_out : {DWIDTH{1'bz}};

  always @ (posedge clk)
  begin
    data_out <= memory[addr];
    if (wr)
      memory[addr] <= data;
  end
endmodule
