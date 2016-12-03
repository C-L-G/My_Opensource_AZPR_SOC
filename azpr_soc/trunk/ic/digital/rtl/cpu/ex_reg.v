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
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------

`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"
`include "cpu.h"

module ex_reg (
    input  wire                clk,            //
    input  wire                reset,          //
    input  wire [`WordDataBus] alu_out,        //
    input  wire                alu_of,         //
    input  wire                stall,          //
    input  wire                flush,          //
    input  wire                int_detect,     //
    input  wire [`WordAddrBus] id_pc,          //
    input  wire                id_en,          //
    input  wire                id_br_flag,     //
    input  wire [`MemOpBus]    id_mem_op,      //
    input  wire [`WordDataBus] id_mem_wr_data, //
    input  wire [`CtrlOpBus]   id_ctrl_op,     //
    input  wire [`RegAddrBus]  id_dst_addr,    //
    input  wire                id_gpr_we_n,     //
    input  wire [`IsaExpBus]   id_exp_code,    //
    output reg  [`WordAddrBus] ex_pc,          //
    output reg                 ex_en,          //
    output reg                 ex_br_flag,     //
    output reg  [`MemOpBus]    ex_mem_op,      //
    output reg  [`WordDataBus] ex_mem_wr_data, //
    output reg  [`CtrlOpBus]   ex_ctrl_op,     //
    output reg  [`RegAddrBus]  ex_dst_addr,    //
    output reg                 ex_gpr_we_n,     //
    output reg  [`IsaExpBus]   ex_exp_code,    //
    output reg  [`WordDataBus] ex_out          //
);

    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin 
            ex_pc          <= #1 `WORD_ADDR_W'h0;
            ex_en          <= #1 `DISABLE;
            ex_br_flag     <= #1 `DISABLE;
            ex_mem_op      <= #1 `MEM_OP_NOP;
            ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
            ex_ctrl_op     <= #1 `CTRL_OP_NOP;
            ex_dst_addr    <= #1 `REG_ADDR_W'd0;
            ex_gpr_we_n     <= #1 `DISABLE_;
            ex_exp_code    <= #1 `ISA_EXP_NO_EXP;
            ex_out         <= #1 `WORD_DATA_W'h0;
        end else begin
            if (stall == `DISABLE) begin 
                if (flush == `ENABLE) begin               
                    ex_pc          <= #1 `WORD_ADDR_W'h0;
                    ex_en          <= #1 `DISABLE;
                    ex_br_flag     <= #1 `DISABLE;
                    ex_mem_op      <= #1 `MEM_OP_NOP;
                    ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
                    ex_ctrl_op     <= #1 `CTRL_OP_NOP;
                    ex_dst_addr    <= #1 `REG_ADDR_W'd0;
                    ex_gpr_we_n     <= #1 `DISABLE_;
                    ex_exp_code    <= #1 `ISA_EXP_NO_EXP;
                    ex_out         <= #1 `WORD_DATA_W'h0;
                end else if (int_detect == `ENABLE) begin 
                    ex_pc          <= #1 id_pc;
                    ex_en          <= #1 id_en;
                    ex_br_flag     <= #1 id_br_flag;
                    ex_mem_op      <= #1 `MEM_OP_NOP;
                    ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
                    ex_ctrl_op     <= #1 `CTRL_OP_NOP;
                    ex_dst_addr    <= #1 `REG_ADDR_W'd0;
                    ex_gpr_we_n     <= #1 `DISABLE_;
                    ex_exp_code    <= #1 `ISA_EXP_EXT_INT;
                    ex_out         <= #1 `WORD_DATA_W'h0;
                end else if (alu_of == `ENABLE) begin     
                    ex_pc          <= #1 id_pc;
                    ex_en          <= #1 id_en;
                    ex_br_flag     <= #1 id_br_flag;
                    ex_mem_op      <= #1 `MEM_OP_NOP;
                    ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
                    ex_ctrl_op     <= #1 `CTRL_OP_NOP;
                    ex_dst_addr    <= #1 `REG_ADDR_W'd0;
                    ex_gpr_we_n     <= #1 `DISABLE_;
                    ex_exp_code    <= #1 `ISA_EXP_OVERFLOW;
                    ex_out         <= #1 `WORD_DATA_W'h0;
                end else begin                            
                    ex_pc          <= #1 id_pc;
                    ex_en          <= #1 id_en;
                    ex_br_flag     <= #1 id_br_flag;
                    ex_mem_op      <= #1 id_mem_op;
                    ex_mem_wr_data <= #1 id_mem_wr_data;
                    ex_ctrl_op     <= #1 id_ctrl_op;
                    ex_dst_addr    <= #1 id_dst_addr;
                    ex_gpr_we_n     <= #1 id_gpr_we_n;
                    ex_exp_code    <= #1 id_exp_code;
                    ex_out         <= #1 alu_out;
                end
            end
        end
    end

endmodule
