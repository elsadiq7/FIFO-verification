package env_pkg;

	import Fifo_mon_pkg::*;
	import Fifo_drv_pkg::*;
	import FIFO_transaction_pkg::*;
	import scb_pkg::*;
	import coverage_pkg::*;
	
	class env;
		moniter   mon_env;
		driver    drv_env;
		scoreboard scb_env;
		coverage   cov_env; 
		mailbox   mon_scb_coverage;
        virtual intf_fifo intf_env;

       function new (virtual intf_fifo intf_env);
       	this.intf_env=intf_env;
        drv_env=new();
        mon_env=new();
        scb_env=new();
        cov_env=new();
        mon_scb_coverage=new();
       endfunction 


       task run();
           drv_env.drv_intf=intf_env;
           mon_env.mon_intf=intf_env;
           scb_env.scb_intf=intf_env;

           mon_env.moniter_mailbox=mon_scb_coverage;
           scb_env.scb_mail=mon_scb_coverage;
           cov_env.cov_mail=mon_scb_coverage;
           cov_env.cov_intf=intf_env;
           fork
           	 drv_env.run();
           	 mon_env.run();
           	 scb_env.validate_output();
           	 cov_env.run();
           join
       	  
       endtask : run

	

	endclass : env
	
endpackage : env_pkg
