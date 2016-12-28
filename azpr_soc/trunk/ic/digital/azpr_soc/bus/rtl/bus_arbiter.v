/*
 -- ============================================================================
 -- FILE	 : bus_arbiter.v
 -- SYNOPSIS : バスアービタ
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
`include "bus.h"

/********** モジュール **********/
module bus_arbiter (
	/********** クロック & リセット **********/
	input  wire		   clk,		 // クロック
	input  wire		   reset,	 // 非同期リセット
	/********** アービトレーション信号 **********/
	// バスマスタ0番
	input  wire		   m0_req_,	 // バスリクエスト
	output reg		   m0_grnt_, // バスグラント
	// バスマスタ1番
	input  wire		   m1_req_,	 // バスリクエスト
	output reg		   m1_grnt_, // バスグラント
	// バスマスタ2番
	input  wire		   m2_req_,	 // バスリクエスト
	output reg		   m2_grnt_, // バスグラント
	// バスマスタ3番
	input  wire		   m3_req_,	 // バスリクエスト
	output reg		   m3_grnt_	 // バスグラント
);

	/********** 内部信号 **********/
	reg [`BusOwnerBus] owner;	 // バス権の所有者
   
	/********** バスグラントの生成 **********/
	always @(*) begin
		/* バスグラントの初期化 */
		m0_grnt_ = `DISABLE_;
		m1_grnt_ = `DISABLE_;
		m2_grnt_ = `DISABLE_;
		m3_grnt_ = `DISABLE_;
		/* バスグラントの生成 */
		case (owner)
			`BUS_OWNER_MASTER_0 : begin // バスマスタ0番
				m0_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_1 : begin // バスマスタ1番
				m1_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_2 : begin // バスマスタ2番
				m2_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_3 : begin // バスマスタ3番
				m3_grnt_ = `ENABLE_;
			end
		endcase
	end
   
	/********** バス権のアービトレーション **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* 非同期リセット */
			owner <= #1 `BUS_OWNER_MASTER_0;
		end else begin
			/* アービトレーション */
			case (owner)
				`BUS_OWNER_MASTER_0 : begin // バス権所有者：バスマスタ0番
					/* 次にバス権を獲得するマスタ */
					if (m0_req_ == `ENABLE_) begin			// バスマスタ0番
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // バスマスタ1番
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // バスマスタ2番
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // バスマスタ3番
						owner <= #1 `BUS_OWNER_MASTER_3;
					end
				end
				`BUS_OWNER_MASTER_1 : begin // バス権所有者：バスマスタ1番
					/* 次にバス権を獲得するマスタ */
					if (m1_req_ == `ENABLE_) begin			// バスマスタ1番
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // バスマスタ2番
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // バスマスタ3番
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // バスマスタ0番
						owner <= #1 `BUS_OWNER_MASTER_0;
					end
				end
				`BUS_OWNER_MASTER_2 : begin // バス権所有者：バスマスタ2番
					/* 次にバス権を獲得するマスタ */
					if (m2_req_ == `ENABLE_) begin			// バスマスタ2番
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // バスマスタ3番
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // バスマスタ0番
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // バスマスタ1番
						owner <= #1 `BUS_OWNER_MASTER_1;
					end
				end
				`BUS_OWNER_MASTER_3 : begin // バス権所有者：バスマスタ3番
					/* 次にバス権を獲得するマスタ */
					if (m3_req_ == `ENABLE_) begin			// バスマスタ3番
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // バスマスタ0番
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // バスマスタ1番
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // バスマスタ2番
						owner <= #1 `BUS_OWNER_MASTER_2;
					end
				end
			endcase
		end
	end

endmodule
