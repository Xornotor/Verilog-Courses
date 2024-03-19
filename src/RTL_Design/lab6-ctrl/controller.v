module controller(zero, phase, opcode,
                    sel, rd, ld_ir, halt, inc_pc, ld_ac, wr, ld_pc, data_e);

  input wire zero;
  input wire [2:0] phase, opcode;
  output reg sel, rd, ld_ir, halt, inc_pc, ld_ac, wr, ld_pc, data_e;

  reg alu_op;
  reg skz_and_zero;

  always @ (zero, phase, opcode)
  begin
    {sel, rd, ld_ir, halt, inc_pc, ld_ac, wr, ld_pc, data_e} = 9'b0_0000_0000;
    alu_op = (opcode >= 3'b010 && opcode <= 3'b101);
	skz_and_zero = (opcode == 3'b001 && zero);

	case (phase)
      3'b000:
        sel = 1'b1;

      3'b001:
      begin
        sel = 1'b1;
        rd = 1'b1;
      end

      3'b010:
      begin
        sel = 1'b1;
        rd = 1'b1;
        ld_ir = 1'b1;
      end

      3'b011:
      begin
        sel = 1'b1;
        rd = 1'b1;
        ld_ir = 1'b1;
      end

      3'b100:
      begin
        inc_pc = 1'b1;
        halt = opcode == 3'b000;
      end

      3'b101:
      begin
        rd = alu_op;
      end

      3'b110:
      begin
          inc_pc = skz_and_zero;
          rd = alu_op;
		  ld_pc = opcode == 3'b111;
		  data_e = opcode == 3'b110;
      end

      3'b111:
      begin
        rd = alu_op;
        ld_ac = alu_op;
		ld_pc = opcode == 3'b111;
		wr = opcode == 3'b110;
		data_e = opcode == 3'b110;
      end
    endcase
  end

endmodule
