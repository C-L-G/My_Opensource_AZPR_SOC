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
//File Name      : bus_arbiter.v 
//Project Name   : azpr_soc
//Description    : the bus arbiter.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/bus_arbiter.v
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
//2016.11.22 - lichangbeiju - Add the instance and io port.
//**************************************************************************************************** 
`include "../sys_include.h"

`include "bus.h"
module bus(
    input   wire                    clk             ,//01   the system clock 
    input   wire                    reset           ,//01   
    //master 0
    input   wire                    m0_req_n        ,//01   
    output  wire                    m0_grant_n      ,//01   
    input   wire    [`WordAddrBus]  m0_addr         ,//30   address
    input   wire                    m0_as_n         ,//01
    input   wire                    m0_rw           ,//01
    input   wire    [`WordDataBus]  m0_wr_data      ,//32   write data   
    //master 1
    input   wire                    m1_req_n        ,//01   
    output  wire                    m1_grant_n      ,//01   
    input   wire    [`WordAddrBus]  m1_addr         ,//30   address
    input   wire                    m1_as_n         ,//01
    input   wire                    m1_rw           ,//01
    input   wire    [`WordDataBus]  m1_wr_data      ,//32   write data   
    //master 2
    input   wire                    m2_req_n        ,//01   
    output  wire                    m2_grant_n      ,//01   
    input   wire    [`WordAddrBus]  m2_addr         ,//30   address
    input   wire                    m2_as_n         ,//01
    input   wire                    m2_rw           ,//01
    input   wire    [`WordDataBus]  m2_wr_data      ,//32   write data   
    //master 3
    input   wire                    m3_req_n        ,//01   
    output  wire                    m3_grant_n      ,//01   
    input   wire    [`WordAddrBus]  m3_addr         ,//30   address
    input   wire                    m3_as_n         ,//01
    input   wire                    m3_rw           ,//01
    input   wire    [`WordDataBus]  m3_wr_data      ,//32   write data   
    //share
    output  wire    [`WordAddrBus]  s_addr          ,//30   address
    output  wire                    s_as_n          ,//01
    output  wire                    s_rw            ,//01
    output  wire    [`WordDataBus]  s_wr_data       ,//3
    //slave 0
    output  wire                    s0_cs_n         ,//01   chip select
    input   wire    [`WordDataBus]  s0_rd_data      ,//32   write data   
    input   wire                    s0_rdy_n        ,//01
    //slave 1
    output  wire                    s1_cs_n         ,//01   chip select
    input   wire    [`WordDataBus]  s1_rd_data      ,//32   write data   
    input   wire                    s1_rdy_n        ,//01
    //slave 2
    output  wire                    s2_cs_n         ,//01   chip select
    input   wire    [`WordDataBus]  s2_rd_data      ,//32   write data   
    input   wire                    s2_rdy_n        ,//01
    //slave 3
    output  wire                    s3_cs_n         ,//01   chip select
    input   wire    [`WordDataBus]  s3_rd_data      ,//32   write data   
    input   wire                    s3_rdy_n        ,//01
    //slave 4
    output  wire                    s4_cs_n         ,//01   chip select
    input   wire    [`WordDataBus]  s4_rd_data      ,//32   write data   
    input   wire                    s4_rdy_n        ,//01
    //slave 5
    output  wire                    s5_cs_n         ,//01   chip select
    input   wire    [`WordDataBus]  s5_rd_data      ,//32   write data   
    input   wire                    s5_rdy_n        ,//01
    //slave 6
    output  wire                    s6_cs_n         ,//01   chip select
    input   wire    [`WordDataBus]  s6_rd_data      ,//32   write data   
    input   wire                    s6_rdy_n        ,//01
    //slave 7
    output  wire                    s7_cs_n         ,//01   chip select
    input   wire    [`WordDataBus]  s7_rd_data      ,//32   write data   
    input   wire                    s7_rdy_n        ,//01
    //share
    output  wire    [`WordDataBus]  m_rd_data       ,//32
    output  wire                    m_rdy_n          //01   Read
);

    //************************************************************************************************
    // 1.Parameter and constant define
    //************************************************************************************************
    
    
    //************************************************************************************************
    // 2.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 2.1 the output reg
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
    
    
     
    //------------------------------------------------------------------------------------------------
    // 3.1 the master owner control logic
    //------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------
    // 3.x the Test Logic
    //------------------------------------------------------------------------------------------------    

    
    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 5.1 the clk generate module
    //------------------------------------------------------------------------------------------------    
    bus_arbiter bus_arbiter(
        .clk                (clk                ),//01  In 
        .reset              (reset              ),//01  In 
        .m0_req_n           (m0_req_n           ),//01  In 
        .m0_grant_n         (m0_grant_n         ),//01  Out 
        .m1_req_n           (m1_req_n           ),//01  In 
        .m1_grant_n         (m1_grant_n         ),//01  Out 
        .m2_req_n           (m2_req_n           ),//01  In 
        .m2_grant_n         (m2_grant_n         ),//01  Out 
        .m3_req_n           (m3_req_n           ),//01  In 
        .m3_grant_n         (m3_grant_n         ) //01  Out 
    );
    
    //------------------------------------------------------------------------------------------------
    // 5.2 the system auxiliary module
    //------------------------------------------------------------------------------------------------   
    bus_master_mux bus_master_mux(
        .m0_addr            (m0_addr            ),//30   address
        .m0_as_n            (m0_as_n            ),//01
        .m0_rw              (m0_rw              ),//01
        .m0_wr_data         (m0_wr_data         ),//32   write data   
        .m0_grant_n         (m0_grant_n         ),//01
        .m1_addr            (m1_addr            ),//30   address
        .m1_as_n            (m1_as_n            ),//01
        .m1_rw              (m1_rw              ),//01
        .m1_wr_data         (m1_wr_data         ),//32   write data   
        .m1_grant_n         (m1_grant_n         ),//01
        .m2_addr            (m2_addr            ),//30   address
        .m2_as_n            (m2_as_n            ),//01
        .m2_rw              (m2_rw              ),//01
        .m2_wr_data         (m2_wr_data         ),//32   write data   
        .m2_grant_n         (m2_grant_n         ),//01
        .m3_addr            (m3_addr            ),//30   address
        .m3_as_n            (m3_as_n            ),//01
        .m3_rw              (m3_rw              ),//01
        .m3_wr_data         (m3_wr_data         ),//32   write data   
        .m3_grant_n         (m3_grant_n         ),//01
        .s_addr             (s_addr             ),//30
        .s_as_n             (s_as_n             ),//01
        .s_rw               (s_rw               ),//01
        .s_wr_data          (s_wr_data          ) //3
    );
    //------------------------------------------------------------------------------------------------
    // 4.3 the address dec
    //------------------------------------------------------------------------------------------------
    bus_addr_dec bus_addr_dec(
        .s_addr             (s_addr             ),//30   address
        .s0_cs_n            (s0_cs_n            ),//01   slave 0 chip select
        .s1_cs_n            (s1_cs_n            ),//01   slave 1 chip select
        .s2_cs_n            (s2_cs_n            ),//01   slave 2 chip select
        .s3_cs_n            (s3_cs_n            ),//01   slave 3 chip select
        .s4_cs_n            (s4_cs_n            ),//01   slave 4 chip select
        .s5_cs_n            (s5_cs_n            ),//01   slave 5 chip select
        .s6_cs_n            (s6_cs_n            ),//01   slave 6 chip select
        .s7_cs_n            (s7_cs_n            ) //01   slave 7 chip selec
    );  
    
    //------------------------------------------------------------------------------------------------
    // 4.4 the udp/ip stack module
    //------------------------------------------------------------------------------------------------
    bus_slave_mux bus_slave_mux(
        .s0_cs_n            (s0_cs_n            ),//01   chip select
        .s0_rd_data         (s0_rd_data         ),//32   write data   
        .s0_rdy_n           (s0_rdy_n           ),//01
        .s1_cs_n            (s1_cs_n            ),//01   chip select
        .s1_rd_data         (s1_rd_data         ),//32   write data   
        .s1_rdy_n           (s1_rdy_n           ),//01
        .s2_cs_n            (s2_cs_n            ),//01   chip select
        .s2_rd_data         (s2_rd_data         ),//32   write data   
        .s2_rdy_n           (s2_rdy_n           ),//01
        .s3_cs_n            (s3_cs_n            ),//01   chip select
        .s3_rd_data         (s3_rd_data         ),//32   write data   
        .s3_rdy_n           (s3_rdy_n           ),//01
        .s4_cs_n            (s4_cs_n            ),//01   chip select
        .s4_rd_data         (s4_rd_data         ),//32   write data   
        .s4_rdy_n           (s4_rdy_n           ),//01
        .s5_cs_n            (s5_cs_n            ),//01   chip select
        .s5_rd_data         (s5_rd_data         ),//32   write data   
        .s5_rdy_n           (s5_rdy_n           ),//01
        .s6_cs_n            (s6_cs_n            ),//01   chip select
        .s6_rd_data         (s6_rd_data         ),//32   write data   
        .s6_rdy_n           (s6_rdy_n           ),//01
        .s7_cs_n            (s7_cs_n            ),//01   chip select
        .s7_rd_data         (s7_rd_data         ),//32   write data   
        .s7_rdy_n           (s7_rdy_n           ),//01
        .m_rd_data          (m_rd_data          ),//32
        .m_rdy_n            (m_rdy_n            ) //01   Read
    );  


  

    
endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
