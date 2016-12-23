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
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//**************************************************************************************************** 
//File Include : system header file
`include "../sys_include.h"

`include "timer.h"

module timer (
    input  wire                 clk,       
    input  wire                 reset,     
    input  wire                 cs_n,      
    input  wire                 as_n,      
    input  wire                 rw,        
    input  wire [`TimerAddrBus] addr,      
    input  wire [`WordDataBus]  wr_data,   
    output reg  [`WordDataBus]  rd_data,   
    output reg                  rdy_n,     
    output reg                  irq        
);

    reg                         mode;      
    reg                         start;     
    reg [`WordDataBus]          expr_val;  
    reg [`WordDataBus]          counter;   

    wire expr_flag = ((start == `ENABLE) && (counter == expr_val)) ?
                     `ENABLE : `DISABLE;

    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin
            rd_data  <= #1 `WORD_DATA_W'h0;
            rdy_n     <= #1 `DISABLE_N;
            start    <= #1 `DISABLE;
            mode     <= #1 `TIMER_MODE_ONE_SHOT;
            irq      <= #1 `DISABLE;
            expr_val <= #1 `WORD_DATA_W'h0;
            counter  <= #1 `WORD_DATA_W'h0;
        end else begin
            if ((cs_n == `ENABLE_N) && (as_n == `ENABLE_N)) begin
                rdy_n     <= #1 `ENABLE_N;
            end else begin
                rdy_n     <= #1 `DISABLE_N;
            end
            if ((cs_n == `ENABLE_N) && (as_n == `ENABLE_N) && (rw == `READ)) begin
                case (addr)
                    `TIMER_ADDR_CTRL    : begin 
                        rd_data  <= #1 {{`WORD_DATA_W-2{1'b0}}, mode, start};
                    end
                    `TIMER_ADDR_INTR    : begin 
                        rd_data  <= #1 {{`WORD_DATA_W-1{1'b0}}, irq};
                    end
                    `TIMER_ADDR_EXPR    : begin
                        rd_data  <= #1 expr_val;
                    end
                    `TIMER_ADDR_COUNTER : begin
                        rd_data  <= #1 counter;
                    end
                endcase
            end else begin
                rd_data  <= #1 `WORD_DATA_W'h0;
            end
            if ((cs_n == `ENABLE_N) && (as_n == `ENABLE_N) && 
                (rw == `WRITE) && (addr == `TIMER_ADDR_CTRL)) begin
                start    <= #1 wr_data[`TimerStartLoc];
                mode     <= #1 wr_data[`TimerModeLoc];
            end else if ((expr_flag == `ENABLE)  &&
                         (mode == `TIMER_MODE_ONE_SHOT)) begin
                start    <= #1 `DISABLE;
            end
            if (expr_flag == `ENABLE) begin
                irq      <= #1 `ENABLE;
            end else if ((cs_n == `ENABLE_N) && (as_n == `ENABLE_N) && 
                         (rw == `WRITE) && (addr ==  `TIMER_ADDR_INTR)) begin
                irq      <= #1 wr_data[`TimerIrqLoc];
            end
            if ((cs_n == `ENABLE_N) && (as_n == `ENABLE_N) && 
                (rw == `WRITE) && (addr == `TIMER_ADDR_EXPR)) begin
                expr_val <= #1 wr_data;
            end
            if ((cs_n == `ENABLE_N) && (as_n == `ENABLE_N) && 
                (rw == `WRITE) && (addr == `TIMER_ADDR_COUNTER)) begin
                counter  <= #1 wr_data;
            end else if (expr_flag == `ENABLE) begin
                counter  <= #1 `WORD_DATA_W'h0;
            end else if (start == `ENABLE) begin
                counter  <= #1 counter + 1'd1;
            end
        end
    end

endmodule
