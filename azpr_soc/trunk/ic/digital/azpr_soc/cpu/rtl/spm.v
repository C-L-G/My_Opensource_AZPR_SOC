/*
 -- ============================================================================
 -- FILE NAME	: spm.v
 -- DESCRIPTION : スクラッチパッドメモリ
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 新規作成
 -- ============================================================================
*/

/********** 共通ヘッダファイル **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** 個別ヘッダファイル **********/
`include "spm.h"

/********** モジュール **********/
module spm (
	/********** クロック **********/
	input  wire				   clk,				// クロック
	/********** ポートA : IFステージ **********/
	input  wire [`SpmAddrBus]  if_spm_addr,		// アドレス
	input  wire				   if_spm_as_,		// アドレスストローブ
	input  wire				   if_spm_rw,		// 読み／書き
	input  wire [`WordDataBus] if_spm_wr_data,	// 書き込みデータ
	output wire [`WordDataBus] if_spm_rd_data,	// 読み出しデータ
	/********** ポートB : MEMステージ **********/
	input  wire [`SpmAddrBus]  mem_spm_addr,	// アドレス
	input  wire				   mem_spm_as_,		// アドレスストローブ
	input  wire				   mem_spm_rw,		// 読み／書き
	input  wire [`WordDataBus] mem_spm_wr_data, // 書き込みデータ
	output wire [`WordDataBus] mem_spm_rd_data	// 読み出しデータ
);

	/********** 書き込み有効信号 **********/
	reg						   wea;			// ポート A
	reg						   web;			// ポート B

	/********** 書き込み有効信号の生成 **********/
	always @(*) begin
		/* ポート A */
		if ((if_spm_as_ == `ENABLE_) && (if_spm_rw == `WRITE)) begin   
			wea = `MEM_ENABLE;	// 書き込み有効
		end else begin
			wea = `MEM_DISABLE; // 書き込み無効
		end
		/* ポート B */
		if ((mem_spm_as_ == `ENABLE_) && (mem_spm_rw == `WRITE)) begin
			web = `MEM_ENABLE;	// 書き込み有効
		end else begin
			web = `MEM_DISABLE; // 書き込み無効
		end
	end

	/********** Xilinx FPGA Block RAM : デュアルポートRAM **********/
	x_s3e_dpram x_s3e_dpram (
		/********** ポート A : IFステージ **********/
		.clka  (clk),			  // クロック
		.addra (if_spm_addr),	  // アドレス
		.dina  (if_spm_wr_data),  // 書き込みデータ（未接続）
		.wea   (wea),			  // 書き込み有効（ネゲート）
		.douta (if_spm_rd_data),  // 読み出しデータ
		/********** ポート B : MEMステージ **********/
		.clkb  (clk),			  // クロック
		.addrb (mem_spm_addr),	  // アドレス
		.dinb  (mem_spm_wr_data), // 書き込みデータ
		.web   (web),			  // 書き込み有効
		.doutb (mem_spm_rd_data)  // 読み出しデータ
	);
  
endmodule
