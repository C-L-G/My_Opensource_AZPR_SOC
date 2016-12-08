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

`include "../sys_include.h"

`include "isa.h"
`include "cpu.h"

module id_reg (
    input  wire                clk,            //
    input  wire                reset,          //
    input  wire [`AluOpBus]    alu_op,         //
    input  wire [`WordDataBus] alu_in_0,       //
    input  wire [`WordDataBus] alu_in_1,       //
    input  wire                br_flag,        //
    input  wire [`MemOpBus]    mem_op,         //
    input  wire [`WordDataBus] mem_wr_data,    //
    input  wire [`CtrlOpBus]   ctrl_op,        //
    input  wire [`RegAddrBus]  dst_addr,       //
    input  wire                gpr_we_n,        //
    input  wire [`IsaExpBus]   exp_code,       //
    input  wire                stall,          //
    input  wire                flush,          //
    input  wire [`WordAddrBus] if_pc,          //
    input  wire                if_en,          //
    output reg  [`WordAddrBus] id_pc,          //
    output reg                 id_en,          //
    output reg  [`AluOpBus]    id_alu_op,      //
    output reg  [`WordDataBus] id_alu_in_0,    //
    output reg  [`WordDataBus] id_alu_in_1,    //
    output reg                 id_br_flag,     //
    output reg  [`MemOpBus]    id_mem_op,      //
    output reg  [`WordDataBus] id_mem_wr_data, //
    output reg  [`CtrlOpBus]   id_ctrl_op,     //
    output reg  [`RegAddrBus]  id_dst_addr,    //
    output reg                 id_gpr_we_n,     //
    output reg [`IsaExpBus]    id_exp_code     //
);

    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin 
            id_pc          <= #1 `WORD_ADDR_W'h0;
            id_en          <= #1 `DISABLE;
            id_alu_op      <= #1 `ALU_OP_NOP;
            id_alu_in_0    <= #1 `WORD_DATA_W'h0;
            id_alu_in_1    <= #1 `WORD_DATA_W'h0;
            id_br_flag     <= #1 `DISABLE;
            id_mem_op      <= #1 `MEM_OP_NOP;
            id_mem_wr_data <= #1 `WORD_DATA_W'h0;
            id_ctrl_op     <= #1 `CTRL_OP_NOP;
            id_dst_addr    <= #1 `REG_ADDR_W'd0;
            id_gpr_we_n     <= #1 `DISABLE_N;
            id_exp_code    <= #1 `ISA_EXP_NO_EXP;
        end else begin
            if (stall == `DISABLE) begin 
                if (flush == `ENABLE) begin
                   id_pc          <= #1 `WORD_ADDR_W'h0;
                   id_en          <= #1 `DISABLE;
                   id_alu_op      <= #1 `ALU_OP_NOP;
                   id_alu_in_0    <= #1 `WORD_DATA_W'h0;
                   id_alu_in_1    <= #1 `WORD_DATA_W'h0;
                   id_br_flag     <= #1 `DISABLE;
                   id_mem_op      <= #1 `MEM_OP_NOP;
                   id_mem_wr_data <= #1 `WORD_DATA_W'h0;
                   id_ctrl_op     <= #1 `CTRL_OP_NOP;
                   id_dst_addr    <= #1 `REG_ADDR_W'd0;
                   id_gpr_we_n     <= #1 `DISABLE_N;
                   id_exp_code    <= #1 `ISA_EXP_NO_EXP;
                end else begin
                   id_pc          <= #1 if_pc;
                   id_en          <= #1 if_en;
                   id_alu_op      <= #1 alu_op;
                   id_alu_in_0    <= #1 alu_in_0;
                   id_alu_in_1    <= #1 alu_in_1;
                   id_br_flag     <= #1 br_flag;
                   id_mem_op      <= #1 mem_op;
                   id_mem_wr_data <= #1 mem_wr_data;
                   id_ctrl_op     <= #1 ctrl_op;
                   id_dst_addr    <= #1 dst_addr;
                   id_gpr_we_n     <= #1 gpr_we_n;
                   id_exp_code    <= #1 exp_code;
                end
            end
        end
    end

endmodule
