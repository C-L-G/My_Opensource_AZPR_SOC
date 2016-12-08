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
//File Name      : if_reg.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/if_reg.v
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

`include "isa.h"
`include "cpu.h"

module if_reg (
    input   wire                    clk     ,//clock     
    input   wire                    reset   ,//async reset
    input   wire    [`WordDataBus]  insn    ,//read inst
    input   wire                    stall   ,//delay
    input   wire                    flush   ,//refresh
    input   wire    [`WordAddrBus]  new_pc  ,//new program count  
    input   wire                    br_taken,//branch taken
    input   wire    [`WordAddrBus]  br_addr ,//branch dest address
    output  reg     [`WordAddrBus]  if_pc   ,//program count
    output  reg     [`WordDataBus]  if_insn ,//inst
    output  reg                     if_en    //pipeline data valid flag  
);

    //************************************************************************************************
    // 1.Parameter and constant define
    //************************************************************************************************
    
    
    //************************************************************************************************
    // 2.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 2.1 the output reg
    //------------------------------------------------------------------------------------------------   
    //------------------------------------------------------------------------------------------------
    // 2.2 the internal reg
    //------------------------------------------------------------------------------------------------  
    
    //------------------------------------------------------------------------------------------------
    // 2.x the test logic
    //------------------------------------------------------------------------------------------------

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 3.1 the pipeline register
    //------------------------------------------------------------------------------------------------
    always @(posedge clk or `RESET_EDGE reset) begin : PIPELINE_REG
        //asynchronous reset
        if (reset == `RESET_ENABLE) begin 
            if_pc   <= #1 `RESET_VECTOR;
            if_insn <= #1 `ISA_NOP;
            if_en   <= #1 `DISABLE;
        end else begin
            //update the pipeline reg
            if (stall == `DISABLE) begin 
                if (flush == `ENABLE) begin     //refresh the pipeline and pc       
                    if_pc   <= #1 new_pc;
                    if_insn <= #1 `ISA_NOP;
                    if_en   <= #1 `DISABLE;
                end else if (br_taken == `ENABLE) begin //branch taken and pc = br_addr
                    if_pc   <= #1 br_addr;
                    if_insn <= #1 insn;
                    if_en   <= #1 `ENABLE;
                end else begin                          
                    if_pc   <= #1 if_pc + 1'd1;         //pc = next address[+1]
                    if_insn <= #1 insn;
                    if_en   <= #1 `ENABLE;
                end
            end
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
