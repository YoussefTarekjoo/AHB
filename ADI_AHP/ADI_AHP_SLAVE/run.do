vlib work
vlog AHP_slave_PKG.sv AHP_slave.sv AHP_slave_tb.sv
vsim -voptargs=+acc work.AHP_slave_tb
add wave *
run -all