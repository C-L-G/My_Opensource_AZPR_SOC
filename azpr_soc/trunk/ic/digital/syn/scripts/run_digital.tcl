#!/usr/local/bin/perl
#****************************************************************************************************  
#*----------------Copyright (c) 2016 C-L-G.FPGA1988.Roger Wang. All rights reserved------------------
#
#                   --              It to be define                --
#                   --                    ...                      --
#                   --                    ...                      --
#                   --                    ...                      --
#**************************************************************************************************** 
#File Information
#**************************************************************************************************** 
#File Name      : cklog 
#Project Name   : scripts
#Description    : The simulation script for nc-verilog : environment and parameter.
#Github Address : https://github.com/C-L-G/scripts/script_header.txt
#License        : CPL
#**************************************************************************************************** 
#Version Information
#**************************************************************************************************** 
#Create Date    : 01-07-2016 17:00(1th Fri,July,2016)
#First Author   : Roger Wang
#Modify Date    : 03-07-2016 14:20(1th Sun,July,2016)
#Last Author    : Roger Wang
#Version Number : 001   
#Last Commit    : 03-07-2016 14:30(1th Sun,July,2016)
#**************************************************************************************************** 
#Revison History
#**************************************************************************************************** 
#27.07.2016 - Roger Wang - Add the nolib argument.
#03.07.2016 - Roger Wang - Add the File information and the version info.
#02.07.2016 - Roger Wang - The initial version.
#*---------------------------------------------------------------------------------------------------

##***************************************************************************************************
## 1.Get some system information
##***************************************************************************************************
#1.1 get the date and hostname of the host
sh date
sh hostname
#1.2 set the normal path
set SCRIPTS_DIR "scripts"
set REPORTS_DIR "reports"
#The space is necessary beyween (if and {) and ({ and }) and ({ and [) ...
if { ! [file exists ../$REPORTS_DIR] } {
    file mkdir ../$REPORTS_DIR
}
set RESULTS_DIR "results"
if { ! [file exists ../$RESULTS_DIR] } {
    file mkdir ../$RESULTS_DIR
}
#1.3 set the dc use path
set RTL_PATH "../../rtl ../../rtl/clk_gen_top ../../rtl/sys_aux_module"

##***************************************************************************************************
## 2.Set the naming rule
##***************************************************************************************************


##***************************************************************************************************
## 3.Source the setup up file[library]
##***************************************************************************************************
source -echo -verbose ../$SCRIPTS_DIR/configure.tcl

##***************************************************************************************************
## 4.Read the design
##***************************************************************************************************
set DESIGN_NAME "gt0000_digital_top"
#read file or read containt the analyze+elaborate
#read can support all format,analyze and eleborate can only support the hdl

#analyze -format Verilog -recursive $RTL_PATH -top $TOP_NAME

analyze -format verilog $DIGITAL_RTL

#elaborate "$DESIGN_NAME" 

elaborate $DESIGN_NAME
#4.3 set the top name as the current design
current_design $DESIGN_NAME

write -f verilog -hier -out ../$RESULTS_DIR/$DESIGN_NAME.GTECH.v

#4.4 link and check the design
if { [link] == 0 } {
    echo "Link design error"
    exit
}

if { [check_design] == 0 } {
    echo "Check design error"
    exit
}

write -f verilog -hier -out ../$RESULTS_DIR/$DESIGN_NAME.LINK.v
write -f ddc     -hier -out ../$RESULTS_DIR/$DESIGN_NAME.LINK.ddc
##***************************************************************************************************
## 5.Define Design environment
##***************************************************************************************************
set_operating_conditions worst
set_wire_load_mode enclosed
report_wire_load
#set_load
#set_driving_cell -cell cell_name all_inputs()
#set_drive 0 netname
#wire load mode


##***************************************************************************************************
## 6.Source the constraint file
##***************************************************************************************************

##---------------------------------------------------------------------------------------------------
## 6.1 Do some check after applying the constraint file
##---------------------------------------------------------------------------------------------------
source -echo -verbose ../$SCRIPTS_DIR/constraint.tcl

##---------------------------------------------------------------------------------------------------
## 6.2 Do some check after applying the constraint file
##---------------------------------------------------------------------------------------------------
report_clock -attributes -skew  > ../$REPORTS_DIR/${DESIGN_NAME}_clock.rpt
#verbose is to report all of the info
report_port -verbose            > ../$REPORTS_DIR/${DESIGN_NAME}_port.rpt
check_timing                    > ../$REPORTS_DIR/${DESIGN_NAME}_check_timing.rpt

##***************************************************************************************************
## 7.Select the compile strategy
##***************************************************************************************************

set topdown 1
#Bottom Up


##***************************************************************************************************
## 8.Optimize the design
##***************************************************************************************************
uniquify

set_host_options -max_cores 16
compile_ultra



##***************************************************************************************************
## 9.Analyze and resolve design problems
##***************************************************************************************************

report_area -hierarchy      > ../$REPORTS_DIR/${DESIGN_NAME}_area.rpt
report_hierarchy -full      > ../$REPORTS_DIR/${DESIGN_NAME}_hierarchy.rpt
report_compile_options      > ../$REPORTS_DIR/${DESIGN_NAME}_compile_option.rpt
report_resources -hierarchy > ../$REPORTS_DIR/${DESIGN_NAME}_resources.rpt
report_interclock_relation  > ../$REPORTS_DIR/${DESIGN_NAME}_interclock.rpt
report_constraints -all_violators -verbose > ../$REPORTS_DIR/${DESIGN_NAME}_violators.rpt

##---------------------------------------------------------------------------------------------------
## 9.2 timing report : setup and hold
##---------------------------------------------------------------------------------------------------
report_timing -delay max -max_path 100 -nworst 3 -from [get_clocks clk]       > ../$REPORTS_DIR/${DESIGN_NAME}_timing_setup_clk.rpt
report_timing -delay min -max_path 100 -nworst 3 -from [get_clocks clk]       > ../$REPORTS_DIR/${DESIGN_NAME}_timing_hold_clk.rpt
report_timing -delay max -max_path 100 -nworst 3 -from [get_clocks div_2_clk] > ../$REPORTS_DIR/${DESIGN_NAME}_timing_setup_div2clk.rpt
report_timing -delay min -max_path 100 -nworst 3 -from [get_clocks div_2_clk] > ../$REPORTS_DIR/${DESIGN_NAME}_timing_hold_div2clk.rpt
report_timing -delay max -max_path 100 -nworst 3 -from [get_clocks div_4_clk] > ../$REPORTS_DIR/${DESIGN_NAME}_timing_setup_div4clk.rpt
report_timing -delay min -max_path 100 -nworst 3 -from [get_clocks div_4_clk] > ../$REPORTS_DIR/${DESIGN_NAME}_timing_hold_div4clk.rpt
report_timing -delay max -max_path 100 -nworst 3 -from [get_clocks gated_clk] > ../$REPORTS_DIR/${DESIGN_NAME}_timing_setup_gatedclk.rpt
report_timing -delay min -max_path 100 -nworst 3 -from [get_clocks gated_clk] > ../$REPORTS_DIR/${DESIGN_NAME}_timing_hold_gatedclk.rpt
#report_timing -delay max -max_path 100 -nworst 3 -from [get_clocks sw_clk]    > ../$REPORTS_DIR/${DESIGN_NAME}_timing_setup_swclk.rpt
#report_timing -delay min -max_path 100 -nworst 3 -from [get_clocks sw_clk]    > ../$REPORTS_DIR/${DESIGN_NAME}_timing_hold_swclk.rpt


#report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {clk}] -to [get_clocks {div_2_clk div_4_clk gated_clk sw_clk}] >  ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
#report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {div_2_clk}] -to [get_clocks {clk div_4_clk gated_clk sw_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
#report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {div_4_clk}] -to [get_clocks {clk div_2_clk gated_clk sw_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
#report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {gated_clk}] -to [get_clocks {clk div_2_clk div_4_clk sw_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
#report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {sw_clk}] -to [get_clocks {clk div_2_clk div_4_clk gated_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
#report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {clk}] -to [get_clocks {div_2_clk div_4_clk gated_clk sw_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt
#report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {div_2_clk}] -to [get_clocks {clk div_4_clk gated_clk sw_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt
#report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {div_4_clk}] -to [get_clocks {clk div_2_clk gated_clk sw_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt
#report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {gated_clk}] -to [get_clocks {clk div_2_clk div_4_clk sw_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt
#report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {sw_clk}] -to [get_clocks {clk div_2_clk div_4_clk gated_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt

report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {clk}] -to [get_clocks {div_2_clk div_4_clk gated_clk}] >  ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {div_2_clk}] -to [get_clocks {clk div_4_clk gated_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {div_4_clk}] -to [get_clocks {clk div_2_clk gated_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
report_timing -delay max -max_path 900 -nworst 30 -from [get_clocks {gated_clk}] -to [get_clocks {clk div_2_clk div_4_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_setup.rpt
report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {clk}] -to [get_clocks {div_2_clk div_4_clk gated_clk}] >  ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt
report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {div_2_clk}] -to [get_clocks {clk div_4_clk gated_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt
report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {div_4_clk}] -to [get_clocks {clk div_2_clk gated_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt
report_timing -delay min -max_path 900 -nworst 30 -from [get_clocks {gated_clk}] -to [get_clocks {clk div_2_clk div_4_clk}] >> ../$REPORTS_DIR/${DESIGN_NAME}_ccd_hold.rpt
#check design
#report_area -hier
#report constraint
#report_constraint -all_violations
#report timing


##***************************************************************************************************
## 10.Save the design database
##***************************************************************************************************

#write
write -format verilog -hierarchy -output ../$RESULTS_DIR/${DESIGN_NAME}_mapped.v
write -format ddc     -hierarchy -output ../$RESULTS_DIR/${DESIGN_NAME}_mapped.ddc
write_sdf ../$RESULTS_DIR/${DESIGN_NAME}_mapped.sdf
write_sdc ../$RESULTS_DIR/${DESIGN_NAME}_syn.sdc
#write -format verilog -hie -out gt0000_digital_top_mapped.v






exit
