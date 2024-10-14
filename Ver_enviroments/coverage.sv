package coverage_pkg;
    import FIFO_transaction_pkg::*;

    class coverage;
        // Mailbox and transaction handle
        mailbox cov_mail;
        FIFO_transaction cov_trans;
        virtual intf_fifo cov_intf;

        // Coverage Group 1: Write enable, full, almost full signals
        covergroup wr_full_coverage;
            wr_en_cp: coverpoint cov_trans.wr_en iff (cov_trans.rst_n);
            full_cp: coverpoint cov_trans.full iff (cov_trans.rst_n);
            almost_full_cp: coverpoint cov_trans.almostfull iff (cov_trans.rst_n);
            cross wr_en_cp, full_cp, almost_full_cp {
                ignore_bins full_almost_full = binsof(full_cp) intersect {1} && binsof(almost_full_cp) intersect {1};
            }
        endgroup : wr_full_coverage

        // Coverage Group 2: Read enable, empty, and almost empty signals
        covergroup rd_empty_coverage;
            rd_en_cp: coverpoint cov_trans.rd_en iff (cov_trans.rst_n);
            empty_cp: coverpoint cov_trans.empty iff (cov_trans.rst_n);
            almost_empty_cp: coverpoint cov_trans.almostempty iff (cov_trans.rst_n);
            cross rd_en_cp, empty_cp, almost_empty_cp {
                ignore_bins empty_almost_empty = binsof(empty_cp) intersect {1} && binsof(almost_empty_cp) intersect {1};
            }
        endgroup : rd_empty_coverage

        // Coverage Group 3: Read enable and write enable cross-coverage
        covergroup rd_wr_enable_cross_coverage;
            rd_en_cp: coverpoint cov_trans.rd_en iff (cov_trans.rst_n);
            wr_en_cp: coverpoint cov_trans.wr_en iff (cov_trans.rst_n);
            cross rd_en_cp, wr_en_cp;
        endgroup : rd_wr_enable_cross_coverage

        // Coverage Group 4: Data input bin ranges
        covergroup data_input_range_coverage;
            data_in_cp: coverpoint cov_trans.data_in iff (cov_trans.rst_n) {
                bins low        = {[0:16383]};
                bins lower_mid  = {[16384:32767]};
                bins upper_mid  = {[32768:49151]};
                bins high       = {[49152:65535]};
            }
        endgroup : data_input_range_coverage

        // Coverage Group 5: Reset signal
        covergroup reset_coverage;
            rst_cp: coverpoint cov_trans.rst_n;
        endgroup : reset_coverage

        function new;
            wr_full_coverage  = new();
            rd_empty_coverage  = new();
            rd_wr_enable_cross_coverage  = new();
            data_input_range_coverage  = new();
            reset_coverage = new();
        endfunction

        // Task to continuously sample coverage data
        task run();
            forever begin
                // Wait for the tb_cb signal from the interface
                @(posedge cov_intf.clk) #10;

                if($time >30) begin
                    // Sample all the coverage groups
                    wr_full_coverage.sample();
                    rd_empty_coverage.sample();
                    rd_wr_enable_cross_coverage.sample();
                    data_input_range_coverage.sample();
                    reset_coverage.sample();
                end
            end
        endtask : run

    endclass : coverage;

endpackage : coverage_pkg
