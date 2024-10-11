import FIFO_transaction_pkg::*;


module FIFO_transaction_testing;
	  bit clk;
	  int i;
     FIFO_transaction  fifo_test;
	initial begin
		fifo_test=new(40,70);  //(parameter FIFO_WIDTH=16, FIFO_DEPTH=8, int RD_EN_ON_DIST=30, WR_EN_ON_DIST=70);

		repeat(1000) begin
			 fifo_test.randomize();
			 fifo_test.print($sformatf("testing: %0d", i));
			 i++;
			 @(negedge clk);
		end

	$stop;
	end
	always #5 clk=!clk;

endmodule : FIFO_transaction_testing