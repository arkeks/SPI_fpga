module tb;

logic clk;
logic rst;
logic start_i;
logic [7:0] tx_data_i;
logic [7:0] rx_data_o;

logic MISO;
logic CS;
logic SCLK;
logic MOSI;
logic slow_clk_d;
logic [2:0] bit_cnt_d;
logic [1:0] next_state_d, state_d;

master #(.FREQ(12500000))
  dut
	(
		.*
	);
	
always begin
  clk = ~clk;
  #1;
end

initial begin
  clk = 'b0;
  rst = 'b0;
  tx_data_i = 8'h3A;
  start_i = 'b0;
  #1;
  rst = 'b1;
  #4;
  
  rst = 'b0;
  
  #2;
  
  start_i = 1'b1;
  
  #5;
  
  start_i = 1'b0;
  
  #200;
  $finish;
end

initial
  MISO = 'b1;
  
always @ (negedge SCLK)
  MISO = ~MISO;
  

endmodule














