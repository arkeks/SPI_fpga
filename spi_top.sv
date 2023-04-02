module spi_top
#(
  parameter F_SIZE = 8,
            F_NUM  = 4,
				FC_SIZE = $clog2(F_NUM) + 1,
				FREQ   = 1000
)
(
  input  logic        clk,
  input  logic        rst_n,   // negative reset
  input  logic [3:0]  key_sw,    // negative tactile switches       
  input  logic        miso_i,
  
  output logic        mosi_o,
  output logic        cs_o,
  output logic        sclk_o,
  output logic [7:0]  abcdefgh, // displayed letter
  output logic [3:0]  digit,    // 4 indicators
  output logic [3:0]  led
);

logic                 start_i, rst;
logic [FC_SIZE - 1:0] f_cnt;
logic [7:0]           tx_buff [0:3];
logic [7:0]           tx_data_i;
logic [7:0]           rx_data_o;
logic                 MISO, CS, SCLK, MOSI;


assign rst = ~rst_n;

// start transmit by pressing
assign start_i = ~key_sw[0];

// led indication
assign led[0] = ~key_sw[0];

// hard coding message "FPGA"
assign tx_buff[0] = 'h66; // F
assign tx_buff[1] = 'h70; // P
assign tx_buff[2] = 'h67; // G
assign tx_buff[3] = 'h61; // A


// changing tx frame every CS rising edge
always @ (posedge clk or posedge rst)
  if (rst)
    tx_data_i = tx_buff[0];
  else if (CS)
    tx_data_i = tx_buff[f_cnt];



master #( .FREQ(FREQ), .F_NUM(F_NUM), .F_SIZE(F_SIZE) )
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
		MOSI,
		f_cnt
	);
	
assign MISO = miso_i;

assign mosi_o = MOSI;

assign cs_o   = CS;

assign sclk_o = SCLK;
	
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