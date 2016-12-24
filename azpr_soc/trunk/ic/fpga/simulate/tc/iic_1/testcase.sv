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
//File Name      : azpr_soc_tb_top.sv 
//Project Name   : azpr_soc
//Description    : the fpga testbench top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/fpga/simulate/tb/azpr_soc_tb_top.sv
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
//2016.12.01 - lichangbeiju - The first version.
//*---------------------------------------------------------------------------------------------------
//File Include : system header file
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "Environment.sv"

//modport : iic_if
program testcase(soc_if soc_if);
    //************************************************************************************************
    // 1.environment init
    //************************************************************************************************
    Environment env         ;
    integer     len         ;
    integer     datastart   ;
    integer     j           ;
    logic       ack_bit     ;
    integer     start_time  ;
    integer     stop_time   ;

    //************************************************************************************************
    // 2.testcase start
    //************************************************************************************************
    initial begin : iic_1
        $display("iic_1 test start!");
        env = new(soc_if);
        $display("clock generate start!");
        fork
            cr.run(4,25,25,0);
            env.drv.uart_baud_set('d1_000_000);
        join_none
        #1000;
        
        $display("uart frame send start!");

        env.drv.uart_frame_send('d10);
        #20_000_000;
        $finish();
    end

endprogram
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
