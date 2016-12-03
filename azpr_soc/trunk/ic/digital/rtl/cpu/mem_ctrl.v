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
`include "bus.h"

module mem_ctrl (
    input  wire                ex_en,          
    input  wire [`MemOpBus]    ex_mem_op,     
    input  wire [`WordDataBus] ex_mem_wr_data, 
    input  wire [`WordDataBus] ex_out,         
    input  wire [`WordDataBus] rd_data,        
    output wire [`WordAddrBus] addr,           
    output reg                 as_n,            
    output reg                 rw,             
    output wire [`WordDataBus] wr_data,        
    output reg [`WordDataBus]  out   ,         
    output reg                 miss_align      
);

    wire [`ByteOffsetBus]    offset;           

    assign wr_data = ex_mem_wr_data;           
    assign addr    = ex_out[`WordAddrLoc];     
    assign offset  = ex_out[`ByteOffsetLoc];   

    always @(*) begin
        miss_align = `DISABLE;
        out        = `WORD_DATA_W'h0;
        as_n        = `DISABLE_N;
        rw         = `READ;
        if (ex_en == `ENABLE) begin
            case (ex_mem_op)
                `MEM_OP_LDW : begin 
                    if (offset == `BYTE_OFFSET_WORD) begin 
                        out         = rd_data;
                        as_n        = `ENABLE_N;
                    end else begin                         
                        miss_align  = `ENABLE;
                    end
                end
                `MEM_OP_STW : begin 
                    if (offset == `BYTE_OFFSET_WORD) begin 
                        rw          = `WRITE;
                        as_n        = `ENABLE_N;
                    end else begin                         
                        miss_align  = `ENABLE;
                    end
                end
                default     : begin 
                    out         = ex_out;
                end
            endcase
        end
    end

endmodule
