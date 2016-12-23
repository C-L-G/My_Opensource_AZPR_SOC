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
//2016.11.21 - lichangbeiju - Add grant and master owner logic.
//**************************************************************************************************** 
`include "../sys_include.h"

`include "bus.h"
module bus_arbiter(
    input   wire            clk             ,//01   the system clock 
    input   wire            reset           ,//01   
    input   wire            m0_req_n        ,//01   
    output  reg             m0_grant_n      ,//01   
    input   wire            m1_req_n        ,//01   
    output  reg             m1_grant_n      ,//01   
    input   wire            m2_req_n        ,//01   
    output  reg             m2_grant_n      ,//01   
    input   wire            m3_req_n        ,//01   
    output  reg             m3_grant_n       //01   
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
    reg     [01:00]     owner           ;//aux data input and output
    
    
    
    //------------------------------------------------------------------------------------------------
    // 2.x the test logic
    //------------------------------------------------------------------------------------------------

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 3.1 the master grant logic
    //------------------------------------------------------------------------------------------------
    
    always @(*) begin : MASTER_GRANT
        m0_grant_n  = `DISABLE_N;
        m1_grant_n  = `DISABLE_N;
        m2_grant_n  = `DISABLE_N;
        m3_grant_n  = `DISABLE_N;
        case(owner)
            `BUS_OWNER_MASTER_0 :   begin
                m0_grant_n  = `ENABLE_N;
            end
            `BUS_OWNER_MASTER_1 :   begin
                m1_grant_n  = `ENABLE_N;
            end
            `BUS_OWNER_MASTER_2 :   begin
                m2_grant_n  = `ENABLE_N;
            end
            `BUS_OWNER_MASTER_3 :   begin
                m3_grant_n  = `ENABLE_N;
            end
        endcase
    end
    
     
    //------------------------------------------------------------------------------------------------
    // 4.1 the master owner control logic
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
//End of Module
//****************************************************************************************************
