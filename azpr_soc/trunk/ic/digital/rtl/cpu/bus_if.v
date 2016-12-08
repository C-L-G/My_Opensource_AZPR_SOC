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
//File Name      : chip_top.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/chip.v
//License        : Apache-2.0
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 2016-11-22 17:00
//First Author   : lichangbeiju
//Last Modify    : 2016-11-23 14:20
//Last Author    : lichangbeiju
//Version Number : 12 commits 
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2016.12.08 - lichangbeiju - Change the include.
//2016.11.29 - lichangbeiju - Change the xx_ to xx_n.
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//**************************************************************************************************** 
//File Include : system header file
`include "../sys_include.h"

`include "cpu.h"
`include "bus.h"

module bus_if (
    input  wire                clk,            //clock
    input  wire                reset,          //reset
    input  wire                stall,          //delay signal
    input  wire                flush,          //refresh signal
    output reg                 busy,           //bus busy signal
    input  wire [`WordAddrBus] addr,           //cpu address
    input  wire                as_n,           //cpu : address valid
    input  wire                rw,             //cpu : read/write
    input  wire [`WordDataBus] wr_data,        //cpu write data
    output reg  [`WordDataBus] rd_data,        //cpu : read data
    input  wire [`WordDataBus] spm_rd_data,    //spm : read data 
    output wire [`WordAddrBus] spm_addr,       //spm : address 
    output reg                 spm_as_n,       //spm : address valid
    output wire                spm_rw,         //spm : read/write 
    output wire [`WordDataBus] spm_wr_data,    // 
    input  wire [`WordDataBus] bus_rd_data,    //bus : read data 
    input  wire                bus_rdy_n,      //bus : ready
    input  wire                bus_grant_n,      //bus : grant 
    output reg                 bus_req_n,      //bus : request
    output reg  [`WordAddrBus] bus_addr,       //bus : address
    output reg                 bus_as_n,       //bus : address select
    output reg                 bus_rw,         // 
    output reg  [`WordDataBus] bus_wr_data     // 
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
    
    reg  [`BusIfStateBus]      state;          //bus inteface state
    reg  [`WordDataBus]        rd_buf;         //read buffer
    wire [`BusSlaveIndexBus]   s_index;        //slave index
    //------------------------------------------------------------------------------------------------
    // 2.x the test logic
    //------------------------------------------------------------------------------------------------

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 3.1 the master grant logic
    //------------------------------------------------------------------------------------------------

    /********** generate the bus slave index**********/
    //use the MSB 3 bit to control the index
    assign s_index     = addr[`BusSlaveIndexLoc];

    /********** output assignemnt**********/
    assign spm_addr    = addr;
    assign spm_rw      = rw;
    assign spm_wr_data = wr_data;
                         
    /********** memory access control**********/
    always @(*) begin
        /* default */
        rd_data  = `WORD_DATA_W'h0;
        spm_as_n = `DISABLE_N;
        busy     = `DISABLE;
        /* bus interface state */
        case (state)
            `BUS_IF_STATE_IDLE   : begin //idle
                /* memory access */
                if ((flush == `DISABLE) && (as_n == `ENABLE_N)) begin
                    /* select the access target */
                    if (s_index == `BUS_SLAVE_1) begin // SPM access control
                        if (stall == `DISABLE) begin //dectect the delay[stall]
                            spm_as_n  = `ENABLE_N;
                            if (rw == `READ) begin //read access control
                                rd_data  = spm_rd_data;
                            end
                        end
                    end else begin                     //access the bus
                        busy     = `ENABLE;
                    end
                end
            end
            `BUS_IF_STATE_REQ    : begin //bus request
                busy     = `ENABLE;
            end
            `BUS_IF_STATE_ACCESS : begin //read access
                /* wait the ready */
                if (bus_rdy_n == `ENABLE_N) begin //bus ready
                    if (rw == `READ) begin //read control
                        rd_data  = bus_rd_data;
                    end
                end else begin                  //the bus is not ready
                    busy     = `ENABLE;
                end
            end
            `BUS_IF_STATE_STALL  : begin //delay 
                if (rw == `READ) begin //read control
                    rd_data  = rd_buf;
                end
            end
        endcase
    end

   /********** bus interface state contrl **********/ 
   always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin
            /* asynchronous reset */
            state       <= #1 `BUS_IF_STATE_IDLE;
            bus_req_n   <= #1 `DISABLE_N;
            bus_addr    <= #1 `WORD_ADDR_W'h0;
            bus_as_n    <= #1 `DISABLE_N;
            bus_rw      <= #1 `READ;
            bus_wr_data <= #1 `WORD_DATA_W'h0;
            rd_buf      <= #1 `WORD_DATA_W'h0;
        end else begin
            /* bus interface state */
            case (state)
                `BUS_IF_STATE_IDLE   : begin //Idle 
                    /* memory access */
                    if ((flush == `DISABLE) && (as_n == `ENABLE_N)) begin 
                        /* select the access target*/
                        if (s_index != `BUS_SLAVE_1) begin // access the bus
                            state       <= #1 `BUS_IF_STATE_REQ;
                            bus_req_n   <= #1 `ENABLE_N;
                            bus_addr    <= #1 addr;
                            bus_rw      <= #1 rw;
                            bus_wr_data <= #1 wr_data;
                        end
                    end
                end
                `BUS_IF_STATE_REQ    : begin //bus request
                    /* wait the bus grant */
                    if (bus_grant_n == `ENABLE_N) begin //get the grant
                        state       <= #1 `BUS_IF_STATE_ACCESS;
                        bus_as_n    <= #1 `ENABLE_N;
                    end
                end
                `BUS_IF_STATE_ACCESS : begin //access the bus
                    /* disable the address select */
                    bus_as_n     <= #1 `DISABLE_N;
                    /* wait the bus ready*/
                    if (bus_rdy_n == `ENABLE_N) begin //the bus is ready
                        bus_req_n   <= #1 `DISABLE_N;
                        bus_addr    <= #1 `WORD_ADDR_W'h0;
                        bus_rw      <= #1 `READ;
                        bus_wr_data <= #1 `WORD_DATA_W'h0;
                        /* save the read data into buffer*/
                        if (bus_rw == `READ) begin //read access
                            rd_buf      <= #1 bus_rd_data;
                        end
                        /* detect the stall */
                        if (stall == `ENABLE) begin //have a stall
                            state       <= #1 `BUS_IF_STATE_STALL;
                        end else begin              //have not a stall
                            state       <= #1 `BUS_IF_STATE_IDLE;
                        end
                    end
                end
                `BUS_IF_STATE_STALL  : begin //STALL
                    /* detect the stall */
                    if (stall == `DISABLE) begin //disable the stall
                        state       <= #1 `BUS_IF_STATE_IDLE;
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
