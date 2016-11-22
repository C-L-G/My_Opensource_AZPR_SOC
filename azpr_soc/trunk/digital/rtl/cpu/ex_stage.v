/*
 -- ============================================================================
 -- FILE NAME	: ex_stage.v
 -- DESCRIPTION : EXステージ
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
module ex_stage (
	/********** クロック & リセット **********/
	input  wire				   clk,			   // クロック
	input  wire				   reset,		   // 非同期リセット
	/********** パイプライン制御信号 **********/
	input  wire				   stall,		   // ストール
	input  wire				   flush,		   // フラッシュ
	input  wire				   int_detect,	   // 割り込み検出
	/********** フォワーディング **********/
	output wire [`WordDataBus] fwd_data,	   // フォワーディングデータ
	/********** ID/EXパイプラインレジスタ **********/
	input  wire [`WordAddrBus] id_pc,		   // プログラムカウンタ
	input  wire				   id_en,		   // パイプラインデータの有効
	input  wire [`AluOpBus]	   id_alu_op,	   // ALUオペレーション
	input  wire [`WordDataBus] id_alu_in_0,	   // ALU入力 0
	input  wire [`WordDataBus] id_alu_in_1,	   // ALU入力 1
	input  wire				   id_br_flag,	   // 分岐フラグ
	input  wire [`MemOpBus]	   id_mem_op,	   // メモリオペレーション
	input  wire [`WordDataBus] id_mem_wr_data, // メモリ書き込みデータ
	input  wire [`CtrlOpBus]   id_ctrl_op,	   // 制御レジスタオペレーション
	input  wire [`RegAddrBus]  id_dst_addr,	   // 汎用レジスタ書き込みアドレス
	input  wire				   id_gpr_we_,	   // 汎用レジスタ書き込み有効
	input  wire [`IsaExpBus]   id_exp_code,	   // 例外コード
	/********** EX/MEMパイプラインレジスタ **********/
	output wire [`WordAddrBus] ex_pc,		   // プログラムカウンタ
	output wire				   ex_en,		   // パイプラインデータの有効
	output wire				   ex_br_flag,	   // 分岐フラグ
	output wire [`MemOpBus]	   ex_mem_op,	   // メモリオペレーション
	output wire [`WordDataBus] ex_mem_wr_data, // メモリ書き込みデータ
	output wire [`CtrlOpBus]   ex_ctrl_op,	   // 制御レジスタオペレーション
	output wire [`RegAddrBus]  ex_dst_addr,	   // 汎用レジスタ書き込みアドレス
	output wire				   ex_gpr_we_,	   // 汎用レジスタ書き込み有効
	output wire [`IsaExpBus]   ex_exp_code,	   // 例外コード
	output wire [`WordDataBus] ex_out		   // 処理結果
);

	/********** ALUの出力 **********/
	wire [`WordDataBus]		   alu_out;		   // 演算結果
	wire					   alu_of;		   // オーバフロー

	/********** 演算結果のフォワーディング **********/
	assign fwd_data = alu_out;

	/********** ALU **********/
	alu alu (
		.in_0			(id_alu_in_0),	  // 入力 0
		.in_1			(id_alu_in_1),	  // 入力 1
		.op				(id_alu_op),	  // オペレーション
		.out			(alu_out),		  // 出力
		.of				(alu_of)		  // オーバフロー
	);

	/********** パイプラインレジスタ **********/
	ex_reg ex_reg (
		/********** クロック & リセット **********/
		.clk			(clk),			  // クロック
		.reset			(reset),		  // 非同期リセット
		/********** ALUの出力 **********/
		.alu_out		(alu_out),		  // 演算結果
		.alu_of			(alu_of),		  // オーバフロー
		/********** パイプライン制御信号 **********/
		.stall			(stall),		  // ストール
		.flush			(flush),		  // フラッシュ
		.int_detect		(int_detect),	  // 割り込み検出
		/********** ID/EXパイプラインレジスタ **********/
		.id_pc			(id_pc),		  // プログラムカウンタ
		.id_en			(id_en),		  // パイプラインデータの有効
		.id_br_flag		(id_br_flag),	  // 分岐フラグ
		.id_mem_op		(id_mem_op),	  // メモリオペレーション
		.id_mem_wr_data (id_mem_wr_data), // メモリ書き込みデータ
		.id_ctrl_op		(id_ctrl_op),	  // 制御レジスタオペレーション
		.id_dst_addr	(id_dst_addr),	  // 汎用レジスタ書き込みアドレス
		.id_gpr_we_		(id_gpr_we_),	  // 汎用レジスタ書き込み有効
		.id_exp_code	(id_exp_code),	  // 例外コード
		/********** EX/MEMパイプラインレジスタ **********/
		.ex_pc			(ex_pc),		  // プログラムカウンタ
		.ex_en			(ex_en),		  // パイプラインデータの有効
		.ex_br_flag		(ex_br_flag),	  // 分岐フラグ
		.ex_mem_op		(ex_mem_op),	  // メモリオペレーション
		.ex_mem_wr_data (ex_mem_wr_data), // メモリ書き込みデータ
		.ex_ctrl_op		(ex_ctrl_op),	  // 制御レジスタオペレーション
		.ex_dst_addr	(ex_dst_addr),	  // 汎用レジスタ書き込みアドレス
		.ex_gpr_we_		(ex_gpr_we_),	  // 汎用レジスタ書き込み有効
		.ex_exp_code	(ex_exp_code),	  // 例外コード
		.ex_out			(ex_out)		  // 処理結果
	);

endmodule
