module alu(in_a, in_b, opcode, alu_out, a_is_zero);
    
    parameter WIDTH = 8;

    input [WIDTH-1:0] in_a, in_b;
    input [2:0] opcode;
    output reg [WIDTH-1:0] alu_out;
    output wire a_is_zero;
    
    assign a_is_zero = (in_a == 0);

    always @ *
    begin
        if(opcode == 3'b101)
            alu_out <= in_b;
        else if(opcode == 3'b010)
            alu_out <= in_a + in_b;
        else if(opcode == 3'b011)
            alu_out <= in_a & in_b;
        else if (opcode == 3'b100)
            alu_out <= in_a ^ in_b;
        else
            alu_out <= in_a;
    end

endmodule
