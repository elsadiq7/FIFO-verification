package Fifo_mon_pkg;
    import FIFO_transaction_pkg::*;

    class monitor;
        // Change from mailbox to queue
        // FIFO_transaction my_q[$];  // Dynamic queue to store transactions
        virtual intf_fifo mon_intf;
        // event mon_ack;
        FIFO_transaction mon_tran = new();

        task run();
            $display("T:%0t [monitor] starting ...", $time);

            forever begin
                @(posedge mon_intf.clk) #2;

                if($time >22) begin
                $display("T:%0t [monitor] waiting for item ...", $time);

                // Capture interface signals into the transaction
                capture_interface_signals();

                // // Push transaction into the queue
                // my_q.push_back(mon_tran);

                // // Print the transaction just added
                // my_q[$].print("monitor");

                // // Print the first element in the queue
                // if (my_q.size() > 0) begin
                //     $display("First element in the queue:");
                //     my_q[0].print("First transaction in my_q");
                // end

                // ->mon_ack;  
                end       
            end
        endtask : run

        // Task to capture and display interface signals
        task capture_interface_signals();
            mon_tran.data_in      = mon_intf.data_in;
            mon_tran.rst_n        = mon_intf.rst_n;
            mon_tran.wr_en        = mon_intf.wr_en;
            mon_tran.rd_en        = mon_intf.rd_en;
            mon_tran.data_out     = mon_intf.data_out;
            mon_tran.wr_ack       = mon_intf.wr_ack;
            mon_tran.overflow     = mon_intf.overflow;
            mon_tran.full         = mon_intf.full;
            mon_tran.empty        = mon_intf.empty;
            mon_tran.almostfull   = mon_intf.almostfull;
            mon_tran.almostempty  = mon_intf.almostempty;
            mon_tran.underflow    = mon_intf.underflow;
            mon_tran.print("monitor");
            // // Display the captured signals
            // $display("Captured interface signals:");
            // $display("  data_in:      %h", mon_tran.data_in);
            // $display("  rst_n:        %b", mon_tran.rst_n);
            // $display("  wr_en:        %b", mon_tran.wr_en);
            // $display("  rd_en:        %b", mon_tran.rd_en);
            // $display("  data_out:     %h", mon_tran.data_out);
            // $display("  wr_ack:       %b", mon_tran.wr_ack);
            // $display("  overflow:     %b", mon_tran.overflow);
            // $display("  full:         %b", mon_tran.full);
            // $display("  empty:        %b", mon_tran.empty);
            // $display("  almostfull:   %b", mon_tran.almostfull);
            // $display("  almostempty:  %b", mon_tran.almostempty);
            // $display("  underflow:    %b", mon_tran.underflow);
        endtask : capture_interface_signals

    endclass : monitor
endpackage : Fifo_mon_pkg
