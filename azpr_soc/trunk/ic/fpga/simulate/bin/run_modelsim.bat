echo Using Modelsim in path
vlib work
vlog -timescale "1 ns / 1 ps" +incdir+../../../digital/rtl/header+../../../digital/rtl -f ../flist/rtl.f
vlog ../tb/azpr_soc_tb.v
vsim -c -do "do runsim.do"


pause
