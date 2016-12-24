echo Using Modelsim in path
vlib work
vlog -timescale "1 ns / 1 ps" +incdir+../../../digital/rtl/header+../../../digital/rtl+../tb -f ../flist/rtl_sim.f

vsim -voptargs="+acc" -t 1ps -lib work work.Testbench

run 1ms

#vsim -c -do "do runsim.do"


pause
