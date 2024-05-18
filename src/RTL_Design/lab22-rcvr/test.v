`timescale 1 ns / 1 ns
module test;
  
  // PARAMS
  localparam integer HSIZE      = 8;
  localparam integer HVALUE     = 8'hA5;
  localparam integer BSIZE      = 16;
  localparam integer VALUE1     = 16'h3524;
  localparam integer VALUE2     = 16'h5E81; 
  localparam integer VALUE3     = 16'hD609;
  localparam integer VALUE4     = 16'h5663; 

  // I/O FOR DUT    
  reg SCLK, RST, SDATA, ACK;
  wire READY;
  wire [7:0] DOUT;

  // VARIABLES
  reg [255:0] test_stream;
  reg [15:0] output_capture;
  reg [7:0] last_byte_sent;
  integer i, seed, frames_sent, frames_rcvd;

  // DUT INSTANCE
  rcvr #(
    .HEADER_SIZE(HSIZE), .HEADER_VALUE(HVALUE),
    .BODY_SIZE(BSIZE)
  ) dut (
    .SCLK(SCLK), .RST(RST), .SDATA(SDATA), .ACK(ACK),
    .READY(READY), .DOUT(DOUT)
  );

  // CLOCKGEN
  initial begin
    SCLK = 0;
    forever
      #1 SCLK = ~SCLK;
  end

  // VAR INIT
  initial begin
    seed = 1;
    test_stream = { $random(seed), $random(seed), $random(seed), $random(seed), 
                    $random(seed), $random(seed), $random(seed), $random(seed)};
    test_stream[220:(220-7)] = HVALUE;
    test_stream[180:(180-7)] = HVALUE;
    test_stream[92:(92-7)] = HVALUE;
    test_stream[36:(36-7)] = HVALUE;
    test_stream[(220-8):(220-23)] = VALUE1;
    test_stream[(180-8):(180-23)] = VALUE2;
    test_stream[(92-8):(92-23)] = VALUE3;
    test_stream[(36-8):(36-23)] = VALUE4;
    frames_sent = 0;
    frames_rcvd = 0;
    output_capture = 16'd0;
    last_byte_sent = 8'bxxxxxxxx;
  end

  // TASK EXPECT
  task expect(input [15:0] exp_num);
    if(output_capture != exp_num) begin
      $display("%0dns: ERROR - Expected %0h, got %0h", 
                $time, exp_num, output_capture);
      $display("TEST FAILED");
      $finish;
    end
    else
      $display("%0dns: Value just as expected", $time);
  endtask

  // STIMULUS AND CHECK
  initial begin
    RST = 1;
    @(posedge SCLK);
    @(posedge SCLK);
    RST = 0;
    $display("Reset signal low at %0d ns", $time);
    for(i = 0; i <= 255; i = i + 1) begin
      @(negedge SCLK);
      if(!READY && ACK) begin
        $display("%0dns: Rcvd data %0h", $time, output_capture);
        case(frames_rcvd)
          0: expect(VALUE1);
          1: expect(VALUE2);
          2: expect(VALUE3);
          3: expect(VALUE4);
        endcase
        frames_rcvd = frames_rcvd + 1;
        ACK = 0;
      end     
      if(READY) begin
        output_capture = (output_capture << 8) | DOUT;
        ACK = 1;
      end
      SDATA = test_stream[255-i];
      last_byte_sent = (last_byte_sent << 1) | SDATA;
      if(i >= 23 && last_byte_sent == HVALUE)
        frames_sent = frames_sent + 1;
    end
    $display("%0dns: Stimulus process complete", $time);
    $display("%0dns: frames_sent=%0d, frames_rcvd=%0d",
              $time, frames_sent, frames_rcvd);
    if(frames_sent != frames_rcvd) begin
      $display("ERROR: frames_sent != frames_rcvd\nTEST FAILED");
      $finish;
    end
    $display("TEST PASSED");
    $finish;
  end

endmodule
