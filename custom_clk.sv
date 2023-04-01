// FREQ  - desired clk frequency
// clk_o - clock with frequency = FREQ

module custom_clk #(
  parameter FREQ  = 1000,
            COEF  = 50000000/FREQ,
            WIDTH = $clog2(COEF) - 1
)
(
  input  logic clk_i,
  input  logic rst,
  
  output logic clk_o 
);

logic [WIDTH - 1:0] cnt;

counter #(.WIDTH(WIDTH))
  cnt_instance
  (
    .clk( clk_i ),
	 .rst(  rst  ),
	 
	 .cnt(  cnt  )
);

always_ff @ (posedge clk_i or posedge rst) 
  if (rst)
    clk_o <= 'b0;
  else if (cnt == 'b0)
    clk_o <= ~clk_o;

//assign clk_o = (cnt == 'b0) ? ~clk_o : clk_o;

endmodule