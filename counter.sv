module counter #(
  parameter WIDTH = 2
)
(
  input    logic            clk,
  input    logic            rst,

  output logic [WIDTH - 1:0] cnt
);

always_ff @ (posedge clk or posedge rst)
  if (rst)
    cnt <= 'b0;
  else
    cnt <= cnt + 1'b1;
	 
	 
endmodule