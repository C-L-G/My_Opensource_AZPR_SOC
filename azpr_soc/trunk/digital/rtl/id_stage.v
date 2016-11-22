/*
 -- ============================================================================
 -- FILE NAME	: id_stage.v
 -- DESCRIPTION : IDステージ
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
module id_stage (
	/********** クロック & リセット **********/
	input  wire					 clk,			 // クロック
	input  wire					 reset,			 // 非同期リセット
	/********** GPRインタフェース **********/
	input  wire [`WordDataBus]	 gpr_rd_data_0,	 // 読み出しデータ 0
	input  wire [`WordDataBus]	 gpr_rd_data_1,	 // 読み出しデータ 1
	output wire [`RegAddrBus]	 gpr_rd_addr_0,	 // 読み出しアドレス 0
	output wire [`RegAddrBus]	 gpr_rd_addr_1,	 // 読み出しアドレス 1
	/********** フォワーディング **********/
	// EXステージからのフォワーディング
	input  wire					 ex_en,			// パイプラインデータの有効
	input  wire [`WordDataBus]	 ex_fwd_data,	 // フォワーディングデータ
	input  wire [`RegAddrBus]	 ex_dst_addr,	 // 書き込みアドレス
	input  wire					 ex_gpr_we_,	 // 書き込み有効
	// MEMステージからのフォワーディング
	input  wire [`WordDataBus]	 mem_fwd_data,	 // フォワーディングデータ
	/********** 制御レジスタインタフェース **********/
	input  wire [`CpuExeModeBus] exe_mode,		 // 実行モード
	input  wire [`WordDataBus]	 creg_rd_data,	 // 読み出しデータ
	output wire [`RegAddrBus]	 creg_rd_addr,	 // 読み出しアドレス
	/********** パイプライン制御信号 **********/
	input  wire					 stall,			 // ストール
	input  wire					 flush,			 // フラッシュ
	output wire [`WordAddrBus]	 br_addr,		 // 分岐アドレス
	output wire					 br_taken,		 // 分岐の成立
	output wire					 ld_hazard,		 // ロードハザード
	/********** IF/IDパイプラインレジスタ **********/
	input  wire [`WordAddrBus]	 if_pc,			 // プログラムカウンタ
	input  wire [`WordDataBus]	 if_insn,		 // 命令
	input  wire					 if_en,			 // パイプラインデータの有効
	/********** ID/EXパイプラインレジスタ **********/
	output wire [`WordAddrBus]	 id_pc,			 // プログラムカウンタ
	output wire					 id_en,			 // パイプラインデータの有効
	output wire [`AluOpBus]		 id_alu_op,		 // ALUオペレーション
	output wire [`WordDataBus]	 id_alu_in_0,	 // ALU入力 0
	output wire [`WordDataBus]	 id_alu_in_1,	 // ALU入力 1
	output wire					 id_br_flag,	 // 分岐フラグ
	output wire [`MemOpBus]		 id_mem_op,		 // メモリオペレーション
	output wire [`WordDataBus]	 id_mem_wr_data, // メモリ書き込みデータ
	output wire [`CtrlOpBus]	 id_ctrl_op,	 // 制御オペレーション
	output wire [`RegAddrBus]	 id_dst_addr,	 // GPR書き込みアドレス
	output wire					 id_gpr_we_,	 // GPR書き込み有効
	output wire [`IsaExpBus]	 id_exp_code	 // 例外コード
);

	/********** デコード信号 **********/
	wire  [`AluOpBus]			 alu_op;		 // ALUオペレーション
	wire  [`WordDataBus]		 alu_in_0;		 // ALU入力 0
	wire  [`WordDataBus]		 alu_in_1;		 // ALU入力 1
	wire						 br_flag;		 // 分岐フラグ
	wire  [`MemOpBus]			 mem_op;		 // メモリオペレーション
	wire  [`WordDataBus]		 mem_wr_data;	 // メモリ書き込みデータ
	wire  [`CtrlOpBus]			 ctrl_op;		 // 制御オペレーション
	wire  [`RegAddrBus]			 dst_addr;		 // GPR書き込みアドレス
	wire						 gpr_we_;		 // GPR書き込み有効
	wire  [`IsaExpBus]			 exp_code;		 // 例外コード

	/********** デコーダ **********/
	decoder decoder (
		/********** IF/IDパイプラインレジスタ **********/
		.if_pc			(if_pc),		  // プログラムカウンタ
		.if_insn		(if_insn),		  // 命令
		.if_en			(if_en),		  // パイプラインデータの有効
		/********** GPRインタフェース **********/
		.gpr_rd_data_0	(gpr_rd_data_0),  // 読み出しデータ 0
		.gpr_rd_data_1	(gpr_rd_data_1),  // 読み出しデータ 1
		.gpr_rd_addr_0	(gpr_rd_addr_0),  // 読み出しアドレス 0
		.gpr_rd_addr_1	(gpr_rd_addr_1),  // 読み出しアドレス 1
		/********** フォワーディング **********/
		// IDステージからのフォワーディング
		.id_en			(id_en),		  // パイプラインデータの有効
		.id_dst_addr	(id_dst_addr),	  // 書き込みアドレス
		.id_gpr_we_		(id_gpr_we_),	  // 書き込み有効
		.id_mem_op		(id_mem_op),	  // メモリオペレーション
		// EXステージからのフォワーディング
		.ex_en			(ex_en),		  // パイプラインデータの有効
		.ex_fwd_data	(ex_fwd_data),	  // フォワーディングデータ
		.ex_dst_addr	(ex_dst_addr),	  // 書き込みアドレス
		.ex_gpr_we_		(ex_gpr_we_),	  // 書き込み有効
		// MEMステージからのフォワーディング
		.mem_fwd_data	(mem_fwd_data),	  // フォワーディングデータ
		/********** 制御レジスタインタフェース **********/
		.exe_mode		(exe_mode),		  // 実行モード
		.creg_rd_data	(creg_rd_data),	  // 読み出しデータ
		.creg_rd_addr	(creg_rd_addr),	  // 読み出しアドレス
		/********** デコード信号 **********/
		.alu_op			(alu_op),		  // ALUオペレーション
		.alu_in_0		(alu_in_0),		  // ALU入力 0
		.alu_in_1		(alu_in_1),		  // ALU入力 1
		.br_addr		(br_addr),		  // 分岐アドレス
		.br_taken		(br_taken),		  // 分岐の成立
		.br_flag		(br_flag),		  // 分岐フラグ
		.mem_op			(mem_op),		  // メモリオペレーション
		.mem_wr_data	(mem_wr_data),	  // メモリ書き込みデータ
		.ctrl_op		(ctrl_op),		  // 制御オペレーション
		.dst_addr		(dst_addr),		  // 汎用レジスタ書き込みアドレス
		.gpr_we_		(gpr_we_),		  // 汎用レジスタ書き込み有効
		.exp_code		(exp_code),		  // 例外コード
		.ld_hazard		(ld_hazard)		  // ロードハザード
	);

	/********** パイプラインレジスタ **********/
	id_reg id_reg (
		/********** クロック & リセット **********/
		.clk			(clk),			  // クロック
		.reset			(reset),		  // 非同期リセット
		/********** デコード結果 **********/
		.alu_op			(alu_op),		  // ALUオペレーション
		.alu_in_0		(alu_in_0),		  // ALU入力 0
		.alu_in_1		(alu_in_1),		  // ALU入力 1
		.br_flag		(br_flag),		  // 分岐フラグ
		.mem_op			(mem_op),		  // メモリオペレーション
		.mem_wr_data	(mem_wr_data),	  // メモリ書き込みデータ
		.ctrl_op		(ctrl_op),		  // 制御オペレーション
		.dst_addr		(dst_addr),		  // 汎用レジスタ書き込みアドレス
		.gpr_we_		(gpr_we_),		  // 汎用レジスタ書き込み有効
		.exp_code		(exp_code),		  // 例外コード
		/********** パイプライン制御信号 **********/
		.stall			(stall),		  // ストール
		.flush			(flush),		  // フラッシュ
		/********** IF/IDパイプラインレジスタ **********/
		.if_pc			(if_pc),		  // プログラムカウンタ
		.if_en			(if_en),		  // パイプラインデータの有効
		/********** ID/EXパイプラインレジスタ **********/
		.id_pc			(id_pc),		  // プログラムカウンタ
		.id_en			(id_en),		  // パイプラインデータの有効
		.id_alu_op		(id_alu_op),	  // ALUオペレーション
		.id_alu_in_0	(id_alu_in_0),	  // ALU入力 0
		.id_alu_in_1	(id_alu_in_1),	  // ALU入力 1
		.id_br_flag		(id_br_flag),	  // 分岐フラグ
		.id_mem_op		(id_mem_op),	  // メモリオペレーション
		.id_mem_wr_data (id_mem_wr_data), // メモリ書き込みデータ
		.id_ctrl_op		(id_ctrl_op),	  // 制御オペレーション
		.id_dst_addr	(id_dst_addr),	  // 汎用レジスタ書き込みアドレス
		.id_gpr_we_		(id_gpr_we_),	  // 汎用レジスタ書き込み有効
		.id_exp_code	(id_exp_code)	  // 例外コード
	);

endmodule
