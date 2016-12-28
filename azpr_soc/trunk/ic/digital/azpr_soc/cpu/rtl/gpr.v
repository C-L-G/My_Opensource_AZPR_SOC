/* 
 -- ============================================================================
 -- FILE NAME	: gpr.v
 -- DESCRIPTION : 汎用レジスタ
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
`include "cpu.h"

/********** モジュール **********/
module gpr (
	/********** クロック & リセット **********/
	input  wire				   clk,				   // クロック
	input  wire				   reset,			   // 非同期リセット
	/********** 読み出しポート 0 **********/
	input  wire [`RegAddrBus]  rd_addr_0,		   // 読み出しアドレス
	output wire [`WordDataBus] rd_data_0,		   // 読み出しデータ
	/********** 読み出しポート 1 **********/
	input  wire [`RegAddrBus]  rd_addr_1,		   // 読み出しアドレス
	output wire [`WordDataBus] rd_data_1,		   // 読み出しデータ
	/********** 書き込みポート **********/
	input  wire				   we_,				   // 書き込み有効
	input  wire [`RegAddrBus]  wr_addr,			   // 書き込みアドレス
	input  wire [`WordDataBus] wr_data			   // 書き込みデータ
);

	/********** 内部信号 **********/
	reg [`WordDataBus]		   gpr [`REG_NUM-1:0]; // レジスタ配列
	integer					   i;				   // イテレータ

	/********** 読み出しアクセス (Write After Read) **********/
	// 読み出しポート 0
	assign rd_data_0 = ((we_ == `ENABLE_) && (wr_addr == rd_addr_0)) ? 
					   wr_data : gpr[rd_addr_0];
	// 読み出しポート 1
	assign rd_data_1 = ((we_ == `ENABLE_) && (wr_addr == rd_addr_1)) ? 
					   wr_data : gpr[rd_addr_1];
   
	/********** 書き込みアクセス **********/
	always @ (posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin 
			/* 非同期リセット */
			for (i = 0; i < `REG_NUM; i = i + 1) begin
				gpr[i]		 <= #1 `WORD_DATA_W'h0;
			end
		end else begin
			/* 書き込みアクセス */
			if (we_ == `ENABLE_) begin 
				gpr[wr_addr] <= #1 wr_data;
			end
		end
	end

endmodule 
