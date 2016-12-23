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
//File Name      : bus_master_mux.v 
//Project Name   : azpr_soc
//Description    : the bus arbiter.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/bus_master_mux.v
//License        : CPL
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 01-07-2016 17:00(1th Fri,July,2016)
//First Author   : lichangbeiju
//Modify Date    : 02-09-2016 14:20(1th Sun,July,2016)
//Last Author    : lichangbeiju
//Version Number : 002   
//Last Commit    : 03-09-2016 14:30(1th Sun,July,2016)
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2016.12.08 - lichangbeiju - Change the include.
//2016.11.21 - lichangbeiju - Add io port.
//**************************************************************************************************** 
`include "../sys_include.h"

`include "bus.h"
module bus_master_mux(
    //master 0
    input   wire    [`WordAddrBus]  m0_addr         ,//30   address
    input   wire                    m0_as_n         ,//01
    input   wire                    m0_rw           ,//01
    input   wire    [`WordDataBus]  m0_wr_data      ,//32   write data   
    input   wire                    m0_grant_n      ,//01
    //master 1
    input   wire    [`WordAddrBus]  m1_addr         ,//30   address
    input   wire                    m1_as_n         ,//01
    input   wire                    m1_rw           ,//01
    input   wire    [`WordDataBus]  m1_wr_data      ,//32   write data   
    input   wire                    m1_grant_n      ,//01
    //master 2
    input   wire    [`WordAddrBus]  m2_addr         ,//30   address
    input   wire                    m2_as_n         ,//01
    input   wire                    m2_rw           ,//01
    input   wire    [`WordDataBus]  m2_wr_data      ,//32   write data   
    input   wire                    m2_grant_n      ,//01
    //master 3
    input   wire    [`WordAddrBus]  m3_addr         ,//30   address
    input   wire                    m3_as_n         ,//01
    input   wire                    m3_rw           ,//01
    input   wire    [`WordDataBus]  m3_wr_data      ,//32   write data   
    input   wire                    m3_grant_n      ,//01
    //share
    output  reg     [`WordAddrBus]  s_addr          ,//30
    output  reg                     s_as_n          ,//01
    output  reg                     s_rw            ,//01
    output  reg     [`WordDataBus]  s_wr_data        //32

);

    //************************************************************************************************
    // 1.Parameter and constant define
    //************************************************************************************************
    
//    `define UDP
//    `define CLK_TEST_EN
    
    //************************************************************************************************
    // 2.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 2.1 the output reg
    //------------------------------------------------------------------------------------------------   

    //------------------------------------------------------------------------------------------------
    // 2.2 the internal reg
    //------------------------------------------------------------------------------------------------  
    
    
    
    //------------------------------------------------------------------------------------------------
    // 2.x the test logic
    //------------------------------------------------------------------------------------------------

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 3.1 the master grant logic
    //------------------------------------------------------------------------------------------------
    
    always @(*) begin : BUS_MASTER_MULTIPLEX
        if(m0_grant_n == `ENABLE_N)
            begin
                s_addr      = m0_addr;
                s_as_n      = m0_as_n;
                s_rw        = m0_rw;
                s_wr_data   = m0_wr_data;
            end
        else if(m1_grant_n == `ENABLE_N)
            begin
                s_addr      = m1_addr;
                s_as_n      = m1_as_n;
                s_rw        = m1_rw;
                s_wr_data   = m1_wr_data;
            end
        else if(m2_grant_n == `ENABLE_N)
            begin
                s_addr      = m2_addr;
                s_as_n      = m2_as_n;
                s_rw        = m2_rw;
                s_wr_data   = m2_wr_data;
            end
        else if(m3_grant_n == `ENABLE_N)
            begin
                s_addr      = m3_addr;
                s_as_n      = m3_as_n;
                s_rw        = m3_rw;
                s_wr_data   = m3_wr_data;
            end
        else    //default
            begin
                s_addr      = `WORD_ADDR_W'h0;
                s_as_n      = `DISABLE_N;
                s_rw        = `READ;
                s_wr_data   = `WORD_DATA_W'h0;
            end
    end
    
     
    //------------------------------------------------------------------------------------------------
    // 3.2 the master owner control logic
    //------------------------------------------------------------------------------------------------
    
    
    //************************************************************************************************
    // 4.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 4.1 the clk generate module
    //------------------------------------------------------------------------------------------------    
    
endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
