/* 
 -- ============================================================================
 -- FILE NAME	: cpu.h
 -- DESCRIPTION : CPUヘッダ
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 新規作成
 -- ============================================================================
*/

`ifndef __CPU_HEADER__
	`define __CPU_HEADER__	// インクルードガード

//------------------------------------------------------------------------------
// Operation
//------------------------------------------------------------------------------
	/********** レジスタ **********/
	`define REG_NUM				 32	  // レジスタ数
	`define REG_ADDR_W			 5	  // レジスタアドレス幅
	`define RegAddrBus			 4:0  // レジスタアドレスバス
	/********** 割り込み要求信号 **********/
	`define CPU_IRQ_CH			 8	  // IRQ幅
	/********** ALUオペコード **********/
	// バス
	`define ALU_OP_W			 4	  // ALUオペコード幅
	`define AluOpBus			 3:0  // ALUオペコードバス
	// オペコード
	`define ALU_OP_NOP			 4'h0 // No Operation
	`define ALU_OP_AND			 4'h1 // AND
	`define ALU_OP_OR			 4'h2 // OR
	`define ALU_OP_XOR			 4'h3 // XOR
	`define ALU_OP_ADDS			 4'h4 // 符号付き加算
	`define ALU_OP_ADDU			 4'h5 // 符号なし加算
	`define ALU_OP_SUBS			 4'h6 // 符号付き減算
	`define ALU_OP_SUBU			 4'h7 // 符号なし減算
	`define ALU_OP_SHRL			 4'h8 // 論理右シフト
	`define ALU_OP_SHLL			 4'h9 // 論理左シフト
	/********** メモリオペコード **********/
	// バス
	`define MEM_OP_W			 2	  // メモリオペコード幅
	`define MemOpBus			 1:0  // メモリオペコードバス
	// オペコード
	`define MEM_OP_NOP			 2'h0 // No Operation
	`define MEM_OP_LDW			 2'h1 // ワード読み出し
	`define MEM_OP_STW			 2'h2 // ワード書き込み
	/********** 制御オペコード **********/
	// バス
	`define CTRL_OP_W			 2	  // 制御オペコード幅
	`define CtrlOpBus			 1:0  // 制御オペコードバス
	// オペコード
	`define CTRL_OP_NOP			 2'h0 // No Operation
	`define CTRL_OP_WRCR		 2'h1 // 制御レジスタへの書き込み
	`define CTRL_OP_EXRT		 2'h2 // 例外からの復帰

	/********** 実行モード **********/
	// バス
	`define CPU_EXE_MODE_W		 1	  // 実行モード幅
	`define CpuExeModeBus		 0:0  // 実行モードバス
	// 実行モード
	`define CPU_KERNEL_MODE		 1'b0 // カーネルモード
	`define CPU_USER_MODE		 1'b1 // ユーザモード

//------------------------------------------------------------------------------
// 制御レジスタ
//------------------------------------------------------------------------------
	/********** アドレスマップ **********/
	`define CREG_ADDR_STATUS	 5'h0  // ステータス
	`define CREG_ADDR_PRE_STATUS 5'h1  // 前のステータス
	`define CREG_ADDR_PC		 5'h2  // プログラムカウンタ
	`define CREG_ADDR_EPC		 5'h3  // 例外プログラムカウンタ
	`define CREG_ADDR_EXP_VECTOR 5'h4  // 例外ベクタ
	`define CREG_ADDR_CAUSE		 5'h5  // 例外原因レジスタ
	`define CREG_ADDR_INT_MASK	 5'h6  // 割り込みマスク
	`define CREG_ADDR_IRQ		 5'h7  // 割り込み要求
	// 読み出し専用領域
	`define CREG_ADDR_ROM_SIZE	 5'h1d // ROMサイズ
	`define CREG_ADDR_SPM_SIZE	 5'h1e // SPMサイズ
	`define CREG_ADDR_CPU_INFO	 5'h1f // CPU情報
	/********** ビットマップ **********/
	`define CregExeModeLoc		 0	   // 実行モードの位置
	`define CregIntEnableLoc	 1	   // 割り込み有効の位置
	`define CregExpCodeLoc		 2:0   // 例外コードの位置
	`define CregDlyFlagLoc		 3	   // ディレイスロットフラグの位置

//------------------------------------------------------------------------------
// バスインタフェース
//------------------------------------------------------------------------------
	/********** バスインタフェースの状態 **********/
	// バス
	`define BusIfStateBus		 1:0   // 状態バス
	// 状態
	`define BUS_IF_STATE_IDLE	 2'h0  // アイドル
	`define BUS_IF_STATE_REQ	 2'h1  // バスリクエスト
	`define BUS_IF_STATE_ACCESS	 2'h2  // バスアクセス
	`define BUS_IF_STATE_STALL	 2'h3  // ストール

//------------------------------------------------------------------------------
// MISC
//------------------------------------------------------------------------------
	/********** ベクタ **********/
	`define RESET_VECTOR		 30'h0 // リセットベクタ
	/********** シフト量 **********/
	`define ShAmountBus			 4:0   // シフト量バス
	`define ShAmountLoc			 4:0   // シフト量の位置

	/********** CPU情報 *********/
	`define RELEASE_YEAR		 8'd41 // 作成年 (YYYY - 1970)
	`define RELEASE_MONTH		 8'd7  // 作成月
	`define RELEASE_VERSION		 8'd1  // バージョン
	`define RELEASE_REVISION	 8'd0  // リビジョン


`endif
