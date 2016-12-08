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
//File Name      : clk_gen.v 
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

`include "sys_include.h"

module clk_gen (
    input wire  clk_ref, 
    input wire  reset_sw, 
    output wire clk,       
    output wire clk_n,      
    output wire chip_reset 
);

    wire        locked;    
    wire        dcm_reset; 

    assign locked     = 1'b1;
    assign dcm_reset  = (reset_sw == `RESET_ENABLE) ? `ENABLE : `DISABLE;
    assign chip_reset = ((reset_sw == `RESET_ENABLE) || (locked == `DISABLE)) ?
                            `RESET_ENABLE : `RESET_DISABLE;

   // /********** Xilinx DCM (Digitl Clock Manager) **********/
   // x_s3e_dcm x_s3e_dcm (
   //     .CLKIN_IN        (clk_ref),  
   //     .RST_IN          (dcm_reset),
   //     .CLK0_OUT        (clk),     
   //     .CLK180_OUT      (clk_n),   
   //     .LOCKED_OUT      (locked) 
   //);
   
   assign clk   = clk_ref;
   assign clk_n = ~clk_ref;

endmodule
