package test_pkg;
    import FIFO_transaction_pkg::*;
    import env_pkg::*;
    import test_passed_pkg::*;

    class test ;
        env e0;
        mailbox test_mbx;
        virtual intf_fifo intf_test_me;

        function new ();
            test_mbx=new();
        endfunction 

    task run(virtual intf_fifo intf_test);
            this.intf_test_me=intf_test;
            e0=new(intf_test);
            e0.drv_env.driver_mailbox=test_mbx;


        fork
           e0.run();
        join_none
        apply_stim();
            
    endtask : run

        // Task to apply stimulus
    task apply_stim();
        FIFO_transaction trans = new();
        

        @(negedge intf_test_me.clk);
        $display("%0t: Starting reset...", $time);
        trans.rst_n = 0;
        test_mbx.put(trans);

        @(negedge intf_test_me.clk);  // Hold reset low for 2 clock cycles
        trans.i=1;
        $display("%0t: Ending reset...", $time);
        trans.rst_n = 1;
        test_mbx.put(trans);
         @(negedge intf_test_me.clk);  // Hold reset low for 2 clock cycles


        $display("T=%0t [Test] Starting stimulus ...", $time);
        for (int i=2;i<200;i++) begin
            @(posedge   intf_test_me.clk) ; #3
            assert(trans.randomize())
            else $display("%0t:Error in randomization test:%0d",$time,i);
            trans.i=i;
            test_mbx.put(trans);

            // #10;
        end

        $display("T=%0t [Test] Ending stimulus ...", $time);
        
        display_test_results();
        $finish;


    endtask

        
    endclass : test
    
endpackage : test_pkg

















