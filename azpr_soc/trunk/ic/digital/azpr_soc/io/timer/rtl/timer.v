/*
 -- ============================================================================
 -- FILE NAME	: timer.v
 -- DESCRIPTION : タイマ
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 新規作成
 -- ============================================================================
*/

/********** 共通ヘッダファイル **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 個別ヘッダファイル **********/
`include "timer.h"

/********** モジュール **********/
module timer (
	/********** クロック & リセット **********/
	input  wire					clk,	   // クロック
	input  wire					reset,	   // 非同期リセット
	/********** バスインタフェース **********/
	input  wire					cs_,	   // チップセレクト
	input  wire					as_,	   // アドレスストローブ
	input  wire					rw,		   // Read / Write
	input  wire [`TimerAddrBus] addr,	   // アドレス
	input  wire [`WordDataBus]	wr_data,   // 書き込みデータ
	output reg	[`WordDataBus]	rd_data,   // 読み出しデータ
	output reg					rdy_,	   // レディ
	/********** 割り込み **********/
	output reg					irq		   // 割り込み要求（制御レジスタ 1）
);

	/********** 制御レジツタ **********/
	// 制御レジスタ 0 : コントロール
	reg							mode;	   // モードビット
	reg							start;	   // スタートビット
	// 制御レジスタ 2 : 満了値
	reg [`WordDataBus]			expr_val;  // 満了値
	// 制御レジスタ 3 : カウンタ
	reg [`WordDataBus]			counter;   // カウンタ

	/********** 満了フラグ **********/
	wire expr_flag = ((start == `ENABLE) && (counter == expr_val)) ?
					 `ENABLE : `DISABLE;

	/********** タイマ制御 **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* 非同期リセット */
			rd_data	 <= #1 `WORD_DATA_W'h0;
			rdy_	 <= #1 `DISABLE_;
			start	 <= #1 `DISABLE;
			mode	 <= #1 `TIMER_MODE_ONE_SHOT;
			irq		 <= #1 `DISABLE;
			expr_val <= #1 `WORD_DATA_W'h0;
			counter	 <= #1 `WORD_DATA_W'h0;
		end else begin
			/* レディの生成 */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
				rdy_	 <= #1 `ENABLE_;
			end else begin
				rdy_	 <= #1 `DISABLE_;
			end
			/* 読み出しアクセス */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
				case (addr)
					`TIMER_ADDR_CTRL	: begin // 制御レジスタ 0
						rd_data	 <= #1 {{`WORD_DATA_W-2{1'b0}}, mode, start};
					end
					`TIMER_ADDR_INTR	: begin // 制御レジスタ 1
						rd_data	 <= #1 {{`WORD_DATA_W-1{1'b0}}, irq};
					end
					`TIMER_ADDR_EXPR	: begin // 制御レジスタ 2
						rd_data	 <= #1 expr_val;
					end
					`TIMER_ADDR_COUNTER : begin // 制御レジスタ 3
						rd_data	 <= #1 counter;
					end
				endcase
			end else begin
				rd_data	 <= #1 `WORD_DATA_W'h0;
			end
			/* 書き込みアクセス */
			// 制御レジスタ 0
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_CTRL)) begin
				start	 <= #1 wr_data[`TimerStartLoc];
				mode	 <= #1 wr_data[`TimerModeLoc];
			end else if ((expr_flag == `ENABLE)	 &&
						 (mode == `TIMER_MODE_ONE_SHOT)) begin
				start	 <= #1 `DISABLE;
			end
			// 制御レジスタ 1
			if (expr_flag == `ENABLE) begin
				irq		 <= #1 `ENABLE;
			end else if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
						 (rw == `WRITE) && (addr ==	 `TIMER_ADDR_INTR)) begin
				irq		 <= #1 wr_data[`TimerIrqLoc];
			end
			// 制御レジスタ 2
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_EXPR)) begin
				expr_val <= #1 wr_data;
			end
			// 制御レジスタ 3
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_COUNTER)) begin
				counter	 <= #1 wr_data;
			end else if (expr_flag == `ENABLE) begin
				counter	 <= #1 `WORD_DATA_W'h0;
			end else if (start == `ENABLE) begin
				counter	 <= #1 counter + 1'd1;
			end
		end
	end

endmodule
