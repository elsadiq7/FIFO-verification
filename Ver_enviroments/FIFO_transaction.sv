package FIFO_transaction_pkg;

    class FIFO_transaction;

        // Parameters for FIFO width and depth
        parameter FIFO_WIDTH=16 ;
        parameter FIFO_DEPTH=8 ;

        // Random cyclic logic for data input
        rand bit [FIFO_WIDTH-1:0] data_in;

        static int i;

        // Random logic for reset, write enable, and read enable
        rand logic   wr_en, rd_en;
        rand logic rst_n;
        // Logic for data output and various status signals
        logic  [FIFO_WIDTH-1:0] data_out;
        logic  wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        // Integer variables for distribution of read and write enable signals
        int RD_EN_ON_DIST, WR_EN_ON_DIST;

        // Constraints for the random variables
        int complelte_read =100-RD_EN_ON_DIST;
        int complelte_write=100-WR_EN_ON_DIST;
        constraint c1 {
            rst_n  dist {1:/90, 0:/10};
            wr_en dist {1:/WR_EN_ON_DIST, 0:/complelte_write};
            rd_en dist {1:/RD_EN_ON_DIST, 0:/complelte_read};
        }

        // Constructor function to initialize parameters and distribution values
        function new ( int RD_EN_ON_DIST=30, WR_EN_ON_DIST=70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
            this.rst_n=1'b0;
           
        endfunction : new

        // Function to print the transaction details
        function void print (string str = "");
            $display("----------------------------------------------");
            $display("@%0t:test:%0d",$time(),this.i);
            $display("FIFO Transaction: %s", str);
            $display("Data In: %0h, Data Out: %0h", data_in, data_out);
            $display("Reset: %b, Write Enable: %b, Read Enable: %b", rst_n, wr_en, rd_en);
            $display("Write Ack: %b, Overflow: %b, Full: %b, Empty: %b", wr_ack, overflow, full, empty);
            $display("Almost Full: %b, Almost Empty: %b, Underflow: %b", almostfull, almostempty, underflow);
            $display("----------------------------------------------");
        endfunction : print

    endclass : FIFO_transaction

endpackage : FIFO_transaction_pkg
