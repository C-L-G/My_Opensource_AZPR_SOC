/*
 -- ============================================================================
 -- FILE NAME	: bus_if.v
 -- DESCRIPTION : バスインタフェース
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
`include "bus.h"

/********** モジュール **********/
module bus_if (
	/********** クロック & リセット **********/
	input  wire				   clk,			   // クロック
	input  wire				   reset,		   // 非同期リセット
	/********** パイプライン制御信号 **********/
	input  wire				   stall,		   // ストール
	input  wire				   flush,		   // フラッシュ信号
	output reg				   busy,		   // ビジー信号
	/********** CPUインタフェース **********/
	input  wire [`WordAddrBus] addr,		   // アドレス
	input  wire				   as_,			   // アドレス有効
	input  wire				   rw,			   // 読み／書き
	input  wire [`WordDataBus] wr_data,		   // 書き込みデータ
	output reg	[`WordDataBus] rd_data,		   // 読み出しデータ
	/********** SPMインタフェース **********/
	input  wire [`WordDataBus] spm_rd_data,	   // 読み出しデータ
	output wire [`WordAddrBus] spm_addr,	   // アドレス
	output reg				   spm_as_,		   // アドレスストローブ
	output wire				   spm_rw,		   // 読み／書き
	output wire [`WordDataBus] spm_wr_data,	   // 書き込みデータ
	/********** バスインタフェース **********/
	input  wire [`WordDataBus] bus_rd_data,	   // 読み出しデータ
	input  wire				   bus_rdy_,	   // レディ
	input  wire				   bus_grnt_,	   // バスグラント
	output reg				   bus_req_,	   // バスリクエスト
	output reg	[`WordAddrBus] bus_addr,	   // アドレス
	output reg				   bus_as_,		   // アドレスストローブ
	output reg				   bus_rw,		   // 読み／書き
	output reg	[`WordDataBus] bus_wr_data	   // 書き込みデータ
);

	/********** 内部信号 **********/
	reg	 [`BusIfStateBus]	   state;		   // バスインタフェースの状態
	reg	 [`WordDataBus]		   rd_buf;		   // 読み出しバッファ
	wire [`BusSlaveIndexBus]   s_index;		   // バススレーブインデックス

	/********** バススレーブのインデックス **********/
	assign s_index	   = addr[`BusSlaveIndexLoc];

	/********** 出力のアサイン **********/
	assign spm_addr	   = addr;
	assign spm_rw	   = rw;
	assign spm_wr_data = wr_data;
						 
	/********** メモリアクセスの制御 **********/
	always @(*) begin
		/* デフォルト値 */
		rd_data	 = `WORD_DATA_W'h0;
		spm_as_	 = `DISABLE_;
		busy	 = `DISABLE;
		/* バスインタフェースの状態 */
		case (state)
			`BUS_IF_STATE_IDLE	 : begin // アイドル
				/* メモリアクセス */
				if ((flush == `DISABLE) && (as_ == `ENABLE_)) begin
					/* アクセス先の選択 */
					if (s_index == `BUS_SLAVE_1) begin // SPMへアクセス
						if (stall == `DISABLE) begin // ストール発生のチェック
							spm_as_	 = `ENABLE_;
							if (rw == `READ) begin // 読み出しアクセス
								rd_data	 = spm_rd_data;
							end
						end
					end else begin					   // バスへアクセス
						busy	 = `ENABLE;
					end
				end
			end
			`BUS_IF_STATE_REQ	 : begin // バスリクエスト
				busy	 = `ENABLE;
			end
			`BUS_IF_STATE_ACCESS : begin // バスアクセス
				/* レディ待ち */
				if (bus_rdy_ == `ENABLE_) begin // レディ到着
					if (rw == `READ) begin // 読み出しアクセス
						rd_data	 = bus_rd_data;
					end
				end else begin					// レディ未到着
					busy	 = `ENABLE;
				end
			end
			`BUS_IF_STATE_STALL	 : begin // ストール
				if (rw == `READ) begin // 読み出しアクセス
					rd_data	 = rd_buf;
				end
			end
		endcase
	end

   /********** バスインタフェースの状態制御 **********/ 
   always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* 非同期リセット */
			state		<= #1 `BUS_IF_STATE_IDLE;
			bus_req_	<= #1 `DISABLE_;
			bus_addr	<= #1 `WORD_ADDR_W'h0;
			bus_as_		<= #1 `DISABLE_;
			bus_rw		<= #1 `READ;
			bus_wr_data <= #1 `WORD_DATA_W'h0;
			rd_buf		<= #1 `WORD_DATA_W'h0;
		end else begin
			/* バスインタフェースの状態 */
			case (state)
				`BUS_IF_STATE_IDLE	 : begin // アイドル
					/* メモリアクセス */
					if ((flush == `DISABLE) && (as_ == `ENABLE_)) begin 
						/* アクセス先の選択 */
						if (s_index != `BUS_SLAVE_1) begin // バスへアクセス
							state		<= #1 `BUS_IF_STATE_REQ;
							bus_req_	<= #1 `ENABLE_;
							bus_addr	<= #1 addr;
							bus_rw		<= #1 rw;
							bus_wr_data <= #1 wr_data;
						end
					end
				end
				`BUS_IF_STATE_REQ	 : begin // バスリクエスト
					/* バスグラント待ち */
					if (bus_grnt_ == `ENABLE_) begin // バス権獲得
						state		<= #1 `BUS_IF_STATE_ACCESS;
						bus_as_		<= #1 `ENABLE_;
					end
				end
				`BUS_IF_STATE_ACCESS : begin // バスアクセス
					/* アドレスストローブのネゲート */
					bus_as_		<= #1 `DISABLE_;
					/* レディ待ち */
					if (bus_rdy_ == `ENABLE_) begin // レディ到着
						bus_req_	<= #1 `DISABLE_;
						bus_addr	<= #1 `WORD_ADDR_W'h0;
						bus_rw		<= #1 `READ;
						bus_wr_data <= #1 `WORD_DATA_W'h0;
						/* 読み出しデータの保存 */
						if (bus_rw == `READ) begin // 読み出しアクセス
							rd_buf		<= #1 bus_rd_data;
						end
						/* ストール発生のチェック */
						if (stall == `ENABLE) begin // ストール発生
							state		<= #1 `BUS_IF_STATE_STALL;
						end else begin				// ストール未発生
							state		<= #1 `BUS_IF_STATE_IDLE;
						end
					end
				end
				`BUS_IF_STATE_STALL	 : begin // ストール
					/* ストール発生のチェック */
					if (stall == `DISABLE) begin // ストール解除
						state		<= #1 `BUS_IF_STATE_IDLE;
					end
				end
			endcase
		end
	end

endmodule
