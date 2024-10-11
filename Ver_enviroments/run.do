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

run -all

coverage report -cvg -codeAll -details -output coverage_report.txt
