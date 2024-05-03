module counter
  #(
     parameter integer WIDTH=5
   )
   (
     input  wire clk  ,
     input  wire rst  ,
     input  wire load ,
     input  wire enab ,
     input  wire [WIDTH-1:0] cnt_in ,
     output reg  [WIDTH-1:0] cnt_out
   );


  //////////////////////////////////////////////////////////////////////////////
  //TO DO: DEFINE THE COUNTER COMBINATIONAL LOGIC using FUNCTION AS INSTRUCTED//
  //////////////////////////////////////////////////////////////////////////////

  function [WIDTH-1:0] cnt_func;
    input rst, load, enab;
    input [WIDTH-1:0] cnt_in, cnt_out;
    begin
      cnt_func = cnt_out;
      if(rst)
        cnt_func = 0;
      else if(load)
        cnt_func = cnt_in;
      else if(enab)
        cnt_func = cnt_out + 1;
    end
  endfunction

  always @(posedge clk)
    cnt_out <= cnt_func (rst, load, enab ,cnt_in, cnt_out); //function call

endmodule
