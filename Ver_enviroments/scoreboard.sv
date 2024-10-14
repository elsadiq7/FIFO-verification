package scb_pkg;
    import FIFO_transaction_pkg::*;
    import test_passed_pkg::*;

    class scoreboard;
        // Change from mailbox to queue
        FIFO_transaction my_q[$];  // Dynamic queue for storing transactions
        FIFO_transaction scb_trans;
        virtual intf_fifo scb_intf;
        // event scb_event_recv;

        // FIFO parameters
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        
        // Signals for expected values
        logic [FIFO_WIDTH-1:0] data_out_expec;
        logic wr_ack_expec, overflow_expec;
        logic full_expec, empty_expec, almostfull_expec, almostempty_expec, underflow_expec;

        // FIFO memory and pointer definitions
        localparam max_fifo_addr = $clog2(FIFO_DEPTH);
        logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
        logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
        logic [max_fifo_addr:0] count;

        // Golden model task
        task golden_model();
                // Reset handling: if reset is active, pointers and count are zeroed
                if (!scb_trans.rst_n) begin
                    wr_ptr = 0;
                    rd_ptr = 0;
                    count = 0;
                    wr_ack_expec = 0;
                    overflow_expec = 0;
                end else begin
                          // Read logic: Fetch data from memory if read is enabled
                    if (scb_trans.rd_en && count!=0 &&rd_ptr!=wr_ptr) begin
                        data_out_expec = mem[rd_ptr];
                        rd_ptr = rd_ptr + 1;
                    end

                    // Write logic: Update memory and write pointer if write is enabled
                    if (scb_trans.wr_en && count < FIFO_DEPTH) begin
                        mem[wr_ptr] = scb_trans.data_in;
                        wr_ack_expec = 1;
                        wr_ptr = wr_ptr + 1;
                    end else begin
                        wr_ack_expec = 0;
                        // Overflow check

                        if (full_expec & scb_trans.wr_en)
                              overflow_expec = 1;
                        else
                              overflow_expec = 0;
                        end

              

                    // Counter logic: Update the FIFO count based on write and read actions
                    if (scb_trans.wr_en && !scb_trans.rd_en && !full_expec) begin
                        count = count + 1;
                    end else if (!scb_trans.wr_en && scb_trans.rd_en && !empty_expec) begin
                        count = count - 1;
                    end
                end

                // Update expected control signals
                full_expec        = (count == FIFO_DEPTH) ? 1 : 0;
                empty_expec       = (count == 0) ? 1 : 0;
                underflow_expec   = (empty_expec && scb_trans.rd_en) ? 1 : 0;
                almostfull_expec  = (count == FIFO_DEPTH - 2) ? 1 : 0;
                almostempty_expec = (count == 1) ? 1 : 0;
            
        endtask : golden_model

        // Validate output: compares the expected and actual outputs
        task validate_output();
            forever begin
               @(posedge scb_intf.clk)#5
                // #20
                if($time >25) begin
                    
                golden_model();  // Call the golden model to update expected values

                // Correct comparison for data_out_expec
                if (data_out_expec === scb_trans.data_out && 
                    wr_ack_expec === scb_trans.wr_ack &&
                    overflow_expec === scb_trans.overflow && 
                    full_expec === scb_trans.full &&
                    almostfull_expec === scb_trans.almostfull &&
                    underflow_expec === scb_trans.underflow && 
                    empty_expec === scb_trans.empty &&
                    almostempty_expec === scb_trans.almostempty) begin
                    $display("@%0t: test %0d: passed", $time, scb_trans.i);
                    increment_passed();  // Track successful tests
                    display_mismatch_values(); // Display only when there's a mismatch
                end else begin
                    increment_failed();  // Track failed tests
                    $display("@%0t: test:%0d failed.", $time, scb_trans.i);
                    display_mismatch_values();
                end
              end

            end
        endtask : validate_output

        // Task to display mismatched expected vs actual values
        task display_mismatch_values();
            $display("Reset: %b, Write Enable: %b, Read Enable: %b", scb_trans.rst_n, scb_trans.wr_en, scb_trans.rd_en);
            $display("Data In: %0h", scb_trans.data_in);
            $display("Output: Expected vs Actual:");
            $display("data_out: %h vs %h", data_out_expec, scb_trans.data_out);
            $display("wr_ack: %b vs %b", wr_ack_expec, scb_trans.wr_ack);
            $display("overflow: %b vs %b", overflow_expec, scb_trans.overflow);
            $display("full: %b vs %b", full_expec, scb_trans.full);
            $display("almostfull: %b vs %b", almostfull_expec, scb_trans.almostfull);
            $display("underflow: %b vs %b", underflow_expec, scb_trans.underflow);
            $display("empty: %b vs %b", empty_expec, scb_trans.empty);
            $display("almostempty: %b vs %b", almostempty_expec, scb_trans.almostempty);
        endtask : display_mismatch_values

    endclass : scoreboard

endpackage : scb_pkg
