package env_pkg;

    import Fifo_mon_pkg::*;
    import Fifo_drv_pkg::*;
    import FIFO_transaction_pkg::*;
    import scb_pkg::*;
    import coverage_pkg::*;

    class env;
        monitor     mon_env;
        driver      drv_env;
        scoreboard  scb_env;
        coverage cov_env;
        // FIFO_transaction my_q[$];  // Shared queue for monitor and scoreboard
        virtual intf_fifo intf_env;

        function new(virtual intf_fifo intf_env);
            this.intf_env = intf_env;
            drv_env = new();
            mon_env = new();
            scb_env = new();
            cov_env=new();
        endfunction

        task run();
            drv_env.drv_intf = intf_env;
            mon_env.mon_intf = intf_env;
            scb_env.scb_intf=intf_env;
            cov_env.cov_intf=intf_env;

            // // Share the queue between monitor and scoreboard
            // scb_env.my_q=mon_env.my_q;
            

            // // Synchronize events for scoreboard and monitor
            // scb_env.scb_event_recv = mon_env.mon_ack;

            scb_env.scb_trans=mon_env.mon_tran;
            cov_env.cov_trans=mon_env.mon_tran;

            fork
                drv_env.run();
                mon_env.run();
                scb_env.validate_output();
                cov_env.run();
             
            join_any
        endtask : run

    endclass : env

endpackage : env_pkg
