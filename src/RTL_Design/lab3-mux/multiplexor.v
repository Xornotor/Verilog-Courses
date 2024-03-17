module multiplexor(sel, in0, in1, mux_out);

parameter WIDTH = 5;

input sel;
input[WIDTH-1:0] in0, in1;
output reg [WIDTH-1:0] mux_out;

always @ (in0, in1, sel)
begin
    if(sel == 1'b0)
        mux_out <= in0;
    else
        mux_out <= in1;
end

endmodule
