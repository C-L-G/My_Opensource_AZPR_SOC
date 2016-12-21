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
#File Name      : constraint.tcl
#Project Name   : scripts
#Description    : The constraint file
#Github Address : https://github.com/C-L-G/scripts/script_header.txt
#License        : CPL
#**************************************************************************************************** 
#Version Information
#**************************************************************************************************** 
#Create Date    : 11-07-2016 17:00(1th Fri,July,2016)
#First Author   : Roger Wang
#Modify Date    : 03-07-2016 14:20(1th Sun,July,2016)
#Last Author    : Roger Wang
#Version Number : 001   
#Last Commit    : 03-07-2016 14:30(1th Sun,July,2016)
#**************************************************************************************************** 
#Revison History    (latest change first)
#yyyy.mm.dd - Author - Your log of change
#**************************************************************************************************** 
#2016.12.21 - Roger Wang - Change the script base on gt5238.
#2016.08.31 - Roger Wang - The initial version.
#*---------------------------------------------------------------------------------------------------
set_units -time ns

##***************************************************************************************************
## 1.Set the basic parameter and design rule
##***************************************************************************************************

##---------------------------------------------------------------------------------------------------
## l.1 set the drc constraint
##---------------------------------------------------------------------------------------------------
set LIB_MAX_TRANSITION      3
set_max_transition  [expr $LIB_MAX_TRANSITION*0.8]  [current_design]
set_max_capacitance         1                       [current_design]
set_max_fanout              20                      [current_design]

##---------------------------------------------------------------------------------------------------
## l.2 set the clock arrtibute parameter
##---------------------------------------------------------------------------------------------------
set clk_setup_uncertainty   1.0
set clk_hold_uncertainty    0.5

#SCL clock and Timer clock Frequncy = 1.25MHz[require  = 1MHz]
set SCL_PERIOD              800
set TIMER_CLK_PERIOD        800
set SDA_CLK_PERIOD          [expr $SCL_PERIOD*2]

##***************************************************************************************************
## 2.The clock contraint
##***************************************************************************************************

##---------------------------------------------------------------------------------------------------
## 2.1 Create the source clock
##---------------------------------------------------------------------------------------------------
create_clock -name iic_clk   -period $SCL_PERIOD       [get_ports scl_in]     -waveform {0 400}
create_clock -name sda_clk   -period $SDA_CLK_PERIOD   [get_ports sda_in_clk] -waveform {260 1060}
create_clock -name timer_clk -period $TIMER_CLK_PERIOD [get_ports timer_clk]  -waveform {0 400}


##---------------------------------------------------------------------------------------------------
## 2.2 create the generated clock
##---------------------------------------------------------------------------------------------------
create_generated_clock -name rd_clk [get_ports rd_clk] -source [get_ports scl_in] -divide_by 1 -invert
#create_generated_clock -name gated_clk -source clk -divide_by 1 -combinational [get_ports clk_gen_inst/clk_gated_inst/gated_clk] 

##---------------------------------------------------------------------------------------------------
## 2.3 set the clock network arrtibute
##---------------------------------------------------------------------------------------------------

#set_clock_group -group {clk div_2_clk div_4_clk gated_clk} -name g1

#set_clock_groups -logically_exclusive -group CLKA -group CLKB
#set timing_enable_multiple_clocks_per_reg true,CLKA,CLKB


set_ideal_network [get_ports scl_in]
set_ideal_network [get_ports sda_in_clk]
set_ideal_network [get_ports timer_clk]
#set_ideal_network [get_clock div_clk]
#
#
set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {iic_clk}] 
set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {iic_clk}] 

set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {rd_clk}] 
set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {rd_clk}] 

set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {sda_clk}] 
set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {sda_clk}] 

set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {timer_clk}] 
set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {timer_clk}] 


#set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {sw_clk}] 
#set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {sw_clk}] 
##---------------------------------------------------------------------------------------------------
## 2.4 other clock constraint
##---------------------------------------------------------------------------------------------------

#set_case_analysis 1 [get_pins clk_rst_gen/sss]
#set_case_analysis 0 [get_pins clk_rst_gen/sss]
#


##***************************************************************************************************
## 3.The Exception Constraint
##***************************************************************************************************
#
##---------------------------------------------------------------------------------------------------
## 3.1 set false path on the cross-clock domains
##---------------------------------------------------------------------------------------------------

#use the clock group to set the false path
#set_clock_group -asynchronous -group clk -group div_2_clk -group div_4_clk
#set_false_path -from clk1 -to clk2


#----iic_clk ----> timer_clk : test_en
set_false_path -from iic_clk -to timer_clk
set_false_path -from timer_clk -to iic_clk

#----timer_clk ----> sda_clk: start_pulse
set_false_path -from sda_clk -to timer_clk
set_false_path -from timer_clk -to sda_clk


set_false_path -from rd_clk -to timer_clk
set_false_path -from timer_clk -to rd_clk

##---------------------------------------------------------------------------------------------------
## 3.2 set false path on the asynchronous reset signal
##---------------------------------------------------------------------------------------------------

#set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports por_rst_n]
set_false_path -from [get_ports clk_rst_inst/frm_rst_n]
set_false_path -from [get_ports clk_rst_inst/sys_rst_n]
set_false_path -from [get_ports clk_rst_inst/wbusy_rst_n]
set_false_path -from [get_ports clk_rst_inst/start_pulse_clr]
set_false_path -from [get_ports clk_rst_inst/start_clr]
set_false_path -from [get_ports clk_rst_inst/stop_clr]

##---------------------------------------------------------------------------------------------------
## 3.3 set false path on the constant signal and impossible/ignore path
##---------------------------------------------------------------------------------------------------

set_false_path -from sda_clk -to [get_ports tcode_sel]
set_false_path -from [get_ports sda_in] -to [get_ports tcode_sel]
set_false_path -from [get_ports ee_32k_en_in]

##---------------------------------------------------------------------------------------------------
## 3.4 set the multicycle path
##---------------------------------------------------------------------------------------------------

set multicycle_setup 2
set multicycle_hold [expr $multicycle_setup-1]

#set_multicycle_path -setup $multicycle_setup -from clk1 -to clk2
#set_multicycle_path -hold $multicycle_hold -from clk1 -to clk2


#set_multicycle_path -setup $multicycle_setup -from clk1 through [get_ports ddsds/dsd/wire] -to clk2
#set_multicycle_path -hold $multicycle_hold -from clk1 through [get_ports ddsds/dsd/wire] -to clk2


##***************************************************************************************************
## 4.The delay constraint
##***************************************************************************************************

##---------------------------------------------------------------------------------------------------
## 4.1 the input delay
##---------------------------------------------------------------------------------------------------

set_input_delay [expr 0.4 * $SCL_PERIOD] -clock iic_clk [get_ports {ee_data_e2l}]
set_input_delay [expr 0.4 * $SCL_PERIOD] -clock timer_clk [get_ports {ee_data_e2l}] -add_delay
set_input_delay [expr 0.2 * $SCL_PERIOD] -clock iic_clk [get_ports sda_in]

set_input_delay [expr 0.7 * $SCL_PERIOD] -clock iic_clk [get_ports {a0_in a1_in a2_in}]
set_input_delay [expr 0.4 * $SCL_PERIOD] -clock iic_clk [get_ports {scl_in_data}]
set_input_delay [expr 0.7 * $SCL_PERIOD] -clock iic_clk [get_ports {swpen_n_in}]


##---------------------------------------------------------------------------------------------------
## 4.2 the output delay
##---------------------------------------------------------------------------------------------------
set_output_delay [expr 0.70 * $SCL_PERIOD / 1] -clock iic_clk [get_ports {clr_dl}]
set_output_delay [expr 0.60 * $SCL_PERIOD / 1] -clock iic_clk [get_ports {vs_en}]
set_output_delay [expr 0.70 * $SCL_PERIOD / 1] -clock iic_clk [get_ports {ee_data_l2e[*]}]
set_output_delay [expr 0.70 * $SCL_PERIOD / 1] -clock iic_clk [get_ports {test_en}]
set_output_delay [expr 0.70 * $SCL_PERIOD / 1] -clock iic_clk [get_ports {d_active cin}]
set_output_delay [expr 0.70 * $SCL_PERIOD / 1] -clock iic_clk [get_ports {alleven allodd tm_wall tm_hv}]
set_output_delay [expr 0.70 * $SCL_PERIOD / 1] -clock iic_clk [get_ports {clr_dl}]
set_output_delay [expr 0.20 * $SCL_PERIOD / 1] -clock iic_clk [get_ports {padout}]

set_output_delay [expr 0.96 * $SCL_PERIOD / 2] -clock rd_clk -clock_fall [get_ports {bit_sel[*]}]
set_output_delay [expr 0.96 * $SCL_PERIOD / 2] -clock rd_clk -clock_fall [get_ports {tcode_sel}]
set_output_delay [expr 0.30 * $SCL_PERIOD / 2] -clock rd_clk -clock_fall [get_ports {tm_icell tm_iref}]


set_output_delay [expr 0.96 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {bit_sel[*]}] -add_delay
set_output_delay [expr 0.96 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {ee_addr[*]}] -add_delay
set_output_delay [expr 0.70 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {erase write pumpen ee_wbusy clr_hv tr}]
set_output_delay [expr 0.70 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {op[*] op_n[*]}]
set_output_delay [expr 0.70 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {a0_out a1_out a2_out}]
set_output_delay [expr 0.70 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {ee_32k_en_out}]
set_output_delay [expr 0.70 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {swpen_n_out}]
set_output_delay [expr 0.70 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {por_cfg_done}]
set_output_delay [expr 0.70 * $TIMER_CLK_PERIOD/ 1] -clock timer_clk -clock_fall [get_ports {timer_en}]

##---------------------------------------------------------------------------------------------------
## 4.3 the max/min delay
##---------------------------------------------------------------------------------------------------




##***************************************************************************************************
## 5.Set the dont touch module and cell
##***************************************************************************************************

#set_dont_touch spare_inst
#set_dont_touch [get_cells dont_touch_spare* -hier]
#set_dont_touch [get_cells -filter "full_name =~ dont_touch_*" -hier]
#set_dont_touch clk_inst/sdsd_buf*sa*clk

set_dont_touch clk_rst_inst/sda_in_clk_dly_inst/*
set_dont_touch clk_rst_inst/rd_clk_dly_inst/*
set_dont_touch spare_inst/*

