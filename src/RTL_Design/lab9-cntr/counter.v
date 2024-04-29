module counter(clk, rst, enab, load, cnt_in, cnt_out);

  parameter WIDTH = 5;
  input wire clk, rst, enab, load;
  input wire [WIDTH-1:0] cnt_in;
  output reg [WIDTH-1:0] cnt_out;

  reg [WIDTH-1:0] cnt;

  always @ (cnt_in, rst, load, enab)
  begin
    if (rst)
      cnt = 0;
    else if (load)
      cnt = cnt_in;
    else if (enab)
      cnt = cnt + 1;
  end

  always @ (posedge clk)
    cnt_out <= cnt;

endmodule
