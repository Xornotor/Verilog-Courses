module driver(data_in, data_en, data_out);

    parameter WIDTH = 8;
    input wire data_en;
    input wire [WIDTH-1:0] data_in;
    output wire [WIDTH-1:0] data_out;

    assign data_out = data_en ? data_in : 8'bz;

endmodule
