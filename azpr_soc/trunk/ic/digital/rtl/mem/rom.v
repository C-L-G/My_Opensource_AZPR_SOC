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
//File Name      : rom.v 
//Project Name   : azpr_soc
//Description    : the system rom.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/rom.v
//License        : CPL
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 01-07-2016 17:00(1th Fri,July,2016)
//First Author   : lichangbeiju
//Modify Date    : 02-09-2016 14:20(1th Sun,July,2016)
//Last Author    : lichangbeiju
//Version Number : 002   
//Last Commit    : 03-09-2016 14:30(1th Sun,July,2016)
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2016.11.22 - lichangbeiju - Add basic rom write and read logic.
//*---------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
`include "rom.h" 
`include "stddef.h"
module rom.v#(
   parameter MEM_WIDTH      = 32,
   parameter MEM_ADDR_BITS  = 11
)(
    input   wire                            clockA,
    input   wire                            clockB,
    input   wire                            write_enableA,
    input   wire                            write_enableB,
    input   wire    [MEM_ADDR_BITS-1:0]     addressA, 
    input   wire    [MEM_ADDR_BITS-1:0]     addressB, 
    input   wire    [MEM_WIDTH-1:0]         input_dataA, 
    input   wire    [MEM_WIDTH-1:0]         input_dataB, 
    output  reg     [MEM_WIDTH-1:0]         output_dataA,
    output  reg     [MEM_WIDTH-1:0]         output_dataB
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
    // 2.2 the memory register
    //------------------------------------------------------------------------------------------------  
    //(* RAM_STYLE="{AUTO | BLOCK |  BLOCK_POWER1 | BLOCK_POWER2}" *)
    (* RAM_STYLE="BLOCK" *)
    reg [MEM_WIDTH-1:0] sym_ram [(2**MEM_ADDR_BITS)-1:0];

    wire                    enableA;
    wire                    enableB;
    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 3.1 the memory read and write logic
    //------------------------------------------------------------------------------------------------
    assign enableA = `ENABLE;
    assign enableB = `ENABLE;

   //  The forllowing code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data)
   //initial
   //     $readmemh("data_file_name", sym_ram, begin_address, end_address);

   always @(posedge clockA)
      if (enableA) begin
         if (write_enableA)
            sym_ram[addressA] <= input_dataA;
         output_dataA <= sym_ram[addressA];
      end
      
   always @(posedge clockB)
      if (enableB) begin
         if (write_enableB)
            sym_ram[addressB] <= input_dataB;
         output_dataB <= sym_ram[addressB];
      end
    
    
endmodule    
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
