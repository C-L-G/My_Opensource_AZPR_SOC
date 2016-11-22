/*
 -- ============================================================================
 -- FILE NAME	: uart.h
 -- DESCRIPTION : UARTヘッダ
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 新規作成
 -- ============================================================================
*/

`ifndef __UART_HEADER__
	`define __UART_HEADER__			// インクルードガード

/*
 * 【分周について】
 * ・UARTはチップ全体の基底周波数をもとにボーレートを生成しています。
 *	 基底周波数やボーレートを変更する場合は、
 *	 UART_DIV_RATEとUART_DIV_CNT_WとUartDivCntBusを変更して下さい。
 * ・UART_DIV_RATEは分周レートを定義しています。
 *	 UART_DIV_RATEは基底周波数をボーレートで割った値になります。
 * ・UART_DIV_CNT_Wは分周カウンタの幅を定義しています。
 *	 UART_DIV_CNT_WはUART_DIV_RATEをlog2した値になります。
 * ・UartDivCntBusはUART_DIV_CNT_Wのバスです。
 *	 UART_DIV_CNT_W-1:0として下さい。
 *
 * 【分周の例】
 * ・UARTのボーレートが38,400baudで、チップ全体の基底周波数が10MHzの場合、
 *	 UART_DIV_RATEは10,000,000÷38,400で260となります。
 *	 UART_DIV_CNT_Wはlog2(260)で9となります。
 */

	/********** 分周カウンタ *********/
	`define UART_DIV_RATE	   9'd260  // 分周レート
	`define UART_DIV_CNT_W	   9	   // 分周カウンタ幅
	`define UartDivCntBus	   8:0	   // 分周カウンタバス
	/********** アドレスバス **********/
	`define UartAddrBus		   0:0	// アドレスバス
	`define UART_ADDR_W		   1	// アドレス幅
	`define UartAddrLoc		   0:0	// アドレスの位置
	/********** アドレスマップ **********/
	`define UART_ADDR_STATUS   1'h0 // 制御レジスタ 0 : ステータス
	`define UART_ADDR_DATA	   1'h1 // 制御レジスタ 1 : 送受信データ
	/********** ビットマップ **********/
	`define UartCtrlIrqRx	   0	// 受信完了割り込み
	`define UartCtrlIrqTx	   1	// 送信完了割り込み
	`define UartCtrlBusyRx	   2	// 受信中フラグ
	`define UartCtrlBusyTx	   3	// 送信中フラグ
	/********** 送受信ステータス **********/
	`define UartStateBus	   0:0	// ステータスバス
	`define UART_STATE_IDLE	   1'b0 // ステータス : アイドル状態
	`define UART_STATE_TX	   1'b1 // ステータス : 送信中
	`define UART_STATE_RX	   1'b1 // ステータス : 受信中
	/********** ビットカウンタ **********/
	`define UartBitCntBus	   3:0	// ビットカウンタバス
	`define UART_BIT_CNT_W	   4	// ビットカウンタ幅
	`define UART_BIT_CNT_START 4'h0 // カウント値 : スタートビット
	`define UART_BIT_CNT_MSB   4'h8 // カウント値 : データのMSB
	`define UART_BIT_CNT_STOP  4'h9 // カウント値 : ストップビット
	/********** ビットレベル **********/
	`define UART_START_BIT	   1'b0 // スタートビット
	`define UART_STOP_BIT	   1'b1 // ストップビット

`endif
