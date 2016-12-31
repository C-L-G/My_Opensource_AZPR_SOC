/*
 -- ============================================================================
 -- FILE NAME	: bus_addr_dec.v
 -- DESCRIPTION : アドレスデコーダ
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
module bus_addr_dec (
	/********** アドレス **********/
	input  wire [`WordAddrBus] s_addr, // アドレス
	/********** チップセレクト **********/
	output reg				   s0_cs_, // バススレーブ0番
	output reg				   s1_cs_, // バススレーブ1番
	output reg				   s2_cs_, // バススレーブ2番
	output reg				   s3_cs_, // バススレーブ3番
	output reg				   s4_cs_, // バススレーブ4番
	output reg				   s5_cs_, // バススレーブ5番
	output reg				   s6_cs_, // バススレーブ6番
	output reg				   s7_cs_  // バススレーブ7番
);

	/********** バススレーブインデックス **********/
	wire [`BusSlaveIndexBus] s_index = s_addr[`BusSlaveIndexLoc];

	/********** バススレーブマルチプレクサ **********/
	always @(*) begin
		/* チップセレクトの初期化 */
		s0_cs_ = `DISABLE_;
		s1_cs_ = `DISABLE_;
		s2_cs_ = `DISABLE_;
		s3_cs_ = `DISABLE_;
		s4_cs_ = `DISABLE_;
		s5_cs_ = `DISABLE_;
		s6_cs_ = `DISABLE_;
		s7_cs_ = `DISABLE_;
		/* アドレスに対応するスレーブの選択 */
		case (s_index)
			`BUS_SLAVE_0 : begin // バススレーブ0番
				s0_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_1 : begin // バススレーブ1番
				s1_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_2 : begin // バススレーブ2番
				s2_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_3 : begin // バススレーブ3番
				s3_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_4 : begin // バススレーブ4番
				s4_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_5 : begin // バススレーブ5番
				s5_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_6 : begin // バススレーブ6番
				s6_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_7 : begin // バススレーブ7番
				s7_cs_	= `ENABLE_;
			end
		endcase
	end

endmodule
