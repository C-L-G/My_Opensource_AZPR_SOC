/*
 -- ============================================================================
 -- FILE NAME	: bus_slave_mux.v
 -- DESCRIPTION : バススレーブマルチプレクサ
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
module bus_slave_mux (
	/********** チップセレクト **********/
	input  wire				   s0_cs_,	   // バススレーブ0番
	input  wire				   s1_cs_,	   // バススレーブ1番
	input  wire				   s2_cs_,	   // バススレーブ2番
	input  wire				   s3_cs_,	   // バススレーブ3番
	input  wire				   s4_cs_,	   // バススレーブ4番
	input  wire				   s5_cs_,	   // バススレーブ5番
	input  wire				   s6_cs_,	   // バススレーブ6番
	input  wire				   s7_cs_,	   // バススレーブ7番
	/********** バススレーブ信号 **********/
	// バススレーブ0番
	input  wire [`WordDataBus] s0_rd_data, // 読み出しデータ
	input  wire				   s0_rdy_,	   // レディ
	// バススレーブ1番
	input  wire [`WordDataBus] s1_rd_data, // 読み出しデータ
	input  wire				   s1_rdy_,	   // レディ
	// バススレーブ2番
	input  wire [`WordDataBus] s2_rd_data, // 読み出しデータ
	input  wire				   s2_rdy_,	   // レディ
	// バススレーブ3番
	input  wire [`WordDataBus] s3_rd_data, // 読み出しデータ
	input  wire				   s3_rdy_,	   // レディ
	// バススレーブ4番
	input  wire [`WordDataBus] s4_rd_data, // 読み出しデータ
	input  wire				   s4_rdy_,	   // レディ
	// バススレーブ5番
	input  wire [`WordDataBus] s5_rd_data, // 読み出しデータ
	input  wire				   s5_rdy_,	   // レディ
	// バススレーブ6番
	input  wire [`WordDataBus] s6_rd_data, // 読み出しデータ
	input  wire				   s6_rdy_,	   // レディ
	// バススレーブ7番
	input  wire [`WordDataBus] s7_rd_data, // 読み出しデータ
	input  wire				   s7_rdy_,	   // レディ
	/********** バスマスタ共通信号 **********/
	output reg	[`WordDataBus] m_rd_data,  // 読み出しデータ
	output reg				   m_rdy_	   // レディ
);

	/********** バススレーブマルチプレクサ **********/
	always @(*) begin
		/* チップセレクトに対応するスレーブの選択 */
		if (s0_cs_ == `ENABLE_) begin		   // バススレーブ0番
			m_rd_data = s0_rd_data;
			m_rdy_	  = s0_rdy_;
		end else if (s1_cs_ == `ENABLE_) begin // バススレーブ1番
			m_rd_data = s1_rd_data;
			m_rdy_	  = s1_rdy_;
		end else if (s2_cs_ == `ENABLE_) begin // バススレーブ2番
			m_rd_data = s2_rd_data;
			m_rdy_	  = s2_rdy_;
		end else if (s3_cs_ == `ENABLE_) begin // バススレーブ3番
			m_rd_data = s3_rd_data;
			m_rdy_	  = s3_rdy_;
		end else if (s4_cs_ == `ENABLE_) begin // バススレーブ4番
			m_rd_data = s4_rd_data;
			m_rdy_	  = s4_rdy_;
		end else if (s5_cs_ == `ENABLE_) begin // バススレーブ5番
			m_rd_data = s5_rd_data;
			m_rdy_	  = s5_rdy_;
		end else if (s6_cs_ == `ENABLE_) begin // バススレーブ6番
			m_rd_data = s6_rd_data;
			m_rdy_	  = s6_rdy_;
		end else if (s7_cs_ == `ENABLE_) begin // バススレーブ7番
			m_rd_data = s7_rd_data;
			m_rdy_	  = s7_rdy_;
		end else begin						   // デフォルト値
			m_rd_data = `WORD_DATA_W'h0;
			m_rdy_	  = `DISABLE_;
		end
	end

endmodule
