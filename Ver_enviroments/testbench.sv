import  test_pkg::*; // Include your test package assuming it's defined in 'test_pkg.sv'
import test_case_pkg::*;
module top_tb;
    bit clk; // Clock signal

    // Instantiate the interface (assuming intf_fifo and FIFO are defined properly)
    intf_fifo intf_tb(clk); // Interface instance

    // Instantiate the DUT
    FIFO dut (intf_tb); // DUT instance

    // Instantiate the test
    test t1;

    // Clock generation
    always #5 clk = ~clk; // Toggle clock every 5 time units

    // Initial block for simulation setup
    initial begin
        // Initialize the test
        t1 = new(); // Instantiate the test

        // Run the test with the interface instance
        t1.run(intf_tb);
        
     

    end

    // Initial block for waveform dumping (simulator-specific tasks)
    initial begin
        $dumpvars; // Dump all variables
        $dumpfile("dump.vcd"); // Dump to VCD file "dump.vcd"
    end
endmodule
