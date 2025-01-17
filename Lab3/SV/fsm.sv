module FSM (clk, reset, left, right, lg);
//FSM with Thunderbird hazard lights
 // inputs
   input logic  clk;
   input logic  reset;
   input logic 	left;
   input logic  right;
 // output lights
   output logic [5:0]lg;
 // list of states
   typedef enum 	logic [3:0] {S0, L1, L2, L3, R1, R2, R3, W1, W2, W3} statetype;
   statetype state, nextstate;
   
   // state register
   always_ff @(posedge clk, posedge reset)
     if (reset) begin
      state <= S0;
     end
     else       state <= nextstate;
   
   // next state logic
   always_comb
     case (state)
//initial state
      S0: begin
    //set all lights to off
       lg[5:0] <= 6'b000000;
       if(left & right) nextstate <= W1;    //left and right switch on -> start hazard sequence
       else if(left) nextstate <= L1;        //left switch on -> start left sequence
       else if(right) nextstate <= R1;         //right switch on -> start right sequence
        else nextstate <= S0;         //no switches on -> remain in S0
      end
//left sequence
      L1: begin
      //LA on
        lg[5:0] = 6'b001000;
        nextstate = L2;
      end
      L2: begin
      //LA and LB on
        lg[5:0] = 6'b011000;
        nextstate = L3;
      end
      L3: begin
      //LA, LB, and LC on
        lg[5:0] = 6'b111000;
        //back to initial state
        nextstate = S0;
      end
//right sequence
      R1: begin
      //RA on
        lg[5:0] = 6'b000100;
        nextstate = R2;
      end
      R2: begin
      //RA and RB on
        lg[5:0] = 6'b000110;
        nextstate = R3;
      end
      //RA,RB,and RC on
      R3: begin
        lg[5:0] = 6'b000111;
        //back to initial state
        nextstate = S0;
      end
//hazard sequence
      W1: begin
      //LA and RA on
        lg[5:0] = 6'b001100;
        nextstate = W2;
      end
      W2: begin
      //LB, LA, RA, and RB on
        lg[5:0] = 6'b011110;
        nextstate = W3;
      end
      W3: begin
      //all lights on
        lg[5:0] = 6'b111111;
        //back to initial state
        nextstate = S0;
      end            
     endcase
   
endmodule
