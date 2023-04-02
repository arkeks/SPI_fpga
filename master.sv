module master #(
  parameter CPOL   = 0,
            CPHA   = 0,
				FREQ   = 1000, // SCLK frequency
				F_NUM  = 1,    // number of frames
				F_SIZE = 8,    // frame size
				C_SIZE = $clog2(F_SIZE)
				
)
(
  input  logic                clk,
  input  logic                rst,
  input  logic                start_i,
  input  logic [F_SIZE - 1:0] tx_data_i,
  
  output logic [F_SIZE - 1:0] rx_data_o,
  //output logic                end_o,
  
  input  logic                MISO,
  output logic                CS,
  output logic                SCLK,
  output logic                MOSI,
  
  // debug
  output logic slow_clk_d,
  output logic [2:0] bit_cnt_d,
  output logic [1:0] next_state_d, state_d
);

logic slow_clk;

logic [C_SIZE - 1:0] bit_cnt;


// slow clock for SCLK
custom_clk #( .FREQ(FREQ) )
  sclk
  (
    .clk_i (    clk   ),
	 .rst   (    rst   ),
	 .clk_o ( slow_clk )
  );

//-------------------------------------
  
// master instance
spi_fsm_master #(F_NUM, F_SIZE)
  fsm_inst
  (
  .clk      ( clk     ),
  .slow_clk ( slow_clk),
  .rst      ( rst     ),
  .start_i  ( start_i ),
  
  .CS       ( CS      ),
  .SCLK     ( SCLK    ),
  
  // for debug
  .next_state_d(next_state_d),
  .state_d(state_d)
  );

//-------------------------------------

  
// bit counter: goes from 'd7 to 'd0 (if F_SIZE == 8)
always_ff @ (posedge SCLK or posedge rst)
  if (rst)
    bit_cnt <= 'hF;
  else
    bit_cnt <= bit_cnt - 1'b1;

//-------------------------------------
	 
// transmit bits from MSB to LSB
always_ff @ (negedge SCLK or posedge rst)
    MOSI <= tx_data_i[bit_cnt];


	 
// receive bits from slave
always_ff @ (posedge SCLK or posedge rst)
  if (rst)
    rx_data_o <= 'b0;
  else
    rx_data_o[bit_cnt] <= MISO;

//------------------------------------- 
	 
// for debug
assign slow_clk_d = slow_clk;

assign bit_cnt_d = bit_cnt;	 

endmodule