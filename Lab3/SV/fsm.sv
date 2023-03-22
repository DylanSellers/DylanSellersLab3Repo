module FSM (clk, reset, left, right, hazards, [5:0]Lg);

   input logic  clk;
   input logic  reset;
   input logic 	left;
   input logic  right;
   input logic  [0] hazards;
   
   output logic [5:0]Lg;
   typedef enum 	logic [2:0] {L0, L!, L2, L3} statetype;
   typedef enum 	logic [2:0] {R0, R1, R2, R3} statetype;
   statetype state, nextstate;
   
   // state register
   always_ff @(posedge clk, posedge reset)
     if (reset) state <= L0;
     else       state <= nextstate;
   
   // next state logic

   always_comb
     case (state)
       L0: begin
    
	  if (left) nextstate <= L0;
	  else   nextstate <= ;
       end
  
       L1: begin
    LC = 1'b0;
    LB = 1'b0;
    LA = 1'b1;	
	  if (left) nextstate <= L1;
	  else   nextstate <= L2;
       end

       L2: begin
	  LC = 1'b0;
    LB = 1'b1;
    LA = 1'b1;	  	  
	  if (left) nextstate <= L2;
	  else   nextstate <= L3;
       end
        L3: begin
    LC = 1'b1;
    LB = 1'b1;
    LA = 1'b1;	
	  if (left) nextstate <= L3;
	  else   nextstate <= L0;
        end
       default: begin
	  nextstate <= L0;
       end
     endcase
   
endmodule
