/*
 -- ============================================================================
 -- FILE NAME	: bus.h
 -- DESCRIPTION : バスヘッダ
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 新規作成
 -- ============================================================================
*/

`ifndef __BUS_HEADER__
	`define __BUS_HEADER__			 // インクルードガード

	/********** バスマスタ *********/
	`define BUS_MASTER_CH	   4	 // バスマスタチャネル数
	`define BUS_MASTER_INDEX_W 2	 // バスマスタインデックス幅

	/********** バス権の所有者 *********/
	`define BusOwnerBus		   1:0	 // バス権状態バス
	`define BUS_OWNER_MASTER_0 2'h0	 // バス権の所有者 ： バスマスタ0番
	`define BUS_OWNER_MASTER_1 2'h1	 // バス権の所有者 ： バスマスタ1番
	`define BUS_OWNER_MASTER_2 2'h2	 // バス権の所有者 ： バスマスタ2番
	`define BUS_OWNER_MASTER_3 2'h3	 // バス権の所有者 ： バスマスタ3番

	/********** バススレーブ *********/
	`define BUS_SLAVE_CH	   8	 // バススレーブチャネル数
	`define BUS_SLAVE_INDEX_W  3	 // バススレーブインデックス幅
	`define BusSlaveIndexBus   2:0	 // バススレーブインデックスバス
	`define BusSlaveIndexLoc   29:27 // バススレーブインデックスの位置

	`define BUS_SLAVE_0		   0	 // バススレーブ0番
	`define BUS_SLAVE_1		   1	 // バススレーブ1番
	`define BUS_SLAVE_2		   2	 // バススレーブ2番
	`define BUS_SLAVE_3		   3	 // バススレーブ3番
	`define BUS_SLAVE_4		   4	 // バススレーブ4番
	`define BUS_SLAVE_5		   5	 // バススレーブ5番
	`define BUS_SLAVE_6		   6	 // バススレーブ6番
	`define BUS_SLAVE_7		   7	 // バススレーブ7番

`endif
