module test;

  // DUT I/O
  reg CLK;
  reg RST;
  wire HALT;  

  // VARS
  reg [7:0] number;

  // DUT INST
  cpu cpu_inst(.CLK(CLK), .RST(RST), .HALT(HALT));
  
  // CLOCK GEN
  initial begin
    CLK = 0;
    forever
      #1 CLK = ~CLK;
  end

  // INIT_MSG TASK
  task init_msg;
    begin
      $display("VeriRISC Testbench - Made by Xornotor\n");
      $display("Commands");
      $display("--------\n");
      $display("deposit object_name value");
      $display("task task_name");
      $display("run [time_spec]");
      $display("-------------------------------------");
    end
  endtask
  
  // FINAL_MSG TASK
  task final_msg;
    reg [7:0] exp_halt_addr;
    begin
      case(number)
        8'd1: exp_halt_addr = 8'h17;
        8'd2: exp_halt_addr = 8'h10;
        8'd3: exp_halt_addr = 8'h0C;
      endcase
      $display("Halted at address = %0h", test.cpu_inst.pc);
      $display("Expected  address = %0h", exp_halt_addr);
      if(test.cpu_inst.pc == exp_halt_addr)
        $display("TEST PASSED");
      else
        $display("TEST FAILED");
      $display("-------------------------------------");
    end
  endtask
  
  // RUN TASK
  task run;
    reg [8*9:1] testfile;
    begin
      testfile = {"PROG", 8'h30 + number, ".txt"};
      $readmemb(testfile, test.cpu_inst.mem);
      @(negedge CLK) RST = 1;
      @(negedge CLK) RST = 0;
    end
  endtask
  
  // HALT PROCEDURAL BLOCK
  always @(posedge HALT) begin
    final_msg;
    init_msg;
    $stop;
  end
  
  // STARTUP PROCEDURAL BLOCK 
  initial begin
    init_msg;
    $stop;
  end
  
endmodule
