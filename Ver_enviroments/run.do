vlib work
vlog -sv +cover *.sv
vopt -stats=all,qis,verbose -fsmverbose btw -debug +designfile top_tb -o opt
vsim -c -debugdb -coverage top_tb -l sim.log
add wave -position insertpoint  \
    sim:/top_tb/intf_tb/FIFO_WIDTH \
    sim:/top_tb/intf_tb/FIFO_DEPTH \
    sim:/top_tb/intf_tb/clk \
    sim:/top_tb/intf_tb/data_in \
    sim:/top_tb/intf_tb/rst_n \
    sim:/top_tb/intf_tb/wr_en \
    sim:/top_tb/intf_tb/rd_en \
    sim:/top_tb/intf_tb/data_out \
    sim:/top_tb/intf_tb/wr_ack \
    sim:/top_tb/intf_tb/overflow \
    sim:/top_tb/intf_tb/full \
    sim:/top_tb/intf_tb/empty \
    sim:/top_tb/intf_tb/almostfull \
    sim:/top_tb/intf_tb/almostempty \
    sim:/top_tb/intf_tb/underflow


add wave -position insertpoint  \
sim:/top_tb/clk \
sim:/top_tb/mem_golden \
sim:/top_tb/wr_ptr_golden \
sim:/top_tb/rd_ptr_golden \
sim:/top_tb/count_golden \
sim:/top_tb/data_out_golden \
sim:/top_tb/wr_ack_golden \
sim:/top_tb/overflow_golden \
sim:/top_tb/full_golden \
sim:/top_tb/empty_golden \
sim:/top_tb/almostfull_golden \
sim:/top_tb/almostempty_golden \
sim:/top_tb/underflow_golden \
sim:/top_tb/mem_dut \
sim:/top_tb/wr_ptr_dut \
sim:/top_tb/rd_ptr_dut \
sim:/top_tb/count_dut
add wave -position insertpoint  \
sim:/top_tb/clk \
sim:/top_tb/mem_golden \
sim:/top_tb/wr_ptr_golden \
sim:/top_tb/rd_ptr_golden \
sim:/top_tb/count_golden \
sim:/top_tb/data_out_golden \
sim:/top_tb/wr_ack_golden \
sim:/top_tb/overflow_golden \
sim:/top_tb/full_golden \
sim:/top_tb/empty_golden \
sim:/top_tb/almostfull_golden \
sim:/top_tb/almostempty_golden \
sim:/top_tb/underflow_golden \
sim:/top_tb/mem_dut \
sim:/top_tb/wr_ptr_dut \
sim:/top_tb/rd_ptr_dut \
sim:/top_tb/count_dut
run -all

coverage report -cvg -codeAll -details -output coverage_report.txt