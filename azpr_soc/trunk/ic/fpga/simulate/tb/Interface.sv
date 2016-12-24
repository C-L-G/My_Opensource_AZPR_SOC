//****************************************************************************************************  
//*---------------Copyright (c) 2016 C-L-G.FPGA1988.lichangbeiju. All rights reserved-----------------
//
//                   --              It to be define                --
//                   --                    ...                      --
//                   --                    ...                      --
//                   --                    ...                      --
//**************************************************************************************************** 
//File Information
//**************************************************************************************************** 
//File Name      : Interface.sv 
//Project Name   : azpr_soc_tb
//Description    : the testbench Interface : compare the result between dut and ref.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/fpga/simulate/tb/Interface.sv
//License        : Apache-2.0
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 2016-12-01 09:00
//First Author   : lichangbeiju
//Last Modify    : 2016-12-01 14:20
//Last Author    : lichangbeiju
//Version Number : 12 commits 
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2016.12.02 - lichangbeiju - The first version.
//*---------------------------------------------------------------------------------------------------
//File Include : system header file
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

//File Include : testbench include


`ifndef INC_INTERFACE_SV
`define INC_INTERFACE_SV
//************************************************************************************************
// 1.Interface
//************************************************************************************************
interface soc_if(input wire system_clock);


	logic					a0;
	logic					a1;
	logic					a2;
	logic					sdo;
	logic					sdi;
	logic					scl;
	logic					wp;
	
	
	logic					uart_tx;
	logic					uart_rx;

//    assign scl = system_clock;
    //------------------------------------------------------------------------------------------------
    //1.1 modport
    //------------------------------------------------------------------------------------------------
    modport iic(
        output              a0      ,
        output              a1      ,
        output              a2      ,
        output              sdo     ,
        input               sdi     ,
        output              scl     ,
        output              wp
    );
    
    modport uart(
        output              uart_tx ,
        input               uart_rx  
    );


endinterface




`endif
//****************************************************************************************************
//End of Interface
//****************************************************************************************************
