package Fifo_mon_pkg;
	import FIFO_transaction_pkg::*;
	class moniter ;
		mailbox moniter_mailbox;
		virtual intf_fifo mon_intf;

		task run();

			$display("T:%0t [moniter] starting ...", $time);

			forever begin
			   FIFO_transaction mon_tran=new();
			   
			   @(posedge mon_intf.clk);
			   #1;
                  
			   $display("T:%0t [moniter] waiting for item ...", $time);

              

               mon_tran.data_in=mon_intf.data_in;
               mon_tran.rst_n=mon_intf.rst_n;
               mon_tran.wr_en=mon_intf.wr_en;
               mon_tran.rd_en=mon_intf.rd_en;


               mon_tran.data_out=mon_intf.data_out;
               mon_tran.wr_ack=mon_intf.wr_ack;
               mon_tran.overflow=mon_intf.overflow;

               mon_tran.full=mon_intf.full;
               mon_tran.empty=mon_intf.empty;
               mon_tran.almostfull=mon_intf.almostfull;

               mon_tran.almostempty=mon_intf.almostempty;
               mon_tran.underflow=mon_intf.underflow;


               moniter_mailbox.put(mon_tran);
               mon_tran.print("moniter");

			end
		endtask : run
	endclass : moniter
endpackage : Fifo_mon_pkg



