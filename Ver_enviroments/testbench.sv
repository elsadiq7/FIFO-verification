import test_pkg::*;

localparam FIFO_WIDTH = 16;
localparam FIFO_DEPTH = 8;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

module top_tb(
    output logic clk, // Change to logic
    // FIFO memory and pointer definitions for the golden model
    output logic [FIFO_WIDTH-1:0] mem_golden [FIFO_DEPTH-1:0],
    output logic [max_fifo_addr-1:0] wr_ptr_golden,
    output logic [max_fifo_addr-1:0] rd_ptr_golden,
    output logic [max_fifo_addr:0] count_golden,
    output logic [FIFO_WIDTH-1:0] data_out_golden,
    output logic wr_ack_golden,
    output logic overflow_golden,
    output logic full_golden,
    output logic empty_golden,
    output logic almostfull_golden,
    output logic almostempty_golden,
    output logic underflow_golden,
    
    output logic [FIFO_WIDTH-1:0] mem_dut [FIFO_DEPTH-1:0],
    output logic [max_fifo_addr-1:0] wr_ptr_dut,
    output logic [max_fifo_addr-1:0] rd_ptr_dut,
    output logic [max_fifo_addr:0] count_dut
);

    // Clock signal generation
    initial begin
        clk = 0; // Initialize clock
    end

    // Clock generation logic
    always #10 clk = ~clk;

    // Instantiate the interface
    intf_fifo intf_tb(clk);

    // Instantiate the DUT
    FIFO dut(intf_tb);

    // Instantiate the test
    test t1;

    // Initial block for simulation setup
    initial begin
        t1 = new();
        // Start the test in a separate thread
        fork 
        begin
            t1.run(intf_tb); 
        end
        
        // Use a procedural block for dynamic assignments
        begin 
            forever begin
                // Ensure t1.e0 and t1.e0.scb_env are valid before access
                if (t1.e0 != null && t1.e0.scb_env != null) begin
                    // Assigning golden memory and other golden values
                    for (int i = 0; i < FIFO_DEPTH; i++) begin
                        mem_golden[i] = t1.e0.scb_env.mem[i];
                    end

                    wr_ptr_golden    = t1.e0.scb_env.wr_ptr;
                    rd_ptr_golden    = t1.e0.scb_env.rd_ptr;
                    count_golden     = t1.e0.scb_env.count;
                    data_out_golden  = t1.e0.scb_env.data_out_expec;
                    wr_ack_golden    = t1.e0.scb_env.wr_ack_expec;
                    overflow_golden  = t1.e0.scb_env.overflow_expec;
                    full_golden      = t1.e0.scb_env.full_expec;
                    empty_golden     = t1.e0.scb_env.empty_expec;
                    almostfull_golden = t1.e0.scb_env.almostfull_expec;
                    almostempty_golden = t1.e0.scb_env.almostempty_expec;
                    underflow_golden = t1.e0.scb_env.underflow_expec;

                    // DUT signals
                    for (int i = 0; i < FIFO_DEPTH; i++) begin
                        mem_dut[i] = dut.mem[i];
                    end
                    
                    wr_ptr_dut = dut.wr_ptr;
                    rd_ptr_dut = dut.rd_ptr;
                    count_dut  = dut.count;
                end else begin
                    $warning("Warning: t1.e0 or t1.e0.scb_env is null.");
                end

                // Optional delay to reduce simulation load
                #10; 
            end
        end
        join 
    end

    // Initial block for waveform dumping (simulator-specific tasks)
    initial begin
        $dumpvars;              // Dump all variables
        $dumpfile("dump.vcd"); // Dump to VCD file "dump.vcd"
    end
endmodule
