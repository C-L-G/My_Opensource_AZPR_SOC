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
//File Name      : bug_addr_dec.v 
//Project Name   : azpr_soc
//Description    : the bus arbiter.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/bug_addr_dec.v
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
//2016.11.21 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
`include "bus.h"
`include "global_config.h"
`include "stddef.h"
module bug_addr_dec(
    input   wire    [`WordAddrBus]  s_addr      ,//30   address
    output  wire                    s0_cs_n     ,//01   slave 0 chip select
    output  wire                    s1_cs_n     ,//01   slave 1 chip select
    output  wire                    s2_cs_n     ,//01   slave 2 chip select
    output  wire                    s3_cs_n     ,//01   slave 3 chip select
    output  wire                    s4_cs_n     ,//01   slave 4 chip select
    output  wire                    s5_cs_n     ,//01   slave 5 chip select
    output  wire                    s6_cs_n     ,//01   slave 6 chip select
    output  wire                    s7_cs_n      //01   slave 7 chip select

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
    reg                     s0_cs_n     ;//01   rom
    reg                     s1_cs_n     ;//01   spm
    reg                     s2_cs_n     ;//01   timer
    reg                     s3_cs_n     ;//01   uart
    reg                     s4_cs_n     ;//01   gpio
    reg                     s5_cs_n     ;//01   dont use
    reg                     s6_cs_n     ;//01   dont use
    reg                     s7_cs_n     ;//01   dont use

    //------------------------------------------------------------------------------------------------
    // 2.x the test logic
    //------------------------------------------------------------------------------------------------
    wire    [02:00]         s_index     ;//the bus slave index

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    assign s_index = s_addr[`BusSlaveIndexLoc];

    //------------------------------------------------------------------------------------------------
    // 3.1 the master grant logic
    //------------------------------------------------------------------------------------------------
    
    always @(*) begin : BUS_SLAVE_INDEX
        s0_cs_n = `DISABLE_N;
        s1_cs_n = `DISABLE_N;
        s2_cs_n = `DISABLE_N;
        s3_cs_n = `DISABLE_N;
        s4_cs_n = `DISABLE_N;
        s5_cs_n = `DISABLE_N;
        s6_cs_n = `DISABLE_N;
        s7_cs_n = `DISABLE_N;
        case(s_index)
            `BUS_SLAVE_0    :   begin
                s0_cs_n = `ENABLE_N;
            end
            `BUS_SLAVE_1    :   begin
                s1_cs_n = `ENABLE_N;
            end
            `BUS_SLAVE_2    :   begin
                s2_cs_n = `ENABLE_N;
            end
            `BUS_SLAVE_3    :   begin
                s3_cs_n = `ENABLE_N;
            end
            `BUS_SLAVE_4    :   begin
                s4_cs_n = `ENABLE_N;
            end
            `BUS_SLAVE_5    :   begin
                s5_cs_n = `ENABLE_N;
            end
            `BUS_SLAVE_6    :   begin
                s6_cs_n = `ENABLE_N;
            end
            `BUS_SLAVE_7    :   begin
                s7_cs_n = `ENABLE_N;
            end
        endcase
    end
    
     
    //------------------------------------------------------------------------------------------------
    // 3.2 the master owner control logic
    //------------------------------------------------------------------------------------------------
    
    always @(posedge clk or `RESET_EDGE reset) begin : OWNER_CTRL 
        if(reset == `RESET_ENABLE)
            begin
                owner   <= `BUS_OWNER_MASTER_0;
            end
        else begin
            case(owner)
                `BUS_OWNER_MASTER_0 :   begin
                    if(m0_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_0;
                        end
                    else if(m1_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_1;
                        end
                    else if(m2_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_2;
                        end
                    else if(m3_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_3;
                        end
                    else
                        begin
                            owner   <= owner;
                        end
                end
                `BUS_OWNER_MASTER_1 :   begin
                    if(m1_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_1;
                        end
                    else if(m2_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_2;
                        end
                    else if(m3_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_3;
                        end
                    else if(m0_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_0;
                        end
                    else
                        begin
                            owner   <= owner;
                        end
                end
                `BUS_OWNER_MASTER_2 :   begin
                    if(m2_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_2;
                        end
                    else if(m3_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_3;
                        end
                    else if(m0_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_0;
                        end
                    else if(m1_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_1;
                        end
                    else
                        begin
                            owner   <= owner;
                        end
                end
                `BUS_OWNER_MASTER_3 :   begin
                    if(m3_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_3;
                        end
                    else if(m0_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_0;
                        end
                    else if(m1_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_1;
                        end
                    else if(m2_req_n == `ENABLE_N)
                        begin
                            owner   <= `BUS_OWNER_MASTER_2;
                        end
                    else
                        begin
                            owner   <= owner;
                        end
                end
            endcase
        end
    end


    
    //************************************************************************************************
    // 4.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 4.1 the clk generate module
    //------------------------------------------------------------------------------------------------    
    
endmodule    
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
