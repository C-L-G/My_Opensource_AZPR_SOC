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
    input  wire [`WordDataBus] in_0,  // ���� 0
    input  wire [`WordDataBus] in_1,  // ���� 1
    input  wire [`AluOpBus]    op,    // �I�y���[�V����
    output reg  [`WordDataBus] out,   // �o��
    output reg                 of     // �I�[�o�t���[
);

    wire signed [`WordDataBus] s_in_0 = $signed(in_0); // �����t������ 0
    wire signed [`WordDataBus] s_in_1 = $signed(in_1); // �����t������ 1
    wire signed [`WordDataBus] s_out  = $signed(out);  // �����t���o��

    /********** �Z�p�_�����Z **********/
    always @(*) begin
        case (op)
            `ALU_OP_AND  : begin // �_���ρiAND�j
                out   = in_0 & in_1;
            end
            `ALU_OP_OR   : begin // �_���a�iOR�j
                out   = in_0 | in_1;
            end
            `ALU_OP_XOR  : begin // �r���I�_���a�iXOR�j
                out   = in_0 ^ in_1;
            end
            `ALU_OP_ADDS : begin // �����t�����Z
                out   = in_0 + in_1;
            end
            `ALU_OP_ADDU : begin // �����Ȃ����Z
                out   = in_0 + in_1;
            end
            `ALU_OP_SUBS : begin // �����t�����Z
                out   = in_0 - in_1;
            end
            `ALU_OP_SUBU : begin // �����Ȃ����Z
                out   = in_0 - in_1;
            end
            `ALU_OP_SHRL : begin // �_���E�V�t�g
                out   = in_0 >> in_1[`ShAmountLoc];
            end
            `ALU_OP_SHLL : begin // �_�����V�t�g
                out   = in_0 << in_1[`ShAmountLoc];
            end
            default      : begin // �f�t�H���g�l (No Operation)
                out   = in_0;
            end
        endcase
    end

    /********** �I�[�o�t���[�`�F�b�N **********/
    always @(*) begin
        case (op)
            `ALU_OP_ADDS : begin // ���Z�I�[�o�t���[�̃`�F�b�N
                if (((s_in_0 > 0) && (s_in_1 > 0) && (s_out < 0)) ||
                    ((s_in_0 < 0) && (s_in_1 < 0) && (s_out > 0))) begin
                    of = `ENABLE;
                end else begin
                    of = `DISABLE;
                end
            end
            `ALU_OP_SUBS : begin // ���Z�I�[�o�t���[�̃`�F�b�N
                if (((s_in_0 < 0) && (s_in_1 > 0) && (s_out > 0)) ||
                    ((s_in_0 > 0) && (s_in_1 < 0) && (s_out < 0))) begin
                    of = `ENABLE;
                end else begin
                    of = `DISABLE;
                end
            end
            default     : begin // �f�t�H���g�l
                of = `DISABLE;
            end
        endcase
    end

endmodule
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
