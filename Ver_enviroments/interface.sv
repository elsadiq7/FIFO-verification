interface intf_fifo (input bit clk);
	    // Parameters for FIFO width and depth
        parameter FIFO_WIDTH=16 ;
        parameter FIFO_DEPTH=8 ;

        logic [FIFO_WIDTH-1:0] data_in;
        logic  rst_n, wr_en, rd_en;
        logic  [FIFO_WIDTH-1:0] data_out;
        logic  wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

 
      

   // modport dut (input clk, data_in,  rst_n, wr_en, rd_en,output data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow);
   
   // modport tb (output  data_in,  rst_n, wr_en, rd_en,input clk,data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow);

	
endinterface : intf_fifo 