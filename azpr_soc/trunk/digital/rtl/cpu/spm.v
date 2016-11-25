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

//File Include : system header file
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

//File Include : module header file
`include "spm.h"

module spm (
    //1.clock and reset if
    input  wire                clk              ,//clock
    //2.port a if stage
    input  wire [`SpmAddrBus]  if_spm_addr      ,//address
    input  wire                if_spm_as_n      ,//address strobe
    input  wire                if_spm_rw        ,// 読み／書き
    input  wire [`WordDataBus] if_spm_wr_data   ,   // 書き込みデータ
    output wire [`WordDataBus] if_spm_rd_data   ,   // 読み出しデータ
    /********** ポートB : MEMステージ **********/
    //3.port b mem stage
    input  wire [`SpmAddrBus]  mem_spm_addr     ,   // アドレス
    input  wire                mem_spm_as_n     ,       // アドレスストローブ
    input  wire                mem_spm_rw       ,       // 読み／書き
    input  wire [`WordDataBus] mem_spm_wr_data  , // 書き込みデータ
    output wire [`WordDataBus] mem_spm_rd_data  // 読み出しデータ
);

    /********** 書き込み有効信号 **********/
    reg                        wea;         // ポート A
    reg                        web;         // ポート B

    /********** 書き込み有効信号の生成 **********/
    always @(*) begin
        /* ポート A */
        if ((if_spm_as_ == `ENABLE_) && (if_spm_rw == `WRITE)) begin   
            wea = `MEM_ENABLE;  // 書き込み有効
        end else begin
            wea = `MEM_DISABLE; // 書き込み無効
        end
        /* ポート B */
        if ((mem_spm_as_ == `ENABLE_) && (mem_spm_rw == `WRITE)) begin
            web = `MEM_ENABLE;  // 書き込み有効
        end else begin
            web = `MEM_DISABLE; // 書き込み無効
        end
    end

    /********** Xilinx FPGA Block RAM : デュアルポートRAM **********/
    x_s3e_dpram x_s3e_dpram (
        /********** ポート A : IFステージ **********/
        .clka  (clk),             // クロック
        .addra (if_spm_addr),     // アドレス
        .dina  (if_spm_wr_data),  // 書き込みデータ（未接続）
        .wea   (wea),             // 書き込み有効（ネゲート）
        .douta (if_spm_rd_data),  // 読み出しデータ
        /********** ポート B : MEMステージ **********/
        .clkb  (clk),             // クロック
        .addrb (mem_spm_addr),    // アドレス
        .dinb  (mem_spm_wr_data), // 書き込みデータ
        .web   (web),             // 書き込み有効
        .doutb (mem_spm_rd_data)  // 読み出しデータ
    );
  
endmodule
