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
//File Name      : alu.v 
//Project Name   : azpr_soc
//Description    : the alu module.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/cpu/alu.v
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
//2016.11.22 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
//File Include : system header file
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "cpu.h"
module alu (
    input  wire [`WordDataBus] in_0,  // 入力 0
    input  wire [`WordDataBus] in_1,  // 入力 1
    input  wire [`AluOpBus]    op,    // オペレーション
    output reg  [`WordDataBus] out,   // 出力
    output reg                 of     // オーバフロー
);

    wire signed [`WordDataBus] s_in_0 = $signed(in_0); // 符号付き入力 0
    wire signed [`WordDataBus] s_in_1 = $signed(in_1); // 符号付き入力 1
    wire signed [`WordDataBus] s_out  = $signed(out);  // 符号付き出力

    /********** 算術論理演算 **********/
    always @(*) begin
        case (op)
            `ALU_OP_AND  : begin // 論理積（AND）
                out   = in_0 & in_1;
            end
            `ALU_OP_OR   : begin // 論理和（OR）
                out   = in_0 | in_1;
            end
            `ALU_OP_XOR  : begin // 排他的論理和（XOR）
                out   = in_0 ^ in_1;
            end
            `ALU_OP_ADDS : begin // 符号付き加算
                out   = in_0 + in_1;
            end
            `ALU_OP_ADDU : begin // 符号なし加算
                out   = in_0 + in_1;
            end
            `ALU_OP_SUBS : begin // 符号付き減算
                out   = in_0 - in_1;
            end
            `ALU_OP_SUBU : begin // 符号なし減算
                out   = in_0 - in_1;
            end
            `ALU_OP_SHRL : begin // 論理右シフト
                out   = in_0 >> in_1[`ShAmountLoc];
            end
            `ALU_OP_SHLL : begin // 論理左シフト
                out   = in_0 << in_1[`ShAmountLoc];
            end
            default      : begin // デフォルト値 (No Operation)
                out   = in_0;
            end
        endcase
    end

    /********** オーバフローチェック **********/
    always @(*) begin
        case (op)
            `ALU_OP_ADDS : begin // 加算オーバフローのチェック
                if (((s_in_0 > 0) && (s_in_1 > 0) && (s_out < 0)) ||
                    ((s_in_0 < 0) && (s_in_1 < 0) && (s_out > 0))) begin
                    of = `ENABLE;
                end else begin
                    of = `DISABLE;
                end
            end
            `ALU_OP_SUBS : begin // 減算オーバフローのチェック
                if (((s_in_0 < 0) && (s_in_1 > 0) && (s_out > 0)) ||
                    ((s_in_0 > 0) && (s_in_1 < 0) && (s_out < 0))) begin
                    of = `ENABLE;
                end else begin
                    of = `DISABLE;
                end
            end
            default     : begin // デフォルト値
                of = `DISABLE;
            end
        endcase
    end

endmodule
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
