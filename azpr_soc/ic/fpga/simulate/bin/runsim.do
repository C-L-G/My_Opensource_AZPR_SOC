vsim -voptargs="+acc" -t 1ps -lib work work.azpr_soc_tb
vcd file ss.vcd
vcd add azpr_soc_tb/uut/*

run -all
vcd2wlf ss.vcd ss.wlf


quit

