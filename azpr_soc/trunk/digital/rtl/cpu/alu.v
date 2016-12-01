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
//2016.12.01 - lichangbeiju - Change the coding style : part 2.
//2016.11.22 - lichangbeiju - Change the coding style : part 1.
//2016.11.22 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
//File Include : system header file
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "cpu.h"
module alu (
    input  wire [`WordDataBus] in_0,  
    input  wire [`WordDataBus] in_1,  
    input  wire [`AluOpBus]    op,    
    output reg  [`WordDataBus] out,   
    output reg                 of     
);

    wire signed [`WordDataBus] s_in_0 = $signed(in_0); 
    wire signed [`WordDataBus] s_in_1 = $signed(in_1); 
    wire signed [`WordDataBus] s_out  = $signed(out);  

    always @(*) begin
        case (op)
            `ALU_OP_AND  : begin 
                out   = in_0 & in_1;
            end
            `ALU_OP_OR   : begin 
                out   = in_0 | in_1;
            end
            `ALU_OP_XOR  : begin 
                out   = in_0 ^ in_1;
            end
            `ALU_OP_ADDS : begin 
                out   = in_0 + in_1;
            end
            `ALU_OP_ADDU : begin 
                out   = in_0 + in_1;
            end
            `ALU_OP_SUBS : begin 
                out   = in_0 - in_1;
            end
            `ALU_OP_SUBU : begin 
                out   = in_0 - in_1;
            end
            `ALU_OP_SHRL : begin 
                out   = in_0 >> in_1[`ShAmountLoc];
            end
            `ALU_OP_SHLL : begin 
                out   = in_0 << in_1[`ShAmountLoc];
            end
            default      : begin 
                out   = in_0;
            end
        endcase
    end

    always @(*) begin
        case (op)
            `ALU_OP_ADDS : begin 
                if (((s_in_0 > 0) && (s_in_1 > 0) && (s_out < 0)) ||
                    ((s_in_0 < 0) && (s_in_1 < 0) && (s_out > 0))) begin
                    of = `ENABLE;
                end else begin
                    of = `DISABLE;
                end
            end
            `ALU_OP_SUBS : begin 
                if (((s_in_0 < 0) && (s_in_1 > 0) && (s_out > 0)) ||
                    ((s_in_0 > 0) && (s_in_1 < 0) && (s_out < 0))) begin
                    of = `ENABLE;
                end else begin
                    of = `DISABLE;
                end
            end
            default     : begin 
                of = `DISABLE;
            end
        endcase
    end

endmodule
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
