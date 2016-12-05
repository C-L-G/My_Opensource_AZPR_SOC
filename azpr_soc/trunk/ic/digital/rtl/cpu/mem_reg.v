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
//File Name      : mem_reg.v 
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
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------

`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"
`include "cpu.h"

module mem_reg (
    input  wire                clk,          
    input  wire                reset,        
    input  wire [`WordDataBus] out,          
    input  wire                miss_align,   
    input  wire                stall,        
    input  wire                flush,        
    input  wire [`WordAddrBus] ex_pc,        
    input  wire                ex_en,        
    input  wire                ex_br_flag,   
    input  wire [`CtrlOpBus]   ex_ctrl_op,   
    input  wire [`RegAddrBus]  ex_dst_addr,  
    input  wire                ex_gpr_we_n,   
    input  wire [`IsaExpBus]   ex_exp_code,  
    output reg  [`WordAddrBus] mem_pc,       
    output reg                 mem_en,       
    output reg                 mem_br_flag,  
    output reg  [`CtrlOpBus]   mem_ctrl_op,  
    output reg  [`RegAddrBus]  mem_dst_addr, 
    output reg                 mem_gpr_we_n,  
    output reg  [`IsaExpBus]   mem_exp_code, 
    output reg  [`WordDataBus] mem_out       
);

    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin    
            mem_pc       <= #1 `WORD_ADDR_W'h0;
            mem_en       <= #1 `DISABLE;
            mem_br_flag  <= #1 `DISABLE;
            mem_ctrl_op  <= #1 `CTRL_OP_NOP;
            mem_dst_addr <= #1 `REG_ADDR_W'h0;
            mem_gpr_we_n  <= #1 `DISABLE_N;
            mem_exp_code <= #1 `ISA_EXP_NO_EXP;
            mem_out      <= #1 `WORD_DATA_W'h0;
        end else begin
            if (stall == `DISABLE) begin 
                if (flush == `ENABLE) begin               
                    mem_pc       <= #1 `WORD_ADDR_W'h0;
                    mem_en       <= #1 `DISABLE;
                    mem_br_flag  <= #1 `DISABLE;
                    mem_ctrl_op  <= #1 `CTRL_OP_NOP;
                    mem_dst_addr <= #1 `REG_ADDR_W'h0;
                    mem_gpr_we_n  <= #1 `DISABLE_N;
                    mem_exp_code <= #1 `ISA_EXP_NO_EXP;
                    mem_out      <= #1 `WORD_DATA_W'h0;
                end else if (miss_align == `ENABLE) begin 
                    mem_pc       <= #1 ex_pc;
                    mem_en       <= #1 ex_en;
                    mem_br_flag  <= #1 ex_br_flag;
                    mem_ctrl_op  <= #1 `CTRL_OP_NOP;
                    mem_dst_addr <= #1 `REG_ADDR_W'h0;
                    mem_gpr_we_n  <= #1 `DISABLE_N;
                    mem_exp_code <= #1 `ISA_EXP_MISS_ALIGN;
                    mem_out      <= #1 `WORD_DATA_W'h0;
                end else begin                            
                    mem_pc       <= #1 ex_pc;
                    mem_en       <= #1 ex_en;
                    mem_br_flag  <= #1 ex_br_flag;
                    mem_ctrl_op  <= #1 ex_ctrl_op;
                    mem_dst_addr <= #1 ex_dst_addr;
                    mem_gpr_we_n  <= #1 ex_gpr_we_n;
                    mem_exp_code <= #1 ex_exp_code;
                    mem_out      <= #1 out;
                end
            end
        end
    end

endmodule
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
