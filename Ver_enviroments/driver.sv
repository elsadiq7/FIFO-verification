package Fifo_drv_pkg;
	import FIFO_transaction_pkg::*;
	class driver;

		mailbox driver_mailbox;
		virtual intf_fifo drv_intf;

		task run();

			$display("T:%0t [Driver] starting ...", $time);

			forever begin
			   FIFO_transaction drv_tran=new();
			   @(negedge  drv_intf.clk)
			   $display("T:%0t [Driver] waiting for item ...", $time);

               driver_mailbox.get(drv_tran);
               drv_tran.print("Driver");

              
               drv_intf.rst_n=drv_tran.rst_n;
               drv_intf.wr_en=drv_tran.wr_en;
               drv_intf.rd_en=drv_tran.rd_en;
               drv_intf.data_in=drv_tran.data_in;
               

			end
		endtask : run
	endclass : driver
endpackage : Fifo_drv_pkg



