
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
//File Name      : bus_slave_mux.v 
//Project Name   : azpr_soc
//Description    : the bus arbiter.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/bus_slave_mux.v
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
module bus_slave_mux(
    //slave 0
    input   wire                    s0_cs_n     ,//01   chip select
    input   wire    [`WordDataBus]  s0_rd_data  ,//32   write data   
    input   wire                    s0_rdy_n    ,//01
    //slave 1
    input   wire                    s1_cs_n     ,//01   chip select
    input   wire    [`WordDataBus]  s1_rd_data  ,//32   write data   
    input   wire                    s1_rdy_n    ,//01
    //slave 2
    input   wire                    s2_cs_n     ,//01   chip select
    input   wire    [`WordDataBus]  s2_rd_data  ,//32   write data   
    input   wire                    s2_rdy_n    ,//01
    //slave 3
    input   wire                    s3_cs_n     ,//01   chip select
    input   wire    [`WordDataBus]  s3_rd_data  ,//32   write data   
    input   wire                    s3_rdy_n    ,//01
    //slave 4
    input   wire                    s4_cs_n     ,//01   chip select
    input   wire    [`WordDataBus]  s4_rd_data  ,//32   write data   
    input   wire                    s4_rdy_n    ,//01
    //slave 5
    input   wire                    s5_cs_n     ,//01   chip select
    input   wire    [`WordDataBus]  s5_rd_data  ,//32   write data   
    input   wire                    s5_rdy_n    ,//01
    //slave 6
    input   wire                    s6_cs_n     ,//01   chip select
    input   wire    [`WordDataBus]  s6_rd_data  ,//32   write data   
    input   wire                    s6_rdy_n    ,//01
    //slave 7
    input   wire                    s7_cs_n     ,//01   chip select
    input   wire    [`WordDataBus]  s7_rd_data  ,//32   write data   
    input   wire                    s7_rdy_n    ,//01
    //share
    output  reg     [`WordDataBus]  m_rd_data   ,//32
    output  reg                     m_rdy_n      //01   Ready

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
    
    always @(*) begin : BUS_SLAVE_MULTIPLEX
        if(s0_cs_n == `ENABLE_N)
            begin
                m_rd_data   = s0_rd_data;
                m_rdy_n     = s0_rdy_n;
            end
        else if(s1_cs_n == `ENABLE_N)
            begin
                m_rd_data   = s1_rd_data;
                m_rdy_n     = s1_rdy_n;
            end
        else if(s2_cs_n == `ENABLE_N)
            begin
                m_rd_data   = s2_rd_data;
                m_rdy_n     = s2_rdy_n;
            end
        else if(s3_cs_n == `ENABLE_N)
            begin
                m_rd_data   = s3_rd_data;
                m_rdy_n     = s3_rdy_n;
            end
        else if(s4_cs_n == `ENABLE_N)
            begin
                m_rd_data   = s4_rd_data;
                m_rdy_n     = s4_rdy_n;
            end
        else if(s5_cs_n == `ENABLE_N)
            begin
                m_rd_data   = s5_rd_data;
                m_rdy_n     = s5_rdy_n;
            end
        else if(s6_cs_n == `ENABLE_N)
            begin
                m_rd_data   = s6_rd_data;
                m_rdy_n     = s6_rdy_n;
            end
        else if(s7_cs_n == `ENABLE_N)
            begin
                m_rd_data   = s7_rd_data;
                m_rdy_n     = s7_rdy_n;
            end
        else
            begin
                m_rd_data   = `WORD_DATA_W'h0;
                m_rdy_n     = `DISABLE_N;
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
