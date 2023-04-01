module spi_top
#(
  parameter SIZE = 8
)
(
  input logic clk,
  input logic rst
);

logic start_i;
logic [25:0] cnt;
logic [7:0] tx_data_i;
logic [7:0] rx_data_o;
logic MISO, CS, SCLK, MOSI;

assign tx_data_i = 'b01010101;

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
	
endmodule