////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
//
////////////////////////////////////////////////////////////////////////////////
module FIFO(intf_fifo intf);
 
 
localparam max_fifo_addr = $clog2(intf.FIFO_DEPTH);


reg [intf.FIFO_WIDTH-1:0] mem [intf.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge intf.clk or negedge intf.rst_n) begin
	if (!intf.rst_n) begin
		wr_ptr <= 0;
		intf.wr_ack <= 0;            //modified 
		intf.overflow<=0;              //modified 
	end
	else if (intf.wr_en && count < intf.FIFO_DEPTH) begin
		mem[wr_ptr] <= intf.data_in;
		intf.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		intf.wr_ack <= 0; 
		if (intf.full & intf.wr_en)
			intf.overflow <= 1;
		else
			intf.overflow <= 0;
	end
end

always @(posedge intf.clk or negedge intf.rst_n) begin
	if (!intf.rst_n) begin
		rd_ptr <= 0;
	end
	else if (intf.rd_en && !intf.empty &&rd_ptr!=wr_ptr) begin  //modfied 
		intf.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge intf.clk or negedge intf.rst_n) begin
	if (!intf.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({intf.wr_en, intf.rd_en} == 2'b10) && !intf.full) 
			count <= count + 1;
		else if ( ({intf.wr_en, intf.rd_en} == 2'b01) && !intf.empty)
			count <= count - 1;
	end
end

assign intf.full = (count == intf.FIFO_DEPTH)? 1 : 0;
assign intf.empty = (count == 0)? 1 : 0;
assign intf.underflow = (intf.empty && intf.rd_en)? 1 : 0; 
assign intf.almostfull = (count == intf.FIFO_DEPTH-2)? 1 : 0; 
assign intf.almostempty = (count == 1)? 1 : 0;



// Property-based assertions for FIFO conditions

property p1_full_not_empty;
    @(negedge  intf.clk) !(intf.full === 1 && intf.empty === 1);
endproperty

assert property(p1_full_not_empty) 
    else $display("@%0t:Error: full && empty = 1",$time);

property p2_no_underflow_overflow;
    @(negedge intf.clk) !(intf.underflow === 1 && intf.overflow === 1);
endproperty

assert property(p2_no_underflow_overflow) 
    else $display("@%0t:Error: underflow && overflow = 1",$time);

property p3_almostfull_not_full;
    @(posedge intf.clk) !(intf.almostfull === 1 && intf.full === 1);
endproperty

assert property(p3_almostfull_not_full) 
    else $display("@%0t:Error: almostfull && full = 1",$time);

property p4_almostempty_not_empty;
    @(posedge intf.clk) !(intf.almostempty === 1 && intf.empty === 1);
endproperty

assert property(p4_almostempty_not_empty) 
    else $display("@%0t:Error: almostempty && empty = 1",$time);




endmodule