module spi_fsm_master
#(
  parameter F_NUM   = 1,                  // number of frames
            F_SIZE  = 8,                  // frame size (ususally 8 bits)
				C_SIZE  = $clog2(F_SIZE) + 1, // bit_cnt size
				FC_SIZE = $clog2(F_NUM) + 1   // frame_cnt size
)
(
  input  logic clk,
  input  logic slow_clk,
  input  logic rst,
  input  logic start_i,
  
  output logic [FC_SIZE - 1:0] f_cnt, // frame counter
  output logic CS,
  output logic SCLK
  
  /*
  // for debug
  ,
  output logic [1:0] next_state_d, state_d,
  output logic [C_SIZE - 1:0] bit_cnt_fsm
  */
);

logic [C_SIZE - 1:0]  bit_cnt; // transmitted bits counter
//logic [FC_SIZE - 1:0] f_cnt;   // frame counter


// bits counter: increments every SCLK and becomes 0 after 8 transmitted bits
always @ (posedge SCLK or posedge rst or posedge CS)
  if (rst)
    bit_cnt <= 'b0;
	 
  else if (CS)
    bit_cnt <= 'b0;
	 
  else
    bit_cnt <= bit_cnt + 1'b1;

//-------------------------------------
	 
	 
// frames counter: increments every 8 transmitted bits
always @ (posedge SCLK or posedge rst or posedge CS)
  if (rst)
    f_cnt <= 'b0;
	 
  else if (CS) begin
    if (f_cnt == F_NUM)
      f_cnt <= 'b0;
  end
	 
  else if ((bit_cnt + 1'b1) == F_SIZE)
    f_cnt <= f_cnt + 1'b1;

//-------------------------------------

// states enum
typedef enum {
  IDLE,
  TRANSMIT,
  END_OF_FRAME
} state_t;



state_t state, next_state;

always @(posedge clk or posedge rst)
	if (rst)
		state <= IDLE;
	else
		state <= next_state;

		
// next_state logic
always_comb begin
	case(state)
	  IDLE:
		 if (start_i)
			next_state = TRANSMIT;
		 else
			next_state = IDLE;     // @loopback
			
	  TRANSMIT:
		 if (bit_cnt == F_SIZE)
			next_state = END_OF_FRAME;
		 else
			next_state = TRANSMIT; // @loopback
	  
	  END_OF_FRAME:
		 if (f_cnt == F_NUM)
			next_state = IDLE;
		 else
			next_state = TRANSMIT;
	  
	  default:
		 next_state = IDLE;
	
	endcase
end

//-------------------------------------
		
// chip select (CS) logic
always_comb begin
  if (state == TRANSMIT)
    CS = 'b0;
	 
  else begin
    if (SCLK)    // CS goes back to 'b1 only 
	   CS = 'b0;  // when the last SCLK is 'b0
	 else
	   CS = 'b1;
	end
end

//-------------------------------------

// SCLK gated clock logic
logic sclk_en, sclk_en_latch;
assign sclk_en = (state == TRANSMIT);

always_latch begin
  if (~slow_clk)
    sclk_en_latch = sclk_en;
end

assign SCLK = sclk_en_latch ? slow_clk : 'b0;

/*
//for debug
assign next_state_d = next_state;
assign state_d = state;
assign bit_cnt_fsm = bit_cnt;
//assign f_cnt_fsm = f_cnt;
*/

endmodule