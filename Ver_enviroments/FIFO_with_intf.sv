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
	else if (intf.rd_en && count != 0) begin
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



// Assertion checks for FIFO conditions, now clocked
always @(posedge intf.clk) begin
    // Assertion 1: Check that full and empty are not true at the same time
    p1: assert property (!(intf.full===1 && intf.empty===1)) 
        else $display("Error: full && empty = 1");

    // Assertion 2: Check that underflow and overflow are not true at the same time
    p2: assert property (!(intf.underflow===1 && intf.overflow===1)) 
        else $display("Error: underflow && overflow = 1");

    // Assertion 3: Check that almost full and full are not true at the same time
    p3: assert property (!(intf.almostfull===1 && intf.full===1)) 
        else $display("Error: almostfull && full = 1");

    // Assertion 4: Check that almost empty and empty are not true at the same time
    p4: assert property (!(intf.almostempty===1 && intf.empty===1)) 
        else $display("Error: almostempty && empty = 1");
end




endmodule