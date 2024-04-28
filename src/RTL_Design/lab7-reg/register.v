module register#(parameter WIDTH=8)
 (data_in, load, clk, rst, data_out);
input wire[WIDTH-1:0] data_in;
input wire load, clk, rst;
output reg[WIDTH-1:0] data_out;

always @ (posedge clk) begin
	if(rst)
		data_out <= 0;
	else if(load)
		data_out <= data_in;
end

endmodule