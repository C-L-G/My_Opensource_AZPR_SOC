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
#File Name      : configure.tcl
#Project Name   : azpr_soc
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
#Revison History    (latest change first)
#yyyy.mm.dd - Author - Your log of change
#**************************************************************************************************** 
#2016.12.21 - Roger Wang - Change the configure script base on the gt5238.
#2016.07.02 - Roger Wang - The initial version.
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
set design_search_path "../../rtl"
set lib_search_path "../../../lib"

set lib_search_path "$search_path $lib_search_path $design_search_path"

#The technology library : delay arcs and pin load/operate condition/transition time : design rule constraint 
#= cell infomation + design rule constraint[db format]
#
#for map + optimization : cell + operating conditions
set target_library "smic18_ss.db"

#DesignWare library
#set synthetic_library
set synthetic_library [list standard.sldb dw_foundation.sldb]


#link lib is for cell reference,can include design file
#use * to search designs in the memory
set link_library "* $target_library"
#if you will use the design analyzer gui,you may set the symbol library[.sdb format]
#set symbol_library




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

set TOP_NAME gt5238_chip_top
set DIGITAL_NAME gt5238_digital_top

set DIGITAL_RTL "gt5238_digital_top.v clk_rst_module.v ee_ctrl_module.v addr_ctrl_module.v rx_ctrl_module.v tx_ctrl_module.v iic_det_module.v mode_det_module.v spare_module.v por_cfg_module.v
delay_module.v"
