package coverage_pkg;
    import FIFO_transaction_pkg::*;
    
    class coverage;
        // Mailbox and transaction handle
        mailbox cov_mail;
        FIFO_transaction cov_trans;
        virtual intf_fifo cov_intf;

        // Coverage Group 1: Write enable, full, almost full signals
        covergroup cov_1;
            cov_1_p1: coverpoint cov_trans.wr_en iff (!cov_trans.rst_n);
            cov_1_p2: coverpoint cov_trans.full iff (!cov_trans.rst_n);
            cov_1_p3: coverpoint cov_trans.almostfull iff (!cov_trans.rst_n);
            cross cov_1_p1, cov_1_p2, cov_1_p3 {
                ignore_bins full_almost_full = binsof(cov_1_p2) intersect {1} && binsof(cov_1_p3) intersect {1};
            }
        endgroup : cov_1

        // Coverage Group 2: Read enable, empty, and almost empty signals
        covergroup cov_2;
            cov_2_p1: coverpoint cov_trans.rd_en iff (!cov_trans.rst_n);
            cov_2_p2: coverpoint cov_trans.empty iff (!cov_trans.rst_n);
            cov_2_p3: coverpoint cov_trans.almostempty iff (!cov_trans.rst_n);
            cross cov_2_p1, cov_2_p2, cov_2_p3 {
                ignore_bins full_almost_empty = binsof(cov_2_p2) intersect {1} && binsof(cov_2_p3) intersect {1};
            }
        endgroup : cov_2

        // Coverage Group 3: Read enable and write enable cross-coverage
        covergroup cov_3;
            cov_3_p1: coverpoint cov_trans.rd_en iff (!cov_trans.rst_n);
            cov_3_p2: coverpoint cov_trans.wr_en iff (!cov_trans.rst_n);
            cross cov_3_p1, cov_3_p2;
        endgroup : cov_3

        // Coverage Group 4: Read enable signal with bin ranges
        covergroup cov_4;
            cov_4_p1: coverpoint cov_trans.data_in iff (!cov_trans.rst_n) {
                bins low        = {[0:16383]};
                bins lower_mid  = {[16384:32767]};
                bins upper_mid  = {[32768:49151]};
                bins high       = {[49151:65535]};
            }
        endgroup : cov_4


        function new ;
            cov_1  = new();
            cov_2  = new();
            cov_3  = new();
            cov_4  = new();
        endfunction 

        // Task to continuously sample coverage data
        task run();
            forever begin
                // Wait for the tb_cb signal from the interface
          
                // Get the transaction from the mailbox
                cov_mail.get(cov_trans);
                
                // Sample all the coverage groups
                cov_1.sample();
                cov_2.sample();
                cov_3.sample();
                cov_4.sample();
            end
        endtask : run

    endclass : coverage;

endpackage : coverage_pkg
