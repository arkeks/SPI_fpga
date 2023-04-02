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
logic [2:0] f_cnt;
logic [3:0] bit_cnt_fsm;

master #(.FREQ(12500000), .F_NUM(3))
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
  start_i = 'b0;
  #5;
  rst = 'b1;
  #4;
  
  rst = 'b0;
  
  #2;
  
  start_i = 1'b1;
  
  #5;
  
  start_i = 1'b0;
  
  #300;
  $finish;
end

initial
  MISO = 'b1;
  
logic [7:0] tx_buff [0:2];

initial begin
  tx_buff[0] = 'hAA;
  tx_buff[1] = 'h55;
  tx_buff[2] = 'h5D;
end


always @ (posedge clk or posedge rst)
  if (rst)
    tx_data_i = tx_buff[0];
  else if (CS)
    tx_data_i = tx_buff[f_cnt];
  
always @ (negedge SCLK)
  MISO = ~MISO;
  

endmodule














