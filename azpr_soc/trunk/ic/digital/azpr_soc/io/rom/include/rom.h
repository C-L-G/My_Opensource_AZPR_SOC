/*
 -- ============================================================================
 -- FILE NAME	: rom.h
 -- DESCRIPTION : ROM ヘッダ
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 新規作成
 -- ============================================================================
*/

`ifndef __ROM_HEADER__
	`define __ROM_HEADER__			  // インクルードガード

	`define ROM_SIZE   8192	// ROMのサイズ
	`define ROM_DEPTH  2048	// ROMの深さ
	`define ROM_ADDR_W 11	// アドレス幅
	`define RomAddrBus 10:0 // アドレスバス
	`define RomAddrLoc 10:0 // アドレスの位置

`endif
