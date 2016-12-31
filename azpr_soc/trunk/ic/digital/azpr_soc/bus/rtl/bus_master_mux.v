/*
 -- ============================================================================
 -- FILE NAME	: bus_master_mux.v
 -- DESCRIPTION : バスマスタマルチプレクサ
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
module bus_master_mux (
	/********** バスマスタ信号 **********/
	// バスマスタ0番
	input  wire [`WordAddrBus] m0_addr,	   // アドレス
	input  wire				   m0_as_,	   // アドレスストローブ
	input  wire				   m0_rw,	   // 読み／書き
	input  wire [`WordDataBus] m0_wr_data, // 書き込みデータ
	input  wire				   m0_grnt_,   // バスグラント
	// バスマスタ1番
	input  wire [`WordAddrBus] m1_addr,	   // アドレス
	input  wire				   m1_as_,	   // アドレスストローブ
	input  wire				   m1_rw,	   // 読み／書き
	input  wire [`WordDataBus] m1_wr_data, // 書き込みデータ
	input  wire				   m1_grnt_,   // バスグラント
	// バスマスタ2番
	input  wire [`WordAddrBus] m2_addr,	   // アドレス
	input  wire				   m2_as_,	   // アドレスストローブ
	input  wire				   m2_rw,	   // 読み／書き
	input  wire [`WordDataBus] m2_wr_data, // 書き込みデータ
	input  wire				   m2_grnt_,   // バスグラント
	// バスマスタ3番
	input  wire [`WordAddrBus] m3_addr,	   // アドレス
	input  wire				   m3_as_,	   // アドレスストローブ
	input  wire				   m3_rw,	   // 読み／書き
	input  wire [`WordDataBus] m3_wr_data, // 書き込みデータ
	input  wire				   m3_grnt_,   // バスグラント
	/********** バススレーブ共通信号 **********/
	output reg	[`WordAddrBus] s_addr,	   // アドレス
	output reg				   s_as_,	   // アドレスストローブ
	output reg				   s_rw,	   // 読み／書き
	output reg	[`WordDataBus] s_wr_data   // 書き込みデータ
);

	/********** バスマスタマルチプレクサ **********/
	always @(*) begin
		/* バス権を持っているマスタの選択 */
		if (m0_grnt_ == `ENABLE_) begin			 // バスマスタ0番
			s_addr	  = m0_addr;
			s_as_	  = m0_as_;
			s_rw	  = m0_rw;
			s_wr_data = m0_wr_data;
		end else if (m1_grnt_ == `ENABLE_) begin // バスマスタ0番
			s_addr	  = m1_addr;
			s_as_	  = m1_as_;
			s_rw	  = m1_rw;
			s_wr_data = m1_wr_data;
		end else if (m2_grnt_ == `ENABLE_) begin // バスマスタ0番
			s_addr	  = m2_addr;
			s_as_	  = m2_as_;
			s_rw	  = m2_rw;
			s_wr_data = m2_wr_data;
		end else if (m3_grnt_ == `ENABLE_) begin // バスマスタ0番
			s_addr	  = m3_addr;
			s_as_	  = m3_as_;
			s_rw	  = m3_rw;
			s_wr_data = m3_wr_data;
		end else begin							 // デフォルト値
			s_addr	  = `WORD_ADDR_W'h0;
			s_as_	  = `DISABLE_;
			s_rw	  = `READ;
			s_wr_data = `WORD_DATA_W'h0;
		end
	end

endmodule
