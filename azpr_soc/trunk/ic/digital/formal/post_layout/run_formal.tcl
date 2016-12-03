#****************************************************************************************************   
#*-----------------Copyright (c) 2016 C-L-G.FPGA1988.Roger Wang. All rights reserved------------------
#
#                   --              It to be define                --
#                   --                    ...                      --
#                   --                    ...                      --
#                   --                    ...                      --
#**************************************************************************************************** 
#File Information
#**************************************************************************************************** 
#File Name      : runn 
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
#03.07.2016 - Roger Wang - Add the File information and the version info.
#02.07.2016 - Roger Wang - The initial version.
#*---------------------------------------------------------------------------------------------------- 

#****************************************************************************************************
#1. The package use
#****************************************************************************************************

sh data
sh hostname

set gt5230 $env(gt5230)
set RTL_DIR "$gt5230/digital/rtl"
set lib_search_path "/data/smic/eeprom/0p13/digital/verisilicon_library/SMIC13LL_7T_STD/DK/Synopsys"
set search_path ". $lib_search_path $gt5230/lib"
set target_library "$search_path/worst5230_1d55v_3v_95C.db"
set DESIGN_NAME gt5230_digital_top

#set hdlin_dwroot "tool/tmp/synopsys/dc"
#set synopsys_auto_setup true
#set_power_gating_style -type CLK_LOW
#set enable_power_gating false

#set verification_clock_gate_hold_mode any
#set verification_clock_gate_hold_mode collapse_all_cg_cells
#set verification_clock_gate_edge_analysis true
#set verification_inversion_push true
#set verification_merge_duplicated_register true

#****************************************************************************************************
#2. Setup 0 : Guidance 
#****************************************************************************************************

#*----------------------------------------------------------------------------------------------------
#2.1 set the svf file
#*----------------------------------------------------------------------------------------------------

#set_svf $gt5230/digital/syn/results/gt5230_digital_top_mapped.svf
remove_container -all
#define_design_lib -r WORK -path ./FM_WORK
#define_design_lib -i WORK -path ./FM_WORK

report_guidance -to ./report/myguidance.txt


#****************************************************************************************************
#3. Setup 1 : Read the referance 
#****************************************************************************************************

read_verilog -r -netlist $gt5230/digital/syn/results/${DESIGN_NAME}.v
read_db -r "$target_library worst5230_1d55v_3v_95C.db best5230_1d55v_3v_95C.db"
#set hdlin_unresolved_modules black_box
#set hdlin-warn-on-mismatch_message
set_top r:/WORK/${DESIGN_NAME}

#****************************************************************************************************
#3. Setup 2 : Read the Implementation 
#****************************************************************************************************
read_db -i "$target_library worst5230_1d55v_3v_95C.db"
read_verilog -i $gt5230/apr/dataout/${DESIGN_NAME}.hvo


#****************************************************************************************************
#4. Setup 1 : Setup
#****************************************************************************************************
set_top i:/WORK/${DESIGN_NAME}

#****************************************************************************************************
#5. Setup 1 : Match
#****************************************************************************************************
match
report_unmatched_points > ./report/report_unmatched_points.rpt
report_block_boxes > ./report/report_black_boxes.rpt
report_svf_operation -status rejected > ./report/report_svf_operation_rejected.rpt
#****************************************************************************************************
#6. Setup 1 : Verify
#****************************************************************************************************
verify

report_status > ./report/report_status.rpt
report_failing_points > ./report/report_failing_points.rpt
report_dont_verify_points > ./report/report_dont_verify_points.rpt

diagnose

report_error_candidates > ./report/report_error_candidates.rpt
#2.3.1 dump


#****************************************************************************************************
#7. Setup 1 : Debug
#****************************************************************************************************
exit































































































