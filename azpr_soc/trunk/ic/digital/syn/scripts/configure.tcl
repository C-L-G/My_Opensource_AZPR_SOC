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
#02.07.2016 - Roger Wang - The initial version.
#*---------------------------------------------------------------------------------------------------

##***************************************************************************************************
## 1.Get some system information
##***************************************************************************************************

##***************************************************************************************************
## 2.Set the naming rule
##***************************************************************************************************


##***************************************************************************************************
## 3.Specify the library
##***************************************************************************************************
#3.1 The search path can containt the db and hdl
set search_path "$search_path ../../../lib $RTL_PATH"

#The technology library : delay arcs and pin load/operate condition/transition time : design rule constraint 
#= cell infomation + design rule constraint[db format]
#
#for map + optimization : cell + operating conditions
set target_library "smic18_ss.db"
#link lib is for cell reference,can include design file
#use * to search designs in the memory
set link_library "* $target_library"
#if you will use the design analyzer gui,you may set the symbol library[.sdb format]
#set symbol_library

#DesignWare library
#set synthetic_library



##***************************************************************************************************
## 4.The library setting
##***************************************************************************************************

#4.1 list the library
#list libs only list the library in the memory,now the lib has not been loaded into memory.
#list_libs

#4.1 set the exclude cells and remove the arrtibute.

#set_dont_use lib_name/cell_name
#remove_attribute lib_name/cell_name dont_use

#4.2 set the prefer cells and remove the arrtibute

#set_prefer lib_name/cell_name
#remove_attribute lib_name/cell_name perferred
#
#set_prefer -min class/IV  [-min is to use less large buf to repalce the more little buffer cell] 
#
#
#set_disable_timing find{pin,lib_name/cell_name/pin_name}
##***************************************************************************************************
## 5.The rtl setting
##**************************************************************************************************
set DIGITAL_RTL "gt0000_digital_top.v clk_gen_top.v clk_div_module.v clk_gated_module.v clk_switch_module.v sys_aux_module.v sys_led_module.v"
