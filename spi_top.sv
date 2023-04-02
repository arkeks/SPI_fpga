module spi_top
#(
  parameter SIZE = 8
)
(
  input         clk,
  input         reset_n,   // negative reset
  input [3:0]   key_sw,    // negative tactile switches
  
  output [13:0] gpio,
  output [7:0]  abcdefgh, // displayed letter
  output [3:0]  digit,    // 4 indicators
  output [3:0]  led
);

logic        start_i;
logic [25:0] cnt;
logic [7:0]  tx_data_i;
logic [7:0]  rx_data_o;
logic        MISO, CS, SCLK, MOSI;


// logic for pressings counting
 



master
  test
	(
		clk,
		rst,
		start_i,
		tx_data_i,
		rx_data_o,
		
		MISO,
		CS,
		SCLK,
		MOSI
	);
	
	
	
/* // counter for start_i signal rising
always_ff @ (posedge clk or posedge rst)
  if (rst)
    cnt <= 'b0;
  else
    cnt <= cnt + 'd1;

always_ff @ (posedge clk or posedge rst)
  if (rst)
    start_i <= 'b0;
	 
  else if (cnt == 0)
    start_i <= 'b1;
*/

	

endmodule