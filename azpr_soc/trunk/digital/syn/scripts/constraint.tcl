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
#Description    : The constraint file
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
#dd.mm.yyyy - Author - Your log of change
#**************************************************************************************************** 
#31.08.2016 - Roger Wang - The initial version.
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
set CLK_PERIOD              5  
set CLK_FREQ                [expr 1000/$CLK_PERIOD]
echo "System clock frequency = $CLK_FREQ MHz."
set clk_setup_uncertainty   1.0
set clk_hold_uncertainty    0.5

##***************************************************************************************************
## 2.The clock contraint
##***************************************************************************************************

##---------------------------------------------------------------------------------------------------
## 2.1 Create the source clock
##---------------------------------------------------------------------------------------------------
create_clock -name clk    -period $CLK_PERIOD            [get_ports clk]
#create_clock -name sw_clk -period [expr 2 * $CLK_PERIOD] [get_ports clk_gen_inst/clk_switch_inst/clk_o]


##---------------------------------------------------------------------------------------------------
## 2.2 create the generated clock
##---------------------------------------------------------------------------------------------------

#create_generated_clock -name div_clk -source clk_name -divide_by 3 [get_ports inst1/div_clk] 
create_generated_clock -name div_2_clk -source clk -divide_by 2 [get_ports clk_gen_inst/clk_div_inst/div_clk_0] 
create_generated_clock -name div_4_clk -source clk -divide_by 4 [get_ports clk_gen_inst/clk_div_inst/div_clk_1] 
create_generated_clock -name gated_clk -source clk -divide_by 1 -combinational [get_ports clk_gen_inst/clk_gated_inst/gated_clk] 

##---------------------------------------------------------------------------------------------------
## 2.3 set the clock network arrtibute
##---------------------------------------------------------------------------------------------------

#set_clock_group -group {clk div_2_clk div_4_clk gated_clk} -name g1

#set_clock_groups -logically_exclusive -group CLKA -group CLKB
#set timing_enable_multiple_clocks_per_reg true,CLKA,CLKB


set_ideal_network [get_clocks clk]
#set_ideal_network [get_clock div_clk]

set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {clk}] 
set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {clk}] 

set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {div_2_clk}] 
set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {div_2_clk}] 

set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {div_4_clk}] 
set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {div_4_clk}] 

set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {gated_clk}] 
set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {gated_clk}] 

#set_clock_uncertainty -setup $clk_setup_uncertainty [get_clocks {sw_clk}] 
#set_clock_uncertainty -hold  $clk_hold_uncertainty  [get_clocks {sw_clk}] 
##---------------------------------------------------------------------------------------------------
## 2.4 other clock constraint
##---------------------------------------------------------------------------------------------------

#set_case_analysis 1 [get_pins clk_rst_gen/sss]
#set_case_analysis 0 [get_pins clk_rst_gen/sss]

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


##---------------------------------------------------------------------------------------------------
## 3.2 set false path on the asynchronous reset signal
##---------------------------------------------------------------------------------------------------

#set_false_path -from [get_ports rst_n]

##---------------------------------------------------------------------------------------------------
## 3.3 set false path on the constant signal and impossible/ignore path
##---------------------------------------------------------------------------------------------------

#set_false_path -from [get_cells top/inst1/reg1_reg] -through [get_ports top/inst1/s] -to [get_ports ....reg3[*]] 



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
#set_input_delay [expr 0.8 * $CLK_PERIOD] -clock clk [get_ports ]
#set_input_delay [expr 0.8 * $CLK_PERIOD] -clock clk [get_ports ]
set_input_delay [expr 0.6 * 1 * $CLK_PERIOD] -clock clk [get_ports en]

##---------------------------------------------------------------------------------------------------
## 4.2 the output delay
##---------------------------------------------------------------------------------------------------
set_output_delay [expr 0.6 * 1 * $CLK_PERIOD] -clock clk       [get_ports led[*]]
set_output_delay [expr 0.8 * 2 * $CLK_PERIOD] -clock div_2_clk [get_ports test_o[0]]
set_output_delay [expr 0.8 * 4 * $CLK_PERIOD] -clock div_4_clk [get_ports test_o[1]]
set_output_delay [expr 0.6 * 1 * $CLK_PERIOD] -clock gated_clk [get_ports test_o[2]]
set_output_delay [expr 0.6 * 1 * $CLK_PERIOD] -clock clk       [get_ports test_o[3]]
set_output_delay [expr 0.8 * 4 * $CLK_PERIOD] -clock div_4_clk [get_ports test_o[4]]
set_output_delay [expr 0.6 * 1 * $CLK_PERIOD] -clock clk       [get_ports test_o[5]]
set_output_delay [expr 0.6 * 1 * $CLK_PERIOD] -clock clk       [get_ports test_o[6]]
#set_output_delay [expr 0.8 * 2 * $CLK_PERIOD] -clock sw_clk    [get_ports test_o[7]]
set_output_delay [expr 0.8 * 2 * $CLK_PERIOD] -clock div_4_clk [get_ports test_o[7]]

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


