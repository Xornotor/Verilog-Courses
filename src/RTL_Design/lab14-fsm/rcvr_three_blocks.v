module rcvr
(
  input  wire      clock   ,
  input  wire      reset   ,
  input  wire      data_in ,
  input  wire      reading ,
  output reg       ready   ,
  output reg       overrun ,
  output reg [7:0] data_out
);

  // For proper operation the FSM must hard-code the MATCH
  localparam [7:0] MATCH = 8'hA5 ; // 10100101

  reg [3:0] state, nstate ;

  // Opportunity for Gray encoding as path is mostly linear
  localparam [3:0] HEAD1=4'b0000, HEAD2=4'b0001, HEAD3=4'b0011, HEAD4=4'b0010,
                   HEAD5=4'b0110, HEAD6=4'b0111, HEAD7=4'b0101, HEAD8=4'b0100,
                   BODY1=4'b1100, BODY2=4'b1101, BODY3=4'b1111, BODY4=4'b1110,
                   BODY5=4'b1010, BODY6=4'b1011, BODY7=4'b1001, BODY8=4'b1000;

  reg [6:0] body_reg ;

  always @* begin
    // WHEN IN EACH STATE WHAT MOVES FSM TO WHAT NEXT STATE?
    case ( state )
      HEAD1, BODY8: nstate = (data_in == MATCH[0]) ? HEAD2 : HEAD1;
      HEAD2: nstate = (data_in == MATCH[1]) ? HEAD3 : ((data_in == MATCH[0]) ? HEAD2 : HEAD1);
      HEAD3: nstate = (data_in == MATCH[2]) ? HEAD4 : ((data_in == MATCH[0]) ? HEAD2 : HEAD1);
      HEAD4: nstate = (data_in == MATCH[3]) ? HEAD5 : ((data_in == MATCH[0]) ? HEAD2 : HEAD1);
      HEAD5: nstate = (data_in == MATCH[4]) ? HEAD6 : ((data_in == MATCH[0]) ? HEAD2 : HEAD1);
      HEAD6: nstate = (data_in == MATCH[5]) ? HEAD7 : ((data_in == MATCH[0]) ? HEAD2 : HEAD1);
      HEAD7: nstate = (data_in == MATCH[6]) ? HEAD8 : ((data_in == MATCH[0]) ? HEAD2 : HEAD1);
      HEAD8: nstate = (data_in == MATCH[7]) ? BODY1 : ((data_in == MATCH[0]) ? HEAD2 : HEAD1);
      BODY1: nstate = BODY2;
      BODY2: nstate = BODY3;
      BODY3: nstate = BODY4;
      BODY4: nstate = BODY5;
      BODY5: nstate = BODY6;
      BODY6: nstate = BODY7;
      BODY7: nstate = BODY8;
    endcase
  end

  always @(posedge clock)
    if(reset) state <= HEAD1;
    else state <= nstate;

  always @(posedge clock)

    if (reset) begin
      // CLEAR ALL CONTROL REGISTERS TO INACTIVE STATE (IGNORE DATA REGISTERS)
      ready <= 1'b0;
      overrun <= 1'b0;
    end

    else begin
        // IF STATE IS BODY? THEN SHIFT DATA INPUT LEFT INTO BODY REGISTER
        if(state[3] == 1'b1) begin
          body_reg <= (body_reg << 1) | {6'd0, data_in};
        end

        // IF STATE IS BODY8 THEN COPY CONCATENATION OF BODY REGISTER AND INPUT
        // DATA TO OUTPUT REGISTER
        if(state == BODY8)
          data_out <= {body_reg, data_in};
        // IF STATE IS BODY8 THEN SET READY ELSE IF READING THEN CLEAR READY
        if(state == BODY8) ready <= 1'b1;
	    else if(reading) ready <= 1'b0;

        // IF READING THEN CLEAR OVERRUN, ELSE
        // IF STATE IS BODY8 AND STILL READY THEN SET OVERRUN
        if(reading) overrun <= 1'b0;
        else if(state == BODY8 && ready) overrun <= 1'b1;
      end

endmodule
