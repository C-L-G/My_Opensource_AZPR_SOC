/*
 -- ============================================================================
 -- FILE NAME   : ex_stage.v
 -- DESCRIPTION : EXステージ
 -- ----------------------------------------------------------------------------
 -- Revision  Date        Coding_by  Comment
 -- 1.0.0     2011/06/27  suito      新規作成
 -- ============================================================================
*/
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
//File Name      : ex_stage.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/ex_stage.v
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

module ex_stage (
    input  wire                clk,            //
    input  wire                reset,          //
    input  wire                stall,          //
    input  wire                flush,          //
    input  wire                int_detect,     //
    output wire [`WordDataBus] fwd_data,       //
    input  wire [`WordAddrBus] id_pc,          //
    input  wire                id_en,          //
    input  wire [`AluOpBus]    id_alu_op,      //
    input  wire [`WordDataBus] id_alu_in_0,    //
    input  wire [`WordDataBus] id_alu_in_1,    //
    input  wire                id_br_flag,     //
    input  wire [`MemOpBus]    id_mem_op,      //
    input  wire [`WordDataBus] id_mem_wr_data, //
    input  wire [`CtrlOpBus]   id_ctrl_op,     //
    input  wire [`RegAddrBus]  id_dst_addr,    //
    input  wire                id_gpr_we_,     //
    input  wire [`IsaExpBus]   id_exp_code,    //
    output wire [`WordAddrBus] ex_pc,          //
    output wire                ex_en,          //
    output wire                ex_br_flag,     //
    output wire [`MemOpBus]    ex_mem_op,      //
    output wire [`WordDataBus] ex_mem_wr_data, //
    output wire [`CtrlOpBus]   ex_ctrl_op,     //
    output wire [`RegAddrBus]  ex_dst_addr,    //
    output wire                ex_gpr_we_,     //
    output wire [`IsaExpBus]   ex_exp_code,    //
    output wire [`WordDataBus] ex_out          //
);

    wire [`WordDataBus]        alu_out;        //
    wire                       alu_of;         //

    assign fwd_data = alu_out;

    /********** ALU **********/
    alu alu (
        .in_0           (id_alu_in_0),    // 
        .in_1           (id_alu_in_1),    // 
        .op             (id_alu_op),      // 
        .out            (alu_out),        // 
        .of             (alu_of)          // 
    );

    ex_reg ex_reg (
        .clk            (clk),            //
        .reset          (reset),          //
        .alu_out        (alu_out),        //
        .alu_of         (alu_of),         //
        .stall          (stall),          //
        .flush          (flush),          //
        .int_detect     (int_detect),     //
        .id_pc          (id_pc),          //
        .id_en          (id_en),          //
        .id_br_flag     (id_br_flag),     //
        .id_mem_op      (id_mem_op),      //
        .id_mem_wr_data (id_mem_wr_data), //
        .id_ctrl_op     (id_ctrl_op),     //
        .id_dst_addr    (id_dst_addr),    //
        .id_gpr_we_     (id_gpr_we_),     //
        .id_exp_code    (id_exp_code),    //
        .ex_pc          (ex_pc),          //
        .ex_en          (ex_en),          //
        .ex_br_flag     (ex_br_flag),     //
        .ex_mem_op      (ex_mem_op),      //
        .ex_mem_wr_data (ex_mem_wr_data), //
        .ex_ctrl_op     (ex_ctrl_op),     //
        .ex_dst_addr    (ex_dst_addr),    //
        .ex_gpr_we_     (ex_gpr_we_),     //
        .ex_exp_code    (ex_exp_code),    //
        .ex_out         (ex_out)          //
    );

endmodule
