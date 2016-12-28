/*
 -- ============================================================================
 -- FILE NAME	: mem_reg.v
 -- DESCRIPTION : MEMステージパイプラインレジスタ
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
`include "isa.h"
`include "cpu.h"

/********** モジュール **********/
module mem_reg (
	/********** クロック & リセット **********/
	input  wire				   clk,			 // クロック
	input  wire				   reset,		 // 非同期リセット
	/********** メモリアクセス結果 **********/
	input  wire [`WordDataBus] out,			 // メモリアクセス結果
	input  wire				   miss_align,	 // ミスアライン
	/********** パイプライン制御信号 **********/
	input  wire				   stall,		 // ストール
	input  wire				   flush,		 // フラッシュ
	/********** EX/MEMパイプラインレジスタ **********/
	input  wire [`WordAddrBus] ex_pc,		 // プログランカウンタ
	input  wire				   ex_en,		 // パイプラインデータの有効
	input  wire				   ex_br_flag,	 // 分岐フラグ
	input  wire [`CtrlOpBus]   ex_ctrl_op,	 // 制御レジスタオペレーション
	input  wire [`RegAddrBus]  ex_dst_addr,	 // 汎用レジスタ書き込みアドレス
	input  wire				   ex_gpr_we_,	 // 汎用レジスタ書き込み有効
	input  wire [`IsaExpBus]   ex_exp_code,	 // 例外コード
	/********** MEM/WBパイプラインレジスタ **********/
	output reg	[`WordAddrBus] mem_pc,		 // プログランカウンタ
	output reg				   mem_en,		 // パイプラインデータの有効
	output reg				   mem_br_flag,	 // 分岐フラグ
	output reg	[`CtrlOpBus]   mem_ctrl_op,	 // 制御レジスタオペレーション
	output reg	[`RegAddrBus]  mem_dst_addr, // 汎用レジスタ書き込みアドレス
	output reg				   mem_gpr_we_,	 // 汎用レジスタ書き込み有効
	output reg	[`IsaExpBus]   mem_exp_code, // 例外コード
	output reg	[`WordDataBus] mem_out		 // 処理結果
);

	/********** パイプラインレジスタ **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin	 
			/* 非同期リセット */
			mem_pc		 <= #1 `WORD_ADDR_W'h0;
			mem_en		 <= #1 `DISABLE;
			mem_br_flag	 <= #1 `DISABLE;
			mem_ctrl_op	 <= #1 `CTRL_OP_NOP;
			mem_dst_addr <= #1 `REG_ADDR_W'h0;
			mem_gpr_we_	 <= #1 `DISABLE_;
			mem_exp_code <= #1 `ISA_EXP_NO_EXP;
			mem_out		 <= #1 `WORD_DATA_W'h0;
		end else begin
			if (stall == `DISABLE) begin 
				/* パイプラインレジスタの更新 */
				if (flush == `ENABLE) begin				  // フラッシュ
					mem_pc		 <= #1 `WORD_ADDR_W'h0;
					mem_en		 <= #1 `DISABLE;
					mem_br_flag	 <= #1 `DISABLE;
					mem_ctrl_op	 <= #1 `CTRL_OP_NOP;
					mem_dst_addr <= #1 `REG_ADDR_W'h0;
					mem_gpr_we_	 <= #1 `DISABLE_;
					mem_exp_code <= #1 `ISA_EXP_NO_EXP;
					mem_out		 <= #1 `WORD_DATA_W'h0;
				end else if (miss_align == `ENABLE) begin // ミスアライン例外
					mem_pc		 <= #1 ex_pc;
					mem_en		 <= #1 ex_en;
					mem_br_flag	 <= #1 ex_br_flag;
					mem_ctrl_op	 <= #1 `CTRL_OP_NOP;
					mem_dst_addr <= #1 `REG_ADDR_W'h0;
					mem_gpr_we_	 <= #1 `DISABLE_;
					mem_exp_code <= #1 `ISA_EXP_MISS_ALIGN;
					mem_out		 <= #1 `WORD_DATA_W'h0;
				end else begin							  // 次のデータ
					mem_pc		 <= #1 ex_pc;
					mem_en		 <= #1 ex_en;
					mem_br_flag	 <= #1 ex_br_flag;
					mem_ctrl_op	 <= #1 ex_ctrl_op;
					mem_dst_addr <= #1 ex_dst_addr;
					mem_gpr_we_	 <= #1 ex_gpr_we_;
					mem_exp_code <= #1 ex_exp_code;
					mem_out		 <= #1 out;
				end
			end
		end
	end

endmodule
