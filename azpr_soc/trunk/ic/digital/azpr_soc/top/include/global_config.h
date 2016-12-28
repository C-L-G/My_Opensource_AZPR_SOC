/*
 -- ============================================================================
 -- FILE NAME	: global_config.h
 -- DESCRIPTION : 全体設定
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 新規作成
 -- ============================================================================
*/

`ifndef __GLOBAL_CONFIG_HEADER__
	`define __GLOBAL_CONFIG_HEADER__	// インクルードガード

//------------------------------------------------------------------------------
// 設定項目
//------------------------------------------------------------------------------
	/********** ターゲットデバイス : いずれか1つを選択 **********/
//	`define TARGET_DEV_MFPGA_SPAR3E		// マルツ評価ボード
	`define TARGET_DEV_AZPR_EV_BOARD	// AZPRオリジナル評価ボード

	/********** リセット極性 : いずれか1つを選択 **********/
//	`define POSITIVE_RESET				// Active High
	`define NEGATIVE_RESET				// Active Low

	/********** メモリ制御信号の極性 : いずれか1つを選択 **********/
	`define POSITIVE_MEMORY				// Active High
//	`define NEGATIVE_MEMORY				// Active Low

	/********** I/O設定 : 実装するI/Oを定義**********/
	`define IMPLEMENT_TIMER				// タイマ
	`define IMPLEMENT_UART				// UART
	`define IMPLEMENT_GPIO				// General Purpose I/O

//------------------------------------------------------------------------------
// 設定に応じてパラメータを生成
//------------------------------------------------------------------------------
	/********** リセット極性 *********/
	// Active Low
	`ifdef POSITIVE_RESET
		`define RESET_EDGE	  posedge	// リセットエッジ
		`define RESET_ENABLE  1'b1		// リセット有効
		`define RESET_DISABLE 1'b0		// リセット無効
	`endif
	// Active High
	`ifdef NEGATIVE_RESET
		`define RESET_EDGE	  negedge	// リセットエッジ
		`define RESET_ENABLE  1'b0		// リセット有効
		`define RESET_DISABLE 1'b1		// リセット無効
	`endif

	/********** メモリ制御信号の極性 *********/
	// Actoive High
	`ifdef POSITIVE_MEMORY
		`define MEM_ENABLE	  1'b1		// メモリ有効
		`define MEM_DISABLE	  1'b0		// メモリ無効
	`endif
	// Active Low
	`ifdef NEGATIVE_MEMORY
		`define MEM_ENABLE	  1'b0		// メモリ有効
		`define MEM_DISABLE	  1'b1		// メモリ無効
	`endif

`endif
